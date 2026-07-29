"""
Phase 3 tests — Gemini Vision identification (Gemini API is fully mocked).

Strategy
--------
* TestGeminiService  — unit-tests the real identify_butterfly() code path.
  Mocks google.generativeai via sys.modules so the C-extension import never
  happens (protobuf C extensions are incompatible with Python 3.14).

* TestIdentificationFlow / TestAdminAcceptMatch — integration tests that patch
  app.services.gemini_service.identify_butterfly directly.  No genai import
  is triggered at all; tests run in milliseconds and need no API key.
"""
import io
import json
import sys
import uuid
from unittest.mock import MagicMock, patch

import pytest
from PIL import Image


# ── Helpers ────────────────────────────────────────────────────────────────────

def _make_jpeg_bytes(color=(0, 128, 0)) -> bytes:
    """Create a tiny valid JPEG in memory."""
    img = Image.new("RGB", (100, 100), color=color)
    buf = io.BytesIO()
    img.save(buf, format="JPEG")
    return buf.getvalue()


def _gemini_response(matches: list, is_butterfly=True, identified=True) -> MagicMock:
    """
    Build a mock requests.Response object.
    Used by TestGeminiService (unit tests) that exercise the real parsing code.
    """
    detection = {
        "contains_butterfly": is_butterfly,
        "life_stage": "adult",
        "number_of_individuals": 1,
        "is_partial_view": False,
        "occluded": False
    }
    
    identification = {}
    identification_reason = {
        "summary": "Mock Gemini response for pytest.",
        "key_features": []
    }
    
    alternative_matches = []
    
    if matches:
        primary = matches[0]
        conf_val = primary.get("confidence", 0) * 100
        identification = {
            "common_name": primary.get("common_name", ""),
            "scientific_name": primary.get("scientific_name", ""),
            "confidence": conf_val,
            "family": "",
            "genus": "",
            "species": ""
        }
        identification_reason["summary"] = primary.get("reasoning", "")
        identification_reason["key_features"] = primary.get("visible_features", [])
        
        for alt in matches[1:]:
            alt_conf = alt.get("confidence", 0) * 100
            alternative_matches.append({
                "common_name": alt.get("common_name", ""),
                "scientific_name": alt.get("scientific_name", ""),
                "confidence": alt_conf,
                "reason": alt.get("reasoning", "")
            })
            
    payload = {
        "success": True,
        "image_quality": {
            "score": 85,
            "rating": "good",
            "lighting": "good",
            "sharpness": "sharp",
            "visibility": "clear",
            "background_complexity": "low",
            "recommendation": ""
        },
        "detection": detection,
        "identification": identification,
        "alternative_matches": alternative_matches,
        "identification_reason": identification_reason,
        "user_guidance": {
            "certainty_explanation": "Mock Gemini response for pytest."
        }
    }
    
    vertex_payload = {
        "candidates": [
            {
                "content": {
                    "parts": [
                        {"text": json.dumps(payload)}
                    ]
                }
            }
        ],
        "usageMetadata": {
            "promptTokenCount": 350,
            "candidatesTokenCount": 200,
            "totalTokenCount": 550
        }
    }
    mock_resp = MagicMock()
    mock_resp.json.return_value = vertex_payload
    mock_resp.raise_for_status = MagicMock()
    return mock_resp


def _make_gemini_result(matches, is_butterfly=True, identified=True) -> dict:
    """
    Return a dict that matches what gemini_service.identify_butterfly() returns.
    Used by integration tests that bypass identify_butterfly entirely.
    """
    return {
        "is_butterfly": is_butterfly,
        "identified": identified,
        "image_quality": "good",
        "matches": matches,
        "notes": "Mock Gemini response",
        "raw_text": json.dumps({
            "is_butterfly": is_butterfly,
            "identified": identified,
            "matches": matches,
        }),
        "raw_json": {
            "is_butterfly": is_butterfly,
            "identified": identified,
            "matches": matches,
        },
        "input_token_count": 350,
        "output_token_count": 200,
        "total_token_count": 550,
    }


