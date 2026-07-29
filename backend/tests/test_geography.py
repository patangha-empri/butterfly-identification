"""Tests for /api/v1/geography/* — public, no auth required."""


class TestStates:
    URL = "/api/v1/geography/states"

    def test_returns_200(self, client):
        r = client.get(self.URL)
        assert r.status_code == 200

    def test_returns_36_states(self, client):
        r = client.get(self.URL)
        data = r.get_json()["data"]
        assert len(data) == 36, f"Expected 36 states/UTs, got {len(data)}"

    def test_state_has_required_fields(self, client):
        r = client.get(self.URL)
        state = r.get_json()["data"][0]
        for field in ("id", "name", "code", "region", "is_union_territory"):
            assert field in state, f"Missing field: {field}"

    def test_states_sorted_alphabetically(self, client):
        r = client.get(self.URL)
        names = [s["name"] for s in r.get_json()["data"]]
        assert names == sorted(names)

    def test_no_auth_required(self, client):
        # Explicitly no Authorization header
        r = client.get(self.URL)
        assert r.status_code == 200


class TestDistricts:
    def test_returns_districts_for_valid_state(self, client):
        r = client.get("/api/v1/geography/states/1/districts")
        assert r.status_code == 200
        data = r.get_json()["data"]
        assert len(data) > 0

    def test_district_has_required_fields(self, client):
        r = client.get("/api/v1/geography/states/1/districts")
        d = r.get_json()["data"][0]
        for field in ("id", "name"):
            assert field in d

    def test_invalid_state_returns_404(self, client):
        r = client.get("/api/v1/geography/states/99999/districts")
        assert r.status_code == 404

    def test_different_states_return_different_districts(self, client):
        r1 = client.get("/api/v1/geography/states/1/districts")
        r2 = client.get("/api/v1/geography/states/2/districts")
        names1 = {d["name"] for d in r1.get_json()["data"]}
        names2 = {d["name"] for d in r2.get_json()["data"]}
        assert names1 != names2
