"""Tests for /api/v1/observations/* endpoints."""
import uuid


VALID_OBS = {
    "state_id": 1,
    "latitude": 12.97,
    "longitude": 77.59,
    "location_name": "Bangalore, Karnataka",
    "privacy": "public",
    "title": "Blue Mormon spotted",
    "notes": "Feeding on Ixora flowers near the pond.",
    "weather": "sunny",
    "butterfly_activity": "feeding",
    "count_observed": 2,
}


class TestCreateObservation:
    URL = "/api/v1/observations/"

    def test_create_returns_201(self, client, auth):
        r = client.post(self.URL, json=VALID_OBS, headers=auth)
        assert r.status_code == 201
        data = r.get_json()["data"]
        assert "id" in data

    def test_create_without_auth_returns_401(self, client):
        r = client.post(self.URL, json=VALID_OBS)
        assert r.status_code == 401

    def test_create_missing_state_id_returns_422(self, client, auth):
        payload = {k: v for k, v in VALID_OBS.items() if k != "state_id"}
        r = client.post(self.URL, json=payload, headers=auth)
        assert r.status_code == 422

    def test_create_missing_lat_lon_succeeds(self, client, auth):
        payload = {k: v for k, v in VALID_OBS.items() if k not in ("latitude", "longitude")}
        r = client.post(self.URL, json=payload, headers=auth)
        assert r.status_code == 201
        data = r.get_json()["data"]
        assert data["latitude"] is None
        assert data["longitude"] is None

    def test_create_latitude_out_of_india_bounds_returns_422(self, client, auth):
        r = client.post(self.URL, json={**VALID_OBS, "latitude": 50.0}, headers=auth)
        assert r.status_code == 422

    def test_create_invalid_weather_value_returns_422(self, client, auth):
        r = client.post(self.URL, json={**VALID_OBS, "weather": "hailstorm"}, headers=auth)
        assert r.status_code == 422

    def test_create_updates_user_stats(self, client, auth, app, regular_user_creds):
        with app.app_context():
            from app.models.user import User
            from app.models.achievement import UserStats
            user = User.query.filter_by(email=regular_user_creds["email"]).first()
            before = UserStats.query.filter_by(user_id=user.id).first().total_observations

        client.post(self.URL, json=VALID_OBS, headers=auth)

        with app.app_context():
            user = User.query.filter_by(email=regular_user_creds["email"]).first()
            after = UserStats.query.filter_by(user_id=user.id).first().total_observations

        assert after == before + 1


