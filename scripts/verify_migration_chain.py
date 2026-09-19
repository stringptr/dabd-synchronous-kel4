import os
import sys
import time
import subprocess
import psycopg2
from psycopg2.extras import RealDictCursor

COMPOSE_FILE = "compose.test.yaml"
TEST_HOST = "127.0.0.1"
TEST_PORT = 5434
TEST_USER = "postgres"
TEST_PASSWORD = "testpassword"
TEST_DBNAME = "test_db"

def get_conn():
    return psycopg2.connect(
        host=TEST_HOST,
        port=TEST_PORT,
        user=TEST_USER,
        password=TEST_PASSWORD,
        dbname=TEST_DBNAME,
        cursor_factory=RealDictCursor
    )

def run_cmd(cmd, env=None, check=True):
    merged = os.environ.copy()
    if env:
        merged.update(env)
    print(f"--> Running: {' '.join(cmd)}")
    return subprocess.run(cmd, check=check, text=True, capture_output=True, env=merged)

def wait_for_postgres(timeout=30):
    start = time.time()
    while time.time() - start < timeout:
        try:
            conn = get_conn()
            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
            conn.close()
            print("Isolated PostgreSQL (port 5434) is ready!")
            return
        except Exception:
            time.sleep(1)
    raise TimeoutError("PostgreSQL 5434 did not become ready.")

