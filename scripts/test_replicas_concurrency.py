import os
import sys
import time
import uuid
import json
import argparse
import threading
import subprocess
from concurrent.futures import ThreadPoolExecutor
import requests
import psycopg2
from psycopg2.extras import RealDictCursor

COMPOSE_FILE = "compose.test.yaml"
TEST_DB_HOST = "127.0.0.1"
TEST_DB_PORT = 5434
TEST_DB_USER = "postgres"
TEST_DB_PASSWORD = "testpassword"
TEST_DB_NAME = "test_db"
TEST_DB_URL = f"postgresql://{TEST_DB_USER}:{TEST_DB_PASSWORD}@{TEST_DB_HOST}:{TEST_DB_PORT}/{TEST_DB_NAME}"

REPLICA_1_URL = "http://127.0.0.1:8001"
REPLICA_2_URL = "http://127.0.0.1:8002"
INTERNAL_API_KEY = "testinternal"
HEADERS = {
    "X-Internal-Secret": INTERNAL_API_KEY,
    "Content-Type": "application/json"
}

def get_db_conn():
    return psycopg2.connect(
        host=TEST_DB_HOST,
        port=TEST_DB_PORT,
        user=TEST_DB_USER,
        password=TEST_DB_PASSWORD,
        dbname=TEST_DB_NAME,
        cursor_factory=RealDictCursor
    )

def run_cmd(cmd, check=True, capture=True, env=None):
    merged_env = os.environ.copy()
    if env:
        merged_env.update(env)
    print(f"--> Running: {' '.join(cmd)}")
    res = subprocess.run(cmd, check=check, text=True, capture_output=capture, env=merged_env)
    return res

def wait_for_postgres(timeout=30):
    print(f"Waiting for test PostgreSQL on {TEST_DB_HOST}:{TEST_DB_PORT}...")
    start = time.time()
    while time.time() - start < timeout:
        try:
            conn = get_db_conn()
            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
            conn.close()
            print("PostgreSQL is ready!")
            return True
        except Exception:
            time.sleep(1)
    raise TimeoutError(f"PostgreSQL on {TEST_DB_HOST}:{TEST_DB_PORT} did not become ready within {timeout}s.")

def wait_for_replica(url, timeout=30):
    print(f"Waiting for replica at {url}/health/live...")
    start = time.time()
    while time.time() - start < timeout:
        try:
            r = requests.get(f"{url}/health/live", timeout=2)
            if r.status_code == 200:
                print(f"Replica {url} is live!")
                return True
        except Exception:
            pass
        time.sleep(1)
    raise TimeoutError(f"Replica at {url} did not become healthy within {timeout}s.")

def apply_migrations():
    print("Applying Alembic migrations to test_db...")
    alembic_env = {
        "DB_HOST": TEST_DB_HOST,
        "DB_PORT": str(TEST_DB_PORT),
        "POSTGRES_USER": TEST_DB_USER,
        "POSTGRES_PASSWORD": TEST_DB_PASSWORD,
        "POSTGRES_DB": TEST_DB_NAME
    }
    
    # Check if alembic_version already exists
    conn = get_db_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT to_regclass('alembic_version');")
        tbl = cur.fetchone()["to_regclass"]
    conn.close()

    if not tbl:
        print("Stamping baseline cf95d0e3a541...")
        run_cmd(["alembic", "stamp", "cf95d0e3a541"], env=alembic_env)
    
    print("Upgrading Alembic to head...")
    run_cmd(["alembic", "upgrade", "head"], env=alembic_env)
    print("Migrations applied successfully!")

def setup_environment():
    print("=" * 60)
    print("Spinning up isolated test environment via Docker Compose...")
    print("=" * 60)
    # 1. Clean previous state
    run_cmd(["docker", "compose", "-f", COMPOSE_FILE, "down", "-v"], check=False)
    
    # 2. Start PostgreSQL
    run_cmd(["docker", "compose", "-f", COMPOSE_FILE, "up", "-d", "test-postgres"])
    wait_for_postgres()

    # 3. Run migrations on PostgreSQL
    apply_migrations()

    # 4. Build and start Product Service replicas
    run_cmd(["docker", "compose", "-f", COMPOSE_FILE, "up", "-d", "--build", "test-product-1", "test-product-2"])
    wait_for_replica(REPLICA_1_URL)
    wait_for_replica(REPLICA_2_URL)
    print("Isolated test environment ready!\n")

def teardown_environment():
    print("\n" + "=" * 60)
    print("Tearing down isolated test environment...")
    print("=" * 60)
    run_cmd(["docker", "compose", "-f", COMPOSE_FILE, "down", "-v"], check=False)
    print("Teardown complete.")