_MONARCH_MATCH = {
    "common_name": "Plain Tiger",
    "scientific_name": "Danaus chrysippus",
    "confidence": 0.94,
    "reasoning": "Orange wings with black borders and white spots — D. chrysippus.",
    "visible_features": ["orange wings", "black border", "white spots"],
}

_BLUE_MORMON_MATCH = {
    "common_name": "Blue Mormon",
    "scientific_name": "Papilio polymnestor",
    "confidence": 0.88,
    "reasoning": "Large Papilionid with iridescent blue hindwing scaling.",
    "visible_features": ["blue iridescent scaling", "black body", "swallowtail"],
}


# ── Fixtures ───────────────────────────────────────────────────────────────────

@pytest.fixture()
def obs_with_image(client, auth, app):
    """Create an observation and inject a fake ObservationImage row (no real file upload)."""
    r = client.post("/api/v1/observations/", json={
        "state_id": 1,
        "latitude": 13.0,
        "longitude": 77.5,
        "location_name": "Test Location",
        "privacy": "public",
        "title": "Phase 3 test observation",
    }, headers=auth)
    assert r.status_code == 201
    obs_id = r.get_json()["data"]["id"]

    # Inject a fake image row directly into DB (avoids needing real file upload)
    with app.app_context():
        from app.extensions import db
        from app.models.observation import ObservationImage
        fake_url = f"/uploads/observations/{obs_id}/fake_test.jpg"
        img_row = ObservationImage(
            observation_id=obs_id,
            original_url=fake_url,
            optimized_url=fake_url,
            thumbnail_url=fake_url,
            is_primary=True,
            file_size_bytes=5000,
            width=100,
            height=100,
        )
        db.session.add(img_row)
        db.session.commit()

    yield obs_id

    # Teardown — soft-delete the observation
    client.delete(f"/api/v1/observations/{obs_id}", headers=auth)


# ── gemini_service unit tests ──────────────────────────────────────────────────

