import os
import sys
import time
import uuid
import http.client
import argparse
import subprocess
import requests
import psycopg2
from psycopg2.extras import RealDictCursor

COMPOSE_FILE = "compose.test.yaml"

# Environment configuration: connection details obtained dynamically, never hardcoded application credentials
TEST_GATEWAY_URL = os.getenv("TEST_GATEWAY_URL", "http://127.0.0.1:8082")
TEST_PRODUCT_URL = os.getenv("TEST_PRODUCT_URL", "http://127.0.0.1:8001")
TEST_AUTH_URL = os.getenv("TEST_AUTH_URL", "http://127.0.0.1:8003")

DB_HOST = os.getenv("TEST_DB_HOST", "127.0.0.1")
DB_PORT = int(os.getenv("TEST_DB_PORT", "5434"))
DB_USER = os.getenv("TEST_DB_USER", "postgres")
DB_PASSWORD = os.getenv("TEST_DB_PASSWORD", "testpassword")
DB_NAME = os.getenv("TEST_DB_NAME", "test_db")
INTERNAL_API_KEY = os.getenv("INTERNAL_API_KEY", "testinternal")

def get_db_conn():
    return psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASSWORD,
        dbname=DB_NAME,
        cursor_factory=RealDictCursor
    )

def run_cmd(cmd, check=True, env=None):
    merged_env = os.environ.copy()
    if env:
        merged_env.update(env)
    print(f"--> Running: {' '.join(cmd)}")
    return subprocess.run(cmd, check=check, text=True, capture_output=True, env=merged_env, encoding="utf-8", errors="replace")

def wait_for_service(url, name, timeout=30):
    print(f"Waiting for {name} at {url}...")
    start = time.time()
    while time.time() - start < timeout:
        try:
            r = requests.get(url, timeout=2)
            if r.status_code in (200, 401, 404):  # Service answered
                print(f"{name} is ready (HTTP {r.status_code})!")
                return True
        except Exception:
            pass
        time.sleep(1)
    raise TimeoutError(f"{name} at {url} did not respond within {timeout}s.")

def wait_for_postgres(timeout=30):
    print(f"Waiting for test PostgreSQL on {DB_HOST}:{DB_PORT}...")
    start = time.time()
    while time.time() - start < timeout:
        try:
            conn = get_db_conn()
            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
            conn.close()
            print("Test PostgreSQL is ready!")
            return True
        except Exception:
            time.sleep(1)
    raise TimeoutError(f"Test PostgreSQL on {DB_HOST}:{DB_PORT} did not become ready.")

def apply_migrations():
    print("Applying Stage 2B migrations to isolated test_db...")
    alembic_env = {
        "DB_HOST": DB_HOST,
        "DB_PORT": str(DB_PORT),
        "POSTGRES_USER": DB_USER,
        "POSTGRES_PASSWORD": DB_PASSWORD,
        "POSTGRES_DB": DB_NAME
    }
    conn = get_db_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT to_regclass('alembic_version');")
        tbl = cur.fetchone()["to_regclass"]
    conn.close()

    if not tbl:
        run_cmd(["alembic", "stamp", "cf95d0e3a541"], env=alembic_env)
    run_cmd(["alembic", "upgrade", "head"], env=alembic_env)
    print("Stage 2B migrations applied successfully to test_db!")

def setup_environment():
    print("=" * 70)
    print("Spinning up isolated test environment for Gateway Security Verification...")
    print("=" * 70)
    run_cmd(["docker", "compose", "-f", COMPOSE_FILE, "down", "-v"], check=False)
    run_cmd(["docker", "compose", "-f", COMPOSE_FILE, "up", "-d", "test-postgres"])
    wait_for_postgres()
    apply_migrations()
    run_cmd(["docker", "compose", "-f", COMPOSE_FILE, "up", "-d", "--build",
             "test-product-1", "test-product-2", "test-auth", "test-nginx"])
    wait_for_service(f"{TEST_PRODUCT_URL}/health/live", "Product Service")
    wait_for_service(f"{TEST_AUTH_URL}/health/live", "Auth Service")
    wait_for_service(f"{TEST_GATEWAY_URL}/api/products", "Nginx Gateway")
    print("Isolated test environment ready!\n")

def teardown_environment():
    print("\n" + "=" * 70)
    print("Tearing down isolated test environment...")
    print("=" * 70)
    run_cmd(["docker", "compose", "-f", COMPOSE_FILE, "down", "-v"], check=False)
    print("Teardown complete.")