def set_product_stock(cur, product_id, total_stock):
    cur.execute("UPDATE inventory SET quantity_on_hand = 0, reserved_quantity = 0 WHERE product_id = %s;", (product_id,))
    cur.execute("SELECT warehouse_id FROM inventory WHERE product_id = %s ORDER BY warehouse_id LIMIT 1;", (product_id,))
    row = cur.fetchone()
    if row:
        cur.execute("UPDATE inventory SET quantity_on_hand = %s WHERE product_id = %s AND warehouse_id = %s;", 
                    (total_stock, product_id, row["warehouse_id"]))
    else:
        cur.execute("SELECT warehouse_id FROM warehouses ORDER BY warehouse_id LIMIT 1;")
        w_row = cur.fetchone()
        wid = w_row["warehouse_id"] if w_row else 1
        cur.execute("INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reserved_quantity) VALUES (%s, %s, %s, 0);",
                    (product_id, wid, total_stock))

# ----------------- TEST CASES -----------------

def test_1_identical_operation_id_race_single_stock():
    print("\n--- Test 1: Identical operation_id Race across Replicas with Stock = 1 ---")
    op_id = f"test1-race-{uuid.uuid4()}"
    pid = 1

    # Reset Product 1 inventory to exactly 1 on-hand, 0 reserved
    conn = get_db_conn()
    with conn.cursor() as cur:
        cur.execute("DELETE FROM stock_reservation_items;")
        cur.execute("DELETE FROM stock_reservations;")
        set_product_stock(cur, pid, 1)
        conn.commit()
    conn.close()

    payload = {
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 1}]
    }

    barrier = threading.Barrier(2)
    results = [None, None]

    def call_replica(idx, url):
        barrier.wait()
        res = requests.post(f"{url}/internal/reservations", json=payload, headers=HEADERS, timeout=10)
        results[idx] = res

    t1 = threading.Thread(target=call_replica, args=(0, REPLICA_1_URL))
    t2 = threading.Thread(target=call_replica, args=(1, REPLICA_2_URL))
    t1.start()
    t2.start()
    t1.join()
    t2.join()

    r1, r2 = results[0], results[1]
    print(f"Replica 1 Response: HTTP {r1.status_code}, Body: {r1.json()}")
    print(f"Replica 2 Response: HTTP {r2.status_code}, Body: {r2.json()}")

    assert r1.status_code in (200, 201), f"Unexpected status {r1.status_code} on replica 1"
    assert r2.status_code in (200, 201), f"Unexpected status {r2.status_code} on replica 2"

    d1, d2 = r1.json(), r2.json()
    assert d1["reservation_id"] == d2["reservation_id"], "Reservation IDs must be identical"
    assert d1["status"] == "ACTIVE" and d2["status"] == "ACTIVE"

    # Database verification
    conn = get_db_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = %s;", (pid,))
        inv_rows = cur.fetchall()
        total_on_hand = sum(r["quantity_on_hand"] for r in inv_rows)
        total_reserved = sum(r["reserved_quantity"] for r in inv_rows)

        cur.execute("SELECT COUNT(*) as count FROM stock_reservations WHERE operation_id = %s;", (op_id,))
        res_count = cur.fetchone()["count"]
    conn.close()

    print(f"DB Verification -> Total on hand: {total_on_hand}, Total reserved: {total_reserved}, Res count: {res_count}")
    assert total_reserved == 1, f"Expected exactly 1 unit reserved, got {total_reserved} (oversell detected!)"
    assert res_count == 1, f"Expected exactly 1 reservation row, got {res_count}"
    print("PASSED: Test 1 (Zero oversell, concurrent identical requests resolved to same reservation)")

