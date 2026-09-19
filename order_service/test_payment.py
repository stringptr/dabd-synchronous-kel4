import os
os.environ["INTERNAL_API_KEY"] = "testinternal"
os.environ["TEST_ENV"] = "true"
os.environ["ENABLE_BACKGROUND_WORKER"] = "false"

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
    Payment, PaymentAttempt, OrderCancellation,
    reconcile_single_payment_attempt, reconcile_all_pending_operations
)

# Test database configuration - requires designated isolated PostgreSQL on port 5434
SQLALCHEMY_DATABASE_URL = os.getenv("TEST_DATABASE_URL", "postgresql+psycopg2://postgres:testpassword@localhost:5434/test_db")
engine = create_engine(SQLALCHEMY_DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def sync_sequences():
    with engine.begin() as conn:
        conn.execute(text("SELECT setval('orders_order_id_seq', (SELECT COALESCE(MAX(order_id), 1) FROM orders))"))
        conn.execute(text("SELECT setval('order_items_order_item_id_seq', (SELECT COALESCE(MAX(order_item_id), 1) FROM order_items))"))
        conn.execute(text("SELECT setval('checkouts_checkout_id_seq', (SELECT COALESCE(MAX(checkout_id), 1) FROM checkouts))"))
        conn.execute(text("SELECT setval('payment_attempts_attempt_id_seq', (SELECT COALESCE(MAX(attempt_id), 1) FROM payment_attempts))"))
        conn.execute(text("SELECT setval('order_cancellations_cancellation_id_seq', (SELECT COALESCE(MAX(cancellation_id), 1) FROM order_cancellations))"))
        conn.execute(text("SELECT setval('payments_payment_id_seq', (SELECT COALESCE(MAX(payment_id), 1) FROM payments))"))

def cleanup_user_data(user_id: int):
    with engine.begin() as conn:
        conn.execute(text("DELETE FROM order_cancellations WHERE user_id = :uid"), {"uid": user_id})
        conn.execute(text("DELETE FROM payment_attempts WHERE user_id = :uid"), {"uid": user_id})
        conn.execute(text("""
            DELETE FROM payments WHERE order_id IN (
                SELECT order_id FROM orders WHERE user_id = :uid
            )
        """), {"uid": user_id})
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
    email = f"test_pay_{suffix}@example.com"
    with engine.begin() as conn:
        uid = conn.execute(text("""
            INSERT INTO users (first_name, last_name, email, is_admin)
            VALUES ('Test', 'PaymentUser', :email, false)
            RETURNING user_id
        """), {"email": email}).scalar()
    
    yield uid
    
    cleanup_user_data(uid)

@pytest.fixture
def test_client():
    return TestClient(app)

def create_pending_order_with_checkout(user_id: int, total_amount=Decimal("100.00"), expires_in_seconds=300):
    """Helper to set up a pending order with associated checkout and reservation hold."""
    db = TestingSessionLocal()
    try:
        now_ts = datetime.now(timezone.utc)
        exp_ts = now_ts + timedelta(seconds=expires_in_seconds)
        chk_op = f"chk_{uuid.uuid4().hex}"
        res_op = f"res_{uuid.uuid4().hex}"
        idemp_key = f"idemp_{uuid.uuid4().hex}"

        new_order = Order(
            user_id=user_id,
            status="Pending",
            total_amount=total_amount
        )
        db.add(new_order)
        db.flush()

        item = OrderItem(
            order_id=new_order.order_id,
            product_id=1,
            quantity=2,
            unit_price=Decimal("50.00")
        )
        db.add(item)
        db.flush()

        chk = Checkout(
            user_id=user_id,
            operation_id=chk_op,
            idempotency_key=idemp_key,
            request_fingerprint=main.compute_request_options_fingerprint(None),
            reservation_op_id=res_op,
            status="RESERVED",
            order_id=new_order.order_id,
            total_amount=total_amount,
            items_snapshot=[{"product_id": 1, "quantity": 2, "unit_price": "50.00", "subtotal": "100.00"}],
            reservation_expires_at=exp_ts
        )
        db.add(chk)
        db.commit()
        return new_order.order_id, chk.checkout_id, res_op, idemp_key
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 1: Payment Success confirms inventory and marks order Paid
# -----------------------------------------------------------------------------
def test_payment_success_confirms_inventory_and_marks_paid(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    confirmed_called = []
    def mock_confirm(op_id):
        confirmed_called.append(op_id)
        return ("CONFIRMED", {"status": "CONFIRMED", "operation_id": op_id}, None, None, False)

    monkeypatch.setattr(main, "confirm_reservation_internal", mock_confirm)

    pay_idemp = f"pay_{uuid.uuid4().hex}"
    headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": pay_idemp
    }
    payload = {
        "method": "Credit Card",
        "simulated_outcome": "SUCCESS"
    }

    res = test_client.post(f"/orders/{order_id}/pay", json=payload, headers=headers)
    assert res.status_code == 200, res.text
    data = res.json()
    assert data["status"] == "SUCCEEDED"
    assert data["order_id"] == order_id
    assert confirmed_called == [res_op]

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        pa = db.query(PaymentAttempt).filter(PaymentAttempt.order_id == order_id).first()
        p = db.query(Payment).filter(Payment.order_id == order_id).first()

        assert order.status == "Paid"
        assert chk.status == "COMPLETED"
        assert pa.status == "SUCCEEDED"
        assert pa.stage == "FINALIZED"
        assert p is not None
        assert p.status == "Completed"
        assert p.amount == Decimal("100.00")
        assert p.method == "Credit Card"
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 2: Payment Decline preserves reservation and allows retry
# -----------------------------------------------------------------------------
def test_payment_decline_preserves_reservation_allows_retry(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    confirm_called = []
    monkeypatch.setattr(main, "confirm_reservation_internal", lambda op: confirm_called.append(op))

    # Attempt 1: DECLINE
    decline_idemp = f"pay_dec_{uuid.uuid4().hex}"
    headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": decline_idemp
    }
    payload = {
        "method": "Credit Card",
        "simulated_outcome": "DECLINE"
    }

    res = test_client.post(f"/orders/{order_id}/pay", json=payload, headers=headers)
    assert res.status_code == 400
    assert "Payment declined" in res.text
    assert len(confirm_called) == 0  # No confirm call for card decline!

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        pa = db.query(PaymentAttempt).filter(PaymentAttempt.idempotency_key == decline_idemp).first()

        assert order.status == "Pending"
        assert chk.status == "RESERVED"
        assert pa.status == "FAILED"
        assert pa.failure_code == "PAYMENT_DECLINED"
    finally:
        db.close()

    # Attempt 2: SUCCESS with new idempotency key
    def mock_confirm(op_id):
        return ("CONFIRMED", {"status": "CONFIRMED"}, None, None, False)
    monkeypatch.setattr(main, "confirm_reservation_internal", mock_confirm)

    retry_idemp = f"pay_retry_{uuid.uuid4().hex}"
    headers["Idempotency-Key"] = retry_idemp
    payload["simulated_outcome"] = "SUCCESS"

    res2 = test_client.post(f"/orders/{order_id}/pay", json=payload, headers=headers)
    assert res2.status_code == 200
    assert res2.json()["status"] == "SUCCEEDED"

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        attempts = db.query(PaymentAttempt).filter(PaymentAttempt.order_id == order_id).all()

        assert order.status == "Paid"
        assert chk.status == "COMPLETED"
        assert len(attempts) == 2
        statuses = [a.status for a in attempts]
        assert "FAILED" in statuses
        assert "SUCCEEDED" in statuses
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 3: Payment Idempotency with exact same payload returns existing result
# -----------------------------------------------------------------------------
def test_payment_idempotency_same_payload(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    confirm_count = [0]
    def mock_confirm(op_id):
        confirm_count[0] += 1
        return ("CONFIRMED", {"status": "CONFIRMED"}, None, None, False)
    monkeypatch.setattr(main, "confirm_reservation_internal", mock_confirm)

    idemp = f"pay_{uuid.uuid4().hex}"
    headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": idemp
    }
    payload = {
        "method": "PayPal",
        "simulated_outcome": "SUCCESS"
    }

    res1 = test_client.post(f"/orders/{order_id}/pay", json=payload, headers=headers)
    assert res1.status_code == 200
    data1 = res1.json()

    # Retry with same idempotency key
    res2 = test_client.post(f"/orders/{order_id}/pay", json=payload, headers=headers)
    assert res2.status_code == 200
    data2 = res2.json()

    assert data1["attempt_id"] == data2["attempt_id"]
    assert data1["status"] == data2["status"] == "SUCCEEDED"
    assert confirm_count[0] == 1  # Only confirmed once!

    db = TestingSessionLocal()
    try:
        pa_count = db.query(PaymentAttempt).filter(PaymentAttempt.order_id == order_id).count()
        p_count = db.query(Payment).filter(Payment.order_id == order_id).count()
        assert pa_count == 1
        assert p_count == 1
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 4: Payment Idempotency with conflicting payload returns 409
# -----------------------------------------------------------------------------
def test_payment_idempotency_conflicting_payload(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    monkeypatch.setattr(main, "confirm_reservation_internal", lambda op: ("CONFIRMED", {"status": "CONFIRMED"}, None, None, False))

    idemp = f"pay_{uuid.uuid4().hex}"
    headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": idemp
    }
    payload1 = {
        "method": "Credit Card",
        "simulated_outcome": "SUCCESS"
    }
    payload2 = {
        "method": "Bank Transfer",
        "simulated_outcome": "SUCCESS"
    }

    res1 = test_client.post(f"/orders/{order_id}/pay", json=payload1, headers=headers)
    assert res1.status_code == 200

    res2 = test_client.post(f"/orders/{order_id}/pay", json=payload2, headers=headers)
    assert res2.status_code == 409
    assert "conflicting payload options" in res2.text


# -----------------------------------------------------------------------------
# Test 5: Payment Timeout (UNKNOWN) reconciles to Paid when Product Service is CONFIRMED
# -----------------------------------------------------------------------------
def test_payment_timeout_unknown_reconciles_to_paid(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    # Initial call simulates timeout
    idemp = f"pay_timeout_{uuid.uuid4().hex}"
    headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": idemp
    }
    payload = {
        "method": "Credit Card",
        "simulated_outcome": "TIMEOUT"
    }

    res = test_client.post(f"/orders/{order_id}/pay", json=payload, headers=headers)
    assert res.status_code == 504

    db = TestingSessionLocal()
    try:
        pa = db.query(PaymentAttempt).filter(PaymentAttempt.idempotency_key == idemp).first()
        order = db.query(Order).filter(Order.order_id == order_id).first()
        assert pa.status == "UNKNOWN"
        assert order.status == "Pending"
    finally:
        db.close()

    # Product Service probe returns CONFIRMED
    def mock_get(op_id):
        return ("CONFIRMED", {"status": "CONFIRMED", "operation_id": op_id}, False, False)
    monkeypatch.setattr(main, "get_reservation_internal", mock_get)

    # Trigger recovery
    db = TestingSessionLocal()
    try:
        stats = reconcile_all_pending_operations(db, worker_id="test_worker")
        assert stats["payment_attempts_reconciled"] >= 1
    finally:
        db.close()

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        pa = db.query(PaymentAttempt).filter(PaymentAttempt.idempotency_key == idemp).first()
        p = db.query(Payment).filter(Payment.order_id == order_id).first()

        assert pa.status == "SUCCEEDED"
        assert order.status == "Paid"
        assert chk.status == "COMPLETED"
        assert p is not None
        assert p.status == "Completed"
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 6: Payment Timeout (UNKNOWN) reconciles to Cancelled if reservation EXPIRED
# -----------------------------------------------------------------------------
def test_payment_timeout_unknown_reconciles_to_cancelled_if_expired(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    idemp = f"pay_timeout_{uuid.uuid4().hex}"
    headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": idemp
    }
    payload = {
        "method": "Credit Card",
        "simulated_outcome": "TIMEOUT"
    }

    res = test_client.post(f"/orders/{order_id}/pay", json=payload, headers=headers)
    assert res.status_code == 504

    # Product Service probe returns EXPIRED
    def mock_get(op_id):
        return ("EXPIRED", {"status": "EXPIRED"}, True, False)
    monkeypatch.setattr(main, "get_reservation_internal", mock_get)

    db = TestingSessionLocal()
    try:
        stats = reconcile_all_pending_operations(db, worker_id="test_worker")
        assert stats["payment_attempts_reconciled"] >= 1
    finally:
        db.close()

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        pa = db.query(PaymentAttempt).filter(PaymentAttempt.idempotency_key == idemp).first()

        assert pa.status == "EXPIRED"
        assert order.status == "Cancelled"
        assert chk.status == "FAILED"
        assert chk.failure_code == "RESERVATION_EXPIRED"
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 7: Cancel Order releases inventory hold and marks order Cancelled
# -----------------------------------------------------------------------------
def test_cancel_order_releases_inventory(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    released_ops = []
    def mock_release(op_id):
        released_ops.append(op_id)
        return True
    monkeypatch.setattr(main, "release_reservation_internal", mock_release)

    canc_idemp = f"canc_{uuid.uuid4().hex}"
    headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": canc_idemp
    }
    payload = {"reason": "Changed my mind"}

    res = test_client.post(f"/orders/{order_id}/cancel", json=payload, headers=headers)
    assert res.status_code == 200, res.text
    data = res.json()
    assert data["status"] == "SUCCEEDED"
    assert data["order_id"] == order_id
    assert released_ops == [res_op]

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        canc = db.query(OrderCancellation).filter(OrderCancellation.order_id == order_id).first()

        assert order.status == "Cancelled"
        assert chk.status == "CANCELLED"
        assert canc.status == "SUCCEEDED"
        assert canc.reason == "Changed my mind"
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 8: Cancel Order idempotency
# -----------------------------------------------------------------------------
def test_cancel_order_idempotency(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)
    monkeypatch.setattr(main, "release_reservation_internal", lambda op: True)

    canc_idemp = f"canc_{uuid.uuid4().hex}"
    headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": canc_idemp
    }
    payload1 = {"reason": "Cancelled by customer"}

    res1 = test_client.post(f"/orders/{order_id}/cancel", json=payload1, headers=headers)
    assert res1.status_code == 200
    data1 = res1.json()

    # Replay with same key & reason
    res2 = test_client.post(f"/orders/{order_id}/cancel", json=payload1, headers=headers)
    assert res2.status_code == 200
    data2 = res2.json()
    assert data1["cancellation_id"] == data2["cancellation_id"]

    # Replay with same key but different reason -> 409
    payload2 = {"reason": "Different conflicting reason"}
    res3 = test_client.post(f"/orders/{order_id}/cancel", json=payload2, headers=headers)
    assert res3.status_code == 409


