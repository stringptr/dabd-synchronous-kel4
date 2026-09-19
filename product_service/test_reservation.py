import os
os.environ["INTERNAL_API_KEY"] = "testinternal"

import uuid
import pytest
from datetime import datetime, timedelta
from fastapi.testclient import TestClient
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from sqlalchemy.engine import make_url

import product_service.main as main
from product_service.main import (
    app, get_db, Product, Inventory, StockReservation, StockReservationItem
)

SQLALCHEMY_DATABASE_URL = os.getenv("TEST_DATABASE_URL", "postgresql+psycopg2://postgres:postgres@localhost:5433/test_db")
engine = create_engine(SQLALCHEMY_DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture(autouse=True)
def verify_test_environment():
    url = make_url(str(engine.url))
    if url.database != "test_db":
        raise RuntimeError(f"Destructive tests target '{url.database}', expected 'test_db'")
    if os.getenv("TEST_ENV") != "true":
        raise RuntimeError("Destructive tests require TEST_ENV=true")

    def override_get_db():
        db = TestingSessionLocal()
        try:
            yield db
        finally:
            db.close()

    app.dependency_overrides[get_db] = override_get_db
    yield
    app.dependency_overrides.clear()

client = TestClient(app)
INTERNAL_HEADERS = {"X-Internal-Secret": "testinternal"}

@pytest.fixture
def test_tracker():
    pids = []
    op_ids = []
    yield pids, op_ids
    with engine.begin() as conn:
        if op_ids:
            conn.execute(text("""
                DELETE FROM stock_reservation_items 
                WHERE reservation_id IN (SELECT reservation_id FROM stock_reservations WHERE operation_id = ANY(:ops))
            """), {"ops": op_ids})
            conn.execute(text("DELETE FROM stock_reservations WHERE operation_id = ANY(:ops)"), {"ops": op_ids})
        if pids:
            conn.execute(text("DELETE FROM stock_reservation_items WHERE product_id = ANY(:pids)"), {"pids": pids})
            conn.execute(text("DELETE FROM inventory WHERE product_id = ANY(:pids)"), {"pids": pids})
            conn.execute(text("DELETE FROM products WHERE product_id = ANY(:pids)"), {"pids": pids})

def create_test_product(pids_list, name="Test Prod", price=25.0, warehouses_stock=None):
    """
    Helper to insert a product and inventory rows directly into test_db.
    warehouses_stock is a dict of {warehouse_id: quantity_on_hand}
    """
    if warehouses_stock is None:
        warehouses_stock = {1: 20}

    with engine.begin() as conn:
        res = conn.execute(text("""
            INSERT INTO products (name, description, price)
            VALUES (:name, 'Test description', :price)
            RETURNING product_id
        """), {"name": f"{name} {uuid.uuid4().hex[:6]}", "price": price})
        pid = res.scalar()
        pids_list.append(pid)

        for wid, qoh in warehouses_stock.items():
            conn.execute(text("""
                INSERT INTO inventory (product_id, warehouse_id, quantity_on_hand, reserved_quantity, reorder_level)
                VALUES (:pid, :wid, :qoh, 0, 10)
            """), {"pid": pid, "wid": wid, "qoh": qoh})
        
    return pid

# 1. Successful single-warehouse reservation
def test_create_reservation_success_single_warehouse(test_tracker):
    pids, op_ids = test_tracker
    pid = create_test_product(pids, warehouses_stock={1: 20})
    op_id = f"op_test_single_{uuid.uuid4().hex[:8]}"
    op_ids.append(op_id)

    payload = {
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 5}]
    }
    response = client.post("/internal/reservations", json=payload, headers=INTERNAL_HEADERS)
    assert response.status_code == 201
    data = response.json()
    assert data["operation_id"] == op_id
    assert data["status"] == "ACTIVE"
    assert len(data["items"]) == 1
    assert data["items"][0]["product_id"] == pid
    assert data["items"][0]["warehouse_id"] == 1
    assert data["items"][0]["quantity"] == 5

    # Verify inventory state in database
    with engine.connect() as conn:
        inv = conn.execute(text("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = :pid AND warehouse_id = 1"), {"pid": pid}).fetchone()
        assert inv[0] == 20
        assert inv[1] == 5

