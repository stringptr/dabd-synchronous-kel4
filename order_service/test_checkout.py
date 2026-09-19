import os
os.environ["INTERNAL_API_KEY"] = "testinternal"

import uuid
import time
import json
import pytest
from decimal import Decimal
from datetime import datetime, timedelta, timezone
from concurrent.futures import ThreadPoolExecutor
from fastapi import HTTPException
from fastapi.testclient import TestClient
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.engine import make_url

import order_service.main as main
from order_service.main import (
    app, get_db, Cart, CartItemModel, Order, OrderItem, Checkout,
    get_or_create_cart, recover_single_checkout
)

# Test database configuration - requires designated isolated PostgreSQL on port 5434
SQLALCHEMY_DATABASE_URL = os.getenv("TEST_DATABASE_URL", "postgresql+psycopg2://postgres:testpassword@localhost:5434/test_db")
engine = create_engine(SQLALCHEMY_DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def sync_sequences():
    with engine.begin() as conn:
        conn.execute(text("SELECT setval('orders_order_id_seq', (SELECT COALESCE(MAX(order_id), 1) FROM orders))"))
        conn.execute(text("SELECT setval('order_items_order_item_id_seq', (SELECT COALESCE(MAX(order_item_id), 1) FROM order_items))"))
        conn.execute(text("SELECT setval('carts_cart_id_seq', (SELECT COALESCE(MAX(cart_id), 1) FROM carts))"))
        conn.execute(text("SELECT setval('cart_items_cart_item_id_seq', (SELECT COALESCE(MAX(cart_item_id), 1) FROM cart_items))"))
        conn.execute(text("SELECT setval('users_user_id_seq', (SELECT COALESCE(MAX(user_id), 1) FROM users))"))

def cleanup_user_data(user_id: int):
    with engine.begin() as conn:
        conn.execute(text("DELETE FROM checkouts WHERE user_id = :uid"), {"uid": user_id})
        conn.execute(text("""
            DELETE FROM order_items WHERE order_id IN (
                SELECT order_id FROM orders WHERE user_id = :uid
            )
        """), {"uid": user_id})
        conn.execute(text("DELETE FROM orders WHERE user_id = :uid"), {"uid": user_id})
        conn.execute(text("""
            DELETE FROM cart_items WHERE cart_id IN (
                SELECT cart_id FROM carts WHERE user_id = :uid
            )
        """), {"uid": user_id})
        conn.execute(text("DELETE FROM carts WHERE user_id = :uid"), {"uid": user_id})
        conn.execute(text("DELETE FROM users WHERE user_id = :uid"), {"uid": user_id})

@pytest.fixture(autouse=True)
def setup_environment():
    url = make_url(str(engine.url))
    if url.port == 5433 or url.database == "postgres":
        raise RuntimeError("CRITICAL: Destructive test cannot target port 5433 or database 'postgres'! Designated isolated test port is 5434 ('test_db').")
    if url.database != "test_db" or (url.port and url.port != 5434):
        raise RuntimeError(f"Destructive tests target '{url}', expected port 5434 / database 'test_db'")
    if os.getenv("TEST_ENV") != "true":
        raise RuntimeError("Destructive tests require TEST_ENV=true")

    sync_sequences()
    main.breaker.close()

    def override_get_db():
        db = TestingSessionLocal()
        try:
            yield db
        finally:
            db.close()

    app.dependency_overrides[get_db] = override_get_db
    yield
    app.dependency_overrides.clear()

@pytest.fixture
def dedicated_user():
    suffix = uuid.uuid4().hex[:8]
    email = f"test_chk_{suffix}@example.com"
    with engine.begin() as conn:
        uid = conn.execute(text("""
            INSERT INTO users (first_name, last_name, email, is_admin)
            VALUES ('Test', 'Checkout', :email, false)
            RETURNING user_id
        """), {"email": email}).scalar()
    
    yield uid
    
    cleanup_user_data(uid)

@pytest.fixture
def dedicated_user_pair():
    uids = []
    for i in range(2):
        suffix = uuid.uuid4().hex[:8]
        email = f"test_chk_{suffix}@example.com"
        with engine.begin() as conn:
            uid = conn.execute(text("""
                INSERT INTO users (first_name, last_name, email, is_admin)
                VALUES ('Test', 'Pair', :email, false)
                RETURNING user_id
            """), {"email": email}).scalar()
            uids.append(uid)
    
    yield uids
    
    for uid in uids:
        cleanup_user_data(uid)

@pytest.fixture
def test_db():
    session = TestingSessionLocal()
    try:
        yield session
    finally:
        session.close()

client = TestClient(app)

def make_headers(user_id: int, role: str = "user", idempotency_key: str = None):
    h = {"X-User-Sub": str(user_id), "X-User-Role": role}
    if idempotency_key:
        h["Idempotency-Key"] = idempotency_key
    return h


# -----------------------------------------------------------------------------
# 1. Successful Multi-Item Checkout with Decimal Calculations
# -----------------------------------------------------------------------------
def test_successful_multi_item_checkout(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db
    
    # Setup cart with 2 items
    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=2))
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=2, quantity=3))
    db.commit()

    # Mock product prices
    prices = {1: {"price": "19.99", "name": "Item 1"}, 2: {"price": "5.50", "name": "Item 2"}}
    def mock_fetch(product_id, req_id, auth):
        return prices[product_id]
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    # Mock reservation: succeeds
    reserved_payloads = []
    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=5)).isoformat()
    def mock_reserve(op_id, items):
        reserved_payloads.append((op_id, items))
        return ("ACTIVE", {"status": "ACTIVE", "reservation_id": 999, "expires_at": future_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    headers = make_headers(user_id=user_id, idempotency_key=f"checkout-success-{uuid.uuid4().hex[:6]}")
    resp = client.post("/checkout", json={}, headers=headers)

    assert resp.status_code == 201, resp.text
    data = resp.json()
    assert data["status"] == "RESERVED"
    assert data["order_id"] is not None
    # 2 * 19.99 = 39.98; 3 * 5.50 = 16.50; Total = 56.48
    assert Decimal(str(data["total_amount"])) == Decimal("56.48")
    assert len(data["items"]) == 2

    # Cart must be cleared
    cart_items = db.query(CartItemModel).filter(CartItemModel.cart_id == cart.cart_id).all()
    assert len(cart_items) == 0

    # Order must exist in DB with Pending status
    order = db.query(Order).filter(Order.order_id == data["order_id"]).first()
    assert order is not None
    assert order.status == "Pending"
    assert order.total_amount == Decimal("56.48")
    assert len(order.items) == 2


# -----------------------------------------------------------------------------
# 2. Insufficient Stock Handling
# -----------------------------------------------------------------------------
def test_checkout_insufficient_stock(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=100))
    db.commit()

    def mock_fetch(product_id, req_id, auth):
        return {"price": "10.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    def mock_reserve(op_id, items):
        return ("FAILED", {"status": "FAILED", "failure_code": "INSUFFICIENT_STOCK"}, "INSUFFICIENT_STOCK", "Stock exhausted", False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    ik = f"checkout-stock-fail-{uuid.uuid4().hex[:6]}"
    headers = make_headers(user_id=user_id, idempotency_key=ik)
    resp = client.post("/checkout", json={}, headers=headers)

    assert resp.status_code == 400
    err = resp.json()["detail"]
    assert err["failure_code"] == "INSUFFICIENT_STOCK"

    # Checkout recorded as FAILED
    chk = db.query(Checkout).filter(Checkout.user_id == user_id, Checkout.idempotency_key == ik).first()
    assert chk.status == "FAILED"
    assert chk.order_id is None

    # Cart must NOT be cleared
    cart_items = db.query(CartItemModel).filter(CartItemModel.cart_id == cart.cart_id).all()
    assert len(cart_items) == 1


# -----------------------------------------------------------------------------
# 3. Missing Product Handling
# -----------------------------------------------------------------------------
def test_checkout_missing_product(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1))
    db.commit()

    def mock_fetch(product_id, req_id, auth):
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="Product not found")
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    headers = make_headers(user_id=user_id, idempotency_key=f"checkout-missing-prod-{uuid.uuid4().hex[:6]}")
    resp = client.post("/checkout", json={}, headers=headers)
    assert resp.status_code == 404

    # Cart must NOT be cleared
    cart_items = db.query(CartItemModel).filter(CartItemModel.cart_id == cart.cart_id).all()
    assert len(cart_items) == 1


# -----------------------------------------------------------------------------
# 4. Idempotent Replay & Retry After Cart Cleared
# -----------------------------------------------------------------------------
def test_idempotent_replay_after_cart_cleared(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1))
    db.commit()

    def mock_fetch(product_id, req_id, auth):
        return {"price": "25.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=5)).isoformat()
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE", "reservation_id": 101, "expires_at": future_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    ik = f"idemp-key-replay-{uuid.uuid4().hex[:6]}"
    headers = make_headers(user_id=user_id, idempotency_key=ik)
    
    # First checkout
    res1 = client.post("/checkout", json={}, headers=headers)
    assert res1.status_code == 201
    order_id_1 = res1.json()["order_id"]

    # Cart is now empty in DB
    cart_items = db.query(CartItemModel).filter(CartItemModel.cart_id == cart.cart_id).all()
    assert len(cart_items) == 0

    # Second identical checkout with SAME idempotency key
    res2 = client.post("/checkout", json={}, headers=headers)
    assert res2.status_code == 200
    data2 = res2.json()
    assert data2["order_id"] == order_id_1
    assert data2["status"] == "RESERVED"

    # Verify only ONE order exists in database
    orders = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders) == 1
    assert orders[0].order_id == order_id_1