def test_gateway_security():
    print("=" * 70)
    print("ISOLATED APPLICATION GATEWAY SECURITY & RESERVATION ISOLATION TEST")
    print(f"Gateway URL: {TEST_GATEWAY_URL}")
    print(f"Isolated DB: {DB_HOST}:{DB_PORT}/{DB_NAME}")
    print("=" * 70)

    # 1. Preflight Database Verification: confirm we are strictly in isolated test_db with Stage 2B applied
    conn = get_db_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT current_database(), inet_server_port();")
        row = cur.fetchone()
        db_name = row["current_database"]
        db_port = row["inet_server_port"]
        assert db_name == DB_NAME, f"Safety violation: unexpected database {db_name}"
        assert db_port == 5432, f"Safety violation: unexpected internal port {db_port}"

        cur.execute("SELECT version_num FROM alembic_version;")
        rev = cur.fetchone()["version_num"]
        assert rev == "e83f2a1b9c40", f"Expected Stage 2B revision e83f2a1b9c40 in test_db, found {rev}"

        cur.execute("SELECT to_regclass('stock_reservations');")
        assert cur.fetchone()["to_regclass"] is not None, "stock_reservations table must exist in test_db"

        # Setup test product stock in test_db: product 10 with 50 units on-hand, 0 reserved
        pid = 10
        cur.execute("UPDATE inventory SET quantity_on_hand = 0, reserved_quantity = 0 WHERE product_id = %s;", (pid,))
        cur.execute("SELECT warehouse_id FROM inventory WHERE product_id = %s ORDER BY warehouse_id LIMIT 1;", (pid,))
        inv_row = cur.fetchone()
        wid = inv_row["warehouse_id"] if inv_row else 1
        if inv_row:
            cur.execute("UPDATE inventory SET quantity_on_hand = 50, reserved_quantity = 0 WHERE product_id = %s AND warehouse_id = %s;",
                        (pid, wid))
        else:
            cur.execute("INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reserved_quantity) VALUES (%s, %s, 50, 0);",
                        (pid, wid))
        conn.commit()

        # Capture baseline counts
        cur.execute("SELECT COUNT(*) as count FROM stock_reservations;")
        baseline_res_count = cur.fetchone()["count"]
        cur.execute("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = %s;", (pid,))
        inv_before = cur.fetchone()
        assert inv_before["quantity_on_hand"] == 50 and inv_before["reserved_quantity"] == 0
    conn.close()

    print(f"Preflight OK: test_db verified at revision {rev}. Product {pid} stock: 50 on-hand, 0 reserved.\n")

    # -------------------------------------------------------------------------
    # Test 0: Positive Control (Legitimate Internal Reservation)
    # Proves Stage 2B reservation works when invoked through the internal service port.
    # -------------------------------------------------------------------------
    print("--- [Control Test 0] Positive Control: Direct Internal Reservation ---")
    control_op_id = f"control-valid-{uuid.uuid4().hex[:8]}"
    control_payload = {"operation_id": control_op_id, "items": [{"product_id": pid, "quantity": 5}]}
    control_headers = {"X-Internal-Secret": INTERNAL_API_KEY, "Content-Type": "application/json"}

    r_control = requests.post(f"{TEST_PRODUCT_URL}/internal/reservations", json=control_payload, headers=control_headers, timeout=5)
    assert r_control.status_code == 201, f"Positive control reservation failed: {r_control.text}"
    print(f"Direct internal reservation succeeded: HTTP 201, reservation_id={r_control.json()['reservation_id']}")

    # Release control reservation
    r_rel = requests.post(f"{TEST_PRODUCT_URL}/internal/reservations/{control_op_id}/release", headers=control_headers, timeout=5)
    assert r_rel.status_code == 200, f"Positive control release failed: {r_rel.text}"
    print("Positive control reservation released cleanly: HTTP 200")

    # Verify DB: 1 reservation row created (status RELEASED), reserved_quantity returned to 0
    conn = get_db_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT status FROM stock_reservations WHERE operation_id = %s;", (control_op_id,))
        assert cur.fetchone()["status"] == "RELEASED"
        cur.execute("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = %s;", (pid,))
        inv = cur.fetchone()
        assert inv["reserved_quantity"] == 0
    conn.close()
    print("Control test verified: Stage 2B reservation logic is active and functional in test environment.\n")

    op_prefix = f"gw-sec-{uuid.uuid4().hex[:8]}"
    unauthorized_ops = []

    # -------------------------------------------------------------------------
    # Test 1: Direct /internal path via Gateway
    # -------------------------------------------------------------------------
    op_1 = f"{op_prefix}-direct"
    unauthorized_ops.append(op_1)
    url_1 = f"{TEST_GATEWAY_URL}/internal/reservations"
    print(f"--- [Test 1] Testing direct access to internal path via Gateway: {url_1} ---")
    r1 = requests.post(url_1, json={"operation_id": op_1, "items": [{"product_id": pid, "quantity": 1}]}, timeout=5)
    print(f"Gateway Response: HTTP {r1.status_code}")
    assert r1.status_code in (404, 502, 503), f"Expected 404 or 503 from gateway, got {r1.status_code}"
    assert r1.status_code not in (200, 201), "Security breach: internal route reachable directly through gateway!"
    print("PASSED: Direct /internal/reservations rejected by Gateway.")

    # -------------------------------------------------------------------------
    # Test 2: Unauthenticated /api/products/internal/reservations
    # -------------------------------------------------------------------------
    op_2 = f"{op_prefix}-unauth"
    unauthorized_ops.append(op_2)
    url_2 = f"{TEST_GATEWAY_URL}/api/products/internal/reservations"
    print(f"\n--- [Test 2] Testing unauthenticated prefixed internal route: {url_2} ---")
    r2 = requests.post(url_2, json={"operation_id": op_2, "items": [{"product_id": pid, "quantity": 1}]}, timeout=5)
    print(f"Gateway Response: HTTP {r2.status_code}")
    assert r2.status_code == 401, f"Expected 401 Unauthorized from auth_request, got {r2.status_code}"
    print("PASSED: Unauthenticated internal request blocked by Nginx auth_request with 401.")

    # -------------------------------------------------------------------------
    # Test 3: Authenticated User (Valid JWT) Calling Internal Route
    # -------------------------------------------------------------------------
    print(f"\n--- [Test 3] Testing authenticated user calling internal route via Gateway ---")
    # Register and log in user to obtain genuine JWT
    user_email = f"user_{uuid.uuid4().hex[:8]}@example.com"
    test_pass = "Password123!"
    r_reg = requests.post(f"{TEST_GATEWAY_URL}/api/auth/register", json={
        "first_name": "Test",
        "last_name": "User",
        "email": user_email,
        "password": test_pass
    }, timeout=5)
    assert r_reg.status_code in (200, 201), f"User registration failed: {r_reg.text}"

    r_login = requests.post(f"{TEST_GATEWAY_URL}/api/auth/login", json={
        "email": user_email,
        "password": test_pass
    }, timeout=5)
    assert r_login.status_code == 200, f"User login failed: {r_login.text}"
    user_token = r_login.json()["access_token"]
    user_auth_headers = {"Authorization": f"Bearer {user_token}", "Content-Type": "application/json"}

    op_3 = f"{op_prefix}-auth-user"
    unauthorized_ops.append(op_3)
    r3 = requests.post(url_2, json={"operation_id": op_3, "items": [{"product_id": pid, "quantity": 1}]},
                       headers=user_auth_headers, timeout=5)
    print(f"Gateway Response with valid user JWT: HTTP {r3.status_code}")
    # Nginx rewrites /api/products/internal/... to /products/internal/... which does NOT exist on Product Service
    assert r3.status_code == 404, f"Expected 404 Not Found from downstream service rewrite, got {r3.status_code}"
    assert r3.status_code not in (200, 201), "Security breach: authenticated user reached internal reservation endpoint!"
    print("PASSED: Authenticated user cannot reach internal reservation routes (HTTP 404).")

    # -------------------------------------------------------------------------
    # Test 4: Forged Internal Secret Header Injection via Gateway
    # -------------------------------------------------------------------------
    print(f"\n--- [Test 4] Testing forged internal secret header injection via Gateway ---")
    op_4 = f"{op_prefix}-forged-secret"
    unauthorized_ops.append(op_4)
    forged_headers = {
        "Authorization": f"Bearer {user_token}",
        "X-Internal-Secret": INTERNAL_API_KEY,  # Real secret supplied by attacker through Gateway
        "Content-Type": "application/json"
    }
    r4 = requests.post(url_2, json={"operation_id": op_4, "items": [{"product_id": pid, "quantity": 1}]},
                       headers=forged_headers, timeout=5)
    print(f"Gateway Response with forged internal header: HTTP {r4.status_code}")
    # Nginx proxy_set_header X-Internal-Secret "" strips the header
    assert r4.status_code in (401, 403, 404), f"Expected 401/403/404, got {r4.status_code}"
    assert r4.status_code not in (200, 201), "Security breach: internal secret was not stripped by gateway!"
    print("PASSED: Injected X-Internal-Secret stripped by Nginx (HTTP 404/401).")

    # -------------------------------------------------------------------------
    # Test 5: Path Traversal & URL Manipulation
    # -------------------------------------------------------------------------
    print(f"\n--- [Test 5] Testing path traversal and URL manipulation vectors ---")
    traversal_vectors = [
        "/api/products/../internal/reservations",
        "/api/products/..%2finternal/reservations",
        "/api/products/%2e%2e/internal/reservations",
        "/api/products/..;/internal/reservations"
    ]

    for idx, path in enumerate(traversal_vectors):
        op_trav = f"{op_prefix}-trav-{idx}"
        unauthorized_ops.append(op_trav)
        payload = {"operation_id": op_trav, "items": [{"product_id": pid, "quantity": 1}]}

        # 5A. Test via requests library
        req_url = f"{TEST_GATEWAY_URL}{path}"
        r_trav = requests.post(req_url, json=payload, headers=forged_headers, timeout=5)
        print(f"Traversal vector '{path}' (requests) -> HTTP {r_trav.status_code}")
        assert r_trav.status_code in (400, 401, 403, 404, 502, 503), f"Unexpected status code {r_trav.status_code} for path {path}"
        assert r_trav.status_code not in (200, 201), f"Security breach: path traversal succeeded with HTTP {r_trav.status_code}"

        # 5B. Test via raw HTTPConnection to bypass any client-side URL normalization
        conn_raw = http.client.HTTPConnection("127.0.0.1", 8082, timeout=5)
        raw_headers = {
            "Host": "api.example.com",
            "Content-Type": "application/json",
            "Authorization": f"Bearer {user_token}",
            "X-Internal-Secret": INTERNAL_API_KEY
        }
        conn_raw.request("POST", path, body='{"operation_id":"raw","items":[]}', headers=raw_headers)
        raw_resp = conn_raw.getresponse()
        raw_status = raw_resp.status
        conn_raw.close()
        print(f"Traversal vector '{path}' (raw HTTP) -> HTTP {raw_status}")
        assert raw_status in (400, 401, 403, 404, 502, 503), f"Unexpected raw status code {raw_status} for path {path}"
        assert raw_status not in (200, 201), f"Security breach: raw traversal succeeded with HTTP {raw_status}"

    print("PASSED: All path traversal vectors safely blocked.")

    # -------------------------------------------------------------------------
    # Test 6: Database State Verification
    # Strictly prove in test_db that zero unauthorized reservations or inventory mutations occurred
    # -------------------------------------------------------------------------
    print(f"\n--- [Test 6] Database Integrity Verification in test_db ---")
    conn = get_db_conn()
    with conn.cursor() as cur:
        # 1. Total reservations should be baseline + 1 (the positive control reservation only)
        cur.execute("SELECT COUNT(*) as count FROM stock_reservations;")
        total_res = cur.fetchone()["count"]
        assert total_res == baseline_res_count + 1, f"Unexpected reservation count: expected {baseline_res_count + 1}, found {total_res}"

        # 2. None of the unauthorized operation IDs must exist in stock_reservations
        cur.execute("SELECT COUNT(*) as count FROM stock_reservations WHERE operation_id LIKE %s;", (f"{op_prefix}%",))
        unauthorized_count = cur.fetchone()["count"]
        assert unauthorized_count == 0, f"Security breach: found {unauthorized_count} unauthorized reservations in DB!"

        # 3. Product 10 inventory must remain exactly 50 on-hand, 0 reserved
        cur.execute("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = %s;", (pid,))
        inv_after = cur.fetchone()
        assert inv_after["quantity_on_hand"] == 50, f"Quantity on-hand mutated! Expected 50, found {inv_after['quantity_on_hand']}"
        assert inv_after["reserved_quantity"] == 0, f"Reserved quantity mutated! Expected 0, found {inv_after['reserved_quantity']}"
    conn.close()

    print(f"Verified: Total reservations = {total_res} (exactly 1 from control test, 0 from gateway attacks).")
    print(f"Verified: Product {pid} inventory reserved_quantity = 0 (zero inventory mutation).")
    print("\n" + "*" * 70)
    print("ALL ISOLATED GATEWAY SECURITY & ISOLATION CHECKS PASSED!")
    print("*" * 70)

def main():
    parser = argparse.ArgumentParser(description="Isolated Gateway Security Verification")
    parser.add_argument("--no-setup", action="store_true", help="Do not setup Docker environment")
    parser.add_argument("--no-teardown", action="store_true", help="Do not teardown Docker environment")
    args = parser.parse_args()

    if not args.no_setup:
        setup_environment()

    try:
        test_gateway_security()
    finally:
        if not args.no_teardown and not args.no_setup:
            teardown_environment()

if __name__ == "__main__":
    main()
