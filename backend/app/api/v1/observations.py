"""Observation CRUD, images, privacy, share links, public feed."""
import uuid
from datetime import datetime, timezone

from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_identity

from app.extensions import limiter
from app.supabase_client import get_supabase
from app.schemas.observation import CreateObservationSchema, UpdateObservationSchema, PrivacyUpdateSchema
from app.services import observation_service
from app.services.observation_service import ObservationError
from app.utils.pagination import get_pagination_params
from app.utils.responses import success_response, error_response, paginated_response
from app.utils.validators import validate_image_file

observations_bp = Blueprint("observations", __name__)

_create_schema = CreateObservationSchema()
_update_schema = UpdateObservationSchema()
_privacy_schema = PrivacyUpdateSchema()


# ── Public feed (no auth required) ────────────────────────────────────────────

@observations_bp.get("/feed")
@jwt_required(optional=True)
def public_feed():
    page, per_page = get_pagination_params()
    filters = {
        "state_id": request.args.get("state_id", type=int),
        "species_id": request.args.get("species_id"),
        "verification_status": request.args.get("verification_status"),
        "privacy": request.args.get("privacy"),
    }
    filters = {k: v for k, v in filters.items() if v is not None}
    current_user_id = get_jwt_identity()
    items, total = observation_service.list_public_feed(
        page, per_page, filters, current_user_id=current_user_id
    )
    return paginated_response(items, total, page, per_page)


@observations_bp.get("/shared/<token>")
def get_shared(token):
    try:
        data = observation_service.get_by_share_token(token)
    except ObservationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=data)


# ── Authenticated endpoints ────────────────────────────────────────────────────

@observations_bp.post("/")
@jwt_required()
@limiter.limit("100 per day")
def create_observation():
    body = request.get_json(silent=True) or {}
    errors = _create_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _create_schema.load(body)
    user_id = get_jwt_identity()
    try:
        obs = observation_service.create_observation(user_id, data)
    except ObservationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=obs, status_code=201)


@observations_bp.get("/")
@jwt_required()
def list_my_observations():
    user_id = get_jwt_identity()
    page, per_page = get_pagination_params()
    filters = {
        "state_id": request.args.get("state_id", type=int),
        "species_id": request.args.get("species_id"),
        "verification_status": request.args.get("verification_status"),
    }
    filters = {k: v for k, v in filters.items() if v is not None}
    items, total = observation_service.list_user_observations(user_id, user_id, page, per_page, filters)
    return paginated_response(items, total, page, per_page)


@observations_bp.get("/user/<user_id>")
@jwt_required()
def list_user_observations(user_id):
    requesting_user_id = get_jwt_identity()
    page, per_page = get_pagination_params()
    filters = {
        "state_id": request.args.get("state_id", type=int),
        "species_id": request.args.get("species_id"),
    }
    filters = {k: v for k, v in filters.items() if v is not None}
    items, total = observation_service.list_user_observations(
        user_id, requesting_user_id, page, per_page, filters
    )
    return paginated_response(items, total, page, per_page)


@observations_bp.get("/<obs_id>")
@jwt_required()
def get_observation(obs_id):
    user_id = get_jwt_identity()
    try:
        data = observation_service.get_observation(obs_id, user_id)
    except ObservationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=data)


@observations_bp.put("/<obs_id>")
@jwt_required()
def update_observation(obs_id):
    body = request.get_json(silent=True) or {}
    errors = _update_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _update_schema.load(body)
    user_id = get_jwt_identity()
    try:
        obs = observation_service.update_observation(obs_id, user_id, data)
    except ObservationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=obs)


@observations_bp.delete("/<obs_id>")
@jwt_required()
def delete_observation(obs_id):
    user_id = get_jwt_identity()
    # Optional reason (used by moderators; forwarded to the owner's notification).
    reason = (request.get_json(silent=True) or {}).get("reason")
    try:
        observation_service.delete_observation(obs_id, user_id, reason=reason)
    except ObservationError as e:
        return error_response(e.message, e.status_code)
    return success_response(message="Observation deleted.")


@observations_bp.patch("/<obs_id>/privacy")
@jwt_required()
def update_privacy(obs_id):
    body = request.get_json(silent=True) or {}
    errors = _privacy_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _privacy_schema.load(body)
    user_id = get_jwt_identity()
    try:
        obs = observation_service.update_privacy(obs_id, user_id, data["privacy"])
    except ObservationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=obs)


@observations_bp.post("/<obs_id>/share")
@jwt_required()
def create_share_link(obs_id):
    user_id = get_jwt_identity()
    try:
        share = observation_service.get_or_create_share_link(obs_id, user_id)
    except ObservationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=share)


# ── Image management ───────────────────────────────────────────────────────────

@observations_bp.post("/<obs_id>/images")
@jwt_required()
@limiter.limit("50 per hour")
def add_image(obs_id):
    file = request.files.get("image")
    ok, err = validate_image_file(file)
    if not ok:
        return error_response(err, 400)
    user_id = get_jwt_identity()
    try:
        img = observation_service.add_image(obs_id, user_id, file)
    except ObservationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=img, status_code=201)


@observations_bp.delete("/<obs_id>/images/<image_id>")
@jwt_required()
def delete_image(obs_id, image_id):
    user_id = get_jwt_identity()
    try:
        observation_service.delete_image(obs_id, image_id, user_id)
    except ObservationError as e:
        return error_response(e.message, e.status_code)
    return success_response(message="Image removed.")