class TestGeminiService:
    """
    Unit-test the real identify_butterfly() parsing/normalisation code.

    google.generativeai is replaced by a MagicMock injected into sys.modules,
    which makes `import google.generativeai as genai` inside identify_butterfly
    return our mock without ever loading the C-extension protobuf library.
    """


    def test_identify_butterfly_returns_normalised_dict(self, app):
        with app.app_context():
            with patch("app.services.gemini_service.http.post") as mock_post, \
                 patch.dict(app.config, {"VERTEX_AI_API_KEY": "fake-key", "VERTEX_AI_PROJECT": "p", "VERTEX_AI_LOCATION": "l"}):
                mock_post.return_value = _gemini_response([_MONARCH_MATCH])

                from app.services.gemini_service import identify_butterfly
                result = identify_butterfly([_make_jpeg_bytes()])

        assert result["is_butterfly"] is True
        assert result["identified"] is True
        assert len(result["matches"]) == 1
        m = result["matches"][0]
        assert m["common_name"] == "Plain Tiger"
        assert m["scientific_name"] == "Danaus chrysippus"
        assert 0.0 <= m["confidence"] <= 1.0

    def test_up_to_3_matches_returned(self, app):
        three_matches = [_MONARCH_MATCH, _BLUE_MORMON_MATCH, {
            "common_name": "Lime Butterfly",
            "scientific_name": "Papilio demoleus",
            "confidence": 0.55,
            "reasoning": "Yellow-green pattern.",
            "visible_features": ["yellow-green wings"],
        }]
        with app.app_context():
            with patch("app.services.gemini_service.http.post") as mock_post, \
                 patch.dict(app.config, {"VERTEX_AI_API_KEY": "fake-key", "VERTEX_AI_PROJECT": "p", "VERTEX_AI_LOCATION": "l"}):
                mock_post.return_value = _gemini_response(three_matches)

                from app.services import gemini_service
                result = gemini_service.identify_butterfly(
                    [_make_jpeg_bytes(), _make_jpeg_bytes(), _make_jpeg_bytes()]
                )

        assert len(result["matches"]) == 3
        # Verify descending confidence order
        confs = [m["confidence"] for m in result["matches"]]
        assert confs == sorted(confs, reverse=True)

    def test_non_butterfly_returns_empty_matches(self, app):
        with app.app_context():
            with patch("app.services.gemini_service.http.post") as mock_post, \
                 patch.dict(app.config, {"VERTEX_AI_API_KEY": "fake-key", "VERTEX_AI_PROJECT": "p", "VERTEX_AI_LOCATION": "l"}):
                mock_post.return_value = _gemini_response([], is_butterfly=False, identified=False)

                from app.services import gemini_service
                result = gemini_service.identify_butterfly([_make_jpeg_bytes()])

        assert result["is_butterfly"] is False
        assert result["matches"] == []

    def test_missing_api_key_raises_value_error(self, app):
        """No genai import happens — the check is before the import statement."""
        with app.app_context():
            with patch.dict(app.config, {"VERTEX_AI_API_KEY": "", "VERTEX_AI_PROJECT": "p", "VERTEX_AI_LOCATION": "l"}):
                from app.services import gemini_service
                with pytest.raises(ValueError, match="VERTEX_AI_API_KEY"):
                    gemini_service.identify_butterfly([_make_jpeg_bytes()])

    def test_confidence_clamped_between_0_and_1(self, app):
        bad_match = {**_MONARCH_MATCH, "confidence": 1.5}   # out of range
        with app.app_context():
            with patch("app.services.gemini_service.http.post") as mock_post, \
                 patch.dict(app.config, {"VERTEX_AI_API_KEY": "fake-key", "VERTEX_AI_PROJECT": "p", "VERTEX_AI_LOCATION": "l"}):
                mock_post.return_value = _gemini_response([bad_match])

                from app.services import gemini_service
                result = gemini_service.identify_butterfly([_make_jpeg_bytes()])

        assert result["matches"][0]["confidence"] <= 1.0

    def test_malformed_json_raises_value_error(self, app):
        with app.app_context():
            with patch("app.services.gemini_service.http.post") as mock_post, \
                 patch.dict(app.config, {"VERTEX_AI_API_KEY": "fake-key", "VERTEX_AI_PROJECT": "p", "VERTEX_AI_LOCATION": "l"}):
                mock_post.return_value.json.return_value = {"candidates": [{"content": {"parts": [{"text": "Sorry, I cannot identify that."}]}}]}

                from app.services import gemini_service
                with pytest.raises(ValueError):
                    gemini_service.identify_butterfly([_make_jpeg_bytes()])


# ── Species DB matching tests ──────────────────────────────────────────────────

class TestSpeciesMatching:

    def test_exact_scientific_name_resolves(self, app):
        with app.app_context():
            from app.models.species import Species
            sp = Species.query.filter_by(is_active=True).first()
            from app.services.gemini_service import find_species_id
            result = find_species_id(sp.scientific_name, sp.common_name)
            assert result == sp.id

    def test_case_insensitive_scientific_name(self, app):
        with app.app_context():
            from app.models.species import Species
            from app.services.gemini_service import find_species_id
            sp = Species.query.filter_by(is_active=True).first()
            result = find_species_id(sp.scientific_name.upper(), sp.common_name)
            assert result == sp.id

    def test_completely_wrong_name_returns_none(self, app):
        with app.app_context():
            from app.services.gemini_service import find_species_id
            result = find_species_id("Fakus fakus", "Totally Fake Butterfly")
            assert result is None

    def test_close_scientific_name_matches(self, app):
        """A minor typo in the scientific name should not crash — result may or may not match."""
        with app.app_context():
            from app.models.species import Species
            from app.services.gemini_service import find_species_id
            sp = Species.query.filter_by(is_active=True).first()
            typo_name = sp.scientific_name[:-1] + "x"
            result = find_species_id(typo_name, sp.common_name)
            assert result is None or isinstance(result, str)


