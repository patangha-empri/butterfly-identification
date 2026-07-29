"""Tests for /api/v1/users/* endpoints."""
import uuid


class TestMyProfile:
    def test_get_my_profile_returns_200(self, client, auth):
        r = client.get("/api/v1/users/me", headers=auth)
        assert r.status_code == 200
        data = r.get_json()["data"]
        assert "email" in data         # private field visible to owner
        assert "username" in data

    def test_get_my_profile_without_auth_returns_401(self, client):
        r = client.get("/api/v1/users/me")
        assert r.status_code == 401

    def test_update_profile_bio(self, client, auth):
        new_bio = f"Updated bio {uuid.uuid4().hex[:6]}"
        r = client.put("/api/v1/users/me", json={"bio": new_bio}, headers=auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["bio"] == new_bio

    def test_update_profile_full_name(self, client, auth):
        r = client.put("/api/v1/users/me", json={"full_name": "Updated Name"}, headers=auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["full_name"] == "Updated Name"

    def test_update_username_to_duplicate_returns_409(self, client, auth):
        # "admin" username from the seeded admin account
        r = client.put("/api/v1/users/me", json={"username": "admin"}, headers=auth)
        assert r.status_code == 409

    def test_update_username_invalid_chars_returns_422(self, client, auth):
        r = client.put("/api/v1/users/me", json={"username": "user name!"}, headers=auth)
        assert r.status_code == 422


class TestMyStats:
    def test_stats_returns_200(self, client, auth):
        r = client.get("/api/v1/users/me/stats", headers=auth)
        assert r.status_code == 200
        data = r.get_json()["data"]
        assert "stats" in data
        assert "streak" in data

    def test_stats_has_expected_keys(self, client, auth):
        r = client.get("/api/v1/users/me/stats", headers=auth)
        stats = r.get_json()["data"]["stats"]
        for key in ("total_observations", "total_identifications",
                    "total_species_observed", "total_states_explored", "total_points"):
            assert key in stats

    def test_achievements_returns_list(self, client, auth):
        r = client.get("/api/v1/users/me/achievements", headers=auth)
        assert r.status_code == 200
        assert isinstance(r.get_json()["data"], list)


class TestPublicProfile:
    def test_get_public_profile_by_username(self, client, auth, regular_user_creds):
        username = regular_user_creds["username"]
        r = client.get(f"/api/v1/users/{username}", headers=auth)
        assert r.status_code == 200
        data = r.get_json()["data"]
        assert data["username"] == username
        assert "email" not in data   # email hidden on public profile

    def test_nonexistent_username_returns_404(self, client, auth):
        r = client.get("/api/v1/users/totally_nonexistent_xyz", headers=auth)
        assert r.status_code == 404


class TestFCMToken:
    def test_register_fcm_token(self, client, auth):
        fake_token = "fcm_" + uuid.uuid4().hex * 2  # realistic length
        r = client.post("/api/v1/users/me/fcm-token",
                        json={"fcm_token": fake_token}, headers=auth)
        assert r.status_code == 200

    def test_register_fcm_token_too_short_returns_422(self, client, auth):
        r = client.post("/api/v1/users/me/fcm-token",
                        json={"fcm_token": "short"}, headers=auth)
        assert r.status_code == 422