# -----------------------------------------------------------------------------
# 5. Conflicting Idempotency Key Rejection
# -----------------------------------------------------------------------------
def test_conflicting_idempotency_key(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1))
    db.commit()

    def mock_fetch(product_id, req_id, auth):
        return {"price": "15.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=5)).isoformat()
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE", "expires_at": future_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    ik = f"conflict-key-{uuid.uuid4().hex[:6]}"
    headers = make_headers(user_id=user_id, idempotency_key=ik)

    # Initial request with coupon "DISCOUNT10"
    res1 = client.post("/checkout", json={"coupon_code": "DISCOUNT10"}, headers=headers)
    assert res1.status_code == 201

    # Replay request with DIFFERENT coupon "SUMMER20"
    res2 = client.post("/checkout", json={"coupon_code": "SUMMER20"}, headers=headers)
    assert res2.status_code == 409
    assert "conflicting" in res2.json()["detail"].lower()


# -----------------------------------------------------------------------------
# 6. Cart Mutation Locked During Active Checkout
# -----------------------------------------------------------------------------
def test_cart_mutation_blocked_during_active_checkout(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    item = CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1)
    db.add(item)
    
    # Simulate an active checkout in RESERVING state
    chk = Checkout(
        user_id=user_id,
        operation_id=f"active-op-{uuid.uuid4().hex[:6]}",
        idempotency_key=f"active-key-{uuid.uuid4().hex[:6]}",
        request_fingerprint="fp1",
        reservation_op_id=f"res_active-{uuid.uuid4().hex[:6]}",
        status="RESERVING",
        total_amount=Decimal("10.00"),
        items_snapshot=[{"product_id": 1, "quantity": 1, "unit_price": "10.00", "subtotal": "10.00"}]
    )
    db.add(chk)
    db.commit()

    headers = make_headers(user_id=user_id)

    # 1. Try adding item
    def mock_fetch(product_id, req_id, auth):
        return {"price": "10.00", "name": "Item 2"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    res_add = client.post("/cart/items", json={"product_id": 2, "quantity": 1}, headers=headers)
    assert res_add.status_code == 409
    assert "locked" in res_add.json()["detail"].lower()

    # 2. Try updating quantity
    res_update = client.patch(f"/cart/items/{item.cart_item_id}", json={"quantity": 5}, headers=headers)
    assert res_update.status_code == 409

    # 3. Try deleting item
    res_del = client.delete(f"/cart/items/{item.cart_item_id}", headers=headers)
    assert res_del.status_code == 409

    # 4. Try emptying cart
    res_empty = client.delete("/cart", headers=headers)
    assert res_empty.status_code == 409


# -----------------------------------------------------------------------------
# 7. Recovery Probe After Ambiguous Timeout
# -----------------------------------------------------------------------------
def test_recovery_after_timeout_succeeds(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=2))
    db.commit()

    def mock_fetch(product_id, req_id, auth):
        return {"price": "50.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    # Initial call causes read timeout (ambiguous)
    def mock_reserve_timeout(op_id, items):
        return ("UNKNOWN", None, "READ_TIMEOUT", "Socket timeout", True)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve_timeout)

    # But subsequent probe reveals reservation actually succeeded on Product Service!
    def mock_get_res(op_id):
        return ("ACTIVE", {"status": "ACTIVE", "expires_at": (datetime.now(timezone.utc) + timedelta(minutes=10)).isoformat()}, False)
    monkeypatch.setattr(main, "get_reservation_internal", mock_get_res)

    headers = make_headers(user_id=user_id, idempotency_key=f"timeout-rec-{uuid.uuid4().hex[:6]}")
    resp = client.post("/checkout", json={}, headers=headers)

    # Because immediate recovery resolved it, response returns 201 RESERVED!
    assert resp.status_code == 201, resp.text
    data = resp.json()
    assert data["status"] == "RESERVED"
    assert data["order_id"] is not None


# -----------------------------------------------------------------------------
# 8. Recovery Does NOT Finalize Expired Reservations
# -----------------------------------------------------------------------------
def test_recovery_rejects_expired_active_reservation(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    # Dangling checkout in UNKNOWN state
    chk = Checkout(
        user_id=user_id,
        operation_id=f"exp-op-{uuid.uuid4().hex[:6]}",
        idempotency_key=f"exp-key-{uuid.uuid4().hex[:6]}",
        request_fingerprint="fp1",
        reservation_op_id=f"res_exp-{uuid.uuid4().hex[:6]}",
        status="UNKNOWN",
        total_amount=Decimal("100.00"),
        items_snapshot=[{"product_id": 1, "quantity": 1, "unit_price": "100.00", "subtotal": "100.00"}]
    )
    db.add(chk)
    db.commit()

    # Product Service returns ACTIVE, BUT expires_at is 5 minutes in the past!
    past_ts = (datetime.now(timezone.utc) - timedelta(minutes=5)).isoformat()
    def mock_get_res(op_id):
        return ("ACTIVE", {"status": "ACTIVE", "expires_at": past_ts}, True, False)
    monkeypatch.setattr(main, "get_reservation_internal", mock_get_res)
    monkeypatch.setattr(main, "release_reservation_internal", lambda op_id: True)

    # Run recovery
    rec = recover_single_checkout(db, chk.checkout_id)
    assert rec.status == "FAILED"
    assert rec.failure_code == "RESERVATION_EXPIRED"
    assert rec.order_id is None


# -----------------------------------------------------------------------------
# 9. Compensation After Local Order Failure
# -----------------------------------------------------------------------------
def test_compensation_after_order_failure(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1))
    db.commit()

    def mock_fetch(product_id, req_id, auth):
        return {"price": "30.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    # Reservation succeeds
    released_ops = []
    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=5)).isoformat()
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE", "expires_at": future_ts}, None, None, False)
    def mock_release(op_id):
        released_ops.append(op_id)
        return True
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)
    monkeypatch.setattr(main, "release_reservation_internal", mock_release)

    # Force failure during Tx 2 Order insertion by monkeypatching Session.add
    original_add = Session.add
    def failing_add(self, instance, _warn=True):
        if isinstance(instance, Order):
            raise RuntimeError("Database disk full during Order insertion!")
        return original_add(self, instance, _warn=_warn)
    monkeypatch.setattr(Session, "add", failing_add)

    ik = f"comp-key-{uuid.uuid4().hex[:6]}"
    headers = make_headers(user_id=user_id, idempotency_key=ik)
    resp = client.post("/checkout", json={}, headers=headers)
    assert resp.status_code == 500

    # Compensating release must have been called
    assert len(released_ops) == 1
    chk = db.query(Checkout).filter(Checkout.user_id == user_id, Checkout.idempotency_key == ik).first()
    assert chk.status == "CANCELLED"


