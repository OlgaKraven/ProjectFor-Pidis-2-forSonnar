# tests/conftest.py
import pytest
from app import create_app
from app import auth


@pytest.fixture(autouse=True)
def clean_users():
    """Очищает хранилище перед каждым тестом."""
    auth.clear_users()
    yield
    auth.clear_users()


@pytest.fixture
def client():
    app = create_app(testing=True)
    return app.test_client()


@pytest.fixture
def registered_user():
    auth.register('testuser', 'password123')
    return {'username': 'testuser', 'password': 'password123'}