class TestGetObservation:
    def test_get_own_observation(self, client, auth, sample_observation):
        obs_id = sample_observation["id"]
        r = client.get(f"/api/v1/observations/{obs_id}", headers=auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["id"] == obs_id

    def test_get_nonexistent_returns_404(self, client, auth):
        r = client.get("/api/v1/observations/nonexistent-id-xyz", headers=auth)
        assert r.status_code == 404

    def test_response_has_images_list(self, client, auth, sample_observation):
        obs_id = sample_observation["id"]
        r = client.get(f"/api/v1/observations/{obs_id}", headers=auth)
        assert "images" in r.get_json()["data"]


class TestListObservations:
    def test_list_my_observations_returns_200(self, client, auth, make_observation):
        make_observation()  # ensure at least one exists
        r = client.get("/api/v1/observations/", headers=auth)
        assert r.status_code == 200
        meta = r.get_json()["meta"]
        assert meta["total"] >= 1

    def test_pagination_meta_present(self, client, auth):
        r = client.get("/api/v1/observations/?per_page=5", headers=auth)
        meta = r.get_json()["meta"]
        assert "total" in meta and "has_next" in meta and "total_pages" in meta

    def test_public_feed_no_auth_required(self, client, make_observation):
        make_observation(privacy="public")
        r = client.get("/api/v1/observations/feed")
        assert r.status_code == 200
        assert r.get_json()["meta"]["total"] >= 1

    def test_public_feed_hides_private(self, client, auth, make_observation):
        make_observation(privacy="private")
        r = client.get("/api/v1/observations/feed")
        pub_ids = {obs["id"] for obs in r.get_json()["data"]}
        # private obs should not appear in public feed
        # (we can't easily know the ID here, just check no privacy=private in results)
        for obs in r.get_json()["data"]:
            assert obs.get("privacy") != "private"


class TestUpdateObservation:
    def test_update_notes(self, client, auth, sample_observation):
        obs_id = sample_observation["id"]
        new_notes = f"Updated notes {uuid.uuid4().hex[:6]}"
        r = client.put(f"/api/v1/observations/{obs_id}", json={"notes": new_notes}, headers=auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["notes"] == new_notes

    def test_update_other_users_observation_returns_403(self, client, sample_observation):
        # sample_observation belongs to regular user; create a second user and try to edit it
        obs_id = sample_observation["id"]
        uid = uuid.uuid4().hex[:8]
        reg = client.post("/api/v1/auth/register", json={
            "email": f"other_{uid}@test.invalid",
            "password": "Other@Pass1",
            "full_name": "Other User",
            "username": f"other_{uid}",
        })
        assert reg.status_code == 201
        login = client.post("/api/v1/auth/login", json={
            "email": f"other_{uid}@test.invalid",
            "password": "Other@Pass1",
        })
        assert login.status_code == 200
        other_token = login.get_json()["data"]["access_token"]
        r = client.put(f"/api/v1/observations/{obs_id}", json={"notes": "Hijack"},
                       headers={"Authorization": f"Bearer {other_token}"})
        assert r.status_code == 403


class TestPrivacyAndSharing:
    def test_update_privacy(self, client, auth, make_observation):
        obs = make_observation(privacy="public")
        obs_id = obs["id"]
        r = client.patch(f"/api/v1/observations/{obs_id}/privacy",
                         json={"privacy": "private"}, headers=auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["privacy"] == "private"

    def test_invalid_privacy_value_returns_422(self, client, auth, sample_observation):
        obs_id = sample_observation["id"]
        r = client.patch(f"/api/v1/observations/{obs_id}/privacy",
                         json={"privacy": "secret"}, headers=auth)
        assert r.status_code == 422

    def test_create_and_retrieve_share_link(self, client, auth, sample_observation):
        obs_id = sample_observation["id"]
        # Create share link
        r = client.post(f"/api/v1/observations/{obs_id}/share", headers=auth)
        assert r.status_code == 200
        share_token = r.get_json()["data"]["share_token"]
        assert len(share_token) > 10

        # Retrieve via share token (no auth)
        r2 = client.get(f"/api/v1/observations/shared/{share_token}")
        assert r2.status_code == 200
        assert r2.get_json()["data"]["id"] == obs_id

    def test_idempotent_share_link(self, client, auth, sample_observation):
        obs_id = sample_observation["id"]
        r1 = client.post(f"/api/v1/observations/{obs_id}/share", headers=auth)
        r2 = client.post(f"/api/v1/observations/{obs_id}/share", headers=auth)
        assert r1.get_json()["data"]["share_token"] == r2.get_json()["data"]["share_token"]

    def test_invalid_share_token_returns_404(self, client):
        r = client.get("/api/v1/observations/shared/completely-fake-token-xyz")
        assert r.status_code == 404


class TestDeleteObservation:
    def test_delete_own_observation(self, client, auth, make_observation):
        obs = make_observation()
        obs_id = obs["id"]
        r = client.delete(f"/api/v1/observations/{obs_id}", headers=auth)
        assert r.status_code == 200
        # Confirm it's gone
        r2 = client.get(f"/api/v1/observations/{obs_id}", headers=auth)
        assert r2.status_code == 404

    def test_delete_nonexistent_returns_404(self, client, auth):
        r = client.delete("/api/v1/observations/fake-id-does-not-exist", headers=auth)
        assert r.status_code == 404