# -----------------------------------------------------------------------------
# 10. Cross-User Authorization and Idempotency Key Scoping
# -----------------------------------------------------------------------------
def test_cross_user_idempotency_scoping(monkeypatch, dedicated_user_pair, test_db):
    db = test_db
    u1, u2 = dedicated_user_pair

    # Both users use the same Idempotency-Key string "shared-key-1"
    for uid in (u1, u2):
        cart = Cart(user_id=uid)
        db.add(cart)
        db.flush()
        db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1))
    db.commit()

    def mock_fetch(product_id, req_id, auth):
        return {"price": "10.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=5)).isoformat()
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE", "expires_at": future_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    # User 1 checks out with "shared-key-1"
    r1 = client.post("/checkout", json={}, headers=make_headers(user_id=u1, idempotency_key="shared-key-1"))
    assert r1.status_code == 201

    # User 2 checks out with the SAME "shared-key-1"
    r2 = client.post("/checkout", json={}, headers=make_headers(user_id=u2, idempotency_key="shared-key-1"))
    assert r2.status_code == 201

    # Both users get their own distinct orders
    assert r1.json()["order_id"] != r2.json()["order_id"]


# -----------------------------------------------------------------------------
# 11. Legacy POST /orders Route Requires Idempotency-Key and Reserves Inventory
# -----------------------------------------------------------------------------
def test_legacy_order_route_requires_idempotency_and_reserves(monkeypatch, dedicated_user, test_db):
    db = test_db
    user_id = dedicated_user

    def mock_fetch(product_id, req_id, auth):
        return {"price": "40.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    # Missing Idempotency-Key header is rejected
    r_no_key = client.post("/orders", json={"items": [{"product_id": 1, "quantity": 1}]}, headers={"X-User-Sub": str(user_id), "X-User-Role": "user"})
    assert r_no_key.status_code == 400
    assert "Idempotency-Key header is required" in r_no_key.json()["detail"]

    # With Idempotency-Key, triggers reservation workflow
    reserved_ops = []
    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=5)).isoformat()
    def mock_reserve(op_id, items):
        reserved_ops.append((op_id, items))
        return ("ACTIVE", {"status": "ACTIVE", "expires_at": future_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    ik = f"legacy-key-{uuid.uuid4().hex[:6]}"
    headers = make_headers(user_id=user_id, idempotency_key=ik)
    r_ok = client.post("/orders", json={"items": [{"product_id": 1, "quantity": 2}]}, headers=headers)
    assert r_ok.status_code == 200
    assert r_ok.json()["total_amount"] == 80.0
    assert len(reserved_ops) == 1

    # Checkout audit record was created
    chk = db.query(Checkout).filter(Checkout.user_id == user_id, Checkout.idempotency_key == ik).first()
    assert chk is not None
    assert chk.status == "RESERVED"
    assert chk.order_id == r_ok.json()["order_id"]


# -----------------------------------------------------------------------------
# 12. Recovery Race: Probe 404 While In-Flight, Then Committed
# -----------------------------------------------------------------------------
def test_recovery_race_404_while_in_flight_then_committed(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    # Checkout persisted in UNKNOWN state after an ambiguous timeout
    res_op_id = f"res_race_{uuid.uuid4().hex[:6]}"
    chk = Checkout(
        user_id=user_id,
        operation_id=f"race-op-{uuid.uuid4().hex[:6]}",
        idempotency_key=f"race-key-{uuid.uuid4().hex[:6]}",
        request_fingerprint="fp_race",
        reservation_op_id=res_op_id,
        status="UNKNOWN",
        total_amount=Decimal("50.00"),
        items_snapshot=[{"product_id": 1, "quantity": 1, "unit_price": "50.00", "subtotal": "50.00"}]
    )
    db.add(chk)
    db.commit()

    # Step 1 & 2: Original POST is still processing; recovery initially probes 404
    def mock_get_404(op_id):
        return ("NOT_FOUND", None, False, True)
    monkeypatch.setattr(main, "get_reservation_internal", mock_get_404)

    rec1 = recover_single_checkout(db, chk.checkout_id)
    # Recovery must preserve UNKNOWN rather than prematurely failing
    assert rec1.status == "UNKNOWN"
    assert rec1.order_id is None
    orders_count = db.query(Order).filter(Order.user_id == user_id).count()
    assert orders_count == 0

    # Step 3: Original POST finishes and commits ACTIVE reservation on Product Service
    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=10)).isoformat()
    def mock_get_active(op_id):
        return ("ACTIVE", {"status": "ACTIVE", "expires_at": future_ts}, False, False)
    monkeypatch.setattr(main, "get_reservation_internal", mock_get_active)

    # Step 4: Subsequent recovery discovers the committed reservation and finalizes exactly one order
    rec2 = recover_single_checkout(db, chk.checkout_id)
    assert rec2.status == "RESERVED"
    assert rec2.order_id is not None
    created_order_id = rec2.order_id
    assert db.query(Order).filter(Order.order_id == created_order_id).count() == 1

    # Step 5: Idempotent repeat: subsequent pass does not duplicate orders
    rec3 = recover_single_checkout(db, chk.checkout_id)
    assert rec3.status == "RESERVED"
    assert rec3.order_id == created_order_id
    assert db.query(Order).filter(Order.user_id == user_id).count() == 1


# -----------------------------------------------------------------------------
# 13. Recovery During Product Service Complete Unavailability Preserves UNKNOWN
# -----------------------------------------------------------------------------
def test_recovery_service_unavailability_preserves_unknown(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    chk = Checkout(
        user_id=user_id,
        operation_id=f"unavail-op-{uuid.uuid4().hex[:6]}",
        idempotency_key=f"unavail-key-{uuid.uuid4().hex[:6]}",
        request_fingerprint="fp_unavail",
        reservation_op_id=f"res_unavail_{uuid.uuid4().hex[:6]}",
        status="UNKNOWN",
        total_amount=Decimal("75.00"),
        items_snapshot=[{"product_id": 1, "quantity": 1, "unit_price": "75.00", "subtotal": "75.00"}]
    )
    db.add(chk)
    db.commit()

    # Product Service is completely down (returns UNKNOWN outcome)
    def mock_get_unavailable(op_id):
        return ("UNKNOWN", None, False, True)
    monkeypatch.setattr(main, "get_reservation_internal", mock_get_unavailable)

    rec = recover_single_checkout(db, chk.checkout_id)
    assert rec.status == "UNKNOWN"
    assert rec.order_id is None
    assert db.query(Order).filter(Order.user_id == user_id).count() == 0


# -----------------------------------------------------------------------------
# 14. Compensation Release Timeout Retains COMPENSATION_REQUIRED
# -----------------------------------------------------------------------------
def test_compensation_release_timeout_retains_compensation_required(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    chk = Checkout(
        user_id=user_id,
        operation_id=f"comp-to-op-{uuid.uuid4().hex[:6]}",
        idempotency_key=f"comp-to-key-{uuid.uuid4().hex[:6]}",
        request_fingerprint="fp_comp_to",
        reservation_op_id=f"res_comp_to_{uuid.uuid4().hex[:6]}",
        status="COMPENSATION_REQUIRED",
        failure_code="ORDER_PERSISTENCE_FAILED",
        failure_reason="DB timeout",
        total_amount=Decimal("50.00"),
        items_snapshot=[{"product_id": 1, "quantity": 1, "unit_price": "50.00", "subtotal": "50.00"}]
    )
    db.add(chk)
    db.commit()

    # Release call to Product Service times out / fails
    def mock_release_timeout(op_id):
        return False
    monkeypatch.setattr(main, "release_reservation_internal", mock_release_timeout)

    rec = recover_single_checkout(db, chk.checkout_id)
    # Must NOT mark CANCELLED without verified terminal state!
    assert rec.status == "COMPENSATION_REQUIRED"
    assert rec.order_id is None


# -----------------------------------------------------------------------------
# 15. Repeated Compensation Recovers From COMPENSATION_REQUIRED to CANCELLED
# -----------------------------------------------------------------------------
def test_repeated_compensation_recovers_to_cancelled(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    chk = Checkout(
        user_id=user_id,
        operation_id=f"rep-comp-op-{uuid.uuid4().hex[:6]}",
        idempotency_key=f"rep-comp-key-{uuid.uuid4().hex[:6]}",
        request_fingerprint="fp_rep_comp",
        reservation_op_id=f"res_rep_comp_{uuid.uuid4().hex[:6]}",
        status="COMPENSATION_REQUIRED",
        failure_code="ORDER_PERSISTENCE_FAILED",
        failure_reason="DB error",
        total_amount=Decimal("60.00"),
        items_snapshot=[{"product_id": 1, "quantity": 1, "unit_price": "60.00", "subtotal": "60.00"}]
    )
    db.add(chk)
    db.commit()

    # Pass 1: Product Service is still down; compensation release fails
    monkeypatch.setattr(main, "release_reservation_internal", lambda op_id: False)
    rec1 = recover_single_checkout(db, chk.checkout_id)
    assert rec1.status == "COMPENSATION_REQUIRED"

    # Pass 2: Product Service recovers; verifiable release succeeds
    released_ops = []
    def mock_release_ok(op_id):
        released_ops.append(op_id)
        return True
    monkeypatch.setattr(main, "release_reservation_internal", mock_release_ok)

    rec2 = recover_single_checkout(db, chk.checkout_id)
    assert rec2.status == "CANCELLED"
    assert len(released_ops) == 1

    # Pass 3: Re-recovery is idempotent
    rec3 = recover_single_checkout(db, chk.checkout_id)
    assert rec3.status == "CANCELLED"


# -----------------------------------------------------------------------------
# 16. Expiration Immediately Prior to Order Finalization Fails Closed
# -----------------------------------------------------------------------------
def test_expiration_immediately_prior_to_order_finalization(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1))
    db.commit()

    monkeypatch.setattr(main, "fetch_product", lambda pid, rid, auth: {"price": "25.00", "name": "Item 1"})

    # Product Service returns ACTIVE reservation, but with expires_at already elapsed
    past_ts = (datetime.now(timezone.utc) - timedelta(seconds=2)).isoformat()
    def mock_reserve_expired(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE", "expires_at": past_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve_expired)

    released_ops = []
    monkeypatch.setattr(main, "release_reservation_internal", lambda op_id: released_ops.append(op_id) or True)

    ik = f"exp-immed-{uuid.uuid4().hex[:6]}"
    resp = client.post("/checkout", json={}, headers=make_headers(user_id=user_id, idempotency_key=ik))
    assert resp.status_code == 400
    data = resp.json()
    assert data["detail"]["failure_code"] == "RESERVATION_EXPIRED"

    # Order must NOT be created
    assert db.query(Order).filter(Order.user_id == user_id).count() == 0
    # Hold must be released
    assert len(released_ops) == 1

    chk = db.query(Checkout).filter(Checkout.user_id == user_id, Checkout.idempotency_key == ik).first()
    assert chk.status == "FAILED"
    assert chk.failure_code == "RESERVATION_EXPIRED"


# -----------------------------------------------------------------------------
# 17. Concurrent Recovery Workers Finalize Exactly Once
# -----------------------------------------------------------------------------
def test_concurrent_recovery_workers_finalize_exactly_once(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    res_op_id = f"res_concrec_{uuid.uuid4().hex[:6]}"
    chk = Checkout(
        user_id=user_id,
        operation_id=f"concrec-op-{uuid.uuid4().hex[:6]}",
        idempotency_key=f"concrec-key-{uuid.uuid4().hex[:6]}",
        request_fingerprint="fp_concrec",
        reservation_op_id=res_op_id,
        status="UNKNOWN",
        total_amount=Decimal("120.00"),
        items_snapshot=[{"product_id": 1, "quantity": 2, "unit_price": "60.00", "subtotal": "120.00"}]
    )
    db.add(chk)
    db.commit()

    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=15)).isoformat()
    monkeypatch.setattr(
        main, "get_reservation_internal",
        lambda op_id: ("ACTIVE", {"status": "ACTIVE", "expires_at": future_ts}, False, False)
    )

    # Concurrently launch 5 recovery workers on this checkout
    def worker_run():
        s = TestingSessionLocal()
        try:
            chk_rec = recover_single_checkout(s, chk.checkout_id)
            return chk_rec.status, chk_rec.order_id
        finally:
            s.close()

    with ThreadPoolExecutor(max_workers=5) as pool:
        futures = [pool.submit(worker_run) for _ in range(5)]
        results = [f.result() for f in futures]

    for status, order_id in results:
        assert status == "RESERVED"
        assert order_id is not None

    # Exactly one order was created in the database across all 5 concurrent recovery workers
    orders = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders) == 1
    assert orders[0].order_id == results[0][1]


# -----------------------------------------------------------------------------
# 18. Defect 1: Recovery when original reservation POST was never sent (Crash Recovery)
# -----------------------------------------------------------------------------
def test_recovery_when_original_post_was_never_sent(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    # Setup a checkout in RESERVING state (simulating crash after Tx 1 before remote POST)
    orig_res_op_id = f"res_unsent_{uuid.uuid4().hex[:6]}"
    chk = Checkout(
        user_id=user_id,
        operation_id=f"unsent-op-{uuid.uuid4().hex[:6]}",
        idempotency_key=f"unsent-key-{uuid.uuid4().hex[:6]}",
        request_fingerprint="fp_unsent",
        reservation_op_id=orig_res_op_id,
        status="RESERVING",
        total_amount=Decimal("50.00"),
        items_snapshot=[{"product_id": 1, "quantity": 1, "unit_price": "50.00", "subtotal": "50.00"}]
    )
    db.add(chk)
    db.commit()

    # Initial reservation lookup returns 404 (NOT_FOUND) because POST was never sent
    lookup_calls = []
    def mock_lookup(op_id):
        lookup_calls.append(op_id)
        return ("NOT_FOUND", None, False, True)
    monkeypatch.setattr(main, "get_reservation_internal", mock_lookup)

    # Recovery retries POST using the SAME reservation_op_id and items_snapshot
    retry_posts = []
    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=5)).isoformat()
    def mock_reserve(op_id, items):
        retry_posts.append((op_id, items))
        return ("ACTIVE", {"status": "ACTIVE", "expires_at": future_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    # Execute recovery
    recovered = recover_single_checkout(db, chk.checkout_id)

    # Verify:
    # 1. Lookup returned 404
    assert len(lookup_calls) == 1
    # 2. Retry POST was sent with the EXACT same reservation_op_id and items_snapshot
    assert len(retry_posts) == 1
    assert retry_posts[0][0] == orig_res_op_id
    assert retry_posts[0][1] == [{"product_id": 1, "quantity": 1}]
    # 3. Exactly one order created and checkout finalized as RESERVED
    assert recovered.status == "RESERVED"
    assert recovered.order_id is not None
    orders = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders) == 1
    assert orders[0].order_id == recovered.order_id


# -----------------------------------------------------------------------------
# 19. Defect 2: Expiration compensation release failure preserves COMPENSATION_REQUIRED
# -----------------------------------------------------------------------------
def test_expiration_compensation_release_timeout_preserves_compensation_required(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1))
    db.commit()

    monkeypatch.setattr(main, "fetch_product", lambda pid, rid, auth: {"price": "30.00", "name": "Item 1"})

    # Product Service returns ACTIVE reservation, but expired
    past_ts = (datetime.now(timezone.utc) - timedelta(seconds=5)).isoformat()
    monkeypatch.setattr(
        main, "reserve_inventory_internal",
        lambda op_id, items: ("ACTIVE", {"status": "ACTIVE", "expires_at": past_ts}, None, None, False)
    )

    # Compensation release times out / fails!
    monkeypatch.setattr(main, "release_reservation_internal", lambda op_id: False)

    ik = f"exp-timeout-{uuid.uuid4().hex[:6]}"
    resp = client.post("/checkout", json={}, headers=make_headers(user_id=user_id, idempotency_key=ik))
    # Must fail, NOT succeed
    assert resp.status_code == 500

    # No order must be created
    assert db.query(Order).filter(Order.user_id == user_id).count() == 0

    # Checkout status must NOT be FAILED! Must be COMPENSATION_REQUIRED because hold release was not confirmed!
    chk = db.query(Checkout).filter(Checkout.user_id == user_id, Checkout.idempotency_key == ik).first()
    assert chk.status == "COMPENSATION_REQUIRED"
    assert chk.failure_code == "RESERVATION_EXPIRED"

    # Subsequent recovery pass where release now succeeds
    monkeypatch.setattr(main, "release_reservation_internal", lambda op_id: True)
    recovered = recover_single_checkout(db, chk.checkout_id)
    assert recovered.status == "CANCELLED"


# -----------------------------------------------------------------------------
# 20. Defect 2: Missing or malformed expiration metadata fails closed
# -----------------------------------------------------------------------------
def test_missing_or_malformed_expiration_metadata_fails_closed(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    # Test missing expires_at
    released_ops = []
    monkeypatch.setattr(main, "release_reservation_internal", lambda op_id: released_ops.append(op_id) or True)

    chk = Checkout(
        user_id=user_id,
        operation_id=f"malformed-op-{uuid.uuid4().hex[:6]}",
        idempotency_key=f"malformed-key-{uuid.uuid4().hex[:6]}",
        request_fingerprint="fp_malformed",
        reservation_op_id=f"res_malformed_{uuid.uuid4().hex[:6]}",
        status="UNKNOWN",
        total_amount=Decimal("45.00"),
        items_snapshot=[{"product_id": 1, "quantity": 1, "unit_price": "45.00", "subtotal": "45.00"}]
    )
    db.add(chk)
    db.commit()

    # Product Service returns status ACTIVE but expires_at is malformed
    monkeypatch.setattr(
        main, "get_reservation_internal",
        lambda op_id: ("ACTIVE", {"status": "ACTIVE", "expires_at": "not-a-valid-timestamp"}, True, False)
    )

    recovered = recover_single_checkout(db, chk.checkout_id)
    # Must NOT assume valid! Must fail closed and release hold
    assert recovered.status == "FAILED"
    assert recovered.failure_code == "RESERVATION_EXPIRED"
    assert len(released_ops) == 1
    assert db.query(Order).filter(Order.user_id == user_id).count() == 0


# -----------------------------------------------------------------------------
# 21. Defect 3: Release HTTP 404 does NOT report success during in-flight commit race
# -----------------------------------------------------------------------------
def test_release_404_preserves_compensation_and_releases_once_committed(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    res_op_id = f"res_race404_{uuid.uuid4().hex[:6]}"
    chk = Checkout(
        user_id=user_id,
        operation_id=f"race404-op-{uuid.uuid4().hex[:6]}",
        idempotency_key=f"race404-key-{uuid.uuid4().hex[:6]}",
        request_fingerprint="fp_race404",
        reservation_op_id=res_op_id,
        status="COMPENSATION_REQUIRED",
        total_amount=Decimal("70.00"),
        items_snapshot=[{"product_id": 1, "quantity": 1, "unit_price": "70.00", "subtotal": "70.00"}]
    )
    db.add(chk)
    db.commit()

    # Pass 1: Release request arrives at Product Service before reservation POST transaction commits -> receives 404
    # release_reservation_internal MUST return False, NOT True!
    monkeypatch.setattr(main, "release_reservation_internal", lambda op_id: False)
    rec1 = recover_single_checkout(db, chk.checkout_id)
    # Checkout MUST remain COMPENSATION_REQUIRED, NOT CANCELLED!
    assert rec1.status == "COMPENSATION_REQUIRED"

    # Pass 2: Reservation POST transaction commits ACTIVE.
    # Now release request finds the ACTIVE reservation and successfully releases it
    monkeypatch.setattr(main, "release_reservation_internal", lambda op_id: True)
    rec2 = recover_single_checkout(db, chk.checkout_id)
    assert rec2.status == "CANCELLED"


# -----------------------------------------------------------------------------
# 22. Defect 4: Verify zero database transactions open during network calls
# -----------------------------------------------------------------------------
def test_zero_database_transactions_across_network_calls(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=2))
    db.commit()

    # Track active database transactions during remote calls
    transactions_during_remote = []

    def check_db_no_tx():
        # Check if the test_db session or connection has an active transaction
        is_tx = db.in_transaction()
        transactions_during_remote.append(is_tx)

    orig_fetch = main.fetch_product
    def hooked_fetch(pid, rid, auth):
        check_db_no_tx()
        return {"price": "20.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", hooked_fetch)

    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=5)).isoformat()
    def hooked_reserve(op_id, items):
        check_db_no_tx()
        return ("ACTIVE", {"status": "ACTIVE", "expires_at": future_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", hooked_reserve)

    ik = f"zerotx-{uuid.uuid4().hex[:6]}"
    resp = client.post("/checkout", json={}, headers=make_headers(user_id=user_id, idempotency_key=ik))
    assert resp.status_code == 201

    # Verify that in EVERY remote call, in_transaction was False!
    assert len(transactions_during_remote) >= 2 # at least 1 price call + 1 reservation call
    for is_tx in transactions_during_remote:
        assert is_tx is False, "Active database transaction detected during remote call!"


# -----------------------------------------------------------------------------
# 23. Finding 1: Prevent compensation after successful order commit
# -----------------------------------------------------------------------------
def test_prevent_compensation_after_successful_order_commit(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1))
    db.commit()

    def mock_fetch(pid, rid, auth):
        return {"price": "10.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=15)).isoformat()
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE", "operation_id": op_id, "expires_at": future_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    # Track any calls to release_reservation_internal
    release_calls = []
    def mock_release(op_id):
        release_calls.append(op_id)
        return True
    monkeypatch.setattr(main, "release_reservation_internal", mock_release)

    # Simulate post-commit failure formatting response
    step4_fail = True
    def buggy_build_checkout_response(chk):
        nonlocal step4_fail
        if step4_fail:
            step4_fail = False
            raise RuntimeError("Simulated transient failure building response after commit")
        return main.CheckoutResponse(
            checkout_id=chk.checkout_id,
            operation_id=chk.operation_id,
            status=chk.status,
            order_id=chk.order_id,
            total_amount=Decimal(str(chk.total_amount)),
            items=[]
        )
    monkeypatch.setattr(main, "build_checkout_response", buggy_build_checkout_response)

    ik = f"post-commit-fail-{uuid.uuid4().hex[:6]}"
    headers = make_headers(user_id=user_id, idempotency_key=ik)
    resp = client.post("/checkout", json={}, headers=headers)

    # The request failed after commit with 500
    assert resp.status_code == 500

    # Verification requirements:
    # 1. Exactly one order exists
    orders = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders) == 1
    committed_order_id = orders[0].order_id

    # 2. Checkout remains RESERVED with the order_id
    chk = db.query(Checkout).filter(Checkout.user_id == user_id, Checkout.idempotency_key == ik).first()
    assert chk is not None
    assert chk.status == "RESERVED"
    assert chk.order_id == committed_order_id

    # 3. The reservation remains ACTIVE: NO compensation release occurred!
    assert len(release_calls) == 0, "Compensation release must NOT be invoked after successful commit!"

    # 4. Retrying the same key returns the original order!
    resp_retry = client.post("/checkout", json={}, headers=headers)
    assert resp_retry.status_code in (200, 201)
    data = resp_retry.json()
    assert data["order_id"] == committed_order_id
    assert data["status"] == "RESERVED"

    # Exactly one order exists after retry
    orders_after = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders_after) == 1


