# app/routes.py
from flask import Blueprint, request, jsonify
from . import auth

auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json(silent=True) or {}
    result = auth.register(data.get('username', ''), data.get('password', ''))
    return jsonify(result), 201 if result['success'] else 400


@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json(silent=True) or {}
    result = auth.login(data.get('username', ''), data.get('password', ''))
    return jsonify(result), 200 if result['success'] else 401


@auth_bp.route('/change-password', methods=['POST'])
def change_password():
    data = request.get_json(silent=True) or {}
    result = auth.change_password(
        data.get('username', ''),
        data.get('old_password', ''),
        data.get('new_password', '')
    )
    return jsonify(result), 200 if result['success'] else 400