# ── Full identification flow (API-level) ───────────────────────────────────────

class TestIdentificationFlow:
    """
    Integration tests for the identify/result endpoints.

    Patches app.services.gemini_service.identify_butterfly directly — the
    service-layer function — so no google.generativeai import is triggered.
    download_image_bytes is also patched so the fake /uploads/ path works.
    """

    @staticmethod
    def _mock_gemini(matches, is_butterfly=True, identified=True):
        """
        Return a 2-patch tuple:
          [0] — replace identify_butterfly with a pre-built result dict
          [1] — replace download_image_bytes so fake image URLs work
        """
        jpeg = _make_jpeg_bytes()
        gemini_result = _make_gemini_result(matches, is_butterfly, identified)
        return (
            patch(
                "app.services.gemini_service.identify_butterfly",
                return_value=gemini_result,
            ),
            patch(
                "app.services.gemini_service.download_image_bytes",
                return_value=jpeg,
            ),
        )

    def test_trigger_returns_completed_result(self, client, auth, obs_with_image, app):
        obs_id = obs_with_image
        p = self._mock_gemini([_MONARCH_MATCH])
        with p[0], p[1]:
            r = client.post(
                f"/api/v1/identifications/observations/{obs_id}/identify",
                headers=auth,
            )

        assert r.status_code == 200
        data = r.get_json()["data"]
        assert data["status"] == "completed"
        assert len(data["matches"]) == 1
        assert data["matches"][0]["matched_common_name"] == "Plain Tiger"
        assert data["matches"][0]["confidence_score"] == pytest.approx(0.94, abs=0.01)
        assert data["processing_time_ms"] is not None

    def test_trigger_links_species_when_db_match_found(self, client, auth, obs_with_image, app):
        """If Gemini returns a scientific name matching our DB, species_id is set."""
        with app.app_context():
            from app.models.species import Species
            real_sp = Species.query.filter_by(is_active=True).first()

        real_match = {
            **_MONARCH_MATCH,
            "common_name": real_sp.common_name,
            "scientific_name": real_sp.scientific_name,
            "confidence": 0.97,
        }
        obs_id = obs_with_image
        p = self._mock_gemini([real_match])
        with p[0], p[1]:
            r = client.post(
                f"/api/v1/identifications/observations/{obs_id}/identify",
                headers=auth,
            )

        assert r.status_code == 200
        data = r.get_json()["data"]
        assert data["status"] == "completed"
        top_match = data["matches"][0]
        assert top_match["species_id"] is not None
        assert top_match["species_id"] == real_sp.id

    def test_trigger_sets_observation_ai_identified(self, client, auth, obs_with_image, app):
        obs_id = obs_with_image
        p = self._mock_gemini([_MONARCH_MATCH])
        with p[0], p[1]:
            client.post(
                f"/api/v1/identifications/observations/{obs_id}/identify",
                headers=auth,
            )

        with app.app_context():
            from app.models.observation import Observation
            obs = Observation.query.get(obs_id)
            assert obs.verification_status == "ai_identified"

    def test_trigger_creates_notification(self, client, auth, obs_with_image, app):
        obs_id = obs_with_image

        with app.app_context():
            from app.models.notification import Notification
            r_me = client.get("/api/v1/auth/me", headers=auth)
            user_id = r_me.get_json()["data"]["id"]
            before = Notification.query.filter_by(
                user_id=user_id, type="identification_complete"
            ).count()

        p = self._mock_gemini([_MONARCH_MATCH])
        with p[0], p[1]:
            client.post(
                f"/api/v1/identifications/observations/{obs_id}/identify",
                headers=auth,
            )

        with app.app_context():
            after = Notification.query.filter_by(
                user_id=user_id, type="identification_complete"
            ).count()
        assert after == before + 1

    def test_non_butterfly_image_yields_completed_no_matches(
        self, client, auth, obs_with_image, app
    ):
        obs_id = obs_with_image
        p = self._mock_gemini([], is_butterfly=False, identified=False)
        with p[0], p[1]:
            r = client.post(
                f"/api/v1/identifications/observations/{obs_id}/identify",
                headers=auth,
            )

        data = r.get_json()["data"]
        assert data["status"] == "completed"
        assert data["matches"] == []
        assert "No butterfly" in (data.get("error_message") or "No butterfly")

    def test_missing_api_key_results_in_failed_status(
        self, client, auth, obs_with_image, app
    ):
        """
        Empty GEMINI_API_KEY → identify_butterfly raises ValueError before any
        genai import → identification_service catches it → status='failed'.
        """
        obs_id = obs_with_image
        jpeg = _make_jpeg_bytes()
        # Only patch download_image_bytes so the fake image URL works.
        # identify_butterfly is NOT patched — we want the real API key check.
        with patch.dict(app.config, {"VERTEX_AI_API_KEY": "", "VERTEX_AI_PROJECT": "p", "VERTEX_AI_LOCATION": "l"}), \
             patch("app.services.gemini_service.download_image_bytes", return_value=jpeg):
            r = client.post(
                f"/api/v1/identifications/observations/{obs_id}/identify",
                headers=auth,
            )

        data = r.get_json()["data"]
        assert data["status"] == "failed"
        assert "VERTEX_AI_API_KEY" in (data.get("error_message") or "")

    def test_re_trigger_replaces_previous_result(
        self, client, auth, obs_with_image, app
    ):
        obs_id = obs_with_image

        # First identification — Plain Tiger
        p1 = self._mock_gemini([_MONARCH_MATCH])
        with p1[0], p1[1]:
            client.post(
                f"/api/v1/identifications/observations/{obs_id}/identify",
                headers=auth,
            )

        # Re-identification — Blue Mormon
        p2 = self._mock_gemini([_BLUE_MORMON_MATCH])
        with p2[0], p2[1]:
            r2 = client.post(
                f"/api/v1/identifications/observations/{obs_id}/identify",
                headers=auth,
            )

        top = r2.get_json()["data"]["matches"][0]
        assert top["matched_common_name"] == "Blue Mormon"

    def test_get_result_after_identification(self, client, auth, obs_with_image, app):
        obs_id = obs_with_image
        p = self._mock_gemini([_MONARCH_MATCH])
        with p[0], p[1]:
            client.post(
                f"/api/v1/identifications/observations/{obs_id}/identify",
                headers=auth,
            )

        r = client.get(
            f"/api/v1/identifications/observations/{obs_id}/result",
            headers=auth,
        )
        assert r.status_code == 200
        assert r.get_json()["data"]["status"] == "completed"

    def test_get_result_without_auth_returns_401(self, client, obs_with_image):
        obs_id = obs_with_image
        r = client.get(f"/api/v1/identifications/observations/{obs_id}/result")
        assert r.status_code == 401

    def test_trigger_without_images_still_returns_400(self, client, auth, make_observation):
        obs = make_observation()
        r = client.post(
            f"/api/v1/identifications/observations/{obs['id']}/identify",
            headers=auth,
        )
        assert r.status_code == 400