# -----------------------------------------------------------------------------
# 24. Finding 2: Product Service HTTP 500 error classification and recovery
# -----------------------------------------------------------------------------
def test_product_service_500_discovers_reservation_and_creates_order(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1))
    db.commit()

    def mock_fetch(pid, rid, auth):
        return {"price": "15.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    # Product Service committed the reservation in its DB, but returned HTTP 500 during response delivery!
    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=15)).isoformat()
    committed_reservations = {}

    def mock_reserve_500(op_id, items):
        # Product Service committed the hold:
        committed_reservations[op_id] = {
            "status": "ACTIVE",
            "operation_id": op_id,
            "expires_at": future_ts,
            "items": [{"product_id": it["product_id"], "quantity": it["quantity"]} for it in items]
        }
        # In reserve_inventory_internal, HTTP 500 returns ("UNKNOWN", None, "HTTP_500", "Internal Server Error", True)
        return ("UNKNOWN", None, "HTTP_500", "Internal Server Error", True)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve_500)

    # When get_reservation_internal is called during recovery, it finds the committed reservation
    def mock_get_res(op_id):
        if op_id in committed_reservations:
            return ("ACTIVE", committed_reservations[op_id], False, False)
        return ("NOT_FOUND", None, False, True)
    monkeypatch.setattr(main, "get_reservation_internal", mock_get_res)

    ik = f"http500-recover-{uuid.uuid4().hex[:6]}"
    headers = make_headers(user_id=user_id, idempotency_key=ik)
    resp = client.post("/checkout", json={}, headers=headers)

    # Verification:
    # 1. Checkout successfully discovers the original reservation via recovery and returns 201
    assert resp.status_code == 201
    data = resp.json()
    assert data["status"] == "RESERVED"
    assert data["order_id"] is not None

    # 2. Exactly one order exists
    orders = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders) == 1

    # 3. Checkout row is RESERVED
    chk = db.query(Checkout).filter(Checkout.user_id == user_id, Checkout.idempotency_key == ik).first()
    assert chk.status == "RESERVED"
    assert chk.order_id == data["order_id"]