# 2. Multi-warehouse deterministic allocation
def test_create_reservation_multi_warehouse_allocation(test_tracker):
    pids, op_ids = test_tracker
    # Warehouse 1 has 4, Warehouse 2 has 6
    pid = create_test_product(pids, warehouses_stock={1: 4, 2: 6})
    op_id = f"op_test_multi_{uuid.uuid4().hex[:8]}"
    op_ids.append(op_id)

    # Request 7 units: should take 4 from wh 1, and 3 from wh 2
    payload = {
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 7}]
    }
    response = client.post("/internal/reservations", json=payload, headers=INTERNAL_HEADERS)
    assert response.status_code == 201
    data = response.json()
    assert data["status"] == "ACTIVE"
    assert len(data["items"]) == 2

    # Warehouse 1 allocation
    assert data["items"][0]["warehouse_id"] == 1
    assert data["items"][0]["quantity"] == 4
    # Warehouse 2 allocation
    assert data["items"][1]["warehouse_id"] == 2
    assert data["items"][1]["quantity"] == 3

    # Check database rows
    with engine.connect() as conn:
        inv1 = conn.execute(text("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = :pid AND warehouse_id = 1"), {"pid": pid}).fetchone()
        inv2 = conn.execute(text("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = :pid AND warehouse_id = 2"), {"pid": pid}).fetchone()
        assert inv1[0] == 4 and inv1[1] == 4
        assert inv2[0] == 6 and inv2[1] == 3

# 3. Insufficient stock fails with 409 and rolls back all-or-nothing
def test_create_reservation_insufficient_stock_rollback(test_tracker):
    pids, op_ids = test_tracker
    pid1 = create_test_product(pids, warehouses_stock={1: 5})
    pid2 = create_test_product(pids, warehouses_stock={1: 2})
    op_id = f"op_test_insufficient_{uuid.uuid4().hex[:8]}"
    op_ids.append(op_id)

    # pid1 has enough (5 >= 4), but pid2 does NOT (2 < 3)
    payload = {
        "operation_id": op_id,
        "items": [
            {"product_id": pid1, "quantity": 4},
            {"product_id": pid2, "quantity": 3}
        ]
    }
    response = client.post("/internal/reservations", json=payload, headers=INTERNAL_HEADERS)
    assert response.status_code == 409
    assert "Insufficient stock" in response.json()["detail"]

    # Verify all-or-nothing: NEITHER product has any reserved_quantity held
    with engine.connect() as conn:
        inv1 = conn.execute(text("SELECT reserved_quantity FROM inventory WHERE product_id = :pid"), {"pid": pid1}).scalar()
        inv2 = conn.execute(text("SELECT reserved_quantity FROM inventory WHERE product_id = :pid"), {"pid": pid2}).scalar()
        assert inv1 == 0
        assert inv2 == 0
        res_count = conn.execute(text("SELECT count(*) FROM stock_reservations WHERE operation_id = :op"), {"op": op_id}).scalar()
        assert res_count == 0

# 4. Nonexistent product returns 404
def test_create_reservation_nonexistent_product():
    payload = {
        "operation_id": f"op_404_{uuid.uuid4().hex[:8]}",
        "items": [{"product_id": 9999999, "quantity": 1}]
    }
    response = client.post("/internal/reservations", json=payload, headers=INTERNAL_HEADERS)
    assert response.status_code == 404
    assert "Products not found" in response.json()["detail"]

# 5. Duplicate product_id within request returns 422
def test_create_reservation_duplicate_product_rejected(test_tracker):
    pids, _ = test_tracker
    pid = create_test_product(pids, warehouses_stock={1: 10})
    payload = {
        "operation_id": f"op_dup_{uuid.uuid4().hex[:8]}",
        "items": [
            {"product_id": pid, "quantity": 1},
            {"product_id": pid, "quantity": 2}
        ]
    }
    response = client.post("/internal/reservations", json=payload, headers=INTERNAL_HEADERS)
    assert response.status_code == 422
    assert "Duplicate product_id" in response.json()["detail"]