def main():
    print("=" * 70)
    print("MIGRATION CHAIN SAFETY & DOWNGRADE PRECONDITION VERIFICATION")
    print("Isolated target: 127.0.0.1:5434 / test_db (NEVER touches live 5433)")
    print("=" * 70)

    # 1. Reset isolated container stack
    run_cmd(["docker", "compose", "-f", COMPOSE_FILE, "down", "-v"], check=False)
    run_cmd(["docker", "compose", "-f", COMPOSE_FILE, "up", "-d", "test-postgres"])
    wait_for_postgres()

    alembic_env = {
        "DB_HOST": TEST_HOST,
        "DB_PORT": str(TEST_PORT),
        "POSTGRES_USER": TEST_USER,
        "POSTGRES_PASSWORD": TEST_PASSWORD,
        "POSTGRES_DB": TEST_DBNAME
    }

    # 2. Stamp baseline cf95d0e3a541
    print("\n[Step 1] Stamping baseline cf95d0e3a541...")
    res = run_cmd(["alembic", "stamp", "cf95d0e3a541"], env=alembic_env)
    assert res.returncode == 0

    # 3. Upgrade to head
    print("\n[Step 2] Upgrading Alembic to head (c74b1e5a2981 -> e83f2a1b9c40)...")
    res = run_cmd(["alembic", "upgrade", "head"], env=alembic_env)
    assert res.returncode == 0
    print("Upgrade to head successful!")

    # Verify schema at head
    conn = get_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT version_num FROM alembic_version;")
        ver = cur.fetchone()["version_num"]
        print(f"Current Alembic revision in isolated DB: {ver}")
        assert ver == "e83f2a1b9c40"

        cur.execute("SELECT column_name, data_type FROM information_schema.columns WHERE table_name='stock_reservations';")
        cols = {r["column_name"]: r["data_type"] for r in cur.fetchall()}
        print(f"stock_reservations columns: {list(cols.keys())}")
        assert "failure_code" in cols, "failure_code column missing"
        assert "failure_reason" in cols, "failure_reason column missing"
        assert cols["expires_at"] == "timestamp with time zone", "expires_at not timestamptz"
        assert cols["created_at"] == "timestamp with time zone", "created_at not timestamptz"
        assert cols["updated_at"] == "timestamp with time zone", "updated_at not timestamptz"
    conn.close()

    # 4. Test Safe Precondition on Incompatible Data
    print("\n[Step 3] Testing Safe Precondition: Attempting downgrade when FAILED row exists...")
    conn = get_conn()
    with conn.cursor() as cur:
        cur.execute("""
            INSERT INTO stock_reservations (operation_id, request_fingerprint, status, failure_code, failure_reason, expires_at)
            VALUES ('test-incompat-op', 'fakehash', 'FAILED', 'PRODUCT_NOT_FOUND', 'Products not found: [999]', clock_timestamp());
        """)
        conn.commit()
    conn.close()

    # Attempt downgrade -> must fail because FAILED row exists!
    res = run_cmd(["alembic", "downgrade", "c74b1e5a2981"], env=alembic_env, check=False)
    print(f"Downgrade returncode: {res.returncode}")
    print(f"Downgrade stderr snippet:\n{res.stderr[-300:]}")
    assert res.returncode != 0, "Downgrade MUST fail when incompatible FAILED records exist"
    assert "Precondition failed" in res.stderr or "Cannot safely downgrade" in res.stderr
    print("PASSED: Precondition successfully blocked unsafe downgrade!")

    # Verify data was NOT destroyed
    conn = get_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT status, failure_code FROM stock_reservations WHERE operation_id = 'test-incompat-op';")
        row = cur.fetchone()
        assert row is not None
        assert row["status"] == "FAILED"
        assert row["failure_code"] == "PRODUCT_NOT_FOUND"
        print(f"Verified row remained intact without data corruption: {dict(row)}")
        
        # Clean up the test row to test clean downgrade
        cur.execute("DELETE FROM stock_reservations WHERE operation_id = 'test-incompat-op';")
        conn.commit()
    conn.close()

    # 5. Test Clean Downgrade on Compatible / Clean Data
    print("\n[Step 4] Testing Clean Downgrade on compatible data...")
    res = run_cmd(["alembic", "downgrade", "c74b1e5a2981"], env=alembic_env)
    assert res.returncode == 0
    print("Downgraded to c74b1e5a2981 successfully!")

    conn = get_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT version_num FROM alembic_version;")
        assert cur.fetchone()["version_num"] == "c74b1e5a2981"
        cur.execute("SELECT column_name FROM information_schema.columns WHERE table_name='stock_reservations';")
        cols = [r["column_name"] for r in cur.fetchall()]
        assert "failure_code" not in cols, "failure_code should be dropped after downgrade"
        assert "failure_reason" not in cols, "failure_reason should be dropped after downgrade"
    conn.close()

    # 6. Test Safe Preconditions on c74b1e5a2981 (Reject downgrade if data exists)
    print("\n[Step 5A] Testing c74b1e5a2981 Precondition: Reject downgrade if reservations exist...")
    conn = get_conn()
    with conn.cursor() as cur:
        cur.execute("""
            INSERT INTO stock_reservations (operation_id, request_fingerprint, status, expires_at)
            VALUES ('test-c74b-safeguard-op', 'fakehash', 'ACTIVE', clock_timestamp());
        """)
        conn.commit()
    conn.close()

    res = run_cmd(["alembic", "downgrade", "3b98a300aa73"], env=alembic_env, check=False)
    print(f"Downgrade with reservations returncode: {res.returncode}")
    print(f"Downgrade stderr snippet:\n{res.stderr[-300:]}")
    assert res.returncode != 0, "Downgrade MUST fail when stock_reservations contains records"
    assert "Precondition failed" in res.stderr and "stock_reservations" in res.stderr
    print("PASSED: c74b1e5a2981 safeguard successfully blocked destructive downgrade with active reservations!")

    # Verify reservation remained intact
    conn = get_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT status FROM stock_reservations WHERE operation_id = 'test-c74b-safeguard-op';")
        assert cur.fetchone()["status"] == "ACTIVE"
        # Clean up test row
        cur.execute("DELETE FROM stock_reservations WHERE operation_id = 'test-c74b-safeguard-op';")
        conn.commit()
    conn.close()

    print("\n[Step 5B] Testing c74b1e5a2981 Precondition: Reject downgrade if reserved_quantity > 0...")
    conn = get_conn()
    with conn.cursor() as cur:
        # Set product 1 reserved_quantity to 5 (assuming quantity_on_hand >= 5)
        cur.execute("UPDATE inventory SET quantity_on_hand = 10, reserved_quantity = 5 WHERE product_id = 1;")
        conn.commit()
    conn.close()

    res = run_cmd(["alembic", "downgrade", "3b98a300aa73"], env=alembic_env, check=False)
    print(f"Downgrade with reserved_quantity returncode: {res.returncode}")
    print(f"Downgrade stderr snippet:\n{res.stderr[-300:]}")
    assert res.returncode != 0, "Downgrade MUST fail when inventory has reserved_quantity > 0"
    assert "Precondition failed" in res.stderr and "reserved_quantity" in res.stderr
    print("PASSED: c74b1e5a2981 safeguard successfully blocked destructive downgrade with nonzero reserved_quantity!")

    # Reset inventory
    conn = get_conn()
    with conn.cursor() as cur:
        cur.execute("UPDATE inventory SET reserved_quantity = 0 WHERE product_id = 1;")
        conn.commit()
    conn.close()

    # 7. Clean Downgrade to Stage 2A (3b98a300aa73)
    print("\n[Step 5C] Clean Downgrading to Stage 2A baseline 3b98a300aa73 on empty tables...")
    res = run_cmd(["alembic", "downgrade", "3b98a300aa73"], env=alembic_env)
    assert res.returncode == 0
    print("Downgraded to 3b98a300aa73 successfully!")

    conn = get_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT version_num FROM alembic_version;")
        assert cur.fetchone()["version_num"] == "3b98a300aa73"
        cur.execute("SELECT to_regclass('stock_reservations');")
        assert cur.fetchone()["to_regclass"] is None, "stock_reservations table should be dropped"
        cur.execute("SELECT column_name FROM information_schema.columns WHERE table_name='inventory' AND column_name='reserved_quantity';")
        assert len(cur.fetchall()) == 0, "reserved_quantity column should be dropped"
    conn.close()

    # 7. Re-upgrade back to head
    print("\n[Step 6] Re-upgrading to head from 3b98a300aa73...")
    res = run_cmd(["alembic", "upgrade", "head"], env=alembic_env)
    assert res.returncode == 0
    print("Re-upgraded to head successfully!")

    conn = get_conn()
    with conn.cursor() as cur:
        cur.execute("SELECT version_num FROM alembic_version;")
        assert cur.fetchone()["version_num"] == "e83f2a1b9c40"
    conn.close()

    # 8. Teardown
    print("\n[Step 7] Tearing down isolated test stack...")
    run_cmd(["docker", "compose", "-f", COMPOSE_FILE, "down", "-v"], check=False)
    print("\n" + "*" * 70)
    print("ALL MIGRATION CHAIN & DOWNGRADE SAFETY CHECKS PASSED!")
    print("*" * 70)

if __name__ == "__main__":
    main()
