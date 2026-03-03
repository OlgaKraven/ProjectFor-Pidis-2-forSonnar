# app/__init__.py
from flask import Flask
from .routes import auth_bp


def create_app(testing: bool = False) -> Flask:
    app = Flask(__name__)
    app.config['TESTING'] = testing
    app.config['SECRET_KEY'] = 'dev-secret-key'
    app.register_blueprint(auth_bp, url_prefix='/api')
    return app