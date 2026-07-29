"""Tests for /api/v1/species/* — public listing with filters."""


class TestSpeciesList:
    URL = "/api/v1/species/"

    def test_list_returns_200(self, client):
        r = client.get(self.URL)
        assert r.status_code == 200

    def test_response_has_pagination_meta(self, client):
        r = client.get(self.URL)
        data = r.get_json()
        assert data["success"] is True
        for key in ("total", "page", "per_page", "total_pages", "has_next", "has_prev"):
            assert key in data["meta"]

    def test_returns_60_total_species(self, client):
        r = client.get(self.URL + "?per_page=100")
        assert r.get_json()["meta"]["total"] == 60

    def test_default_per_page_is_20(self, client):
        r = client.get(self.URL)
        assert len(r.get_json()["data"]) == 20

    def test_per_page_param_respected(self, client):
        r = client.get(self.URL + "?per_page=5")
        assert len(r.get_json()["data"]) == 5

    def test_page_2_has_different_items(self, client):
        r1 = client.get(self.URL + "?per_page=10&page=1")
        r2 = client.get(self.URL + "?per_page=10&page=2")
        ids1 = {s["id"] for s in r1.get_json()["data"]}
        ids2 = {s["id"] for s in r2.get_json()["data"]}
        assert ids1.isdisjoint(ids2)

    def test_filter_by_family(self, client):
        r = client.get(self.URL + "?family=Nymphalidae&per_page=100")
        data = r.get_json()["data"]
        assert len(data) > 0
        for sp in data:
            assert sp["family"] == "Nymphalidae"

    def test_filter_by_conservation_status(self, client):
        r = client.get(self.URL + "?conservation_status=VU&per_page=100")
        data = r.get_json()["data"]
        assert len(data) > 0
        for sp in data:
            assert sp["conservation_status"] == "VU"

    def test_search_by_common_name(self, client):
        r = client.get(self.URL + "?search=tiger")
        data = r.get_json()["data"]
        assert r.get_json()["meta"]["total"] > 0
        for sp in data:
            assert "tiger" in sp["common_name"].lower() or "tiger" in sp["scientific_name"].lower()

    def test_filter_by_state_id(self, client):
        r = client.get(self.URL + "?state_id=1&per_page=100")
        assert r.status_code == 200
        assert r.get_json()["meta"]["total"] > 0

    def test_species_has_required_fields(self, client):
        r = client.get(self.URL)
        sp = r.get_json()["data"][0]
        for field in ("id", "common_name", "scientific_name", "family", "genus",
                      "conservation_status", "slug"):
            assert field in sp

    def test_no_auth_required(self, client):
        r = client.get(self.URL)
        assert r.status_code == 200


class TestSpeciesDetail:
    def test_get_by_valid_slug(self, client):
        # First grab a slug from the list
        r_list = client.get("/api/v1/species/?per_page=1")
        slug = r_list.get_json()["data"][0]["slug"]
        r = client.get(f"/api/v1/species/{slug}")
        assert r.status_code == 200
        assert r.get_json()["data"]["slug"] == slug

    def test_detail_includes_related_data(self, client):
        r_list = client.get("/api/v1/species/?per_page=1")
        slug = r_list.get_json()["data"][0]["slug"]
        r = client.get(f"/api/v1/species/{slug}")
        data = r.get_json()["data"]
        assert "host_plants" in data
        assert "distribution_states" in data

    def test_invalid_slug_returns_404(self, client):
        r = client.get("/api/v1/species/this-slug-does-not-exist-xyz")
        assert r.status_code == 404
        assert r.get_json()["success"] is False
