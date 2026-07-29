"""Tests for /api/v1/notifications/* endpoints."""


class TestListNotifications:
    URL = "/api/v1/notifications/"

    def test_returns_200(self, client, auth):
        r = client.get(self.URL, headers=auth)
        assert r.status_code == 200

    def test_returns_pagination_meta_with_unread_count(self, client, auth):
        r = client.get(self.URL, headers=auth)
        meta = r.get_json()["meta"]
        assert "unread_count" in meta
        assert "total" in meta

    def test_returns_list_data(self, client, auth):
        r = client.get(self.URL, headers=auth)
        assert isinstance(r.get_json()["data"], list)

    def test_requires_auth(self, client):
        r = client.get(self.URL)
        assert r.status_code == 401


class TestMarkRead:
    def test_mark_nonexistent_returns_404(self, client, auth):
        r = client.patch("/api/v1/notifications/fake-notif-id/read", headers=auth)
        assert r.status_code == 404

    def test_mark_all_read_returns_200(self, client, auth):
        r = client.post("/api/v1/notifications/read-all", headers=auth)
        assert r.status_code == 200


class TestPreferences:
    URL = "/api/v1/notifications/preferences"

    def test_get_preferences_returns_200(self, client, auth):
        r = client.get(self.URL, headers=auth)
        assert r.status_code == 200
        data = r.get_json()["data"]
        for key in ("identification_complete", "new_species_nearby",
                    "admin_verification", "educational_alerts", "events"):
            assert key in data

    def test_update_preferences(self, client, auth):
        r = client.put(self.URL, json={
            "identification_complete": False,
            "events": True,
            "new_species_nearby": False,
        }, headers=auth)
        assert r.status_code == 200
        data = r.get_json()["data"]
        assert data["identification_complete"] is False
        assert data["events"] is True
        assert data["new_species_nearby"] is False

    def test_update_preferences_persists(self, client, auth):
        client.put(self.URL, json={"admin_verification": False}, headers=auth)
        r = client.get(self.URL, headers=auth)
        assert r.get_json()["data"]["admin_verification"] is False

    def test_invalid_preference_value_returns_422(self, client, auth):
        r = client.put(self.URL, json={"identification_complete": "yes_please"}, headers=auth)
        assert r.status_code == 422

    def test_preferences_require_auth(self, client):
        r = client.get(self.URL)
        assert r.status_code == 401