# ── Admin accept-match endpoint ────────────────────────────────────────────────

class TestAdminAcceptMatch:

    @staticmethod
    def _run_identification(client, auth, obs_id, app):
        """Trigger identification (two matches) and return the result dict."""
        jpeg = _make_jpeg_bytes()
        gemini_result = _make_gemini_result([_MONARCH_MATCH, _BLUE_MORMON_MATCH])
        with patch(
            "app.services.gemini_service.identify_butterfly",
            return_value=gemini_result,
        ), patch(
            "app.services.gemini_service.download_image_bytes",
            return_value=jpeg,
        ):
            return client.post(
                f"/api/v1/identifications/observations/{obs_id}/identify",
                headers=auth,
            ).get_json()["data"]

    def test_admin_can_accept_match(self, client, auth, admin_auth, obs_with_image, app):
        obs_id = obs_with_image
        result    = self._run_identification(client, auth, obs_id, app)
        result_id = result["id"]
        match_id  = result["matches"][1]["id"]   # second match (Blue Mormon)

        r = client.post(
            f"/api/v1/identifications/results/{result_id}/matches/{match_id}/accept",
            json={"admin_notes": "Confirmed by expert — Blue Mormon"},
            headers=admin_auth,
        )
        assert r.status_code == 200
        accepted = [m for m in r.get_json()["data"]["matches"] if m["is_accepted"]]
        assert len(accepted) == 1
        assert accepted[0]["id"] == match_id

    def test_regular_user_cannot_accept_match(
        self, client, auth, obs_with_image, app
    ):
        obs_id   = obs_with_image
        result   = self._run_identification(client, auth, obs_id, app)
        result_id = result["id"]
        match_id  = result["matches"][0]["id"]

        r = client.post(
            f"/api/v1/identifications/results/{result_id}/matches/{match_id}/accept",
            headers=auth,   # regular user — not admin
        )
        assert r.status_code == 403

    def test_accept_nonexistent_result_returns_404(self, client, admin_auth):
        r = client.post(
            "/api/v1/identifications/results/fake-result-id/matches/999/accept",
            headers=admin_auth,
        )
        assert r.status_code == 404