def test_2_identical_operation_id_race_abundant_stock():
    print("\n--- Test 2: Identical operation_id Race across Replicas with Abundant Stock ---")
    op_id = f"test2-race-{uuid.uuid4()}"
    pid = 2

    conn = get_db_conn()
    with conn.cursor() as cur:
        set_product_stock(cur, pid, 10)
        conn.commit()
    conn.close()

    payload = {
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 4}]
    }

    barrier = threading.Barrier(2)
    results = [None, None]

    def call_replica(idx, url):
        barrier.wait()
        res = requests.post(f"{url}/internal/reservations", json=payload, headers=HEADERS, timeout=10)
        results[idx] = res

    t1 = threading.Thread(target=call_replica, args=(0, REPLICA_1_URL))
    t2 = threading.Thread(target=call_replica, args=(1, REPLICA_2_URL))
    t1.start()
    t2.start()
    t1.join()
    t2.join()

    r1, r2 = results[0], results[1]
    print(f"Replica 1 Response: HTTP {r1.status_code}, Body: {r1.json()}")
    print(f"Replica 2 Response: HTTP {r2.status_code}, Body: {r2.json()}")

    assert r1.status_code in (200, 201) and r2.status_code in (200, 201)
    d1, d2 = r1.json(), r2.json()
    assert d1["reservation_id"] == d2["reservation_id"]

    conn = get_db_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT reserved_quantity FROM inventory WHERE product_id = %s;", (pid,))
        total_reserved = sum(r["reserved_quantity"] for r in cur.fetchall())
    conn.close()

    print(f"DB Verification -> Total reserved: {total_reserved}")
    assert total_reserved == 4, f"Expected exactly 4 reserved, got {total_reserved} (double deduction occurred!)"
    print("PASSED: Test 2 (Exact deduction on concurrent identical replays)")

def test_3_competing_operation_ids_final_stock():
    print("\n--- Test 3: Competing Different operation_ids for Final Unit across Replicas ---")
    op_id_a = f"test3-a-{uuid.uuid4()}"
    op_id_b = f"test3-b-{uuid.uuid4()}"
    pid = 3

    conn = get_db_conn()
    with conn.cursor() as cur:
        set_product_stock(cur, pid, 1)
        conn.commit()
    conn.close()

    barrier = threading.Barrier(2)
    results = {}

    def call_replica(op_id, url):
        payload = {"operation_id": op_id, "items": [{"product_id": pid, "quantity": 1}]}
        barrier.wait()
        res = requests.post(f"{url}/internal/reservations", json=payload, headers=HEADERS, timeout=10)
        results[op_id] = res

    t1 = threading.Thread(target=call_replica, args=(op_id_a, REPLICA_1_URL))
    t2 = threading.Thread(target=call_replica, args=(op_id_b, REPLICA_2_URL))
    t1.start()
    t2.start()
    t1.join()
    t2.join()

    r_a, r_b = results[op_id_a], results[op_id_b]
    print(f"Op A ({REPLICA_1_URL}): HTTP {r_a.status_code}, Body: {r_a.json()}")
    print(f"Op B ({REPLICA_2_URL}): HTTP {r_b.status_code}, Body: {r_b.json()}")

    statuses = [r_a.status_code, r_b.status_code]
    assert 201 in statuses, "Exactly one competitor must win with 201"
    assert 409 in statuses, "Exactly one competitor must lose with 409"

    # Identify winner and loser
    winner_op = op_id_a if r_a.status_code == 201 else op_id_b
    loser_op = op_id_b if r_a.status_code == 201 else op_id_a
    loser_res = r_b if r_a.status_code == 201 else r_a

    assert "Insufficient stock" in loser_res.json()["detail"]

    # Verify DB: winner has ACTIVE, loser has durable FAILED status
    conn = get_db_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT reserved_quantity FROM inventory WHERE product_id = %s;", (pid,))
        total_reserved = sum(r["reserved_quantity"] for r in cur.fetchall())

        cur.execute("SELECT status, failure_reason FROM stock_reservations WHERE operation_id = %s;", (winner_op,))
        winner_row = cur.fetchone()

        cur.execute("SELECT status, failure_reason FROM stock_reservations WHERE operation_id = %s;", (loser_op,))
        loser_row = cur.fetchone()
    conn.close()

    print(f"DB Verification -> Total reserved: {total_reserved}")
    print(f"Winner Row: {winner_row}")
    print(f"Loser Row: {loser_row}")

    assert total_reserved == 1, "Total reserved must be exactly 1"
    assert winner_row["status"] == "ACTIVE"
    assert loser_row["status"] == "FAILED"
    assert "Insufficient stock" in loser_row["failure_reason"]
    print("PASSED: Test 3 (One winner, one durable failure recorded, no oversell)")