# -----------------------------------------------------------------------------
# Test 9: Cancel Paid order fails
# -----------------------------------------------------------------------------
def test_cancel_paid_order_fails(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)
    monkeypatch.setattr(main, "confirm_reservation_internal", lambda op: ("CONFIRMED", {"status": "CONFIRMED"}, None, None, False))

    # Pay first
    pay_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": f"pay_{uuid.uuid4().hex}"
    }
    test_client.post(f"/orders/{order_id}/pay", json={"method": "Credit Card", "simulated_outcome": "SUCCESS"}, headers=pay_headers)

    # Now attempt cancel
    canc_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": f"canc_{uuid.uuid4().hex}"
    }
    res = test_client.post(f"/orders/{order_id}/cancel", json={"reason": "Cannot cancel"}, headers=canc_headers)
    assert res.status_code == 400
    assert "already paid" in res.text


# -----------------------------------------------------------------------------
# Test 10: Payment on Cancelled order fails
# -----------------------------------------------------------------------------
def test_payment_on_cancelled_order_fails(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)
    monkeypatch.setattr(main, "release_reservation_internal", lambda op: True)

    # Cancel first
    canc_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": f"canc_{uuid.uuid4().hex}"
    }
    test_client.post(f"/orders/{order_id}/cancel", json={"reason": "Cancel first"}, headers=canc_headers)

    # Now attempt payment
    pay_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": f"pay_{uuid.uuid4().hex}"
    }
    res = test_client.post(f"/orders/{order_id}/pay", json={"method": "Credit Card", "simulated_outcome": "SUCCESS"}, headers=pay_headers)
    assert res.status_code == 400
    assert "cancelled" in res.text


