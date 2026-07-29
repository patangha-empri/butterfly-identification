"""CMS articles and banners — via Supabase PostgREST."""
import uuid
import json

import bleach
from datetime import datetime, timezone
# pyrefly: ignore [missing-import]
from slugify import slugify

from app.supabase_client import get_supabase
from app.services.user_repo import user_to_dict

ALLOWED_TAGS = [
    "p", "br", "strong", "em", "u", "h2", "h3", "h4",
    "ul", "ol", "li", "a", "blockquote", "img", "figure", "figcaption",
]
ALLOWED_ATTRS = {
    "a": ["href", "title", "target"],
    "img": ["src", "alt", "width", "height"],
    "figure": ["class"],
}

ARTICLE_SELECT = "*, users(*, roles(name))"


class CmsError(Exception):
    def __init__(self, message: str, status_code: int = 400):
        self.message = message
        self.status_code = status_code
        super().__init__(message)


def _now() -> str:
    return datetime.now(timezone.utc).isoformat()


def _sanitize(html: str) -> str:
    return bleach.clean(html, tags=ALLOWED_TAGS, attributes=ALLOWED_ATTRS, strip=True)


def _sanitize_json_blocks(content_str: str) -> str:
    try:
        data = json.loads(content_str)
        if isinstance(data, dict) and "blocks" in data:
            for block in data["blocks"]:
                b_data = block.get("data") or {}
                if "text" in b_data:
                    b_data["text"] = _sanitize(b_data["text"])
                if "items" in b_data:
                    b_data["items"] = [_sanitize(item) for item in b_data["items"]]
            return json.dumps(data)
    except Exception:
        pass
    return content_str


def _compile_blocks_to_html(content_str: str) -> str:
    if not content_str:
        return ""
    try:
        data = json.loads(content_str)
    except Exception:
        return content_str

    if not isinstance(data, dict) or "blocks" not in data:
        return content_str

    blocks = data["blocks"]
    html_lines = []
    for block in blocks:
        b_type = block.get("type")
        b_data = block.get("data") or {}
        
        if b_type == "paragraph":
            text = b_data.get("text", "")
            if text:
                html_lines.append(f"<p>{text}</p>")
        elif b_type == "header":
            level = b_data.get("level", 2)
            text = b_data.get("text", "")
            if text:
                html_lines.append(f"<h{level}>{text}</h{level}>")
        elif b_type == "list":
            style = b_data.get("style", "unordered")
            items = b_data.get("items", [])
            tag = "ol" if style == "ordered" else "ul"
            if items:
                items_html = "".join([f"<li>{item}</li>" for item in items])
                html_lines.append(f"<{tag}>{items_html}</{tag}>")
        elif b_type == "image":
            file_info = b_data.get("file") or {}
            url = file_info.get("url") or b_data.get("url")
            caption = b_data.get("caption", "")
            stretched = b_data.get("stretched", False)
            with_border = b_data.get("withBorder", False)
            with_background = b_data.get("withBackground", False)
            
            img_cls = []
            if stretched: img_cls.append("img-stretched")
            if with_border: img_cls.append("img-border")
            if with_background: img_cls.append("img-bg")
            
            cls_str = f' class="{" ".join(img_cls)}"' if img_cls else ""
            
            if url:
                fig_html = f'<figure{cls_str}><img src="{url}" alt="{caption or ""}" />'
                if caption:
                    fig_html += f'<figcaption>{caption}</figcaption>'
                fig_html += "</figure>"
                html_lines.append(fig_html)
    return "\n".join(html_lines)


def _article_to_dict(a: dict, include_content: bool = False) -> dict:
    author = a.get("users")
    if isinstance(author, list):
        author = author[0] if author else None

    content_str = a.get("content") or ""
    content_json = None
    content_html = ""
    
    if content_str.strip().startswith("{") and content_str.strip().endswith("}"):
        try:
            content_json = json.loads(content_str)
            content_html = _compile_blocks_to_html(content_str)
        except Exception:
            content_html = content_str
    else:
        content_html = content_str

    data = {
        "id": a["id"],
        "title": a["title"],
        "slug": a["slug"],
        "excerpt": a.get("excerpt"),
        "cover_image_url": a.get("cover_image_url"),
        "article_type": a.get("article_type"),
        "status": a.get("status"),
        "author": user_to_dict(author) if author else None,
        "published_at": a.get("published_at"),
        "created_at": a.get("created_at"),
        "content_json": content_json,
        "content_html": _sanitize(content_html) if content_html else "",
    }
    if include_content:
        data["content"] = content_str
    return data


def _banner_to_dict(b: dict) -> dict:
    return {
        "id": b["id"],
        "title": b["title"],
        "image_url": b["image_url"],
        "link_url": b.get("link_url"),
        "placement": b.get("placement"),
        "is_active": b.get("is_active"),
        "display_order": b.get("display_order"),
    }


