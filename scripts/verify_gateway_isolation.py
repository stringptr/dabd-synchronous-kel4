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
EXPECTED_COMPOSE_PROJECT = "stage2b-test"
EXPECTED_CONTAINER_NAME = "stage2b-test-postgres"
EXPECTED_TEST_DB = "test_db"
EXPECTED_TEST_PORT = 5434

FORBIDDEN_PORTS = {5433}
FORBIDDEN_DB_NAMES = {"postgres", "app", "production", "order_service", "auth_service", "product_service"}

class SecurityAbortError(Exception):
    """Raised when safety checks detect any attempt to target a forbidden or non-test database."""
    pass

def validate_target_safety(host: str, port: int, dbname: str):
    """Fail-closed safety check: unconditionally reject application database targets."""
    if port in FORBIDDEN_PORTS:
        raise SecurityAbortError(
            f"CRITICAL SECURITY ABORT: Target port {port} is an application database port! "
            f"Refusing execution to protect application data integrity."
        )
    if dbname.lower() in FORBIDDEN_DB_NAMES:
        raise SecurityAbortError(
            f"CRITICAL SECURITY ABORT: Target database '{dbname}' is a forbidden application database! "
            f"Refusing execution to protect application data integrity."
        )
    if dbname != EXPECTED_TEST_DB:
        raise SecurityAbortError(
            f"CRITICAL SECURITY ABORT: Target database must be explicitly '{EXPECTED_TEST_DB}', got '{dbname}'. "
            f"Refusing execution to prevent unintended database access."
        )
    if port != EXPECTED_TEST_PORT:
        raise SecurityAbortError(
            f"CRITICAL SECURITY ABORT: Target port must be explicitly {EXPECTED_TEST_PORT}, got {port}. "
            f"Refusing execution to prevent unintended database access."
        )

def verify_target_container():
    """Verify that the actual target container is the designated disposable test container."""
    try:
        res = subprocess.run(
            ["docker", "inspect", EXPECTED_CONTAINER_NAME, "--format", "{{.State.Running}}|{{index .Config.Labels \"com.docker.compose.project\"}}"],
            check=True, text=True, capture_output=True, encoding="utf-8", errors="replace"
        )
        output = res.stdout.strip()
        parts = output.split("|")
        is_running = parts[0].strip().lower() == "true"
        project_name = parts[1].strip() if len(parts) > 1 else ""
        if not is_running:
            raise SecurityAbortError(f"Target container '{EXPECTED_CONTAINER_NAME}' is not running.")
        if project_name != EXPECTED_COMPOSE_PROJECT:
            raise SecurityAbortError(
                f"Target container belongs to project '{project_name}', expected '{EXPECTED_COMPOSE_PROJECT}'."
            )
    except subprocess.CalledProcessError as e:
        raise SecurityAbortError(f"Failed to inspect target container '{EXPECTED_CONTAINER_NAME}': {e.stderr}")

def get_db_conn(host, port, user, password, dbname):
    # Safety validation before opening any socket connection
    validate_target_safety(host, port, dbname)
    return psycopg2.connect(
        host=host,
        port=port,
        user=user,
        password=password,
        dbname=dbname,
        cursor_factory=RealDictCursor
    )

def verify_database_identity(conn):
    """Verify database identity and server parameters through the active connection."""
    with conn.cursor() as cur:
        cur.execute("SELECT current_database(), inet_server_port();")
        row = cur.fetchone()
        cur_db = row["current_database"]
        server_port = row["inet_server_port"]

        if cur_db in FORBIDDEN_DB_NAMES or cur_db != EXPECTED_TEST_DB:
            raise SecurityAbortError(
                f"CRITICAL SECURITY ABORT: Connected database is '{cur_db}', expected '{EXPECTED_TEST_DB}'! "
                f"Aborting immediately."
            )
        if server_port != 5432:
            raise SecurityAbortError(
                f"CRITICAL SECURITY ABORT: Internal PostgreSQL port is {server_port}, expected 5432! "
                f"Aborting immediately."
            )

def run_cmd(cmd, check=True, env=None):
    merged_env = os.environ.copy()
    if env:
        merged_env.update(env)
    print(f"--> Running: {' '.join(cmd)}")
    return subprocess.run(cmd, check=check, text=True, capture_output=True, env=merged_env, encoding="utf-8", errors="replace")