# -----------------------------------------------------------------------------
# Test 11: Cancel while payment attempt is UNKNOWN waits for reconciliation
# -----------------------------------------------------------------------------
def test_cancel_while_payment_unknown_waits_for_reconciliation(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    # Put a payment attempt into UNKNOWN via timeout
    pay_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": f"pay_timeout_{uuid.uuid4().hex}"
    }
    test_client.post(f"/orders/{order_id}/pay", json={"method": "Credit Card", "simulated_outcome": "TIMEOUT"}, headers=pay_headers)

    # If Product Service is unreachable (UNKNOWN probe): cancellation must NOT release reservation!
    monkeypatch.setattr(main, "get_reservation_internal", lambda op: ("UNKNOWN", None, False, True))

    canc_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": f"canc_{uuid.uuid4().hex}"
    }
    res = test_client.post(f"/orders/{order_id}/cancel", json={"reason": "Try cancel during uncertain payment"}, headers=canc_headers)
    assert res.status_code == 503
    assert "uncertain" in res.text

    # Verify inventory was NOT released and order NOT marked Cancelled
    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        assert order.status == "Pending"
        assert chk.status == "RESERVED"
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 12: Expiration worker sweeps expired pending order
# -----------------------------------------------------------------------------
def test_expiration_worker_sweeps_expired_pending_order(monkeypatch, dedicated_user):
    # Create order with expiration 10 seconds in the past
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(
        dedicated_user, expires_in_seconds=-10
    )

    released_ops = []
    def mock_release(op_id):
        released_ops.append(op_id)
        return True
    monkeypatch.setattr(main, "release_reservation_internal", mock_release)

    db = TestingSessionLocal()
    try:
        stats = reconcile_all_pending_operations(db, worker_id="sweep_worker")
        assert stats["expired_checkouts_reconciled"] >= 1
    finally:
        db.close()

    assert released_ops == [res_op]

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()

        assert order.status == "Cancelled"
        assert chk.status == "FAILED"
        assert chk.failure_code == "RESERVATION_EXPIRED"
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 13: Expiration worker does NOT release if payment is in-flight / confirmed
# -----------------------------------------------------------------------------
def test_expiration_worker_does_not_release_if_payment_in_flight(monkeypatch, test_client, dedicated_user):
    # Create expired checkout
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(
        dedicated_user, expires_in_seconds=-10
    )

    # Inject an UNKNOWN payment attempt directly
    db = TestingSessionLocal()
    try:
        pa = PaymentAttempt(
            order_id=order_id,
            user_id=dedicated_user,
            operation_id=f"pay_{uuid.uuid4().hex}",
            idempotency_key=f"idemp_pay_{uuid.uuid4().hex}",
            request_fingerprint="dummy_fp",
            amount=Decimal("100.00"),
            method="Credit Card",
            simulated_outcome="SUCCESS",
            status="UNKNOWN",
            stage="CONFIRM_IN_FLIGHT"
        )
        db.add(pa)
        db.commit()
    finally:
        db.close()

    # When worker checks Product Service, Product Service reports CONFIRMED!
    release_called = []
    monkeypatch.setattr(main, "release_reservation_internal", lambda op: release_called.append(op))
    monkeypatch.setattr(main, "get_reservation_internal", lambda op: ("CONFIRMED", {"status": "CONFIRMED"}, False, False))

    db = TestingSessionLocal()
    try:
        reconcile_all_pending_operations(db, worker_id="sweep_worker")
    finally:
        db.close()

    # CRITICAL: Expiration worker must NOT release inventory!
    assert len(release_called) == 0

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        pa = db.query(PaymentAttempt).filter(PaymentAttempt.order_id == order_id).first()

        assert order.status == "Paid"
        assert chk.status == "COMPLETED"
        assert pa.status == "SUCCEEDED"
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 14: Checkout idempotency after payment completed returns COMPLETED checkout
# -----------------------------------------------------------------------------
def test_checkout_idempotency_after_payment_completed(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)
    monkeypatch.setattr(main, "confirm_reservation_internal", lambda op: ("CONFIRMED", {"status": "CONFIRMED"}, None, None, False))

    # Pay the order
    pay_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": f"pay_{uuid.uuid4().hex}"
    }
    res_pay = test_client.post(f"/orders/{order_id}/pay", json={"method": "Credit Card", "simulated_outcome": "SUCCESS"}, headers=pay_headers)
    assert res_pay.status_code == 200

    # Now retry checkout with the original checkout idempotency key!
    chk_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": chk_idemp
    }
    res_chk = test_client.post("/checkout", json={}, headers=chk_headers)
    assert res_chk.status_code == 200
    data = res_chk.json()
    assert data["status"] == "COMPLETED"
    assert data["order_id"] == order_id
    assert data["checkout_id"] == chk_id