# ── Bunny Storage ──────────────────────────────────────────────────────────────

class TestStorageService:

    def test_upload_bytes_uses_bunny_when_configured(self, app):
        with app.app_context():
            fake_response = MagicMock()
            fake_response.raise_for_status = MagicMock()

            with patch("requests.put", return_value=fake_response) as mock_put, \
                 patch.dict(app.config, {
                     "BUNNY_STORAGE_API_KEY": "fake-api-key",
                     "BUNNY_STORAGE_ZONE": "myzone",
                     "BUNNY_CDN_URL": "https://myzone.b-cdn.net",
                 }):
                from app.services.storage_service import upload_bytes
                url = upload_bytes(b"fake image bytes", "test/image.jpg")

            mock_put.assert_called_once()
            assert url.startswith("https://myzone.b-cdn.net/")
            assert url.endswith("test/image.jpg")

    def test_upload_bytes_falls_back_to_local_when_no_key(self, app, tmp_path):
        with app.app_context():
            with patch("app.services.storage_service._local_uploads_dir", return_value=tmp_path), \
                 patch.dict(app.config, {
                     "BUNNY_STORAGE_API_KEY": "",
                     "BUNNY_STORAGE_ZONE": "",
                 }):
                from app.services.storage_service import upload_bytes
                import warnings
                with warnings.catch_warnings():
                    warnings.simplefilter("ignore")
                    url = upload_bytes(b"fake bytes", "test/image.jpg")

            assert url.startswith("/uploads/")

    def test_delete_file_returns_true_when_no_key(self, app):
        with app.app_context():
            with patch.dict(app.config, {"BUNNY_STORAGE_API_KEY": "", "BUNNY_STORAGE_ZONE": ""}):
                from app.services.storage_service import delete_file
                result = delete_file("test/image.jpg")
            assert result is True

    def test_delete_file_calls_bunny_when_configured(self, app):
        with app.app_context():
            fake_response = MagicMock()
            fake_response.status_code = 200

            with patch("requests.delete", return_value=fake_response) as mock_del, \
                 patch.dict(app.config, {
                     "BUNNY_STORAGE_API_KEY": "fake-key",
                     "BUNNY_STORAGE_ZONE": "myzone",
                 }):
                from app.services.storage_service import delete_file
                result = delete_file("observations/abc/image.jpg")

            mock_del.assert_called_once()
            assert result is True