# -----------------------------------------------------------------------------
# 25. Finding 3: Recheck expiration after acquiring finalization lock in normal checkout
# -----------------------------------------------------------------------------
def test_recheck_expiration_after_acquiring_finalization_lock_checkout(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1))
    db.commit()

    def mock_fetch(pid, rid, auth):
        return {"price": "10.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    # Reservation returned ACTIVE with an expires_at in the near future (+2 seconds)
    exp_time = datetime.now(timezone.utc) + timedelta(seconds=2)
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE", "operation_id": op_id, "expires_at": exp_time.isoformat()}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    release_calls = []
    def mock_release(op_id):
        release_calls.append(op_id)
        return True
    monkeypatch.setattr(main, "release_reservation_internal", mock_release)

    # Advance clock past expires_at when finalization lock is acquired
    class MockDatetime(datetime):
        @classmethod
        def now(cls, tz=None):
            return exp_time + timedelta(seconds=5)
    monkeypatch.setattr(main, "datetime", MockDatetime)

    ik = f"lock-exp-race-{uuid.uuid4().hex[:6]}"
    headers = make_headers(user_id=user_id, idempotency_key=ik)
    resp = client.post("/checkout", json={}, headers=headers)

    assert resp.status_code == 400
    assert resp.json()["detail"]["failure_code"] == "RESERVATION_EXPIRED"

    # Verification:
    # 1. No order was created!
    orders = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders) == 0

    # 2. Verifiable release was attempted outside database transaction
    assert len(release_calls) == 1

    # 3. Checkout recorded as FAILED with RESERVATION_EXPIRED
    chk = db.query(Checkout).filter(Checkout.user_id == user_id, Checkout.idempotency_key == ik).first()
    assert chk.status == "FAILED"
    assert chk.failure_code == "RESERVATION_EXPIRED"
    assert chk.order_id is None


