# tests/test_auth.py
from app.auth import register, login, change_password


class TestRegister:
    def test_success(self):
        result = register('alice', 'secret123')
        assert result['success'] is True

    def test_duplicate(self):
        register('alice', 'secret123')
        result = register('alice', 'other123')
        assert result['success'] is False
        assert 'уже существует' in result['message']

    def test_short_password(self):
        result = register('bob', '123')
        assert result['success'] is False

    def test_invalid_username(self):
        result = register('bad user!', 'password123')
        assert result['success'] is False

    def test_empty_fields(self):
        result = register('', '')
        assert result['success'] is False


class TestLogin:
    def test_success(self, registered_user):
        result = login(registered_user['username'], registered_user['password'])
        assert result['success'] is True

    def test_wrong_password(self, registered_user):
        result = login(registered_user['username'], 'wrongpass')
        assert result['success'] is False

    def test_unknown_user(self):
        result = login('ghost', 'password123')
        assert result['success'] is False


class TestChangePassword:
    def test_success(self, registered_user):
        result = change_password(
            registered_user['username'],
            registered_user['password'],
            'newpass456'
        )
        assert result['success'] is True
        # Проверяем, что новый пароль работает
        assert login(registered_user['username'], 'newpass456')['success'] is True

    def test_wrong_old_password(self, registered_user):
        result = change_password(registered_user['username'], 'wrongold', 'newpass456')
        assert result['success'] is False

    def test_same_password(self, registered_user):
        result = change_password(
            registered_user['username'],
            registered_user['password'],
            registered_user['password']
        )
        assert result['success'] is False
        assert 'совпадает' in result['message']

    def test_unknown_user(self):
        result = change_password('ghost', 'old123', 'new123456')
        assert result['success'] is False