def test_4_conflicting_payloads_same_operation_id():
    print("\n--- Test 4: Conflicting Payloads for Same operation_id across Replicas ---")
    op_id = f"test4-clash-{uuid.uuid4()}"

    conn = get_db_conn()
    with conn.cursor() as cur:
        set_product_stock(cur, 1, 10)
        set_product_stock(cur, 2, 10)
        conn.commit()
    conn.close()

    payload_a = {"operation_id": op_id, "items": [{"product_id": 1, "quantity": 1}]}
    payload_b = {"operation_id": op_id, "items": [{"product_id": 2, "quantity": 1}]}

    barrier = threading.Barrier(2)
    results = [None, None]

    def call_replica(idx, url, payload):
        barrier.wait()
        res = requests.post(f"{url}/internal/reservations", json=payload, headers=HEADERS, timeout=10)
        results[idx] = res

    t1 = threading.Thread(target=call_replica, args=(0, REPLICA_1_URL, payload_a))
    t2 = threading.Thread(target=call_replica, args=(1, REPLICA_2_URL, payload_b))
    t1.start()
    t2.start()
    t1.join()
    t2.join()

    r1, r2 = results[0], results[1]
    print(f"Replica 1 Response: HTTP {r1.status_code}, Body: {r1.json()}")
    print(f"Replica 2 Response: HTTP {r2.status_code}, Body: {r2.json()}")

    statuses = [r1.status_code, r2.status_code]
    assert 201 in statuses, "One request must succeed with 201"
    assert 409 in statuses, "Conflicting request must be rejected with 409"

    conflict_res = r1 if r1.status_code == 409 else r2
    assert "conflicting payload" in conflict_res.json()["detail"].lower()
    print("PASSED: Test 4 (Conflicting payload rejected with 409)")

def test_5_cross_product_deadlock_prevention():
    print("\n--- Test 5: Cross-Product Deadlock Prevention across Replicas ---")
    pid_a = 4
    pid_b = 5

    conn = get_db_conn()
    with conn.cursor() as cur:
        set_product_stock(cur, pid_a, 20)
        set_product_stock(cur, pid_b, 20)
        conn.commit()
    conn.close()

    op_1 = f"test5-dl1-{uuid.uuid4()}"
    op_2 = f"test5-dl2-{uuid.uuid4()}"

    # Request 1: [pid_a, pid_b]
    payload_1 = {"operation_id": op_1, "items": [{"product_id": pid_a, "quantity": 1}, {"product_id": pid_b, "quantity": 1}]}
    # Request 2: [pid_b, pid_a] (Reverse order)
    payload_2 = {"operation_id": op_2, "items": [{"product_id": pid_b, "quantity": 1}, {"product_id": pid_a, "quantity": 1}]}

    barrier = threading.Barrier(2)
    results = [None, None]

    def call_replica(idx, url, payload):
        barrier.wait()
        res = requests.post(f"{url}/internal/reservations", json=payload, headers=HEADERS, timeout=10)
        results[idx] = res

    t1 = threading.Thread(target=call_replica, args=(0, REPLICA_1_URL, payload_1))
    t2 = threading.Thread(target=call_replica, args=(1, REPLICA_2_URL, payload_2))
    t1.start()
    t2.start()
    t1.join()
    t2.join()

    r1, r2 = results[0], results[1]
    print(f"Replica 1 Response: HTTP {r1.status_code}, Body: {r1.json()}")
    print(f"Replica 2 Response: HTTP {r2.status_code}, Body: {r2.json()}")

    assert r1.status_code == 201, f"Deadlock or failure on replica 1: {r1.text}"
    assert r2.status_code == 201, f"Deadlock or failure on replica 2: {r2.text}"
    print("PASSED: Test 5 (Zero deadlocks under reverse-ordered multi-product requests)")

def test_6_cross_replica_lifecycle_transitions():
    print("\n--- Test 6: Cross-Replica Lifecycle Transitions (Confirm & Release) ---")
    op_id = f"test6-life-{uuid.uuid4()}"
    pid = 6

    conn = get_db_conn()
    with conn.cursor() as cur:
        set_product_stock(cur, pid, 10)
        conn.commit()
    conn.close()

    # Step 1: Create reservation on Replica 1
    create_res = requests.post(
        f"{REPLICA_1_URL}/internal/reservations",
        json={"operation_id": op_id, "items": [{"product_id": pid, "quantity": 2}]},
        headers=HEADERS,
        timeout=5
    )
    assert create_res.status_code == 201
    print(f"Created reservation on Replica 1: {create_res.json()}")

    # Step 2: Confirm reservation on Replica 2
    confirm_res = requests.post(
        f"{REPLICA_2_URL}/internal/reservations/{op_id}/confirm",
        headers=HEADERS,
        timeout=5
    )
    assert confirm_res.status_code == 200
    assert confirm_res.json()["status"] == "CONFIRMED"
    print(f"Confirmed on Replica 2: {confirm_res.json()}")

    # Verify DB: on_hand was decremented from 10 to 8, reserved_quantity became 0
    conn = get_db_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = %s;", (pid,))
        row = cur.fetchone()
    conn.close()
    assert row["quantity_on_hand"] == 8 and row["reserved_quantity"] == 0

    # Step 3: Re-confirm on Replica 1 (Idempotent replay)
    reconfirm_res = requests.post(
        f"{REPLICA_1_URL}/internal/reservations/{op_id}/confirm",
        headers=HEADERS,
        timeout=5
    )
    assert reconfirm_res.status_code == 200
    assert reconfirm_res.json()["status"] == "CONFIRMED"
    print(f"Re-confirmed on Replica 1 (Idempotent replay): HTTP {reconfirm_res.status_code}")

    # Verify DB still 8 and 0 (no double decrement)
    conn = get_db_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = %s;", (pid,))
        row = cur.fetchone()
    conn.close()
    assert row["quantity_on_hand"] == 8 and row["reserved_quantity"] == 0

    # Step 4: Release after Confirm on Replica 2 -> Must be rejected with 409
    release_res = requests.post(
        f"{REPLICA_2_URL}/internal/reservations/{op_id}/release",
        headers=HEADERS,
        timeout=5
    )
    assert release_res.status_code == 409
    assert "already confirmed" in release_res.json()["detail"].lower()
    print(f"Release after confirm rejected on Replica 2: HTTP {release_res.status_code}, Detail: {release_res.json()['detail']}")
    print("PASSED: Test 6 (Lifecycle transitions and idempotent confirm verified across replicas)")

