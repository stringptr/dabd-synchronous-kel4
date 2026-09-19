import os
os.environ["INTERNAL_API_KEY"] = "testinternal"

import pytest
from decimal import Decimal
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.engine import make_url
from concurrent.futures import ThreadPoolExecutor

import order_service.main as main
from order_service.main import app, get_db, Cart, CartItemModel, get_or_create_cart

SQLALCHEMY_DATABASE_URL = os.getenv("TEST_DATABASE_URL", "postgresql+psycopg2://postgres:postgres@localhost:5433/test_db")
engine = create_engine(SQLALCHEMY_DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

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

def mock_product_service(product_id: int, price: float = 19.99, name: str = None):
    return {
        "product_id": product_id,
        "name": name or f"Test Product {product_id}",
        "price": price,
        "total_stock": 100
    }

# 1. Lazy cart creation
def test_lazy_cart_creation():
    response = client.get("/cart", headers={"X-User-Sub": "50", "X-User-Role": "user"})
    assert response.status_code == 200
    data = response.json()
    assert data["user_id"] == 50
    assert data["items"] == []
    assert data["total_items"] == 0
    assert float(data["estimated_total"]) == 0.0

# 2. Cart persistence
def test_cart_persistence(monkeypatch):
    monkeypatch.setattr(main, "fetch_product_with_breaker", lambda pid, rid, auth=None: mock_product_service(pid, price=25.00))
    
    # Add item
    res = client.post("/cart/items", json={"product_id": 1, "quantity": 2}, headers={"X-User-Sub": "51", "X-User-Role": "user"})
    assert res.status_code == 200
    
    # Retrieve cart later
    res2 = client.get("/cart", headers={"X-User-Sub": "51", "X-User-Role": "user"})
    assert res2.status_code == 200
    data = res2.json()
    assert len(data["items"]) == 1
    assert data["items"][0]["product_id"] == 1
    assert data["items"][0]["quantity"] == 2
    assert float(data["items"][0]["unit_price"]) == 25.00
    assert float(data["estimated_total"]) == 50.00

# 3. Adding an item
def test_add_item_to_cart(monkeypatch):
    monkeypatch.setattr(main, "fetch_product_with_breaker", lambda pid, rid, auth=None: mock_product_service(pid, price=10.00, name="Gadget"))
    
    res = client.post("/cart/items", json={"product_id": 2, "quantity": 3}, headers={"X-User-Sub": "52", "X-User-Role": "user"})
    assert res.status_code == 200
    data = res.json()
    assert data["total_items"] == 3
    assert len(data["items"]) == 1
    assert data["items"][0]["name"] == "Gadget"
    assert float(data["items"][0]["subtotal"]) == 30.00

# 4. Adding the same product twice (deterministic: INCREASES quantity)
def test_add_same_product_twice_increases_quantity(monkeypatch):
    monkeypatch.setattr(main, "fetch_product_with_breaker", lambda pid, rid, auth=None: mock_product_service(pid, price=15.00))
    
    # First addition
    res1 = client.post("/cart/items", json={"product_id": 3, "quantity": 2}, headers={"X-User-Sub": "53", "X-User-Role": "user"})
    assert res1.status_code == 200
    assert res1.json()["total_items"] == 2
    
    # Second addition of same product
    res2 = client.post("/cart/items", json={"product_id": 3, "quantity": 4}, headers={"X-User-Sub": "53", "X-User-Role": "user"})
    assert res2.status_code == 200
    data = res2.json()
    assert len(data["items"]) == 1
    assert data["items"][0]["quantity"] == 6
    assert data["total_items"] == 6
    assert float(data["estimated_total"]) == 90.00

# 5. Updating quantities
def test_update_item_quantity(monkeypatch):
    monkeypatch.setattr(main, "fetch_product_with_breaker", lambda pid, rid, auth=None: mock_product_service(pid, price=20.00))
    
    res = client.post("/cart/items", json={"product_id": 4, "quantity": 1}, headers={"X-User-Sub": "54", "X-User-Role": "user"})
    item_id = res.json()["items"][0]["cart_item_id"]
    
    # Update quantity to 5
    res_patch = client.patch(f"/cart/items/{item_id}", json={"quantity": 5}, headers={"X-User-Sub": "54", "X-User-Role": "user"})
    assert res_patch.status_code == 200
    data = res_patch.json()
    assert data["items"][0]["quantity"] == 5
    assert float(data["estimated_total"]) == 100.00

# 6. Removing an item
def test_remove_item(monkeypatch):
    monkeypatch.setattr(main, "fetch_product_with_breaker", lambda pid, rid, auth=None: mock_product_service(pid, price=12.00))
    
    res = client.post("/cart/items", json={"product_id": 5, "quantity": 1}, headers={"X-User-Sub": "55", "X-User-Role": "user"})
    item_id = res.json()["items"][0]["cart_item_id"]
    
    del_res = client.delete(f"/cart/items/{item_id}", headers={"X-User-Sub": "55", "X-User-Role": "user"})
    assert del_res.status_code == 200
    assert del_res.json() == {"message": "Item removed from cart"}
    
    # Check cart is now empty
    get_res = client.get("/cart", headers={"X-User-Sub": "55", "X-User-Role": "user"})
    assert len(get_res.json()["items"]) == 0

# 7. Emptying a cart
def test_empty_cart(monkeypatch):
    monkeypatch.setattr(main, "fetch_product_with_breaker", lambda pid, rid, auth=None: mock_product_service(pid, price=10.00))
    
    client.post("/cart/items", json={"product_id": 1, "quantity": 2}, headers={"X-User-Sub": "56", "X-User-Role": "user"})
    client.post("/cart/items", json={"product_id": 2, "quantity": 3}, headers={"X-User-Sub": "56", "X-User-Role": "user"})
    
    res = client.delete("/cart", headers={"X-User-Sub": "56", "X-User-Role": "user"})
    assert res.status_code == 200
    assert res.json() == {"message": "Cart emptied successfully"}
    
    get_res = client.get("/cart", headers={"X-User-Sub": "56", "X-User-Role": "user"})
    assert get_res.json()["items"] == []
    assert get_res.json()["total_items"] == 0

# 8. Invalid quantities
def test_invalid_quantities():
    # Adding zero quantity
    res1 = client.post("/cart/items", json={"product_id": 1, "quantity": 0}, headers={"X-User-Sub": "57", "X-User-Role": "user"})
    assert res1.status_code == 422

    # Adding negative quantity
    res2 = client.post("/cart/items", json={"product_id": 1, "quantity": -2}, headers={"X-User-Sub": "57", "X-User-Role": "user"})
    assert res2.status_code == 422

    # Updating to zero quantity
    res3 = client.patch("/cart/items/1", json={"quantity": 0}, headers={"X-User-Sub": "57", "X-User-Role": "user"})
    assert res3.status_code == 422

# 9. Nonexistent products
def test_nonexistent_product(monkeypatch):
    from fastapi import HTTPException
    def mock_fetch_fail(pid, rid, auth=None):
        raise HTTPException(status_code=404, detail=f"Product {pid} not found")
    
    monkeypatch.setattr(main, "fetch_product_with_breaker", mock_fetch_fail)
    
    res = client.post("/cart/items", json={"product_id": 99999, "quantity": 1}, headers={"X-User-Sub": "58", "X-User-Role": "user"})
    assert res.status_code == 404
    assert "not found" in res.json()["detail"]

# 10. Cross-user access attempts
def test_cross_user_cart_access(monkeypatch):
    monkeypatch.setattr(main, "fetch_product_with_breaker", lambda pid, rid, auth=None: mock_product_service(pid, price=10.00))
    
    # User 60 adds item
    res = client.post("/cart/items", json={"product_id": 1, "quantity": 1}, headers={"X-User-Sub": "60", "X-User-Role": "user"})
    item_id = res.json()["items"][0]["cart_item_id"]
    
    # User 61 tries to modify User 60's cart item -> 404
    patch_res = client.patch(f"/cart/items/{item_id}", json={"quantity": 10}, headers={"X-User-Sub": "61", "X-User-Role": "user"})
    assert patch_res.status_code == 404

    # User 61 tries to delete User 60's cart item -> 404
    del_res = client.delete(f"/cart/items/{item_id}", headers={"X-User-Sub": "61", "X-User-Role": "user"})
    assert del_res.status_code == 404

    # User 61 gets their own cart -> completely empty
    user61_cart = client.get("/cart", headers={"X-User-Sub": "61", "X-User-Role": "user"})
    assert user61_cart.json()["items"] == []

# 11. Unauthenticated requests
def test_unauthenticated_cart_requests():
    assert client.get("/cart").status_code == 401
    assert client.post("/cart/items", json={"product_id": 1, "quantity": 1}).status_code == 401
    assert client.patch("/cart/items/1", json={"quantity": 1}).status_code == 401
    assert client.delete("/cart/items/1").status_code == 401
    assert client.delete("/cart").status_code == 401

# 12. Product Service failures
def test_product_service_failure_does_not_corrupt_cart(monkeypatch):
    monkeypatch.setattr(main, "fetch_product_with_breaker", lambda pid, rid, auth=None: mock_product_service(pid, price=10.00))
    
    # User 62 adds item successfully
    res = client.post("/cart/items", json={"product_id": 1, "quantity": 2}, headers={"X-User-Sub": "62", "X-User-Role": "user"})
    assert res.status_code == 200

    # Now product service fails with 503
    def mock_service_down(pid, rid, auth=None):
        raise Exception("Connection refused")
    monkeypatch.setattr(main, "fetch_product_with_breaker", mock_service_down)

    # Calling GET /cart returns 503
    fail_res = client.get("/cart", headers={"X-User-Sub": "62", "X-User-Role": "user"})
    assert fail_res.status_code == 503

    # Restore product service: cart is still intact and not corrupted!
    monkeypatch.setattr(main, "fetch_product_with_breaker", lambda pid, rid, auth=None: mock_product_service(pid, price=10.00))
    recovered_res = client.get("/cart", headers={"X-User-Sub": "62", "X-User-Role": "user"})
    assert recovered_res.status_code == 200
    assert len(recovered_res.json()["items"]) == 1
    assert recovered_res.json()["items"][0]["quantity"] == 2

# 13. Authoritative price calculation with Decimal precision
def test_authoritative_price_calculation_decimal(monkeypatch):
    # Test fractional cents: price $19.99 * 3 = $59.97
    monkeypatch.setattr(main, "fetch_product_with_breaker", lambda pid, rid, auth=None: mock_product_service(pid, price=19.99))
    
    res = client.post("/cart/items", json={"product_id": 1, "quantity": 3}, headers={"X-User-Sub": "63", "X-User-Role": "user"})
    assert res.status_code == 200
    data = res.json()
    assert float(data["items"][0]["unit_price"]) == 19.99
    assert float(data["items"][0]["subtotal"]) == 59.97
    assert float(data["estimated_total"]) == 59.97

# 14. Concurrent attempts to create the same user's cart
def test_concurrent_cart_creation():
    user_id = 70
    results = []
    
    def create_cart_task():
        # Create separate session for each concurrent worker
        session = TestingSessionLocal()
        try:
            cart = get_or_create_cart(session, user_id)
            results.append(cart.cart_id)
        finally:
            session.close()

    with ThreadPoolExecutor(max_workers=5) as executor:
        futures = [executor.submit(create_cart_task) for _ in range(5)]
        for f in futures:
            f.result()

    # All threads must receive the EXACT same cart_id without IntegrityError breaking
    assert len(results) == 5
    assert len(set(results)) == 1
