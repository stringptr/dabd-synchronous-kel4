import pytest
from fastapi.testclient import TestClient
from main import app, get_db, Base
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

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
