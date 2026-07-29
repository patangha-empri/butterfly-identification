"""Tests for all /api/v1/admin/* endpoints."""
import uuid


class TestAdminDashboard:
    URL = "/api/v1/admin/dashboard/stats"

    def test_returns_200_for_admin(self, client, admin_auth):
        r = client.get(self.URL, headers=admin_auth)
        assert r.status_code == 200

    def test_has_expected_keys(self, client, admin_auth):
        r = client.get(self.URL, headers=admin_auth)
        data = r.get_json()["data"]
        for key in ("total_users", "total_observations", "total_species",
                    "pending_observations", "new_users_30d"):
            assert key in data

    def test_regular_user_gets_403(self, client, auth):
        r = client.get(self.URL, headers=auth)
        assert r.status_code == 403

    def test_unauthenticated_gets_401(self, client):
        r = client.get(self.URL)
        assert r.status_code == 401

    def test_species_count_matches_seed(self, client, admin_auth):
        r = client.get(self.URL, headers=admin_auth)
        assert r.get_json()["data"]["total_species"] == 60


class TestAdminUsers:
    URL = "/api/v1/admin/users/"

    def test_list_users_returns_200(self, client, admin_auth):
        r = client.get(self.URL, headers=admin_auth)
        assert r.status_code == 200
        assert r.get_json()["meta"]["total"] >= 1

    def test_list_users_search_filter(self, client, admin_auth, regular_user_creds):
        username = regular_user_creds["username"]
        r = client.get(f"{self.URL}?search={username}", headers=admin_auth)
        assert r.status_code == 200
        names = [u["username"] for u in r.get_json()["data"]]
        assert username in names

    def test_get_user_by_id(self, client, admin_auth, app, regular_user_creds):
        with app.app_context():
            from app.models.user import User
            user = User.query.filter_by(email=regular_user_creds["email"]).first()
            user_id = user.id
        r = client.get(f"{self.URL}{user_id}", headers=admin_auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["email"] == regular_user_creds["email"]

    def test_get_nonexistent_user_returns_404(self, client, admin_auth):
        r = client.get(f"{self.URL}fake-id-does-not-exist", headers=admin_auth)
        assert r.status_code == 404

    def test_regular_user_cannot_list_users(self, client, auth):
        r = client.get(self.URL, headers=auth)
        assert r.status_code == 403

    def test_verify_user(self, client, admin_auth, app, regular_user_creds):
        with app.app_context():
            from app.models.user import User
            user = User.query.filter_by(email=regular_user_creds["email"]).first()
            user_id = user.id
        r = client.patch(f"{self.URL}{user_id}/verify", headers=admin_auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["is_verified"] is True

    def test_change_role_to_moderator(self, client, admin_auth, app):
        # Create a temp user to change role
        uid = uuid.uuid4().hex[:8]
        client.post("/api/v1/auth/register", json={
            "email": f"role_{uid}@test.invalid",
            "password": "Role@Pass123",
            "full_name": "Role Test",
            "username": f"role_{uid}",
        })
        with app.app_context():
            from app.models.user import User
            user = User.query.filter_by(email=f"role_{uid}@test.invalid").first()
            user_id = user.id

        r = client.patch(f"{self.URL}{user_id}/role",
                         json={"role": "moderator"}, headers=admin_auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["role"] == "moderator"

    def test_change_role_invalid_value_returns_422(self, client, admin_auth, app, regular_user_creds):
        with app.app_context():
            from app.models.user import User
            user = User.query.filter_by(email=regular_user_creds["email"]).first()
            user_id = user.id
        r = client.patch(f"{self.URL}{user_id}/role",
                         json={"role": "superduper"}, headers=admin_auth)
        assert r.status_code == 422

    def test_suspend_and_unsuspend_user(self, client, admin_auth, app):
        uid = uuid.uuid4().hex[:8]
        client.post("/api/v1/auth/register", json={
            "email": f"susp_{uid}@test.invalid",
            "password": "Susp@Pass123",
            "full_name": "Suspend Test",
            "username": f"susp_{uid}",
        })
        with app.app_context():
            from app.models.user import User
            user = User.query.filter_by(email=f"susp_{uid}@test.invalid").first()
            user_id = user.id

        # Suspend
        r = client.patch(f"{self.URL}{user_id}/suspend",
                         json={"suspend": True, "reason": "Test suspension"},
                         headers=admin_auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["is_suspended"] is True

        # Unsuspend
        r = client.patch(f"{self.URL}{user_id}/suspend",
                         json={"suspend": False}, headers=admin_auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["is_suspended"] is False

    def test_suspended_user_cannot_login(self, client, admin_auth, app):
        uid = uuid.uuid4().hex[:8]
        email = f"susplogin_{uid}@test.invalid"
        client.post("/api/v1/auth/register", json={
            "email": email,
            "password": "Susp@Pass123",
            "full_name": "Suspend Login Test",
            "username": f"susplogin_{uid}",
        })
        with app.app_context():
            from app.models.user import User
            user = User.query.filter_by(email=email).first()
            user_id = user.id
        client.patch(f"{self.URL}{user_id}/suspend",
                     json={"suspend": True, "reason": "Test"}, headers=admin_auth)
        r = client.post("/api/v1/auth/login", json={"email": email, "password": "Susp@Pass123"})
        assert r.status_code == 403


class TestAdminObservations:
    URL = "/api/v1/admin/observations/"

    def test_list_observations_returns_200(self, client, admin_auth):
        r = client.get(self.URL, headers=admin_auth)
        assert r.status_code == 200

    def test_filter_by_verification_status(self, client, admin_auth):
        r = client.get(f"{self.URL}?verification_status=pending", headers=admin_auth)
        assert r.status_code == 200
        for obs in r.get_json()["data"]:
            assert obs["verification_status"] == "pending"

    def test_regular_user_cannot_access(self, client, auth):
        r = client.get(self.URL, headers=auth)
        assert r.status_code == 403

    def test_verify_observation(self, client, admin_auth, auth, make_observation):
        obs = make_observation(privacy="public")
        obs_id = obs["id"]
        r = client.patch(f"{self.URL}{obs_id}/verify",
                         json={"admin_notes": "Verified in test"},
                         headers=admin_auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["verification_status"] == "expert_verified"

    def test_reject_observation(self, client, admin_auth, auth, make_observation):
        obs = make_observation()
        obs_id = obs["id"]
        r = client.patch(f"{self.URL}{obs_id}/reject",
                         json={"admin_notes": "Rejected in test — blurry photo"},
                         headers=admin_auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["verification_status"] == "rejected"

    def test_reject_without_notes_returns_422(self, client, admin_auth, make_observation):
        obs = make_observation()
        r = client.patch(f"{self.URL}{obs['id']}/reject",
                         json={"admin_notes": "Hi"},   # too short (< 5 chars)
                         headers=admin_auth)
        assert r.status_code == 422


class TestAdminSpecies:
    URL = "/api/v1/admin/species/"

    def test_list_species_admin(self, client, admin_auth):
        r = client.get(self.URL, headers=admin_auth)
        assert r.status_code == 200
        assert r.get_json()["meta"]["total"] >= 60

    def test_create_species(self, client, admin_auth):
        uid = uuid.uuid4().hex[:8]
        payload = {
            "common_name": f"Test Butterfly {uid}",
            "scientific_name": f"Testus butterflicus {uid}",
            "family": "Testidae",
            "genus": "Testus",
            "description": "A test butterfly for pytest.",
            "conservation_status": "LC",
            "wing_span_min_mm": 40,
            "wing_span_max_mm": 60,
            "color_tags": ["blue", "white"],
        }
        r = client.post(self.URL, json=payload, headers=admin_auth)
        assert r.status_code == 201
        created_id = r.get_json()["data"]["id"]
        # cleanup
        client.delete(f"{self.URL}{created_id}", headers=admin_auth)

    def test_create_duplicate_scientific_name_returns_409(self, client, admin_auth):
        # Use an existing species scientific name from seed data
        existing = client.get("/api/v1/species/?per_page=1").get_json()["data"][0]
        r = client.post(self.URL, json={
            "common_name": "Duplicate Test",
            "scientific_name": existing["scientific_name"],
            "family": "Testidae",
            "genus": "Testus",
        }, headers=admin_auth)
        assert r.status_code == 409

    def test_update_species(self, client, admin_auth):
        # Pick a species to update
        sp_list = client.get("/api/v1/species/?per_page=1").get_json()["data"]
        sp_id = sp_list[0]["id"]
        r = client.put(f"{self.URL}{sp_id}",
                       json={"description": "Updated in pytest test."},
                       headers=admin_auth)
        assert r.status_code == 200
        assert "Updated in pytest test." in r.get_json()["data"]["description"]

    def test_regular_user_cannot_create_species(self, client, auth):
        r = client.post(self.URL, json={
            "common_name": "Hack", "scientific_name": "Hackus hacker",
            "family": "Hackidae", "genus": "Hackus",
        }, headers=auth)
        assert r.status_code == 403

    def test_add_host_plant(self, client, admin_auth):
        sp_id = client.get("/api/v1/species/?per_page=1").get_json()["data"][0]["id"]
        r = client.post(f"{self.URL}{sp_id}/host-plants", json={
            "plant_name": "Test Plant",
            "plant_scientific_name": "Plantus testicus",
        }, headers=admin_auth)
        assert r.status_code == 201
        plant_id = r.get_json()["data"]["id"]
        # cleanup
        client.delete(f"{self.URL}{sp_id}/host-plants/{plant_id}", headers=admin_auth)

    def test_add_distribution_state(self, client, admin_auth):
        sp_id = client.get("/api/v1/species/?per_page=1").get_json()["data"][0]["id"]
        r = client.post(f"{self.URL}{sp_id}/distribution", json={
            "state_id": 5,
            "abundance": "uncommon",
        }, headers=admin_auth)
        assert r.status_code == 200


class TestAdminReports:
    def test_observations_pdf_returns_pdf(self, client, admin_auth):
        r = client.get("/api/v1/admin/reports/observations/pdf", headers=admin_auth)
        assert r.status_code == 200
        assert r.content_type == "application/pdf"

    def test_observations_excel_returns_xlsx(self, client, admin_auth):
        r = client.get("/api/v1/admin/reports/observations/excel", headers=admin_auth)
        assert r.status_code == 200
        assert "spreadsheetml" in r.content_type

    def test_users_pdf_returns_pdf(self, client, admin_auth):
        r = client.get("/api/v1/admin/reports/users/pdf", headers=admin_auth)
        assert r.status_code == 200
        assert r.content_type == "application/pdf"

    def test_users_excel_returns_xlsx(self, client, admin_auth):
        r = client.get("/api/v1/admin/reports/users/excel", headers=admin_auth)
        assert r.status_code == 200
        assert "spreadsheetml" in r.content_type

    def test_species_pdf_returns_pdf(self, client, admin_auth):
        r = client.get("/api/v1/admin/reports/species/pdf", headers=admin_auth)
        assert r.status_code == 200
        assert r.content_type == "application/pdf"

    def test_species_excel_returns_xlsx(self, client, admin_auth):
        r = client.get("/api/v1/admin/reports/species/excel", headers=admin_auth)
        assert r.status_code == 200
        assert "spreadsheetml" in r.content_type

    def test_reports_require_moderator(self, client, auth):
        # A regular user (auth) should be forbidden
        r = client.get("/api/v1/admin/reports/observations/pdf", headers=auth)
        assert r.status_code == 403

    def test_reports_with_date_filter(self, client, admin_auth):
        r = client.get(
            "/api/v1/admin/reports/observations/excel?from_date=2024-01-01&to_date=2026-12-31",
            headers=admin_auth,
        )
        assert r.status_code == 200

        r2 = client.get(
            "/api/v1/admin/reports/users/excel?from_date=2024-01-01&to_date=2026-12-31",
            headers=admin_auth,
        )
        assert r2.status_code == 200

        r3 = client.get(
            "/api/v1/admin/reports/species/excel?from_date=2024-01-01&to_date=2026-12-31",
            headers=admin_auth,
        )
        assert r3.status_code == 200

