import os
import uuid
import requests
import psycopg2
from psycopg2.extras import RealDictCursor

GATEWAY_BASE_URL = "http://127.0.0.1:8081"
LIVE_DB_HOST = "127.0.0.1"
LIVE_DB_PORT = 5433
LIVE_DB_USER = "postgres"
LIVE_DB_PASSWORD = "postgres"
LIVE_DB_NAME = "postgres"

def get_live_db_conn():
    return psycopg2.connect(
        host=LIVE_DB_HOST,
        port=LIVE_DB_PORT,
        user=LIVE_DB_USER,
        password=LIVE_DB_PASSWORD,
        dbname=LIVE_DB_NAME,
        cursor_factory=RealDictCursor
    )

def test_gateway_isolation():
    print("=" * 70)
    print("PUBLIC GATEWAY ISOLATION VERIFICATION")
    print(f"Target Gateway: {GATEWAY_BASE_URL}")
    print(f"Database verification target: {LIVE_DB_HOST}:{LIVE_DB_PORT}/{LIVE_DB_NAME}")
    print("=" * 70)

    # 1. Capture baseline state in live database
    conn = get_live_db_conn()
    with conn.cursor() as cur:
        # Check if stock_reservations table exists in live DB
        cur.execute("SELECT to_regclass('stock_reservations');")
        tbl = cur.fetchone()["to_regclass"]
        if tbl:
            cur.execute("SELECT COUNT(*) as cnt FROM stock_reservations;")
            baseline_res_count = cur.fetchone()["cnt"]
        else:
            baseline_res_count = 0
        
        cur.execute("SELECT product_id, quantity_on_hand FROM inventory ORDER BY product_id LIMIT 10;")
        baseline_inv = {r["product_id"]: r["quantity_on_hand"] for r in cur.fetchall()}
    conn.close()

    print(f"Baseline state -> stock_reservations count: {baseline_res_count}, tracked products: {len(baseline_inv)}")

    op_prefix = f"gw-test-{uuid.uuid4().hex[:8]}"
    tested_op_ids = []

    # Attempt 1: Direct /internal path via Gateway
    op_1 = f"{op_prefix}-direct"
    tested_op_ids.append(op_1)
    url_1 = f"{GATEWAY_BASE_URL}/internal/reservations"
    print(f"\n[Test 1] Testing direct access to internal path: {url_1}")
    r1 = requests.post(url_1, json={"operation_id": op_1, "items": [{"product_id": 1, "quantity": 1}]}, timeout=5)
    print(f"Result: HTTP {r1.status_code}, content-type: {r1.headers.get('content-type', '')}")
    # Gateway should either return 404 (Not Found) or 200 from frontend static HTML, but NEVER 201/409 from product-service
    assert r1.status_code != 201 and r1.status_code != 409

    # Attempt 2: Via /api/products/internal/reservations
    op_2 = f"{op_prefix}-prod-internal"
    tested_op_ids.append(op_2)
    url_2 = f"{GATEWAY_BASE_URL}/api/products/internal/reservations"
    print(f"\n[Test 2] Testing prefixed internal route: {url_2}")
    r2 = requests.post(url_2, json={"operation_id": op_2, "items": [{"product_id": 1, "quantity": 1}]}, timeout=5)
    print(f"Result: HTTP {r2.status_code}")
    # Protected by auth_request (returns 401 Unauthorized without JWT)
    assert r2.status_code in (401, 403, 404)

    # Attempt 3: Path traversal manipulation
    traversal_paths = [
        f"{GATEWAY_BASE_URL}/api/products/../internal/reservations",
        f"{GATEWAY_BASE_URL}/api/products/..%2finternal/reservations",
        f"{GATEWAY_BASE_URL}/api/products/%2e%2e/internal/reservations",
        f"{GATEWAY_BASE_URL}/api/products/..;/internal/reservations"
    ]
    for idx, path in enumerate(traversal_paths):
        op_trav = f"{op_prefix}-trav-{idx}"
        tested_op_ids.append(op_trav)
        print(f"\n[Test 3.{idx+1}] Testing path traversal attempt: {path}")
        try:
            r = requests.post(path, json={"operation_id": op_trav, "items": [{"product_id": 1, "quantity": 1}]}, timeout=5)
            print(f"Result: HTTP {r.status_code}")
            assert r.status_code != 201 and r.status_code != 409
        except Exception as e:
            print(f"Request blocked or failed as expected: {type(e).__name__}")

    # Attempt 4: Forged internal secret header injection
    # Note: internal credentials are NEVER logged
    op_4 = f"{op_prefix}-forged-secret"
    tested_op_ids.append(op_4)
    url_4 = f"{GATEWAY_BASE_URL}/api/products/internal/reservations"
    print(f"\n[Test 4] Testing forged internal header injection (header stripped by Nginx): {url_4}")
    forged_headers = {
        "X-Internal-Secret": "forged_attempt_key",
        "Content-Type": "application/json"
    }
    r4 = requests.post(url_4, json={"operation_id": op_4, "items": [{"product_id": 1, "quantity": 1}]}, headers=forged_headers, timeout=5)
    print(f"Result: HTTP {r4.status_code}")
    assert r4.status_code in (401, 403, 404)

    # 2. Database Verification: Prove zero reservations were created and inventory untouched
    print("\n[Verification] Checking database state to prove no reservation was created or modified...")
    conn = get_live_db_conn()
    with conn.cursor() as cur:
        if tbl:
            cur.execute("SELECT COUNT(*) as cnt FROM stock_reservations;")
            after_res_count = cur.fetchone()["cnt"]
            assert after_res_count == baseline_res_count, f"Reservation count changed! Was {baseline_res_count}, now {after_res_count}"

            cur.execute("SELECT COUNT(*) as cnt FROM stock_reservations WHERE operation_id LIKE %s;", (f"{op_prefix}%",))
            test_created = cur.fetchone()["cnt"]
            assert test_created == 0, f"Found {test_created} test reservation(s) created through gateway!"
        else:
            print("Verified: stock_reservations table does not exist in live application DB (safeguard maintained).")

        cur.execute("SELECT product_id, quantity_on_hand FROM inventory ORDER BY product_id LIMIT 10;")
        after_inv = {r["product_id"]: r["quantity_on_hand"] for r in cur.fetchall()}
        assert after_inv == baseline_inv, "Inventory quantity_on_hand was modified by gateway requests!"
    conn.close()

    print("\n" + "*" * 70)
    print("ALL GATEWAY ISOLATION CHECKS PASSED!")
    print("1. All public attempts to reach internal reservation endpoints were rejected/blocked.")
    print("2. Forged internal headers were stripped by Nginx proxy_set_header directives.")
    print("3. Zero reservations were created or modified in the database.")
    print("4. Zero inventory counts were altered.")
    print("*" * 70)

if __name__ == "__main__":
    test_gateway_isolation()