def wait_for_service(url, name, expected_statuses=(200, 401, 404, 405), timeout=45):
    print(f"Waiting for {name} at {url}...")
    start = time.time()
    while time.time() - start < timeout:
        try:
            r = requests.get(url, timeout=2)
            if r.status_code in expected_statuses:
                print(f"{name} is ready (HTTP {r.status_code})!")
                return True
        except Exception:
            pass
        time.sleep(1)
    raise TimeoutError(f"{name} at {url} did not respond with expected status within {timeout}s.")

def wait_for_postgres(host, port, user, password, dbname, timeout=30):
    print(f"Waiting for test PostgreSQL on {host}:{port}...")
    start = time.time()
    while time.time() - start < timeout:
        try:
            conn = get_db_conn(host, port, user, password, dbname)
            verify_database_identity(conn)
            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
            conn.close()
            print("Test PostgreSQL verified and ready!")
            return True
        except Exception:
            time.sleep(1)
    raise TimeoutError(f"Test PostgreSQL on {host}:{port} did not become ready.")

def apply_migrations(host, port, user, password, dbname):
    # Verify safety before running migrations
    validate_target_safety(host, port, dbname)
    verify_target_container()
    conn = get_db_conn(host, port, user, password, dbname)
    verify_database_identity(conn)
    conn.close()

    print("Applying Stage 2B migrations to verified isolated test_db...")
    alembic_env = {
        "DB_HOST": host,
        "DB_PORT": str(port),
        "POSTGRES_USER": user,
        "POSTGRES_PASSWORD": password,
        "POSTGRES_DB": dbname
    }

    conn = get_db_conn(host, port, user, password, dbname)
    with conn.cursor() as cur:
        cur.execute("SELECT to_regclass('alembic_version');")
        tbl = cur.fetchone()["to_regclass"]
    conn.close()

    if not tbl:
        run_cmd(["alembic", "stamp", "cf95d0e3a541"], env=alembic_env)
    run_cmd(["alembic", "upgrade", "head"], env=alembic_env)
    print("Stage 2B migrations applied successfully to test_db!")

def setup_environment(host, port, user, password, dbname):
    print("=" * 70)
    print("Spinning up designated isolated test project (stage2b-test)...")
    print("=" * 70)
    # Validate target parameters before any docker actions
    validate_target_safety(host, port, dbname)

    # Scoped docker compose command targeting only stage2b-test project
    run_cmd(["docker", "compose", "-p", EXPECTED_COMPOSE_PROJECT, "-f", COMPOSE_FILE, "down", "-v"], check=False)
    run_cmd(["docker", "compose", "-p", EXPECTED_COMPOSE_PROJECT, "-f", COMPOSE_FILE, "up", "-d", "test-postgres"])
    wait_for_postgres(host, port, user, password, dbname)

    # Verify container and database identity before applying migrations
    verify_target_container()
    apply_migrations(host, port, user, password, dbname)

    # Start all services with genuine upstreams
    run_cmd([
        "docker", "compose", "-p", EXPECTED_COMPOSE_PROJECT, "-f", COMPOSE_FILE,
        "up", "-d", "--build",
        "test-product-1", "test-product-2", "test-auth", "test-order", "test-frontend", "test-nginx"
    ])
    wait_for_service("http://127.0.0.1:8001/health/live", "Product Service 1")
    wait_for_service("http://127.0.0.1:8002/health/live", "Product Service 2")
    wait_for_service("http://127.0.0.1:8003/health/live", "Auth Service")
    wait_for_service("http://127.0.0.1:8082/api/products", "Nginx Gateway", expected_statuses=(401,))
    print("Designated isolated test environment ready!\n")

def teardown_environment():
    print("\n" + "=" * 70)
    print("Tearing down designated isolated test project (stage2b-test)...")
    print("=" * 70)
    run_cmd(["docker", "compose", "-p", EXPECTED_COMPOSE_PROJECT, "-f", COMPOSE_FILE, "down", "-v"], check=False)
    print("Teardown complete.")