def _make_unique_slug(title: str, exclude_id: str = None) -> str:
    sb = get_supabase()
    base = slugify(title)
    slug = base
    counter = 1
    while True:
        q = sb.table("cms_articles").select("id").eq("slug", slug)
        if exclude_id:
            q = q.neq("id", exclude_id)
        if not q.execute().data:
            return slug
        slug = f"{base}-{counter}"
        counter += 1


def _fetch_article(article_id: str) -> dict | None:
    sb = get_supabase()
    res = sb.table("cms_articles").select(ARTICLE_SELECT).eq("id", article_id).execute()
    return res.data[0] if res.data else None


# ── Public API ─────────────────────────────────────────────────────────────────

def list_articles(page: int, per_page: int, article_type: str = None) -> tuple:
    sb = get_supabase()
    query = sb.table("cms_articles").select(ARTICLE_SELECT, count="exact").eq("status", "published")
    if article_type:
        query = query.eq("article_type", article_type)
    start = (page - 1) * per_page
    res = query.order("published_at", desc=True).range(start, start + per_page - 1).execute()
    return [_article_to_dict(a, include_content=False) for a in res.data], res.count or 0


def get_article(slug: str) -> dict:
    sb = get_supabase()
    res = sb.table("cms_articles").select(ARTICLE_SELECT).eq("slug", slug).eq("status", "published").execute()
    if not res.data:
        raise CmsError("Article not found.", 404)
    return _article_to_dict(res.data[0], include_content=True)


def list_banners(placement: str = None) -> list:
    sb = get_supabase()
    query = sb.table("cms_banners").select("*").eq("is_active", True)
    if placement:
        query = query.eq("placement", placement)
    res = query.order("display_order").execute()
    return [_banner_to_dict(b) for b in res.data]


# ── Admin API ──────────────────────────────────────────────────────────────────

def admin_list_articles(page: int, per_page: int, status: str = None, article_type: str = None) -> tuple:
    sb = get_supabase()
    query = sb.table("cms_articles").select(ARTICLE_SELECT, count="exact")
    if status:
        query = query.eq("status", status)
    if article_type:
        query = query.eq("article_type", article_type)
    start = (page - 1) * per_page
    res = query.order("created_at", desc=True).range(start, start + per_page - 1).execute()
    return [_article_to_dict(a, include_content=False) for a in res.data], res.count or 0


def create_article(data: dict, author_id: str) -> dict:
    sb = get_supabase()
    status = data.get("status", "draft")
    article_id = str(uuid.uuid4())
    now = _now()
    
    content_val = data["content"]
    if content_val.strip().startswith("{") and content_val.strip().endswith("}"):
        sanitized_content = _sanitize_json_blocks(content_val)
    else:
        sanitized_content = _sanitize(content_val)

    sb.table("cms_articles").insert({
        "id": article_id,
        "title": data["title"],
        "slug": _make_unique_slug(data["title"]),
        "content": sanitized_content,
        "excerpt": data.get("excerpt"),
        "cover_image_url": data.get("cover_image_url"),
        "article_type": data.get("article_type", "educational"),
        "status": status,
        "author_id": author_id,
        "published_at": now if status == "published" else None,
        "created_at": now,
        "updated_at": now,
    }).execute()
    
    article_dict = _article_to_dict(_fetch_article(article_id), include_content=True)
    
    if status == "published":
        notif_type = "educational_alert" if data.get("article_type") in ("educational", "facts") else "event"
        title = f"New Announcement: {article_dict['title']}"
        body = article_dict.get("excerpt") or f"Read our latest article: {article_dict['title']}"
        try:
            broadcast_message(title, body, notif_type)
        except Exception:
            pass
            
    return article_dict


def update_article(article_id: str, data: dict) -> dict:
    sb = get_supabase()
    article = _fetch_article(article_id)
    if not article:
        raise CmsError("Article not found.", 404)

    old_status = article.get("status")

    fields = {}
    if "title" in data:
        fields["title"] = data["title"]
        fields["slug"] = _make_unique_slug(data["title"], exclude_id=article_id)
    if "content" in data:
        content_val = data["content"]
        if content_val.strip().startswith("{") and content_val.strip().endswith("}"):
            fields["content"] = _sanitize_json_blocks(content_val)
        else:
            fields["content"] = _sanitize(content_val)
    for field in ("excerpt", "article_type", "cover_image_url"):
        if field in data:
            fields[field] = data[field]
    if "status" in data:
        fields["status"] = data["status"]
        if data["status"] == "published" and old_status != "published":
            fields["published_at"] = _now()

    if fields:
        fields["updated_at"] = _now()
        sb.table("cms_articles").update(fields).eq("id", article_id).execute()

    article_dict = _article_to_dict(_fetch_article(article_id), include_content=True)

    if data.get("status") == "published" and old_status != "published":
        notif_type = "educational_alert" if article_dict.get("article_type") in ("educational", "facts") else "event"
        title = f"New Announcement: {article_dict['title']}"
        body = article_dict.get("excerpt") or f"Read our latest article: {article_dict['title']}"
        try:
            broadcast_message(title, body, notif_type)
        except Exception:
            pass

    return article_dict


