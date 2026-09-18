import pytest
from fastapi.testclient import TestClient
from main import app, get_db, verify_password, get_password_hash, create_access_token
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from main import Base

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

def test_password_hashing():
    pwd = "mysecretpassword"
    hashed = get_password_hash(pwd)
    assert verify_password(pwd, hashed) == True
    assert verify_password("wrong", hashed) == False

def test_jwt_generation():
    token = create_access_token({"sub": "1", "role": "user"})
    assert isinstance(token, str)

def test_register_and_login():
    # Register
    response = client.post("/register", json={
        "first_name": "Test",
        "last_name": "User",
        "email": "test@test.com",
        "password": "password123"
    })
    assert response.status_code == 200
    data = response.json()
    assert data["email"] == "test@test.com"
    assert data["is_admin"] == False

    # Cannot self register as admin (ignored is_admin field in payload)
    response2 = client.post("/register", json={
        "first_name": "Admin",
        "last_name": "WannaBe",
        "email": "hacker@test.com",
        "password": "password123",
        "is_admin": True
    })
    assert response2.status_code == 200
    assert response2.json()["is_admin"] == False
    
    # Login
    response = client.post("/login", json={
        "email": "test@test.com",
        "password": "password123"
    })
    assert response.status_code == 200
    token = response.json()["access_token"]
    assert token is not None

    # Login failure
    response = client.post("/login", json={
        "email": "test@test.com",
        "password": "wrongpassword"
    })
    assert response.status_code == 401

def test_health():
    response = client.get("/health/live")
    assert response.status_code == 200

    response = client.get("/health/ready")
    assert response.status_code == 200 # Since SQLite works