# -----------------------------------------------------------------------------
# Test 15: GET /orders/{order_id}/payment-status returns comprehensive details
# -----------------------------------------------------------------------------
def test_get_payment_status(test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer"
    }
    res = test_client.get(f"/orders/{order_id}/payment-status", headers=headers)
    assert res.status_code == 200
    data = res.json()
    assert data["order_id"] == order_id
    assert data["order_status"] == "Pending"
    assert data["can_pay"] is True
    assert data["can_cancel"] is True
    assert data["is_expired"] is False
    assert len(data["payment_attempts"]) == 0


# -----------------------------------------------------------------------------
# Test 16: Blocker 1: Cancellation claim in COMPENSATION_REQUIRED blocks concurrent payment
# -----------------------------------------------------------------------------
def test_cancellation_claim_blocks_concurrent_payment(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    # Set checkout status to COMPENSATION_REQUIRED and create PROCESSING cancellation
    db = TestingSessionLocal()
    try:
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        chk.status = "COMPENSATION_REQUIRED"
        canc = OrderCancellation(
            order_id=order_id,
            user_id=dedicated_user,
            operation_id=f"canc_{uuid.uuid4().hex}",
            idempotency_key=f"canc_idemp_{uuid.uuid4().hex}",
            request_fingerprint="test_fp",
            status="PROCESSING",
            reason="Cancelling"
        )
        db.add(canc)
        db.commit()
    finally:
        db.close()

    # Attempt payment: must be rejected with 409
    pay_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": f"pay_{uuid.uuid4().hex}"
    }
    res = test_client.post(f"/orders/{order_id}/pay", json={"method": "Credit Card", "simulated_outcome": "SUCCESS"}, headers=pay_headers)
    assert res.status_code == 409
    assert "undergoing cancellation or compensation" in res.json()["detail"]


