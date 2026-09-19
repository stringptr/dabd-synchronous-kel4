import pytest
import os
from sqlalchemy import create_engine
from sqlalchemy.engine import make_url

def setup_database_guard(url_str):
    url = make_url(url_str)
    if url.database != 'test_db':
        raise RuntimeError(f"Destructive tests target '{url.database}', expected 'test_db'")
    if os.getenv('TEST_ENV') != 'true':
        raise RuntimeError('Destructive tests require TEST_ENV=true')

def test_guard_rejects_production():
    os.environ['TEST_ENV'] = 'true'
    # 'test' in username, password, hostname, but database is 'postgres'
    prod_url = 'postgresql://testuser:testpass@test-prod-db:5432/postgres'
    with pytest.raises(RuntimeError, match="expected 'test_db'"):
        setup_database_guard(prod_url)

def test_guard_rejects_missing_env():
    if 'TEST_ENV' in os.environ:
        del os.environ['TEST_ENV']
    valid_url = 'postgresql://postgres:postgres@localhost:5432/test_db'
    with pytest.raises(RuntimeError, match="require TEST_ENV=true"):
        setup_database_guard(valid_url)

def test_guard_accepts_valid():
    os.environ['TEST_ENV'] = 'true'
    valid_url = 'postgresql://postgres:postgres@localhost:5432/test_db'
    setup_database_guard(valid_url)  # Should not raise
