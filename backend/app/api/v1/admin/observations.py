"""Admin — observation moderation."""
from flask import Blueprint, request
# pyrefly: ignore [missing-import]
from flask_jwt_extended import get_jwt_identity

from app.schemas.admin import VerifyObservationSchema, RejectObservationSchema
from app.services import observation_service
from app.services.observation_service import ObservationError
from app.supabase_client import get_supabase
from app.utils.decorators import moderator_required
from app.utils.pagination import get_pagination_params
from app.utils.responses import success_response, error_response, paginated_response

admin_obs_bp = Blueprint("admin_obs", __name__)

_verify_schema = VerifyObservationSchema()
_reject_schema = RejectObservationSchema()


@admin_obs_bp.get("/")
@moderator_required
def list_observations():
    page, per_page = get_pagination_params()
    filters = {
        "state_id": request.args.get("state_id", type=int),
        "species_id": request.args.get("species_id"),
        "verification_status": request.args.get("verification_status"),
        "user_id": request.args.get("user_id"),
        "search": request.args.get("search"),
    }
    filters = {k: v for k, v in filters.items() if v is not None}
    items, total = observation_service.admin_list_observations(page, per_page, filters)
    return paginated_response(items, total, page, per_page)


@admin_obs_bp.patch("/<obs_id>/verify")
@moderator_required
def verify_observation(obs_id):
    body = request.get_json(silent=True) or {}
    errors = _verify_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _verify_schema.load(body)
    admin_id = get_jwt_identity()
    try:
        obs = observation_service.admin_verify_observation(
            obs_id, admin_id,
            species_id=data.get("species_id"),
            notes=data.get("admin_notes"),
        )
    except ObservationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=obs, message="Observation verified.")


@admin_obs_bp.patch("/<obs_id>/reject")
@moderator_required
def reject_observation(obs_id):
    body = request.get_json(silent=True) or {}
    errors = _reject_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _reject_schema.load(body)
    admin_id = get_jwt_identity()
    try:
        obs = observation_service.admin_reject_observation(
            obs_id, admin_id, notes=data["admin_notes"]
        )
    except ObservationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=obs, message="Observation rejected.")


@admin_obs_bp.get("/<obs_id>/social")
@moderator_required
def observation_social(obs_id):
    """Return who liked and who commented on an observation — admin only.

    Likes: full user profile snapshot (id, username, full_name, avatar, liked_at).
    Comments: paginated, newest-first, each with user profile snapshot.
    """
    page, per_page = get_pagination_params(default_per_page=50)
    sb = get_supabase()

    # ── Likers ────────────────────────────────────────────────────────────────
    likes_res = (
        sb.table("observation_likes")
        .select("created_at, users(id, username, full_name, profile_image_url)")
        .eq("observation_id", obs_id)
        .order("created_at", desc=True)
        .execute()
    )
    likers = []
    for row in (likes_res.data or []):
        user_raw = row.get("users")
        if isinstance(user_raw, list):
            user_raw = user_raw[0] if user_raw else None
        if user_raw:
            likers.append({
                "user": {
                    "id": user_raw.get("id"),
                    "username": user_raw.get("username"),
                    "full_name": user_raw.get("full_name"),
                    "profile_image_url": user_raw.get("profile_image_url"),
                },
                "liked_at": row.get("created_at"),
            })

    # ── Comments ──────────────────────────────────────────────────────────────
    start = (page - 1) * per_page
    comments_res = (
        sb.table("observation_comments")
        .select("id, body, created_at, users(id, username, full_name, profile_image_url)",
                count="exact")
        .eq("observation_id", obs_id)
        .order("created_at", desc=False)   # oldest-first so threads read top-down
        .range(start, start + per_page - 1)
        .execute()
    )
    comments = []
    for row in (comments_res.data or []):
        user_raw = row.get("users")
        if isinstance(user_raw, list):
            user_raw = user_raw[0] if user_raw else None
        comments.append({
            "id": row["id"],
            "body": row["body"],
            "created_at": row.get("created_at"),
            "user": {
                "id": user_raw.get("id"),
                "username": user_raw.get("username"),
                "full_name": user_raw.get("full_name"),
                "profile_image_url": user_raw.get("profile_image_url"),
            } if user_raw else None,
        })

    return success_response(data={
        "like_count": len(likers),
        "likers": likers,
        "comment_count": comments_res.count or 0,
        "comments": comments,
    })