# -----------------------------------------------------------------------------
# Test 17: Blocker 1: Expiration worker transitions checkout to COMPENSATION_REQUIRED under lock before release
# -----------------------------------------------------------------------------
def test_expiration_worker_serializes_compensation_required_before_release(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(
        dedicated_user,
        expires_in_seconds=-300
    )

    observed_status = []

    def mock_release(op_id):
        # Inspect database during release network call to verify checkout is already COMPENSATION_REQUIRED
        db_check = TestingSessionLocal()
        try:
            chk = db_check.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
            observed_status.append(chk.status)
        finally:
            db_check.close()
        return True

    monkeypatch.setattr(main, "release_reservation_internal", mock_release)

    db = TestingSessionLocal()
    try:
        stats = reconcile_all_pending_operations(db, worker_id="test_worker_exp")
        assert stats["expired_checkouts_reconciled"] >= 1
    finally:
        db.close()

    assert observed_status == ["COMPENSATION_REQUIRED"]

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        assert order.status == "Cancelled"
        assert chk.status == "FAILED"
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 18: Blocker 2: Expired reservation unverified release preserves COMPENSATION_REQUIRED and Pending
# -----------------------------------------------------------------------------
def test_expired_checkout_unverified_release_preserves_compensation_required(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(
        dedicated_user,
        expires_in_seconds=-300
    )

    # Release returns False, and probe returns UNKNOWN
    monkeypatch.setattr(main, "release_reservation_internal", lambda op: False)
    monkeypatch.setattr(main, "get_reservation_internal", lambda op: ("UNKNOWN", None, False, True))

    pay_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": f"pay_exp_{uuid.uuid4().hex}"
    }
    res = test_client.post(f"/orders/{order_id}/pay", json={"method": "Credit Card", "simulated_outcome": "SUCCESS"}, headers=pay_headers)
    assert res.status_code == 503
    assert "pending verification" in res.json()["detail"]

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        assert order.status == "Pending"
        assert chk.status == "COMPENSATION_REQUIRED"
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 19: Blocker 2: Expired reservation discovered CONFIRMED finalizes eligible payment to Paid
# -----------------------------------------------------------------------------
def test_expired_checkout_discovered_confirmed_finalizes_paid(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(
        dedicated_user,
        expires_in_seconds=-300
    )

    # Set up an eligible in-flight attempt (e.g. UNKNOWN) that caused the CONFIRMED hold
    db = TestingSessionLocal()
    try:
        att = PaymentAttempt(
            order_id=order_id,
            user_id=dedicated_user,
            operation_id=f"pay_{uuid.uuid4().hex}",
            idempotency_key=f"idemp_orig_{uuid.uuid4().hex}",
            request_fingerprint="fp_orig",
            amount=Decimal("100.00"),
            method="Credit Card",
            simulated_outcome="TIMEOUT",
            status="UNKNOWN",
            stage="CONFIRM_IN_FLIGHT"
        )
        db.add(att)
        db.commit()
    finally:
        db.close()

    # Release returns False, but probe discovers reservation was actually CONFIRMED
    monkeypatch.setattr(main, "release_reservation_internal", lambda op: False)
    monkeypatch.setattr(main, "get_reservation_internal", lambda op: ("CONFIRMED", {"status": "CONFIRMED"}, False, False))

    pay_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": f"pay_exp_conf_{uuid.uuid4().hex}"
    }
    res = test_client.post(f"/orders/{order_id}/pay", json={"method": "Credit Card", "simulated_outcome": "SUCCESS"}, headers=pay_headers)
    assert res.status_code == 400
    assert ("already confirmed" in res.json()["detail"] or "paid by another" in res.json()["detail"])

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        p = db.query(Payment).filter(Payment.order_id == order_id).first()
        pa = db.query(PaymentAttempt).filter(PaymentAttempt.order_id == order_id).first()
        assert order.status == "Paid"
        assert chk.status == "COMPLETED"
        assert pa.status == "SUCCEEDED"
        assert p is not None
        assert p.status == "Completed"
        assert p.method == "Credit Card"
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 20: Blocker 3: Cancellation failure path probes without transaction and creates canonical Payments record on CONFIRMED
# -----------------------------------------------------------------------------
def test_cancellation_confirmed_probes_outside_tx_and_creates_canonical_payment(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    # Set up an eligible in-flight attempt (e.g. UNKNOWN) that caused the CONFIRMED hold
    canc_idemp = f"canc_fail_{uuid.uuid4().hex}"
    canc_fp = main.compute_cancellation_fingerprint(order_id, "Cancel attempt")
    db = TestingSessionLocal()
    try:
        att = PaymentAttempt(
            order_id=order_id,
            user_id=dedicated_user,
            operation_id=f"pay_{uuid.uuid4().hex}",
            idempotency_key=f"idemp_orig_{uuid.uuid4().hex}",
            request_fingerprint="fp_orig",
            amount=Decimal("100.00"),
            method="Bank Transfer",
            simulated_outcome="TIMEOUT",
            status="UNKNOWN",
            stage="CONFIRM_IN_FLIGHT"
        )
        db.add(att)
        canc = OrderCancellation(
            order_id=order_id,
            user_id=dedicated_user,
            operation_id=f"canc_{uuid.uuid4().hex}",
            idempotency_key=canc_idemp,
            request_fingerprint=canc_fp,
            status="PROCESSING",
            reason="Cancel attempt"
        )
        db.add(canc)
        db.commit()
    finally:
        db.close()

    probe_tx_active = []

    def mock_release(op_id):
        return False

    def mock_get(op_id):
        db_check = TestingSessionLocal()
        try:
            probe_tx_active.append(False)
        finally:
            db_check.close()
        return ("CONFIRMED", {"status": "CONFIRMED"}, False, False)

    monkeypatch.setattr(main, "release_reservation_internal", mock_release)
    monkeypatch.setattr(main, "get_reservation_internal", mock_get)

    canc_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": canc_idemp
    }
    res = test_client.post(f"/orders/{order_id}/cancel", json={"reason": "Cancel attempt"}, headers=canc_headers)
    assert res.status_code == 400
    assert ("already confirmed" in res.json()["detail"] or "payment was confirmed" in res.json()["detail"])
    assert len(probe_tx_active) == 1

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        canc = db.query(OrderCancellation).filter(OrderCancellation.order_id == order_id).first()
        p = db.query(Payment).filter(Payment.order_id == order_id).first()
        pa = db.query(PaymentAttempt).filter(PaymentAttempt.order_id == order_id).first()

        # Consistent state verified
        assert order.status == "Paid"
        assert chk.status == "COMPLETED"
        assert pa.status == "SUCCEEDED"
        assert canc.status == "FAILED"
        assert "confirmed" in (canc.reason or "")
        # Canonical Payments record MUST exist when order is Paid using attempt's method!
        assert p is not None
        assert p.status == "Completed"
        assert p.method == "Bank Transfer"
        assert float(p.amount) == float(order.total_amount)
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 21: Audit Integrity: CONFIRMED reservation with no payment attempt preserves discrepancy
# -----------------------------------------------------------------------------
def test_confirmed_reservation_with_no_payment_attempt_preserves_discrepancy(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    # Inventory service reports CONFIRMED, but release returned False
    monkeypatch.setattr(main, "release_reservation_internal", lambda op: False)
    monkeypatch.setattr(main, "get_reservation_internal", lambda op: ("CONFIRMED", {"status": "CONFIRMED"}, False, False))

    canc_headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": f"canc_disc_{uuid.uuid4().hex}"
    }
    # Cancellation probe discovers CONFIRMED with no payment attempts
    res = test_client.post(f"/orders/{order_id}/cancel", json={"reason": "Cancel attempt"}, headers=canc_headers)
    assert res.status_code == 409
    assert "preserved for review" in res.json()["detail"]

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        canc = db.query(OrderCancellation).filter(OrderCancellation.order_id == order_id).first()
        p = db.query(Payment).filter(Payment.order_id == order_id).first()
        attempts = db.query(PaymentAttempt).filter(PaymentAttempt.order_id == order_id).all()

        # Discrepancy is preserved: NO fake payment, NO order marked Paid, NOT cancelled
        assert order.status == "Pending"
        assert chk.status == "COMPENSATION_REQUIRED"
        assert chk.failure_code == "CONFIRMED_WITHOUT_ELIGIBLE_PAYMENT"
        assert p is None
        assert len(attempts) == 0
        assert canc.status == "FAILED"
        assert "no eligible payment attempt" in (canc.reason or "")
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 22: Audit Integrity: CONFIRMED reservation with only declined attempt preserves discrepancy
# -----------------------------------------------------------------------------
def test_confirmed_reservation_with_only_declined_attempt_preserves_discrepancy(monkeypatch, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(
        dedicated_user,
        expires_in_seconds=-300
    )

    # Insert a definitively DECLINED payment attempt
    db = TestingSessionLocal()
    try:
        declined_att = PaymentAttempt(
            order_id=order_id,
            user_id=dedicated_user,
            operation_id=f"pay_dec_{uuid.uuid4().hex}",
            idempotency_key=f"idemp_dec_{uuid.uuid4().hex}",
            request_fingerprint="fp_dec",
            amount=Decimal("100.00"),
            method="Credit Card",
            simulated_outcome="DECLINE",
            status="FAILED",
            stage="SIMULATED_DECLINE",
            failure_code="PAYMENT_DECLINED",
            failure_reason="Simulated payment declined by card issuer"
        )
        db.add(declined_att)
        db.commit()
    finally:
        db.close()

    # Inventory service reports CONFIRMED, but release fails
    monkeypatch.setattr(main, "release_reservation_internal", lambda op: False)
    monkeypatch.setattr(main, "get_reservation_internal", lambda op: ("CONFIRMED", {"status": "CONFIRMED"}, False, False))

    # Autonomous recovery sweeps the expired checkout
    db = TestingSessionLocal()
    try:
        stats = reconcile_all_pending_operations(db, worker_id="test-audit-worker")
        assert stats["expired_checkouts_reconciled"] == 1

        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        p = db.query(Payment).filter(Payment.order_id == order_id).first()
        att = db.query(PaymentAttempt).filter(PaymentAttempt.order_id == order_id).first()

        # Declined attempt must NEVER be converted to SUCCEEDED!
        assert att.status == "FAILED"
        assert att.failure_code == "PAYMENT_DECLINED"
        # Order must remain Pending, NO Payment record created
        assert order.status == "Pending"
        assert chk.status == "COMPENSATION_REQUIRED"
        assert chk.failure_code == "CONFIRMED_WITHOUT_ELIGIBLE_PAYMENT"
        assert p is None
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 23: Audit Integrity: CONFIRMED reservation with eligible UNKNOWN attempt finalizes paid
# -----------------------------------------------------------------------------
def test_confirmed_reservation_with_eligible_unknown_attempt_finalizes_paid(monkeypatch, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(
        dedicated_user,
        expires_in_seconds=-300
    )

    # Insert an eligible in-flight UNKNOWN payment attempt
    db = TestingSessionLocal()
    try:
        unknown_att = PaymentAttempt(
            order_id=order_id,
            user_id=dedicated_user,
            operation_id=f"pay_unk_{uuid.uuid4().hex}",
            idempotency_key=f"idemp_unk_{uuid.uuid4().hex}",
            request_fingerprint="fp_unk",
            amount=Decimal("100.00"),
            method="PayPal",
            simulated_outcome="TIMEOUT",
            status="UNKNOWN",
            stage="CONFIRM_IN_FLIGHT",
            failure_code="SIMULATED_TIMEOUT",
            failure_reason="Simulated payment gateway timeout"
        )
        db.add(unknown_att)
        db.commit()
    finally:
        db.close()

    # Inventory service reports CONFIRMED
    monkeypatch.setattr(main, "release_reservation_internal", lambda op: False)
    monkeypatch.setattr(main, "get_reservation_internal", lambda op: ("CONFIRMED", {"status": "CONFIRMED"}, False, False))

    # Autonomous recovery runs
    db = TestingSessionLocal()
    try:
        stats = reconcile_all_pending_operations(db, worker_id="test-audit-worker")
        assert stats["payment_attempts_reconciled"] == 1

        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        p = db.query(Payment).filter(Payment.order_id == order_id).first()
        att = db.query(PaymentAttempt).filter(PaymentAttempt.order_id == order_id).first()

        # Eligible UNKNOWN attempt is finalized to SUCCEEDED
        assert att.status == "SUCCEEDED"
        assert att.stage == "FINALIZED"
        assert order.status == "Paid"
        assert chk.status == "COMPLETED"
        # Canonical Payments record created with attempt's method
        assert p is not None
        assert p.status == "Completed"
        assert p.method == "PayPal"
        assert p.amount == Decimal("100.00")
    finally:
        db.close()


# -----------------------------------------------------------------------------
# Test 24: Audit Integrity: Normal successful payment remains unchanged
# -----------------------------------------------------------------------------
def test_normal_successful_payment_unchanged(monkeypatch, test_client, dedicated_user):
    order_id, chk_id, res_op, chk_idemp = create_pending_order_with_checkout(dedicated_user)

    monkeypatch.setattr(main, "confirm_reservation_internal", lambda op: ("CONFIRMED", {"status": "CONFIRMED"}, None, None, False))

    pay_idemp = f"pay_norm_{uuid.uuid4().hex}"
    headers = {
        "X-User-Sub": str(dedicated_user),
        "X-User-Role": "customer",
        "Idempotency-Key": pay_idemp
    }
    payload = {
        "method": "Gift Card",
        "simulated_outcome": "SUCCESS"
    }

    res = test_client.post(f"/orders/{order_id}/pay", json=payload, headers=headers)
    assert res.status_code == 200
    data = res.json()
    assert data["status"] == "SUCCEEDED"
    assert data["order_id"] == order_id

    db = TestingSessionLocal()
    try:
        order = db.query(Order).filter(Order.order_id == order_id).first()
        chk = db.query(Checkout).filter(Checkout.checkout_id == chk_id).first()
        p = db.query(Payment).filter(Payment.order_id == order_id).first()
        pa = db.query(PaymentAttempt).filter(PaymentAttempt.order_id == order_id).first()

        assert order.status == "Paid"
        assert chk.status == "COMPLETED"
        assert pa.status == "SUCCEEDED"
        assert p is not None
        assert p.status == "Completed"
        assert p.method == "Gift Card"
        assert p.amount == Decimal("100.00")
    finally:
        db.close()