# 6. Negative or zero quantity rejected
def test_create_reservation_invalid_quantity():
    # quantity = 0
    res1 = client.post("/internal/reservations", json={
        "operation_id": f"op_zero_{uuid.uuid4().hex[:8]}",
        "items": [{"product_id": 1, "quantity": 0}]
    }, headers=INTERNAL_HEADERS)
    assert res1.status_code == 422

    # quantity < 0
    res2 = client.post("/internal/reservations", json={
        "operation_id": f"op_neg_{uuid.uuid4().hex[:8]}",
        "items": [{"product_id": 1, "quantity": -3}]
    }, headers=INTERNAL_HEADERS)
    assert res2.status_code == 422

# 7. Idempotent reservation replay with matching fingerprint
def test_create_reservation_idempotency_exact_match(test_tracker):
    pids, op_ids = test_tracker
    pid = create_test_product(pids, warehouses_stock={1: 20})
    op_id = f"op_idemp_{uuid.uuid4().hex[:8]}"
    op_ids.append(op_id)

    payload = {
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 3}]
    }
    # First attempt: 201 Created
    res1 = client.post("/internal/reservations", json=payload, headers=INTERNAL_HEADERS)
    assert res1.status_code == 201
    data1 = res1.json()

    # Second attempt: 200 OK with identical reservation
    res2 = client.post("/internal/reservations", json=payload, headers=INTERNAL_HEADERS)
    assert res2.status_code == 200
    data2 = res2.json()

    assert data1["reservation_id"] == data2["reservation_id"]
    assert data1["expires_at"] == data2["expires_at"]

    # Verify inventory was NOT reserved twice
    with engine.connect() as conn:
        reserved = conn.execute(text("SELECT reserved_quantity FROM inventory WHERE product_id = :pid"), {"pid": pid}).scalar()
        assert reserved == 3

# 8. Idempotency payload mismatch returns 409 Conflict
def test_create_reservation_idempotency_payload_mismatch(test_tracker):
    pids, op_ids = test_tracker
    pid = create_test_product(pids, warehouses_stock={1: 20})
    op_id = f"op_mismatch_{uuid.uuid4().hex[:8]}"
    op_ids.append(op_id)

    payload1 = {
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 3}]
    }
    res1 = client.post("/internal/reservations", json=payload1, headers=INTERNAL_HEADERS)
    assert res1.status_code == 201

    payload2 = {
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 5}] # Different quantity
    }
    res2 = client.post("/internal/reservations", json=payload2, headers=INTERNAL_HEADERS)
    assert res2.status_code == 409
    assert "conflicting payload" in res2.json()["detail"]

# 9. Confirm reservation permanently deducts quantity_on_hand and releases reserved_quantity
def test_confirm_reservation_success(test_tracker):
    pids, op_ids = test_tracker
    pid = create_test_product(pids, warehouses_stock={1: 20})
    op_id = f"op_confirm_{uuid.uuid4().hex[:8]}"
    op_ids.append(op_id)

    # Reserve 5 units
    client.post("/internal/reservations", json={
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 5}]
    }, headers=INTERNAL_HEADERS)

    # Confirm
    res = client.post(f"/internal/reservations/{op_id}/confirm", headers=INTERNAL_HEADERS)
    assert res.status_code == 200
    data = res.json()
    assert data["status"] == "CONFIRMED"

    # Database verification
    with engine.connect() as conn:
        inv = conn.execute(text("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = :pid AND warehouse_id = 1"), {"pid": pid}).fetchone()
        assert inv[0] == 15 # 20 - 5
        assert inv[1] == 0  # 5 - 5

# 10. Repeated confirmation is idempotent
def test_confirm_reservation_idempotent(test_tracker):
    pids, op_ids = test_tracker
    pid = create_test_product(pids, warehouses_stock={1: 20})
    op_id = f"op_confirm_idemp_{uuid.uuid4().hex[:8]}"
    op_ids.append(op_id)

    client.post("/internal/reservations", json={
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 4}]
    }, headers=INTERNAL_HEADERS)

    # First confirm
    res1 = client.post(f"/internal/reservations/{op_id}/confirm", headers=INTERNAL_HEADERS)
    assert res1.status_code == 200
    assert res1.json()["status"] == "CONFIRMED"

    # Second confirm
    res2 = client.post(f"/internal/reservations/{op_id}/confirm", headers=INTERNAL_HEADERS)
    assert res2.status_code == 200
    assert res2.json()["status"] == "CONFIRMED"

    # Check stock was deducted only once
    with engine.connect() as conn:
        inv = conn.execute(text("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = :pid AND warehouse_id = 1"), {"pid": pid}).fetchone()
        assert inv[0] == 16
        assert inv[1] == 0

