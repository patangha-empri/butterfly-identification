"""Admin — CMS article and banner management."""
from flask import Blueprint, request, jsonify
# pyrefly: ignore [missing-import]
from flask_jwt_extended import get_jwt_identity

from app.schemas.cms import ArticleCreateSchema, ArticleUpdateSchema, BannerCreateSchema, BannerUpdateSchema
from app.services import cms_service
from app.services.cms_service import CmsError
from app.utils.decorators import admin_required, moderator_required
from app.utils.pagination import get_pagination_params
from app.utils.responses import success_response, error_response, paginated_response
from app.supabase_client import get_supabase
from app.utils.validators import validate_image_file

admin_cms_bp = Blueprint("admin_cms", __name__)

_banner_create_schema = BannerCreateSchema()
_banner_update_schema = BannerUpdateSchema()


# ── Broadcasts ─────────────────────────────────────────────────────────────────

@admin_cms_bp.post("/broadcast")
@admin_required
def broadcast_announcement():
    body = request.get_json(silent=True) or {}
    title = body.get("title")
    message = body.get("body")
    notif_type = body.get("type", "system")

    if not title or not message:
        return error_response("Title and body are required.", 400)

    if notif_type not in ("system", "event", "educational_alert"):
        return error_response("Invalid alert type.", 400)

    try:
        cms_service.broadcast_message(title, message, notif_type)
    except Exception as e:
        return error_response(str(e), 500)

    return success_response(message="Broadcast sent successfully.")


@admin_cms_bp.get("/broadcast/history")
@admin_required
def list_broadcasts():
    sb = get_supabase()
    page, per_page = get_pagination_params()
    
    res = sb.table("notifications") \
        .select("created_at, title, body, type") \
        .in_("type", ["system", "event", "educational_alert"]) \
        .order("created_at", desc=True) \
        .limit(1000) \
        .execute()
        
    seen = set()
    broadcasts = []
    for item in (res.data or []):
        key = (item["title"], item["body"], item["type"])
        if key not in seen:
            seen.add(key)
            broadcasts.append(item)
            
    start = (page - 1) * per_page
    end = start + per_page
    paginated_items = broadcasts[start:end]
    
    return paginated_response(paginated_items, len(broadcasts), page, per_page)


# ── Banners ────────────────────────────────────────────────────────────────────

@admin_cms_bp.get("/banners")
@moderator_required
def list_banners():
    banners = cms_service.list_banners()
    return success_response(data=banners)


@admin_cms_bp.post("/banners")
@admin_required
def create_banner():
    file = request.files.get("image")
    ok, err = validate_image_file(file)
    if not ok:
        return error_response(err, 400)
    body = request.form.to_dict()
    errors = _banner_create_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _banner_create_schema.load(body)
    try:
        banner = cms_service.create_banner(data, file)
    except CmsError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=banner, status_code=201)


@admin_cms_bp.put("/banners/<int:banner_id>")
@admin_required
def update_banner(banner_id):
    body = request.get_json(silent=True) or {}
    errors = _banner_update_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _banner_update_schema.load(body)
    try:
        banner = cms_service.update_banner(banner_id, data)
    except CmsError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=banner)


@admin_cms_bp.delete("/banners/<int:banner_id>")
@admin_required
def delete_banner(banner_id):
    try:
        cms_service.delete_banner(banner_id)
    except CmsError as e:
        return error_response(e.message, e.status_code)
    return success_response(message="Banner deleted.")
