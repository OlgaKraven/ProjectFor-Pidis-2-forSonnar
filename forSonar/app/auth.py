# app/auth.py
"""Бизнес-логика аутентификации пользователей."""
import hashlib
import re

# Хранилище: {username: hashed_password}
_users: dict[str, str] = {}


def _hash(password: str) -> str:
    return hashlib.sha256(password.encode()).hexdigest()


def _valid_username(username: str) -> bool:
    return bool(re.match(r'^[a-zA-Z0-9_]{3,20}$', username))


def _valid_password(password: str) -> bool:
    return len(password) >= 6


def register(username: str, password: str) -> dict:
    if not username or not password:
        return {'success': False, 'message': 'Логин и пароль обязательны'}
    if not _valid_username(username):
        return {'success': False, 'message': 'Логин: 3–20 символов, буквы/цифры/подчёркивание'}
    if not _valid_password(password):
        return {'success': False, 'message': 'Пароль: минимум 6 символов'}
    if username in _users:
        return {'success': False, 'message': 'Пользователь уже существует'}
    _users[username] = _hash(password)
    return {'success': True, 'message': 'Регистрация успешна'}


def login(username: str, password: str) -> dict:
    if username not in _users or _users[username] != _hash(password):
        return {'success': False, 'message': 'Неверный логин или пароль'}
    return {'success': True, 'message': f'Добро пожаловать, {username}!'}


def change_password(username: str, old_password: str, new_password: str) -> dict:
    if username not in _users:
        return {'success': False, 'message': 'Пользователь не найден'}
    if _users[username] != _hash(old_password):
        return {'success': False, 'message': 'Неверный текущий пароль'}
    if not _valid_password(new_password):
        return {'success': False, 'message': 'Пароль: минимум 6 символов'}
    if old_password == new_password:
        return {'success': False, 'message': 'Новый пароль совпадает со старым'}
    _users[username] = _hash(new_password)
    return {'success': True, 'message': 'Пароль успешно изменён'}


def clear_users() -> None:
    """Используется только в тестах."""
    _users.clear()