# 11. Release reservation restores available stock without altering quantity_on_hand
def test_release_reservation_success(test_tracker):
    pids, op_ids = test_tracker
    pid = create_test_product(pids, warehouses_stock={1: 20})
    op_id = f"op_release_{uuid.uuid4().hex[:8]}"
    op_ids.append(op_id)

    client.post("/internal/reservations", json={
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 6}]
    }, headers=INTERNAL_HEADERS)

    # Release
    res = client.post(f"/internal/reservations/{op_id}/release", headers=INTERNAL_HEADERS)
    assert res.status_code == 200
    data = res.json()
    assert data["status"] == "RELEASED"

    # Database verification
    with engine.connect() as conn:
        inv = conn.execute(text("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = :pid AND warehouse_id = 1"), {"pid": pid}).fetchone()
        assert inv[0] == 20 # Unchanged
        assert inv[1] == 0  # Hold released

# 12. Repeated release is idempotent
def test_release_reservation_idempotent(test_tracker):
    pids, op_ids = test_tracker
    pid = create_test_product(pids, warehouses_stock={1: 20})
    op_id = f"op_release_idemp_{uuid.uuid4().hex[:8]}"
    op_ids.append(op_id)

    client.post("/internal/reservations", json={
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 6}]
    }, headers=INTERNAL_HEADERS)

    # First release
    res1 = client.post(f"/internal/reservations/{op_id}/release", headers=INTERNAL_HEADERS)
    assert res1.status_code == 200
    assert res1.json()["status"] == "RELEASED"

    # Second release
    res2 = client.post(f"/internal/reservations/{op_id}/release", headers=INTERNAL_HEADERS)
    assert res2.status_code == 200
    assert res2.json()["status"] == "RELEASED"

    with engine.connect() as conn:
        inv = conn.execute(text("SELECT quantity_on_hand, reserved_quantity FROM inventory WHERE product_id = :pid AND warehouse_id = 1"), {"pid": pid}).fetchone()
        assert inv[0] == 20
        assert inv[1] == 0

# 13. Conflicting terminal transitions return 409 Conflict
def test_conflicting_terminal_transitions(test_tracker):
    pids, op_ids = test_tracker
    pid = create_test_product(pids, warehouses_stock={1: 20})
    
    # Test 1: Confirm after Release -> 409
    op1 = f"op_term_rel_{uuid.uuid4().hex[:8]}"
    op_ids.append(op1)
    client.post("/internal/reservations", json={"operation_id": op1, "items": [{"product_id": pid, "quantity": 2}]}, headers=INTERNAL_HEADERS)
    client.post(f"/internal/reservations/{op1}/release", headers=INTERNAL_HEADERS)
    conf_res = client.post(f"/internal/reservations/{op1}/confirm", headers=INTERNAL_HEADERS)
    assert conf_res.status_code == 409
    assert "already released" in conf_res.json()["detail"]

    # Test 2: Release after Confirm -> 409
    op2 = f"op_term_conf_{uuid.uuid4().hex[:8]}"
    op_ids.append(op2)
    client.post("/internal/reservations", json={"operation_id": op2, "items": [{"product_id": pid, "quantity": 2}]}, headers=INTERNAL_HEADERS)
    client.post(f"/internal/reservations/{op2}/confirm", headers=INTERNAL_HEADERS)
    rel_res = client.post(f"/internal/reservations/{op2}/release", headers=INTERNAL_HEADERS)
    assert rel_res.status_code == 409
    assert "already confirmed" in rel_res.json()["detail"]

