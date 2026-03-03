@echo off
echo ==========================================
echo Creating Flask Project Structure...
echo ==========================================

REM === Root folders ===
mkdir app
mkdir tests
mkdir .github
mkdir .github\workflows

REM === APP FILES ===
echo # Flask app factory > app\__init__.py
echo from flask import Flask >> app\__init__.py
echo. >> app\__init__.py
echo def create_app(): >> app\__init__.py
echo     app = Flask(__name__) >> app\__init__.py
echo     from .routes import bp >> app\__init__.py
echo     app.register_blueprint(bp) >> app\__init__.py
echo     return app >> app\__init__.py

echo # Authentication business logic > app\auth.py
echo def authenticate(username, password): >> app\auth.py
echo     return username == "admin" and password == "admin" >> app\auth.py

echo # HTTP Routes Blueprint > app\routes.py
echo from flask import Blueprint, jsonify >> app\routes.py
echo. >> app\routes.py
echo bp = Blueprint("main", __name__) >> app\routes.py
echo. >> app\routes.py
echo @bp.route("/health") >> app\routes.py
echo def health(): >> app\routes.py
echo     return jsonify({"status": "ok"}) >> app\routes.py

REM === TESTS FILES ===
echo # Tests package > tests\__init__.py

echo import pytest > tests\conftest.py
echo from app import create_app >> tests\conftest.py
echo. >> tests\conftest.py
echo @pytest.fixture >> tests\conftest.py
echo def app(): >> tests\conftest.py
echo     app = create_app() >> tests\conftest.py
echo     app.config.update({"TESTING": True}) >> tests\conftest.py
echo     yield app >> tests\conftest.py

echo from app.auth import authenticate > tests\test_auth.py
echo. >> tests\test_auth.py
echo def test_auth_success(): >> tests\test_auth.py
echo     assert authenticate("admin", "admin") >> tests\test_auth.py

echo def test_auth_fail(): >> tests\test_auth.py
echo     assert not authenticate("user", "1234") >> tests\test_auth.py

echo def test_health_route(client): > tests\test_routes.py
echo     response = client.get("/health") >> tests\test_routes.py
echo     assert response.status_code == 200 >> tests\test_routes.py

REM === GITHUB CI FILE ===
echo name: CI > .github\workflows\ci.yml
echo on: [push, pull_request] >> .github\workflows\ci.yml
echo jobs: >> .github\workflows\ci.yml
echo   build: >> .github\workflows\ci.yml
echo     runs-on: ubuntu-latest >> .github\workflows\ci.yml
echo     steps: >> .github\workflows\ci.yml
echo       - uses: actions/checkout@v3 >> .github\workflows\ci.yml
echo       - uses: actions/setup-python@v4 >> .github\workflows\ci.yml
echo         with: >> .github\workflows\ci.yml
echo           python-version: '3.11' >> .github\workflows\ci.yml
echo       - run: pip install -r requirements.txt >> .github\workflows\ci.yml
echo       - run: pytest >> .github\workflows\ci.yml

REM === ROOT FILES ===
echo Flask > requirements.txt
echo pytest >> requirements.txt

echo [pytest] > pytest.ini
echo testpaths = tests >> pytest.ini

echo [flake8] > setup.cfg
echo max-line-length = 88 >> setup.cfg

echo sonar.projectKey=flask_project > sonar-project.properties
echo sonar.sources=app >> sonar-project.properties
echo sonar.tests=tests >> sonar-project.properties

echo ==========================================
echo Project structure created successfully!
echo ==========================================

pause