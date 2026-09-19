import os
import jwt
os.environ["JWT_SECRET"] = "testsecret"

import pytest
from fastapi.testclient import TestClient
from auth_service.main import app, get_db, verify_password, get_password_hash, create_access_token
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from auth_service.main import Base

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
    assert response.status_code == 200

def test_unauthorized_verify_missing_token():
    response = client.get("/verify")
    assert response.status_code == 401

def test_unauthorized_verify_invalid_token():
    response = client.get("/verify", headers={"Authorization": "Bearer invalid.token.payload"})
    assert response.status_code == 401

def test_unauthorized_verify_wrong_secret():
    # Token signed with forged secret
    forged_token = jwt.encode({"sub": "1", "role": "admin"}, "wrong_secret", algorithm="HS256")
    response = client.get("/verify", headers={"Authorization": f"Bearer {forged_token}"})
    assert response.status_code == 401

def test_verify_ignores_forged_role_header():
    # User token with role: user, but sending X-User-Role: admin
    user_token = create_access_token({"sub": "1", "role": "user"})
    response = client.get("/verify", headers={
        "Authorization": f"Bearer {user_token}",
        "X-User-Role": "admin"
    })
    assert response.status_code == 200
    # Response header MUST be authoritative from JWT, ignoring forged header
    assert response.headers.get("X-User-Role") == "user"
    assert response.headers.get("X-User-Sub") == "1"