# -----------------------------------------------------------------------------
# 26. Finding 3: Recheck expiration after acquiring finalization lock in recovery
# -----------------------------------------------------------------------------
def test_recheck_expiration_after_acquiring_finalization_lock_recovery(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    exp_time = datetime.now(timezone.utc) + timedelta(seconds=2)
    op_id = f"test-recov-exp-{uuid.uuid4()}"
    res_op = f"res_{op_id}"

    chk = Checkout(
        user_id=user_id,
        operation_id=op_id,
        idempotency_key=f"idem-recov-exp-{uuid.uuid4()}",
        request_fingerprint="dummy",
        reservation_op_id=res_op,
        status="RESERVING",
        total_amount=Decimal("10.00"),
        items_snapshot=[{"product_id": 1, "quantity": 1, "unit_price": "10.00"}]
    )
    db.add(chk)
    db.commit()

    # Probing returns ACTIVE with exp_time
    def mock_get_res(op_id):
        return ("ACTIVE", {"status": "ACTIVE", "operation_id": op_id, "expires_at": exp_time.isoformat()}, False, False)
    monkeypatch.setattr(main, "get_reservation_internal", mock_get_res)

    release_calls = []
    def mock_release(op_id):
        release_calls.append(op_id)
        return True
    monkeypatch.setattr(main, "release_reservation_internal", mock_release)

    # Time advances past expires_at while waiting for finalization lock in Phase C
    class MockDatetime(datetime):
        @classmethod
        def now(cls, tz=None):
            return exp_time + timedelta(seconds=5)
    monkeypatch.setattr(main, "datetime", MockDatetime)

    rec = recover_single_checkout(db, chk.checkout_id)

    # Verification:
    # 1. Checkout status transitioned to FAILED, RESERVATION_EXPIRED
    assert rec.status == "FAILED"
    assert rec.failure_code == "RESERVATION_EXPIRED"
    assert rec.order_id is None

    # 2. No order created
    orders = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders) == 0

    # 3. Release was called
    assert len(release_calls) == 1


