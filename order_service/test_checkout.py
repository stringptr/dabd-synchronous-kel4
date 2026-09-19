import os
os.environ["INTERNAL_API_KEY"] = "testinternal"

import uuid
import time
import json
import pytest
from decimal import Decimal
from datetime import datetime, timedelta, timezone
from concurrent.futures import ThreadPoolExecutor
from fastapi.testclient import TestClient
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.engine import make_url

import order_service.main as main
from order_service.main import (
    app, get_db, Cart, CartItemModel, Order, OrderItem, Checkout,
    get_or_create_cart, recover_single_checkout
)

# Test database configuration
SQLALCHEMY_DATABASE_URL = os.getenv("TEST_DATABASE_URL", "postgresql+psycopg2://postgres:postgres@localhost:5433/test_db")
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
    if url.database != "test_db":
        raise RuntimeError(f"Destructive tests target '{url.database}', expected 'test_db'")
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
    def mock_reserve(op_id, items):
        reserved_payloads.append((op_id, items))
        return ("ACTIVE", {"status": "ACTIVE", "reservation_id": 999}, None, None, False)
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

    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE", "reservation_id": 101}, None, None, False)
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

    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE"}, None, None, False)
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
        return ("ACTIVE", {"status": "ACTIVE", "expires_at": past_ts}, True)
    monkeypatch.setattr(main, "get_reservation_internal", mock_get_res)

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
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE"}, None, None, False)
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

    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE"}, None, None, False)
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
    def mock_reserve(op_id, items):
        reserved_ops.append((op_id, items))
        return ("ACTIVE", {"status": "ACTIVE"}, None, None, False)
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
