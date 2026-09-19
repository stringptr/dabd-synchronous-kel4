import os
os.environ["INTERNAL_API_KEY"] = "testinternal"

import pytest
from fastapi.testclient import TestClient
from order_service.main import app, get_db, Base, fetch_product_with_breaker, breaker
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import pybreaker

import os
SQLALCHEMY_DATABASE_URL = os.getenv("TEST_DATABASE_URL", "postgresql+psycopg2://postgres:postgres@localhost:5433/test_db")
engine = create_engine(SQLALCHEMY_DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

from sqlalchemy import text

from sqlalchemy.engine import make_url
import os

@pytest.fixture(autouse=True)
def setup_database():
    url = make_url(str(engine.url))
    if url.database != "test_db":
        raise RuntimeError(f"Destructive tests target '{url.database}', expected 'test_db'")
    if os.getenv("TEST_ENV") != "true":
        raise RuntimeError("Destructive tests require TEST_ENV=true")

    connection = engine.connect()
    transaction = connection.begin()
    session = TestingSessionLocal(bind=connection)
    
    def override_get_db():
        yield session

    app.dependency_overrides[get_db] = override_get_db
    
    yield
    
    session.close()
    transaction.rollback()
    connection.close()
    app.dependency_overrides.clear()

client = TestClient(app)

# We need to monkeypatch the fetch_product_with_breaker to not hit network, 
# but we want to test circuit breaker. So we patch the inner function fetch_product.
import order_service.main as main

def test_circuit_breaker(monkeypatch):
    fail_count = 0
    def mock_fetch(product_id, req_id, auth):
        nonlocal fail_count
        fail_count += 1
        raise Exception("Network Error")
    
    monkeypatch.setattr(main, "fetch_product", mock_fetch)
    
    # Try calling fetch_product_with_breaker 4 times. 4th time should raise CircuitBreakerError immediately
    for _ in range(3):
        try:
            main.fetch_product_with_breaker(1, "id", None)
        except Exception as e:
            pass
            
    assert fail_count == 3
    
    with pytest.raises(pybreaker.CircuitBreakerError):
        main.fetch_product_with_breaker(1, "id", None)
    
    # The mock fetch is not called a 4th time
    assert fail_count == 3

def test_create_order_unauthenticated():
    response = client.post("/orders", json={
        "items": [{"product_id": 1, "quantity": 1}]
    }, headers={"Idempotency-Key": "unauth-key-1"})
    assert response.status_code == 401

def test_create_order_missing_idempotency_key():
    response = client.post("/orders", json={
        "items": [{"product_id": 1, "quantity": 1}]
    }, headers={"X-User-Sub": "1", "X-User-Role": "user"})
    assert response.status_code == 400
    assert "Idempotency-Key header is required" in response.json()["detail"]

def test_create_order_success(monkeypatch):
    def mock_fetch(product_id, req_id, auth):
        return {"price": 100.0, "name": "Product 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)
    main.breaker.close()
    
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE"}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    response = client.post("/orders", json={
        "items": [{"product_id": 1, "quantity": 2}]
    }, headers={"X-User-Sub": "1", "X-User-Role": "user", "Idempotency-Key": "legacy-order-key-1"})
    
    assert response.status_code == 200
    data = response.json()
    assert data["total_amount"] == 200.0

def test_create_order_insufficient_stock(monkeypatch):
    def mock_fetch(product_id, req_id, auth):
        return {"price": 100.0, "name": "Product 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)
    
    def mock_reserve(op_id, items):
        return ("FAILED", {"status": "FAILED", "failure_code": "INSUFFICIENT_STOCK"}, "INSUFFICIENT_STOCK", "Insufficient stock", False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    response = client.post("/orders", json={
        "items": [{"product_id": 1, "quantity": 2}]
    }, headers={"X-User-Sub": "1", "X-User-Role": "user", "Idempotency-Key": "legacy-order-fail-key"})
    
    assert response.status_code == 400

def test_get_orders(monkeypatch):
    def mock_fetch(product_id, req_id, auth):
        return {"price": 100.0, "name": "Product 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)
    main.breaker.close()
    
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE"}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    client.post("/orders", json={
        "items": [{"product_id": 1, "quantity": 1}]
    }, headers={"X-User-Sub": "1", "X-User-Role": "user", "Idempotency-Key": "get-orders-key-1"})

    response = client.get("/orders", headers={"X-User-Sub": "1", "X-User-Role": "user"})
    assert response.status_code == 200
    assert len(response.json()) > 0

def test_get_orders_unauthenticated():
    response = client.get("/orders")
    assert response.status_code == 401

def test_order_isolation_between_users(monkeypatch):
    def mock_fetch(product_id, req_id, auth):
        return {"price": 50.0, "name": "Product 1"}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)
    main.breaker.close()
    
    def mock_reserve(op_id, items):
        return ("ACTIVE", {"status": "ACTIVE"}, None, None, False)
    monkeypatch.setattr(main, "reserve_inventory_internal", mock_reserve)

    # User 1 creates an order
    res = client.post("/orders", json={
        "items": [{"product_id": 1, "quantity": 1}]
    }, headers={"X-User-Sub": "1", "X-User-Role": "user", "Idempotency-Key": "user1-order-key"})
    assert res.status_code == 200
    created_order_id = res.json()["order_id"]

    # User 2 checks orders - must NOT see User 1's newly created order
    res2 = client.get("/orders", headers={"X-User-Sub": "2", "X-User-Role": "user"})
    assert res2.status_code == 200
    assert not any(o["order_id"] == created_order_id for o in res2.json())

    # User 1 checks orders - must see User 1's newly created order
    res1 = client.get("/orders", headers={"X-User-Sub": "1", "X-User-Role": "user"})
    assert res1.status_code == 200
    assert any(o["order_id"] == created_order_id for o in res1.json())
