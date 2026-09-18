import pytest
from fastapi.testclient import TestClient
from main import app, get_db, Base, fetch_product_with_breaker, breaker
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import pybreaker

from sqlalchemy.pool import StaticPool
SQLALCHEMY_DATABASE_URL = "sqlite:///:memory:"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}, poolclass=StaticPool)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base.metadata.create_all(bind=engine)

def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()

app.dependency_overrides[get_db] = override_get_db

client = TestClient(app)

# We need to monkeypatch the fetch_product_with_breaker to not hit network, 
# but we want to test circuit breaker. So we patch the inner function fetch_product.
import main

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
    })
    assert response.status_code == 401

def test_create_order_success(monkeypatch):
    def mock_fetch(product_id, req_id, auth):
        return {"price": 100.0, "total_stock": 5}
    monkeypatch.setattr(main, "fetch_product", mock_fetch)
    # reset breaker if open
    main.breaker.close()
    
    response = client.post("/orders", json={
        "items": [{"product_id": 1, "quantity": 2}]
    }, headers={"X-User-Sub": "1", "X-User-Role": "user"})
    
    assert response.status_code == 200
    data = response.json()
    assert data["total_amount"] == 200.0

def test_create_order_insufficient_stock(monkeypatch):
    def mock_fetch(product_id, req_id, auth):
        return {"price": 100.0, "total_stock": 1} # Only 1 in stock
    monkeypatch.setattr(main, "fetch_product", mock_fetch)
    
    response = client.post("/orders", json={
        "items": [{"product_id": 1, "quantity": 2}]
    }, headers={"X-User-Sub": "1", "X-User-Role": "user"})
    
    assert response.status_code == 400

def test_get_orders(monkeypatch):
    response = client.get("/orders", headers={"X-User-Sub": "1", "X-User-Role": "user"})
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert data[0]["user_id"] == 1