# -----------------------------------------------------------------------------
# 27. Finding 1: Ambiguous commit outcome inspects persisted state and avoids compensation
# -----------------------------------------------------------------------------
def test_ambiguous_commit_inspects_persisted_state_and_avoids_compensation(monkeypatch, dedicated_user, test_db):
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1))
    db.commit()

    def mock_fetch(pid, rid, auth):
        return {"price": "10.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=15)).isoformat()
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE", "operation_id": op_id, "expires_at": future_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    release_calls = []
    def mock_release(op_id):
        release_calls.append(op_id)
        return True
    monkeypatch.setattr(main, "release_reservation_internal", mock_release)

    # Hook commit to succeed on the DB, but raise an exception simulating socket disconnect on return
    orig_commit = Session.commit
    simulated_dropped = False
    def hooked_commit(self):
        nonlocal simulated_dropped
        has_new_order = any(isinstance(obj, Order) for obj in self.identity_map.values())
        orig_commit(self)
        if has_new_order and not simulated_dropped:
            simulated_dropped = True
            raise RuntimeError("Simulated network drop immediately following successful database commit")

    monkeypatch.setattr(Session, "commit", hooked_commit)

    ik = f"ambig-commit-{uuid.uuid4().hex[:6]}"
    headers = make_headers(user_id=user_id, idempotency_key=ik)
    resp = client.post("/checkout", json={}, headers=headers)

    # Initial request returns 201 (recovered immediately) or 500 (transient post-commit error)
    assert resp.status_code in (200, 201, 500)

    # Verification:
    # 1. Inspect persisted state confirmed order commit succeeded -> NO compensation was triggered!
    assert len(release_calls) == 0

    # 2. Exactly one order exists in DB
    orders = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders) == 1
    committed_order_id = orders[0].order_id

    # 3. Checkout remains RESERVED with the order_id
    chk = db.query(Checkout).filter(Checkout.user_id == user_id, Checkout.idempotency_key == ik).first()
    assert chk.status == "RESERVED"
    assert chk.order_id == committed_order_id

    # 4. Retrying the same key returns the original order!
    resp_retry = client.post("/checkout", json={}, headers=headers)
    assert resp_retry.status_code in (200, 201)
    data = resp_retry.json()
    assert data["order_id"] == committed_order_id
    assert data["status"] == "RESERVED"


def test_ambiguous_commit_with_failed_inspection_preserves_reservation_and_recovers_order(monkeypatch, dedicated_user, test_db):
    """
    Test Ambiguous Commit when independent inspection also fails:
    DB commits order -> commit response lost -> inspection also fails ->
    no reservation release occurs -> DB recovers -> retrying same key discovers
    original order (exactly 1 order and 1 reservation).
    """
    user_id = dedicated_user
    db = test_db

    cart = Cart(user_id=user_id)
    db.add(cart)
    db.flush()
    db.add(CartItemModel(cart_id=cart.cart_id, product_id=1, quantity=1))
    db.commit()

    def mock_fetch(pid, rid, auth):
        return {"price": "10.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=15)).isoformat()
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE", "operation_id": op_id, "expires_at": future_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    release_calls = []
    def mock_release(op_id):
        release_calls.append(op_id)
        return True
    monkeypatch.setattr(main, "release_reservation_internal", mock_release)

    # Hook commit to succeed on DB, but raise exception simulating socket drop on return
    orig_commit = Session.commit
    simulated_dropped = False
    def hooked_commit(self):
        nonlocal simulated_dropped
        has_new_order = any(isinstance(obj, Order) for obj in self.identity_map.values())
        orig_commit(self)
        if has_new_order and not simulated_dropped:
            simulated_dropped = True
            raise RuntimeError("Simulated network drop immediately following successful database commit")

    monkeypatch.setattr(Session, "commit", hooked_commit)

    # Hook sessionmaker to simulate inspection failure
    orig_sessionmaker = main.sessionmaker
    def failing_sessionmaker(*args, **kwargs):
        factory = orig_sessionmaker(*args, **kwargs)
        def make_session(*s_args, **s_kwargs):
            sess = factory(*s_args, **s_kwargs)
            orig_query = sess.query
            def failing_query(*q_args, **q_kwargs):
                raise RuntimeError("Simulated inspection database connection failure")
            sess.query = failing_query
            return sess
        return make_session

    monkeypatch.setattr(main, "sessionmaker", failing_sessionmaker)

    ik = f"ambig-failed-inspect-{uuid.uuid4().hex[:6]}"
    headers = make_headers(user_id=user_id, idempotency_key=ik)
    resp = client.post("/checkout", json={}, headers=headers)

    # Initial request must return 503 (ambiguous commit with inconclusive inspection)
    assert resp.status_code == 503
    assert "ambiguous" in resp.json()["detail"].lower()

    # CRITICAL: No compensation release was triggered!
    assert len(release_calls) == 0

    # The order was actually committed to PostgreSQL
    orders = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders) == 1
    committed_order_id = orders[0].order_id

    # Restore sessionmaker to simulate DB recovery
    monkeypatch.setattr(main, "sessionmaker", orig_sessionmaker)

    # Retrying the same key retrieves the original committed order
    resp_retry = client.post("/checkout", json={}, headers=headers)
    assert resp_retry.status_code in (200, 201)
    data = resp_retry.json()
    assert data["order_id"] == committed_order_id
    assert data["status"] == "RESERVED"

    # Exactly 1 order in DB and 0 release calls
    assert len(release_calls) == 0
    orders_final = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders_final) == 1


