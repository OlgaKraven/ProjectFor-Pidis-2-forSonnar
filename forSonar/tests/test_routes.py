# tests/test_routes.py

class TestRegisterRoute:
    def test_returns_201(self, client):
        r = client.post('/api/register', json={'username': 'alice', 'password': 'secret123'})
        assert r.status_code == 201

    def test_duplicate_returns_400(self, client):
        client.post('/api/register', json={'username': 'alice', 'password': 'secret123'})
        r = client.post('/api/register', json={'username': 'alice', 'password': 'secret123'})
        assert r.status_code == 400

    def test_invalid_returns_400(self, client):
        r = client.post('/api/register', json={'username': 'a', 'password': '12'})
        assert r.status_code == 400


class TestLoginRoute:
    def test_success_returns_200(self, client):
        client.post('/api/register', json={'username': 'bob', 'password': 'mypassword'})
        r = client.post('/api/login', json={'username': 'bob', 'password': 'mypassword'})
        assert r.status_code == 200

    def test_wrong_password_returns_401(self, client):
        client.post('/api/register', json={'username': 'bob', 'password': 'mypassword'})
        r = client.post('/api/login', json={'username': 'bob', 'password': 'wrong!'})
        assert r.status_code == 401


class TestChangePasswordRoute:
    def test_success_returns_200(self, client):
        client.post('/api/register', json={'username': 'carol', 'password': 'oldpass123'})
        r = client.post('/api/change-password', json={
            'username': 'carol',
            'old_password': 'oldpass123',
            'new_password': 'newpass456'
        })
        assert r.status_code == 200

    def test_wrong_old_returns_400(self, client):
        client.post('/api/register', json={'username': 'carol', 'password': 'oldpass123'})
        r = client.post('/api/change-password', json={
            'username': 'carol',
            'old_password': 'WRONG',
            'new_password': 'newpass456'
        })
        assert r.status_code == 400