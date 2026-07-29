"""Tests for public CMS (/api/v1/cms/*) and Admin CMS (/api/v1/admin/cms/*)."""
import uuid


class TestPublicArticles:
    URL = "/api/v1/cms/articles"

    def test_list_returns_200_no_auth(self, client):
        r = client.get(self.URL)
        assert r.status_code == 200

    def test_list_has_pagination_meta(self, client):
        r = client.get(self.URL)
        assert "meta" in r.get_json()

    def test_list_shows_only_published(self, client, admin_auth, make_article):
        # Create draft — should not appear in public list
        draft = make_article(status="draft")
        r = client.get(self.URL)
        public_ids = {a["id"] for a in r.get_json()["data"]}
        assert draft["id"] not in public_ids

    def test_filter_by_type(self, client, make_article):
        make_article(article_type="news")
        r = client.get(self.URL + "?type=news")
        assert r.status_code == 200
        for article in r.get_json()["data"]:
            assert article["article_type"] == "news"

    def test_get_article_by_slug(self, client, make_article):
        article = make_article(status="published")
        slug = article["slug"]
        r = client.get(f"{self.URL}/{slug}")
        assert r.status_code == 200
        data = r.get_json()["data"]
        assert data["slug"] == slug
        assert "content" in data   # full content in detail view

    def test_get_draft_by_slug_returns_404(self, client, make_article):
        draft = make_article(status="draft")
        r = client.get(f"{self.URL}/{draft['slug']}")
        assert r.status_code == 404

    def test_get_nonexistent_slug_returns_404(self, client):
        r = client.get(f"{self.URL}/slug-that-does-not-exist-xyz")
        assert r.status_code == 404


class TestPublicBanners:
    URL = "/api/v1/cms/banners"

    def test_returns_200_no_auth(self, client):
        r = client.get(self.URL)
        assert r.status_code == 200

    def test_returns_list(self, client):
        assert isinstance(client.get(self.URL).get_json()["data"], list)

    def test_filter_by_placement(self, client):
        r = client.get(self.URL + "?placement=app_home")
        assert r.status_code == 200


class TestAdminArticles:
    URL = "/api/v1/admin/cms/articles"

    def test_list_requires_auth(self, client):
        r = client.get(self.URL)
        assert r.status_code == 401

    def test_regular_user_cannot_access_admin_cms(self, client, auth):
        r = client.get(self.URL, headers=auth)
        assert r.status_code == 403

    def test_admin_can_list_all_articles(self, client, admin_auth, make_article):
        make_article(status="draft")
        r = client.get(self.URL, headers=admin_auth)
        assert r.status_code == 200

    def test_create_article_returns_201(self, client, admin_auth):
        uid = uuid.uuid4().hex[:6]
        r = client.post(self.URL, json={
            "title": f"Pytest Article {uid}",
            "content": "<p>Test content longer than 10 chars.</p>",
            "article_type": "facts",
            "status": "draft",
        }, headers=admin_auth)
        assert r.status_code == 201
        assert "slug" in r.get_json()["data"]
        # cleanup
        client.delete(f"{self.URL}/{r.get_json()['data']['id']}", headers=admin_auth)

    def test_create_article_short_title_returns_422(self, client, admin_auth):
        r = client.post(self.URL, json={
            "title": "Hi",
            "content": "<p>Content here is fine.</p>",
        }, headers=admin_auth)
        assert r.status_code == 422

    def test_update_article(self, client, admin_auth, make_article):
        article = make_article(status="draft")
        new_title = f"Updated Title {uuid.uuid4().hex[:6]}"
        r = client.put(f"{self.URL}/{article['id']}", json={"title": new_title}, headers=admin_auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["title"] == new_title

    def test_publish_article(self, client, admin_auth, make_article):
        article = make_article(status="draft")
        r = client.patch(f"{self.URL}/{article['id']}/publish", headers=admin_auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["status"] == "published"

    def test_archive_article(self, client, admin_auth, make_article):
        article = make_article(status="published")
        r = client.patch(f"{self.URL}/{article['id']}/archive", headers=admin_auth)
        assert r.status_code == 200
        assert r.get_json()["data"]["status"] == "archived"

    def test_delete_article(self, client, admin_auth):
        uid = uuid.uuid4().hex[:6]
        create = client.post(self.URL, json={
            "title": f"To Be Deleted {uid}",
            "content": "<p>Content for deletion test.</p>",
            "status": "draft",
        }, headers=admin_auth)
        article_id = create.get_json()["data"]["id"]
        r = client.delete(f"{self.URL}/{article_id}", headers=admin_auth)
        assert r.status_code == 200
        # Confirm it's gone from admin list
        r2 = client.get(f"{self.URL}/{article_id}", headers=admin_auth)
        assert r2.status_code == 404

    def test_html_content_is_sanitized(self, client, admin_auth, app):
        uid = uuid.uuid4().hex[:6]
        malicious = '<p>Good</p><script>alert("xss")</script>'
        r = client.post(self.URL, json={
            "title": f"Sanitize Test {uid}",
            "content": malicious,
            "status": "draft",
        }, headers=admin_auth)
        assert r.status_code == 201
        content = r.get_json()["data"]["content"]
        assert "<script>" not in content
        # cleanup
        client.delete(f"{self.URL}/{r.get_json()['data']['id']}", headers=admin_auth)
