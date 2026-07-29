"""User profile, stats, achievements, FCM token."""
from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_identity

from app.extensions import limiter
from app.schemas.user import UpdateProfileSchema, FCMTokenSchema
from app.services import user_service
from app.services.user_service import UserError
from app.utils.responses import success_response, error_response
from app.utils.validators import validate_image_file

users_bp = Blueprint("users", __name__)

_update_schema = UpdateProfileSchema()
_fcm_schema = FCMTokenSchema()


@users_bp.get("/me")
@jwt_required()
def get_my_profile():
    user_id = get_jwt_identity()
    try:
        data = user_service.get_user_by_id(user_id, include_private=True)
    except UserError as e:
        return error_response(e.message, e.status_code)
    # Surface active moderation warnings so the app can show a banner.
    try:
        from app.services.moderation_service import active_counts
        data["active_warnings"] = active_counts([user_id])[user_id]["warnings"]
    except Exception:
        data["active_warnings"] = 0  # table missing until migration 002 runs
    return success_response(data=data)


@users_bp.put("/me")
@jwt_required()
def update_my_profile():
    errors = _update_schema.validate(request.get_json(silent=True) or {})
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _update_schema.load(request.get_json())
    user_id = get_jwt_identity()
    try:
        updated = user_service.update_profile(user_id, data)
    except UserError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=updated, message="Profile updated.")


@users_bp.delete("/me")
@jwt_required()
def delete_my_account():
    """Soft-delete the current user's account (deactivate + hide content)."""
    user_id = get_jwt_identity()
    try:
        user_service.deactivate_account(user_id)
    except UserError as e:
        return error_response(e.message, e.status_code)
    return success_response(message="Account deleted.")


@users_bp.post("/me/avatar")
@jwt_required()
@limiter.limit("10 per hour")
def upload_avatar():
    file = request.files.get("image")
    ok, err = validate_image_file(file)
    if not ok:
        return error_response(err, 400)

    from app.services.storage_service import upload_file
    user_id = get_jwt_identity()
    urls = upload_file(file, folder=f"avatars/{user_id}")
    try:
        updated = user_service.update_profile_image(user_id, urls["optimized_url"])
    except UserError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=updated, message="Avatar updated.")


@users_bp.post("/me/fcm-token")
@jwt_required()
def register_fcm_token():
    errors = _fcm_schema.validate(request.get_json(silent=True) or {})
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _fcm_schema.load(request.get_json())
    user_id = get_jwt_identity()
    user_service.update_fcm_token(user_id, data["fcm_token"])
    return success_response(message="FCM token registered.")


@users_bp.get("/me/stats")
@jwt_required()
def get_my_stats():
    user_id = get_jwt_identity()
    stats = user_service.get_user_stats(user_id)
    return success_response(data=stats)


@users_bp.get("/me/achievements")
@jwt_required()
def get_my_achievements():
    user_id = get_jwt_identity()
    achievements = user_service.get_user_achievements(user_id)
    return success_response(data=achievements)


@users_bp.get("/<username>")
@jwt_required()
def get_public_profile(username):
    try:
        data = user_service.get_user_by_username(username)
    except UserError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=data)
