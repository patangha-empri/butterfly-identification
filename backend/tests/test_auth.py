"""Tests for /api/v1/auth/* endpoints."""
import uuid
import pytest


class TestRegister:
    URL = "/api/v1/auth/register"

    def _payload(self, **overrides):
        uid = uuid.uuid4().hex[:8]
        base = {
            "email": f"reg_{uid}@test.invalid",
            "password": "Valid@Pass1",
            "full_name": "Test Reg User",
            "username": f"reguser_{uid}",
        }
        return {**base, **overrides}

    def test_register_success(self, client):
        r = client.post(self.URL, json=self._payload())
        assert r.status_code == 201
        data = r.get_json()
        assert data["success"] is True
        assert "access_token" in data["data"]
        assert "refresh_token" in data["data"]
        assert "id" in data["data"]["user"]
        assert data["data"]["user"]["role"] == "user"

    def test_register_initializes_stats_and_streak(self, client, app):
        uid = uuid.uuid4().hex[:8]
        payload = self._payload(email=f"stats_{uid}@test.invalid", username=f"stats_{uid}")
        r = client.post(self.URL, json=payload)
        assert r.status_code == 201
        user_id = r.get_json()["data"]["user"]["id"]
        with app.app_context():
            from app.models.achievement import UserStats, UserStreak
            from app.models.notification import NotificationPreference
            assert UserStats.query.filter_by(user_id=user_id).first() is not None
            assert UserStreak.query.filter_by(user_id=user_id).first() is not None
            assert NotificationPreference.query.filter_by(user_id=user_id).first() is not None

    def test_register_duplicate_email_returns_409(self, client, regular_user_creds, regular_token):
        uid = uuid.uuid4().hex[:8]
        r = client.post(self.URL, json=self._payload(
            email=regular_user_creds["email"],
            username=f"unique_{uid}",
        ))
        assert r.status_code == 409
        assert r.get_json()["success"] is False

    def test_register_duplicate_username_returns_409(self, client, regular_user_creds, regular_token):
        uid = uuid.uuid4().hex[:8]
        r = client.post(self.URL, json=self._payload(
            email=f"unique_{uid}@test.invalid",
            username=regular_user_creds["username"],
        ))
        assert r.status_code == 409

    def test_register_invalid_email_returns_422(self, client):
        r = client.post(self.URL, json=self._payload(email="not-an-email"))
        assert r.status_code == 422
        assert "email" in r.get_json()["errors"]

    def test_register_short_password_returns_422(self, client):
        r = client.post(self.URL, json=self._payload(password="short"))
        assert r.status_code == 422
        assert "password" in r.get_json()["errors"]

    def test_register_short_username_returns_422(self, client):
        r = client.post(self.URL, json=self._payload(username="ab"))
        assert r.status_code == 422

    def test_register_invalid_username_chars_returns_422(self, client):
        r = client.post(self.URL, json=self._payload(username="user name!"))
        assert r.status_code == 422

    def test_register_missing_required_fields(self, client):
        r = client.post(self.URL, json={"email": "x@x.com"})
        assert r.status_code == 422


class TestLogin:
    URL = "/api/v1/auth/login"

    def test_login_success_returns_tokens(self, client, regular_user_creds, regular_token):
        r = client.post(self.URL, json={
            "email": regular_user_creds["email"],
            "password": regular_user_creds["password"],
        })
        assert r.status_code == 200
        data = r.get_json()["data"]
        assert "access_token" in data
        assert "refresh_token" in data
        assert data["user"]["email"] == regular_user_creds["email"]

    def test_login_wrong_password_returns_401(self, client, regular_user_creds, regular_token):
        r = client.post(self.URL, json={
            "email": regular_user_creds["email"],
            "password": "WrongPassword!",
        })
        assert r.status_code == 401

    def test_login_unknown_email_returns_401(self, client):
        r = client.post(self.URL, json={
            "email": "nobody@nowhere.invalid",
            "password": "Whatever1!",
        })
        assert r.status_code == 401

    def test_login_missing_fields_returns_422(self, client):
        r = client.post(self.URL, json={"email": "x@x.com"})
        assert r.status_code == 422


class TestProtectedEndpoints:
    def test_me_without_token_returns_401(self, client):
        r = client.get("/api/v1/auth/me")
        assert r.status_code == 401

    def test_me_with_token_returns_user(self, client, auth):
        r = client.get("/api/v1/auth/me", headers=auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["email"] is not None

    def test_refresh_with_refresh_token(self, client, regular_user_creds):
        login = client.post("/api/v1/auth/login", json={
            "email": regular_user_creds["email"],
            "password": regular_user_creds["password"],
        })
        refresh_token = login.get_json()["data"]["refresh_token"]
        r = client.post("/api/v1/auth/refresh",
                        headers={"Authorization": f"Bearer {refresh_token}"})
        assert r.status_code == 200
        assert "access_token" in r.get_json()["data"]

    def test_refresh_with_access_token_fails(self, client, auth):
        r = client.post("/api/v1/auth/refresh", headers=auth)
        assert r.status_code == 422  # wrong token type

    def test_logout_returns_200(self, client, auth):
        r = client.post("/api/v1/auth/logout", headers=auth)
        assert r.status_code == 200

    def test_change_password_wrong_current(self, client, auth):
        r = client.post("/api/v1/auth/change-password", json={
            "current_password": "WrongCurrent!",
            "new_password": "NewValid@123",
        }, headers=auth)
        assert r.status_code == 400

    def test_change_password_too_short_new(self, client, auth):
        r = client.post("/api/v1/auth/change-password", json={
            "current_password": "Test@Pass123",
            "new_password": "short",
        }, headers=auth)
        assert r.status_code == 422