def test_7_durable_failure_replay_after_restock():
    print("\n--- Test 7: Durable Failure Replay across Replicas after Restock ---")
    op_id = f"test7-fail-{uuid.uuid4()}"
    pid = 7

    conn = get_db_conn()
    with conn.cursor() as cur:
        set_product_stock(cur, pid, 5)
        conn.commit()
    conn.close()

    # Step 1: Request 100 units on Replica 1 (exceeds stock of 5)
    req_fail = requests.post(
        f"{REPLICA_1_URL}/internal/reservations",
        json={"operation_id": op_id, "items": [{"product_id": pid, "quantity": 100}]},
        headers=HEADERS,
        timeout=5
    )
    assert req_fail.status_code == 409
    assert "Insufficient stock" in req_fail.json()["detail"]
    print(f"Initial request failed as expected: HTTP {req_fail.status_code}, Detail: {req_fail.json()['detail']}")

    # Check DB: status must be FAILED, failure_reason recorded
    conn = get_db_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT status, failure_reason FROM stock_reservations WHERE operation_id = %s;", (op_id,))
        fail_row = cur.fetchone()
    conn.close()
    assert fail_row["status"] == "FAILED"
    print(f"DB durable failure row: {fail_row}")

    # Step 2: Restock inventory heavily (quantity_on_hand = 5000)
    conn = get_db_conn()
    with conn.cursor() as cur:
        set_product_stock(cur, pid, 5000)
        conn.commit()
    conn.close()

    # Step 3: Replay identical operation on Replica 2
    req_replay = requests.post(
        f"{REPLICA_2_URL}/internal/reservations",
        json={"operation_id": op_id, "items": [{"product_id": pid, "quantity": 100}]},
        headers=HEADERS,
        timeout=5
    )
    print(f"Replay on Replica 2 after restock: HTTP {req_replay.status_code}, Detail: {req_replay.json()}")
    assert req_replay.status_code == 409, f"Expected 409 on replaying rejected operation, got {req_replay.status_code}"
    assert "Insufficient stock" in req_replay.json()["detail"]
    print("PASSED: Test 7 (Durable failure persisted and replayed deterministically after restock)")

def main():
    parser = argparse.ArgumentParser(description="Stage 2B Two-Replica Concurrency Test Suite")
    parser.add_argument("--no-setup", action="store_true", help="Skip Docker setup (assume containers are already up)")
    parser.add_argument("--no-teardown", action="store_true", help="Do not tear down containers after test run")
    args = parser.parse_args()

    if not args.no_setup:
        setup_environment()

    try:
        test_1_identical_operation_id_race_single_stock()
        test_2_identical_operation_id_race_abundant_stock()
        test_3_competing_operation_ids_final_stock()
        test_4_conflicting_payloads_same_operation_id()
        test_5_cross_product_deadlock_prevention()
        test_6_cross_replica_lifecycle_transitions()
        test_7_durable_failure_replay_after_restock()

        print("\n" + "*" * 60)
        print("ALL 7 TWO-REPLICA CONCURRENCY & SAFEGUARD TESTS PASSED!")
        print("*" * 60)
    finally:
        if not args.no_teardown and not args.no_setup:
            teardown_environment()

if __name__ == "__main__":
    main()