# 14. Confirm expired reservation atomically finalizes EXPIRED and releases hold
def test_confirm_expired_reservation_finalizes_and_releases(test_tracker):
    pids, op_ids = test_tracker
    pid = create_test_product(pids, warehouses_stock={1: 20})
    op_id = f"op_expired_{uuid.uuid4().hex[:8]}"
    op_ids.append(op_id)

    client.post("/internal/reservations", json={
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 5}]
    }, headers=INTERNAL_HEADERS)

    # Verify hold was established
    with engine.connect() as conn:
        assert conn.execute(text("SELECT reserved_quantity FROM inventory WHERE product_id = :pid"), {"pid": pid}).scalar() == 5

    # Backdate expires_at into the past
    with engine.begin() as conn:
        conn.execute(text("""
            UPDATE stock_reservations 
            SET expires_at = CURRENT_TIMESTAMP - INTERVAL '15 minutes'
            WHERE operation_id = :op
        """), {"op": op_id})

    # Call confirm -> must fail with 409 Expired
    res = client.post(f"/internal/reservations/{op_id}/confirm", headers=INTERNAL_HEADERS)
    assert res.status_code == 409
    assert "expired" in res.json()["detail"].lower()

    # Verify status is EXPIRED and reserved_quantity hold was released
    with engine.connect() as conn:
        status = conn.execute(text("SELECT status FROM stock_reservations WHERE operation_id = :op"), {"op": op_id}).scalar()
        reserved = conn.execute(text("SELECT reserved_quantity FROM inventory WHERE product_id = :pid"), {"pid": pid}).scalar()
        assert status == "EXPIRED"
        assert reserved == 0

    # Repeat confirm -> 409 Conflict
    rep_conf = client.post(f"/internal/reservations/{op_id}/confirm", headers=INTERNAL_HEADERS)
    assert rep_conf.status_code == 409

    # Release on expired -> 409 Conflict
    rep_rel = client.post(f"/internal/reservations/{op_id}/release", headers=INTERNAL_HEADERS)
    assert rep_rel.status_code == 409

# 15. GET reservation returns durable allocations
def test_get_reservation(test_tracker):
    pids, op_ids = test_tracker
    pid = create_test_product(pids, warehouses_stock={1: 15})
    op_id = f"op_get_{uuid.uuid4().hex[:8]}"
    op_ids.append(op_id)

    client.post("/internal/reservations", json={
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 4}]
    }, headers=INTERNAL_HEADERS)

    res = client.get(f"/internal/reservations/{op_id}", headers=INTERNAL_HEADERS)
    assert res.status_code == 200
    data = res.json()
    assert data["operation_id"] == op_id
    assert data["status"] == "ACTIVE"
    assert len(data["items"]) == 1
    assert data["items"][0]["quantity"] == 4

    # GET nonexistent returns 404
    res_404 = client.get(f"/internal/reservations/nonexistent_op_id", headers=INTERNAL_HEADERS)
    assert res_404.status_code == 404

# 16. Internal security headers enforced
def test_internal_security():
    op_id = f"op_sec_{uuid.uuid4().hex[:8]}"
    # Missing header -> 422
    res_missing = client.post("/internal/reservations", json={"operation_id": op_id, "items": [{"product_id": 1, "quantity": 1}]})
    assert res_missing.status_code == 422

    # Wrong secret -> 403
    res_wrong = client.post("/internal/reservations", json={"operation_id": op_id, "items": [{"product_id": 1, "quantity": 1}]}, headers={"X-Internal-Secret": "invalid_secret"})
    assert res_wrong.status_code == 403

# 17. Public product stock reflection reflects available stock without masking
def test_public_product_stock_reflection(test_tracker):
    pids, op_ids = test_tracker
    pid = create_test_product(pids, warehouses_stock={1: 12})
    op_id = f"op_pub_{uuid.uuid4().hex[:8]}"
    op_ids.append(op_id)

    # Initial stock
    p_init = client.get(f"/products/{pid}").json()
    assert p_init["total_stock"] == 12

    # Reserve 5 units
    client.post("/internal/reservations", json={
        "operation_id": op_id,
        "items": [{"product_id": pid, "quantity": 5}]
    }, headers=INTERNAL_HEADERS)

    # Available stock reflects reservation
    p_res = client.get(f"/products/{pid}").json()
    assert p_res["total_stock"] == 7

    # Confirm reservation
    client.post(f"/internal/reservations/{op_id}/confirm", headers=INTERNAL_HEADERS)

    # Stock after confirm remains 7
    p_conf = client.get(f"/products/{pid}").json()
    assert p_conf["total_stock"] == 7
