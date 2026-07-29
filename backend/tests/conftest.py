"""
Shared pytest fixtures for all Phase 2 API tests.

Strategy
--------
- One Flask app + test client for the whole session (fast).
- One test user and one admin user for the whole session (avoids re-registering).
- Per-test helpers are function-scoped so state is not leaked between tests.
"""
import uuid
import pytest

from config import DevelopmentConfig


class TestConfig(DevelopmentConfig):
    TESTING = True
    DEBUG = False
    # Disable rate limiting so test suites don't hit per-hour caps.
    RATELIMIT_ENABLED = False
    # Re-use the dev database — tests create data with unique UUIDs.
    # Swap to butterfly_db_test if you want full isolation.


# ── App / client ───────────────────────────────────────────────────────────────

@pytest.fixture(scope="session")
def app():
    from app import create_app
    application = create_app(TestConfig)
    ctx = application.app_context()
    ctx.push()
    yield application
    ctx.pop()


@pytest.fixture(scope="session")
def client(app):
    return app.test_client()


# ── Auth helpers ───────────────────────────────────────────────────────────────

def _make_unique(prefix="pt"):
    """Generate a collision-safe suffix."""
    return f"{prefix}_{uuid.uuid4().hex[:8]}"


@pytest.fixture(scope="session")
def regular_user_creds():
    uid = uuid.uuid4().hex[:8]
    return {
        "email": f"pytest_{uid}@test.invalid",
        "password": "Test@Pass123",
        "full_name": "Pytest Regular",
        "username": f"pytest_{uid}",
        "preferred_state_id": 1,
    }


@pytest.fixture(scope="session")
def regular_token(client, regular_user_creds):
    """Register a regular user once and return the access token."""
    r = client.post("/api/v1/auth/register", json=regular_user_creds)
    assert r.status_code == 201, f"Register failed: {r.get_json()}"
    login = client.post("/api/v1/auth/login", json={
        "email": regular_user_creds["email"],
        "password": regular_user_creds["password"],
    })
    return login.get_json()["data"]["access_token"]


@pytest.fixture(scope="session")
def admin_token(client):
    """Log in as the seeded super_admin and return the access token."""
    r = client.post("/api/v1/auth/login", json={
        "email": "admin@example.com",
        "password": "Admin@1234",
    })
    assert r.status_code == 200, f"Admin login failed: {r.get_json()}"
    return r.get_json()["data"]["access_token"]


# ── Convenience header builders ────────────────────────────────────────────────

@pytest.fixture(scope="session")
def auth(regular_token):
    return {"Authorization": f"Bearer {regular_token}"}


@pytest.fixture(scope="session")
def admin_auth(admin_token):
    return {"Authorization": f"Bearer {admin_token}"}


# ── Reusable resource factories ────────────────────────────────────────────────

@pytest.fixture()
def make_observation(client, auth):
    """Create an observation and return its dict. Cleaned up after test."""
    created_ids = []

    def _create(**overrides):
        payload = {
            "state_id": 1,
            "latitude": 12.97,
            "longitude": 77.59,
            "location_name": "Test Location",
            "privacy": "public",
            **overrides,
        }
        r = client.post("/api/v1/observations/", json=payload, headers=auth)
        assert r.status_code == 201, r.get_json()
        obs = r.get_json()["data"]
        created_ids.append(obs["id"])
        return obs

    yield _create

    # teardown — soft-delete created observations
    for obs_id in created_ids:
        client.delete(f"/api/v1/observations/{obs_id}", headers=auth)


@pytest.fixture()
def sample_observation(make_observation):
    """A single ready-to-use observation."""
    return make_observation(title="Sample obs for test", notes="Auto-created by test fixture")


@pytest.fixture()
def make_article(client, admin_auth):
    """Create a CMS article and return its dict."""
    created_ids = []

    def _create(**overrides):
        payload = {
            "title": f"Test Article {uuid.uuid4().hex[:6]}",
            "content": "<p>Test content for pytest article.</p>",
            "article_type": "educational",
            "status": "published",
            **overrides,
        }
        r = client.post("/api/v1/admin/cms/articles", json=payload, headers=admin_auth)
        assert r.status_code == 201, r.get_json()
        article = r.get_json()["data"]
        created_ids.append(article["id"])
        return article

    yield _create

    for article_id in created_ids:
        client.delete(f"/api/v1/admin/cms/articles/{article_id}", headers=admin_auth)