def test_gateway_security(host, port, user, password, dbname, gateway_url, product_url, internal_key):
    print("=" * 70)
    print("ISOLATED APPLICATION GATEWAY SECURITY & RESERVATION ISOLATION TEST")
    print(f"Gateway URL: {gateway_url}")
    print(f"Target DB: {host}:{port}/{dbname}")
    print("=" * 70)

    # Fail-closed safety check: enforce strict test DB validation even with --no-setup
    validate_target_safety(host, port, dbname)
    verify_target_container()

    conn = get_db_conn(host, port, user, password, dbname)
    verify_database_identity(conn)

    with conn.cursor() as cur:
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
            cur.execute(
                "UPDATE inventory SET quantity_on_hand = 50, reserved_quantity = 0 WHERE product_id = %s AND warehouse_id = %s;",
                (pid, wid)
            )
        else:
            cur.execute(
                "INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reserved_quantity) VALUES (%s, %s, 50, 0);",
                (pid, wid)
            )
        conn.commit()

        # Capture baseline
        cur.execute("SELECT COUNT(*) as count FROM stock_reservations;")
        baseline_res_count = cur.fetchone()["count"]
        cur.execute("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = %s;", (pid,))
        inv_before = cur.fetchone()
        assert inv_before["quantity_on_hand"] == 50 and inv_before["reserved_quantity"] == 0
    conn.close()

    print(f"Preflight OK: test_db verified at revision {rev}. Product {pid} stock: 50 on-hand, 0 reserved.\n")

    # -------------------------------------------------------------------------
    # Test 0: Positive Control (Legitimate Internal Reservation)
    # -------------------------------------------------------------------------
    print("--- [Control Test 0] Positive Control: Direct Internal Reservation ---")
    control_op_id = f"control-valid-{uuid.uuid4().hex[:8]}"
    control_payload = {"operation_id": control_op_id, "items": [{"product_id": pid, "quantity": 5}]}
    control_headers = {"X-Internal-Secret": internal_key, "Content-Type": "application/json"}

    r_control = requests.post(f"{product_url}/internal/reservations", json=control_payload, headers=control_headers, timeout=5)
    assert r_control.status_code == 201, f"Positive control reservation failed: {r_control.text}"
    print(f"Direct internal reservation succeeded: HTTP 201, reservation_id={r_control.json()['reservation_id']}")

    # Release control reservation
    r_rel = requests.post(f"{product_url}/internal/reservations/{control_op_id}/release", headers=control_headers, timeout=5)
    assert r_rel.status_code == 200, f"Positive control release failed: {r_rel.text}"
    print("Positive control reservation released cleanly: HTTP 200")

    # Verify DB: 1 reservation row created (status RELEASED), reserved_quantity returned to 0
    conn = get_db_conn(host, port, user, password, dbname)
    with conn.cursor() as cur:
        cur.execute("SELECT status FROM stock_reservations WHERE operation_id = %s;", (control_op_id,))
        assert cur.fetchone()["status"] == "RELEASED"
        cur.execute("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = %s;", (pid,))
        inv = cur.fetchone()
        assert inv["reserved_quantity"] == 0
    conn.close()
    print("Control test verified: Stage 2B reservation logic is active and functional in test environment.\n")

    # -------------------------------------------------------------------------
    # Test 1: Legitimate Authenticated GET /api/products Request via Gateway
    # -------------------------------------------------------------------------
    print("--- [Test 1] Legitimate Authenticated GET /api/products Request via Gateway ---")
    user_email = f"user_{uuid.uuid4().hex[:8]}@example.com"
    user_pass = "Password123!"
    r_reg = requests.post(f"{gateway_url}/api/auth/register", json={
        "first_name": "Test",
        "last_name": "User",
        "email": user_email,
        "password": user_pass
    }, timeout=5)
    assert r_reg.status_code in (200, 201), f"User registration failed: {r_reg.text}"

    r_login = requests.post(f"{gateway_url}/api/auth/login", json={
        "email": user_email,
        "password": user_pass
    }, timeout=5)
    assert r_login.status_code == 200, f"User login failed: {r_login.text}"
    user_token = r_login.json()["access_token"]
    user_auth_headers = {"Authorization": f"Bearer {user_token}", "Content-Type": "application/json"}

    r_products = requests.get(f"{gateway_url}/api/products", headers=user_auth_headers, timeout=5)
    print(f"GET /api/products Response: HTTP {r_products.status_code}")
    assert r_products.status_code == 200, f"Expected HTTP 200 for legitimate GET /api/products, got {r_products.status_code}: {r_products.text}"
    assert r_products.status_code not in (502, 503), "Unexpected 502/503 bad gateway on legitimate request"
    products_list = r_products.json()
    assert isinstance(products_list, list) and len(products_list) > 0, "Expected non-empty products list"
    print(f"PASSED: Legitimate authenticated request succeeded through Gateway ({len(products_list)} products returned).\n")

    op_prefix = f"gw-sec-{uuid.uuid4().hex[:8]}"
    unauthorized_ops = []

    # -------------------------------------------------------------------------
    # Test 2: Direct /internal path via Gateway (Expected: HTTP 404 or 405 from frontend, NOT 502/503)
    # -------------------------------------------------------------------------
    op_2 = f"{op_prefix}-direct"
    unauthorized_ops.append(op_2)
    url_2 = f"{gateway_url}/internal/reservations"
    print(f"--- [Test 2] Testing direct access to internal path via Gateway: {url_2} ---")
    r2 = requests.post(url_2, json={"operation_id": op_2, "items": [{"product_id": pid, "quantity": 1}]}, timeout=5)
    print(f"Gateway Response: HTTP {r2.status_code}")
    assert r2.status_code not in (502, 503), f"Unexpected HTTP {r2.status_code} bad gateway: frontend upstream must be properly configured"
    assert r2.status_code in (404, 405), f"Expected HTTP 404 or 405 from frontend, got {r2.status_code}"
    assert r2.status_code not in (200, 201), "Security breach: internal route reachable directly through gateway!"
    print("PASSED: Direct /internal/reservations rejected by Gateway (HTTP 404/405).")

    # -------------------------------------------------------------------------
    # Test 3: Unauthenticated /api/products/internal/reservations
    # -------------------------------------------------------------------------
    op_3 = f"{op_prefix}-unauth"
    unauthorized_ops.append(op_3)
    url_3 = f"{gateway_url}/api/products/internal/reservations"
    print(f"\n--- [Test 3] Testing unauthenticated prefixed internal route: {url_3} ---")
    r3 = requests.post(url_3, json={"operation_id": op_3, "items": [{"product_id": pid, "quantity": 1}]}, timeout=5)
    print(f"Gateway Response: HTTP {r3.status_code}")
    assert r3.status_code not in (502, 503), f"Unexpected HTTP {r3.status_code} bad gateway on unauthenticated request"
    assert r3.status_code == 401, f"Expected 401 Unauthorized from auth_request, got {r3.status_code}"
    assert r3.status_code not in (200, 201), "Security breach: unauthenticated request succeeded!"
    print("PASSED: Unauthenticated internal request blocked by Nginx auth_request with HTTP 401.")

    # -------------------------------------------------------------------------
    # Test 4: Authenticated User Calling Internal Route
    # -------------------------------------------------------------------------
    op_4 = f"{op_prefix}-auth-user"
    unauthorized_ops.append(op_4)
    print(f"\n--- [Test 4] Testing authenticated user calling internal route via Gateway ---")
    r4 = requests.post(url_3, json={"operation_id": op_4, "items": [{"product_id": pid, "quantity": 1}]},
                       headers=user_auth_headers, timeout=5)
    print(f"Gateway Response with valid user JWT: HTTP {r4.status_code}")
    assert r4.status_code not in (502, 503), f"Unexpected HTTP {r4.status_code} bad gateway on authenticated request"
    # Nginx rewrites /api/products/internal/... to /products/internal/... which does NOT exist on Product Service
    assert r4.status_code == 404, f"Expected 404 Not Found from downstream service rewrite, got {r4.status_code}"
    assert r4.status_code not in (200, 201), "Security breach: authenticated user reached internal reservation endpoint!"
    print("PASSED: Authenticated user cannot reach internal reservation routes (HTTP 404).")

    # -------------------------------------------------------------------------
    # Test 5: Forged Internal Secret Header Injection via Gateway
    # -------------------------------------------------------------------------
    op_5 = f"{op_prefix}-forged-secret"
    unauthorized_ops.append(op_5)
    print(f"\n--- [Test 5] Testing forged internal secret header injection via Gateway ---")
    forged_headers = {
        "Authorization": f"Bearer {user_token}",
        "X-Internal-Secret": internal_key,
        "Content-Type": "application/json"
    }
    r5 = requests.post(url_3, json={"operation_id": op_5, "items": [{"product_id": pid, "quantity": 1}]},
                       headers=forged_headers, timeout=5)
    print(f"Gateway Response with forged internal header: HTTP {r5.status_code}")
    assert r5.status_code not in (502, 503), f"Unexpected HTTP {r5.status_code} bad gateway on forged header request"
    # Header stripped by Nginx; path rewritten to /products/internal/... -> 404
    assert r5.status_code in (401, 403, 404), f"Expected 401/403/404, got {r5.status_code}"
    assert r5.status_code not in (200, 201), "Security breach: internal secret was not stripped by gateway!"
    print("PASSED: Injected X-Internal-Secret stripped by Nginx (HTTP 404/401).")

    # -------------------------------------------------------------------------
    # Test 6: Path Traversal & URL Manipulation
    # -------------------------------------------------------------------------
    print(f"\n--- [Test 6] Testing path traversal and URL manipulation vectors ---")
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

        # 6A. Test via requests library
        req_url = f"{gateway_url}{path}"
        r_trav = requests.post(req_url, json=payload, headers=forged_headers, timeout=5)
        print(f"Traversal vector '{path}' (requests) -> HTTP {r_trav.status_code}")
        assert r_trav.status_code not in (502, 503), f"Unexpected HTTP {r_trav.status_code} bad gateway on path traversal '{path}'"
        assert r_trav.status_code in (400, 401, 403, 404, 405), f"Unexpected status code {r_trav.status_code} for path {path}"
        assert r_trav.status_code not in (200, 201), f"Security breach: path traversal succeeded with HTTP {r_trav.status_code}"

        # 6B. Test via raw HTTPConnection to bypass any client-side URL normalization
        conn_raw = http.client.HTTPConnection("127.0.0.1", 8082, timeout=5)
        raw_headers = {
            "Host": "api.example.com",
            "Content-Type": "application/json",
            "Authorization": f"Bearer {user_token}",
            "X-Internal-Secret": internal_key
        }
        conn_raw.request("POST", path, body='{"operation_id":"raw","items":[]}', headers=raw_headers)
        raw_resp = conn_raw.getresponse()
        raw_status = raw_resp.status
        conn_raw.close()
        print(f"Traversal vector '{path}' (raw HTTP) -> HTTP {raw_status}")
        assert raw_status not in (502, 503), f"Unexpected HTTP {raw_status} bad gateway on raw traversal '{path}'"
        assert raw_status in (400, 401, 403, 404, 405), f"Unexpected raw status code {raw_status} for path {path}"
        assert raw_status not in (200, 201), f"Security breach: raw traversal succeeded with HTTP {raw_status}"

    print("PASSED: All path traversal vectors safely blocked without unexpected 502/503 errors.")

    # -------------------------------------------------------------------------
    # Test 7: Database State Verification
    # -------------------------------------------------------------------------
    print(f"\n--- [Test 7] Database Integrity Verification in test_db ---")
    conn = get_db_conn(host, port, user, password, dbname)
    verify_database_identity(conn)

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
    parser.add_argument("--test-host", default=None, help="Override DB host (must pass safety checks)")
    parser.add_argument("--test-port", type=int, default=None, help="Override DB port (must pass safety checks)")
    parser.add_argument("--test-db", default=None, help="Override DB name (must pass safety checks)")
    args = parser.parse_args()

    # Determine target parameters from arguments or environment
    db_host = args.test_host or os.getenv("TEST_DB_HOST", "127.0.0.1")
    db_port = args.test_port or int(os.getenv("TEST_DB_PORT", str(EXPECTED_TEST_PORT)))
    db_name = args.test_db or os.getenv("TEST_DB_NAME", EXPECTED_TEST_DB)
    db_user = os.getenv("TEST_DB_USER", "postgres")
    db_password = os.getenv("TEST_DB_PASSWORD", "testpassword")
    gateway_url = os.getenv("TEST_GATEWAY_URL", "http://127.0.0.1:8082")
    product_url = os.getenv("TEST_PRODUCT_URL", "http://127.0.0.1:8001")
    internal_key = os.getenv("INTERNAL_API_KEY", "testinternal")

    # FAIL CLOSED: Validate safety unconditionally before doing ANYTHING
    try:
        validate_target_safety(db_host, db_port, db_name)
    except SecurityAbortError as e:
        print(f"\n[SECURITY ABORT]: {e}", file=sys.stderr)
        sys.exit(2)

    if not args.no_setup:
        setup_environment(db_host, db_port, db_user, db_password, db_name)

    try:
        test_gateway_security(
            host=db_host,
            port=db_port,
            user=db_user,
            password=db_password,
            dbname=db_name,
            gateway_url=gateway_url,
            product_url=product_url,
            internal_key=internal_key
        )
    finally:
        if not args.no_teardown and not args.no_setup:
            teardown_environment()

if __name__ == "__main__":
    main()