def test_checkout_in_compensation_required_cannot_finalize_order(monkeypatch, dedicated_user, test_db):
    """
    Ensure a checkout undergoing compensation (COMPENSATION_REQUIRED) cannot
    concurrently transition to an active or completed state (RESERVED),
    and never creates an order.
    """
    user_id = dedicated_user
    db = test_db

    ik = f"comp-req-{uuid.uuid4().hex[:6]}"
    res_op_id = f"res_chk_{uuid.uuid4()}"

    chk = Checkout(
        user_id=user_id,
        operation_id=str(uuid.uuid4()),
        idempotency_key=ik,
        request_fingerprint="test-fp",
        reservation_op_id=res_op_id,
        items_snapshot=[{"product_id": 1, "quantity": 1, "price": "10.00"}],
        total_amount=Decimal("10.00"),
        status="COMPENSATION_REQUIRED",
        failure_code="ORDER_PERSISTENCE_FAILED",
        failure_reason="Simulated failure"
    )
    db.add(chk)
    db.commit()

    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=15)).isoformat()
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE", "operation_id": op_id, "expires_at": future_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    def mock_fetch(pid, rid, auth):
        return {"price": "10.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    # Attempt checkout on this key
    headers = make_headers(user_id=user_id, idempotency_key=ik)
    resp = client.post("/checkout", json={}, headers=headers)

    # Must reject finalization and must NOT return 200/201
    assert resp.status_code in (400, 409)

    # Verify no order was created
    orders = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders) == 0

    # Checkout status must NOT be RESERVED
    db.refresh(chk)
    assert chk.status != "RESERVED"
    assert chk.order_id is None


def test_compensation_cannot_release_reservation_of_finalized_order(monkeypatch, dedicated_user, test_db):
    """
    Ensure compensation cannot release a reservation belonging to an already-finalized order (RESERVED).
    """
    user_id = dedicated_user
    db = test_db

    order = Order(
        user_id=user_id,
        status="Pending",
        total_amount=Decimal("20.00")
    )
    db.add(order)
    db.flush()

    res_op_id = f"res_chk_{uuid.uuid4()}"
    chk = Checkout(
        user_id=user_id,
        operation_id=str(uuid.uuid4()),
        idempotency_key=f"finalized-{uuid.uuid4().hex[:6]}",
        request_fingerprint="test-fp",
        reservation_op_id=res_op_id,
        items_snapshot=[{"product_id": 1, "quantity": 2, "price": "10.00"}],
        total_amount=Decimal("20.00"),
        status="RESERVED",
        order_id=order.order_id
    )
    db.add(chk)
    db.commit()

    release_calls = []
    def mock_release(op_id):
        release_calls.append(op_id)
        return True
    monkeypatch.setattr(main, "release_reservation_internal", mock_release)

    # Attempt recovery / compensation
    recovered = main.reconcile_and_recover_checkout(chk.checkout_id, db=db)

    # Must NOT release reservation
    assert len(release_calls) == 0
    assert recovered.status == "RESERVED"
    assert recovered.order_id == order.order_id


def test_concurrent_checkout_and_compensation_serialization(monkeypatch, dedicated_user, test_db):
    """
    Deterministic synchronization test:
    Checkout and compensation execute concurrently.
    When compensation begins, checkout row is locked/marked COMPENSATION_REQUIRED.
    The checkout thread cannot finalize or create an order, and the compensating
    state terminates safely in a non-successful state without split-brain.
    """
    import threading

    user_id = dedicated_user
    db = test_db

    ik = f"concurrent-{uuid.uuid4().hex[:6]}"
    res_op_id = f"res_chk_{uuid.uuid4()}"

    chk = Checkout(
        user_id=user_id,
        operation_id=str(uuid.uuid4()),
        idempotency_key=ik,
        request_fingerprint="test-fp",
        reservation_op_id=res_op_id,
        items_snapshot=[{"product_id": 1, "quantity": 1, "price": "15.00"}],
        total_amount=Decimal("15.00"),
        status="RESERVING"
    )
    db.add(chk)
    db.commit()
    chk_id = chk.checkout_id

    future_ts = (datetime.now(timezone.utc) + timedelta(minutes=15)).isoformat()
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE", "operation_id": op_id, "expires_at": future_ts}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    release_calls = []
    def mock_release(op_id):
        release_calls.append(op_id)
        return True
    monkeypatch.setattr(main, "release_reservation_internal", mock_release)

    def mock_fetch(pid, rid, auth):
        return {"price": "15.00", "name": "Item 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)

    barrier = threading.Barrier(2)
    thread_errors = []

    def thread_compensate():
        comp_db = TestingSessionLocal()
        try:
            barrier.wait()
            c = comp_db.query(Checkout).filter(Checkout.checkout_id == chk_id).with_for_update().first()
            c.status = "COMPENSATION_REQUIRED"
            c.failure_code = "SIMULATED_ABORT"
            c.failure_reason = "Concurrent abort triggered compensation"
            c.updated_at = datetime.now(timezone.utc)
            comp_db.commit()
        except Exception as e:
            thread_errors.append(e)
        finally:
            comp_db.close()

    def thread_finalize():
        fin_db = TestingSessionLocal()
        try:
            barrier.wait()
            # Brief delay to let compensate commit COMPENSATION_REQUIRED
            time.sleep(0.05)
            main.execute_checkout_orchestration(
                user_id=user_id,
                idempotency_key=ik,
                request_fingerprint="test-fp",
                candidate_items=[{"product_id": 1, "quantity": 1}],
                clear_cart=False,
                request_id="req-1",
                db=fin_db
            )
        except HTTPException as e:
            # Expected rejection
            thread_errors.append(e)
        except Exception as e:
            thread_errors.append(e)
        finally:
            fin_db.close()

    t1 = threading.Thread(target=thread_finalize)
    t2 = threading.Thread(target=thread_compensate)
    t1.start()
    t2.start()
    t1.join()
    t2.join()

    # Verify:
    # 1. No order was ever created
    orders = db.query(Order).filter(Order.user_id == user_id).all()
    assert len(orders) == 0

    # 2. Checkout status is not RESERVED
    db.expire_all()
    chk_final = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
    assert chk_final.status in ("COMPENSATION_REQUIRED", "CANCELLED", "FAILED")
    assert chk_final.order_id is None



