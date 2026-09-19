import os
os.environ["INTERNAL_API_KEY"] = "testinternal"

import pytest
from fastapi.testclient import TestClient
from product_service.main import app, get_db, Base
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

import os
SQLALCHEMY_DATABASE_URL = os.getenv("TEST_DATABASE_URL", "postgresql+psycopg2://postgres:postgres@localhost:5433/test_db")
engine = create_engine(SQLALCHEMY_DATABASE_URL)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

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

def test_list_products():
    response = client.get("/products")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_create_product_no_auth():
    response = client.post("/products", json={
        "name": "Widget",
        "price": 10.0
    })
    assert response.status_code == 403

def test_create_product_admin():
    response = client.post("/products", json={
        "name": "Widget",
        "price": 10.0
    }, headers={"X-User-Role": "admin"})
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Widget"
    assert data["price"] == 10.0

def test_validation():
    # Negative price
    response = client.post("/products", json={
        "name": "Widget",
        "price": -5.0
    }, headers={"X-User-Role": "admin"})
    assert response.status_code == 422

def test_internal_api_key_missing():
    response = client.get("/internal/ping")
    # Header(...) without default raises 422
    assert response.status_code == 422

def test_internal_api_key_incorrect():
    response = client.get("/internal/ping", headers={"X-Internal-Secret": "wrong_secret_value"})
    assert response.status_code == 403
    assert response.json()["detail"] == "Forbidden: Invalid internal secret"

def test_internal_api_key_valid():
    response = client.get("/internal/ping", headers={"X-Internal-Secret": "testinternal"})
    assert response.status_code == 200
    assert response.json() == {"status": "internal_ok"}

def test_forged_non_admin_role_rejected():
    response = client.post("/products", json={
        "name": "Hacked Product",
        "price": 10.0
    }, headers={"X-User-Role": "user"})
    assert response.status_code == 403
    assert "Admin access required" in response.json()["detail"]