# ── Social: likes & comments ───────────────────────────────────────────────────

@observations_bp.post("/<obs_id>/like")
@jwt_required()
def toggle_like(obs_id):
    user_id = get_jwt_identity()
    sb = get_supabase()
    obs = sb.table("observations").select("id, user_id, verification_status") \
        .eq("id", obs_id).eq("is_active", True).execute()
    if not obs.data:
        return error_response("Observation not found.", 404)
    # Rejected sightings are hidden from the community — no interactions.
    if obs.data[0].get("verification_status") == "rejected" and obs.data[0]["user_id"] != user_id:
        return error_response("Observation not found.", 404)
    existing = sb.table("observation_likes").select("id") \
        .eq("observation_id", obs_id).eq("user_id", user_id).execute()
    if existing.data:
        sb.table("observation_likes").delete().eq("id", existing.data[0]["id"]).execute()
        liked = False
    else:
        sb.table("observation_likes").insert({
            "observation_id": obs_id,
            "user_id": user_id,
            "created_at": datetime.now(timezone.utc).isoformat(),
        }).execute()
        liked = True
    count = sb.table("observation_likes").select("id", count="exact", head=True) \
        .eq("observation_id", obs_id).execute().count or 0
    return success_response(data={"liked": liked, "like_count": count})


def _comment_to_dict(c: dict) -> dict:
    user = c.get("users")
    if isinstance(user, list):
        user = user[0] if user else None
    return {
        "id": c["id"],
        "body": c["body"],
        "created_at": c.get("created_at"),
        "user": {
            "id": user["id"],
            "username": user["username"],
            "full_name": user["full_name"],
            "profile_image_url": user.get("profile_image_url"),
        } if user else None,
    }


@observations_bp.get("/<obs_id>/comments")
@jwt_required(optional=True)
def list_comments(obs_id):
    page, per_page = get_pagination_params()
    sb = get_supabase()
    start = (page - 1) * per_page
    res = (
        sb.table("observation_comments")
        .select("*, users(id, username, full_name, profile_image_url)", count="exact")
        .eq("observation_id", obs_id)
        .order("created_at", desc=True)
        .range(start, start + per_page - 1)
        .execute()
    )
    return paginated_response([_comment_to_dict(c) for c in res.data], res.count or 0, page, per_page)


@observations_bp.post("/<obs_id>/comments")
@jwt_required()
@limiter.limit("60 per hour")
def add_comment(obs_id):
    user_id = get_jwt_identity()
    body = ((request.get_json(silent=True) or {}).get("body") or "").strip()
    if not body:
        return error_response("Comment cannot be empty.", 422)
    if len(body) > 1000:
        return error_response("Comment is too long (max 1000 characters).", 422)
    sb = get_supabase()
    obs = sb.table("observations").select("id, user_id, verification_status") \
        .eq("id", obs_id).eq("is_active", True).execute()
    if not obs.data:
        return error_response("Observation not found.", 404)
    # Rejected sightings are hidden from the community — no interactions.
    if obs.data[0].get("verification_status") == "rejected" and obs.data[0]["user_id"] != user_id:
        return error_response("Observation not found.", 404)
    comment_id = str(uuid.uuid4())
    sb.table("observation_comments").insert({
        "id": comment_id,
        "observation_id": obs_id,
        "user_id": user_id,
        "body": body,
        "created_at": datetime.now(timezone.utc).isoformat(),
    }).execute()
    res = (
        sb.table("observation_comments")
        .select("*, users(id, username, full_name, profile_image_url)")
        .eq("id", comment_id)
        .execute()
    )
    return success_response(data=_comment_to_dict(res.data[0]), status_code=201)


@observations_bp.delete("/<obs_id>/comments/<comment_id>")
@jwt_required()
def delete_comment(obs_id, comment_id):
    user_id = get_jwt_identity()
    sb = get_supabase()
    res = sb.table("observation_comments").select("id, user_id") \
        .eq("id", comment_id).eq("observation_id", obs_id).execute()
    if not res.data:
        return error_response("Comment not found.", 404)
    comment_owner = res.data[0]["user_id"]
    is_own = comment_owner == user_id
    if not is_own:
        from app.services.observation_service import _is_staff
        if not _is_staff(user_id):
            return error_response("You can only delete your own comments.", 403)
    sb.table("observation_comments").delete().eq("id", comment_id).execute()

    # Staff removing someone else's comment → record + notify.
    if not is_own:
        from app.services.moderation_service import record_action, log_admin_activity
        try:
            record_action(user_id, comment_owner, "content_removed",
                          "Comment removed by a moderator.",
                          related_entity_type="ObservationComment",
                          related_entity_id=comment_id)
        except Exception:
            pass
        log_admin_activity(user_id, "delete_comment", "",
                           entity_type="ObservationComment", entity_id=comment_id)
        from app.services.notification_service import notify_moderation
        notify_moderation(
            comment_owner,
            "Your comment was removed",
            "A moderator removed one of your comments for violating "
            "community guidelines.",
            data={"observation_id": obs_id, "action": "comment_deleted"},
        )
    return success_response(message="Comment deleted.")