def delete_article(article_id: str) -> None:
    sb = get_supabase()
    article = sb.table("cms_articles").select("id").eq("id", article_id).execute()
    if not article.data:
        raise CmsError("Article not found.", 404)
    sb.table("cms_articles").delete().eq("id", article_id).execute()


def set_cover_image(article_id: str, file_storage) -> dict:
    from app.services.storage_service import upload_file
    sb = get_supabase()
    article = sb.table("cms_articles").select("id").eq("id", article_id).execute()
    if not article.data:
        raise CmsError("Article not found.", 404)
    urls = upload_file(file_storage, folder=f"cms/articles/{article_id}")
    sb.table("cms_articles").update({
        "cover_image_url": urls["optimized_url"],
        "updated_at": _now(),
    }).eq("id", article_id).execute()
    return _article_to_dict(_fetch_article(article_id), include_content=False)


# ── Banners ────────────────────────────────────────────────────────────────────

def create_banner(data: dict, file_storage) -> dict:
    from app.services.storage_service import upload_file
    sb = get_supabase()
    urls = upload_file(file_storage, folder="cms/banners")
    res = sb.table("cms_banners").insert({
        "title": data["title"],
        "image_url": urls["optimized_url"],
        "link_url": data.get("link_url"),
        "placement": data.get("placement", "app_home"),
        "display_order": data.get("display_order", 0),
        "is_active": True,
        "created_at": _now(),
    }).execute()
    return _banner_to_dict(res.data[0])


def update_banner(banner_id: int, data: dict) -> dict:
    sb = get_supabase()
    banner = sb.table("cms_banners").select("id").eq("id", banner_id).execute()
    if not banner.data:
        raise CmsError("Banner not found.", 404)
    fields = {f: data[f] for f in ("title", "link_url", "placement", "display_order", "is_active") if f in data}
    if fields:
        sb.table("cms_banners").update(fields).eq("id", banner_id).execute()
    res = sb.table("cms_banners").select("*").eq("id", banner_id).execute()
    return _banner_to_dict(res.data[0])


def delete_banner(banner_id: int) -> None:
    sb = get_supabase()
    banner = sb.table("cms_banners").select("id").eq("id", banner_id).execute()
    if not banner.data:
        raise CmsError("Banner not found.", 404)
    sb.table("cms_banners").delete().eq("id", banner_id).execute()


def broadcast_message(title: str, body: str, notif_type: str = "system") -> None:
    """Send system-wide broadcast notification to all active users."""
    sb = get_supabase()
    
    # 1. Fetch all active users
    users_res = sb.table("users").select("id").eq("is_active", True).execute()
    user_ids = [u["id"] for u in users_res.data] if users_res.data else []
    
    if not user_ids:
        return
        
    # 2. Batch insert notifications
    notif_rows = []
    for uid in user_ids:
        notif_rows.append({
            "id": str(uuid.uuid4()),
            "user_id": uid,
            "type": notif_type,
            "title": title,
            "body": body,
            "data": {},
            "is_read": False,
            "created_at": _now()
        })
        
    # Chunk batch inserts to prevent PostgREST URL/payload length overflow
    chunk_size = 500
    for i in range(0, len(notif_rows), chunk_size):
        chunk = notif_rows[i:i + chunk_size]
        sb.table("notifications").insert(chunk).execute()
        
    # 3. Fetch all notification preferences with FCM tokens for push notification
    pref_res = sb.table("notification_preferences") \
        .select("user_id, fcm_token, educational_alerts, events") \
        .execute()
        
    fcm_tokens_to_notify = []
    for pref in (pref_res.data or []):
        uid = pref.get("user_id")
        token = pref.get("fcm_token")
        if not token or uid not in user_ids:
            continue
            
        if notif_type == "educational_alert" and not pref.get("educational_alerts", True):
            continue
        if notif_type == "event" and not pref.get("events", True):
            continue
            
        fcm_tokens_to_notify.append(token)
        
    if fcm_tokens_to_notify:
        import firebase_admin
        from firebase_admin import messaging
        from flask import current_app
        
        try:
            if not firebase_admin._apps:
                cred_path = current_app.config.get("FIREBASE_CREDENTIALS_PATH", "")
                if cred_path:
                    import firebase_admin.credentials as creds
                    firebase_admin.initialize_app(creds.Certificate(cred_path))
                else:
                    return
                    
            fcm_chunk_size = 500
            for i in range(0, len(fcm_tokens_to_notify), fcm_chunk_size):
                chunk_tokens = fcm_tokens_to_notify[i:i + fcm_chunk_size]
                message = messaging.MulticastMessage(
                    notification=messaging.Notification(title=title, body=body),
                    tokens=chunk_tokens,
                    data={}
                )
                if hasattr(messaging, "send_each_for_multicast"):
                    messaging.send_each_for_multicast(message)
                else:
                    messaging.send_multicast(message)
        except Exception:
            pass
