"""Admin — user management."""
from flask import Blueprint, request
from flask_jwt_extended import get_jwt_identity

from app.schemas.admin import (
    SuspendUserSchema, ChangeRoleSchema, WarnUserSchema, FlagUserSchema,
)
from app.services import user_service, moderation_service
from app.services.user_service import UserError
from app.services.moderation_service import ModerationError
from app.utils.decorators import admin_required, moderator_required
from app.utils.pagination import get_pagination_params
from app.utils.responses import success_response, error_response, paginated_response

admin_users_bp = Blueprint("admin_users", __name__)

_suspend_schema = SuspendUserSchema()
_role_schema = ChangeRoleSchema()
_warn_schema = WarnUserSchema()
_flag_schema = FlagUserSchema()


@admin_users_bp.get("/")
@admin_required
def list_users():
    page, per_page = get_pagination_params()
    filters = {
        "search": request.args.get("search"),
        "role": request.args.get("role"),
        "is_suspended": (
            request.args.get("is_suspended", "").lower() == "true"
            if request.args.get("is_suspended") is not None
            else None
        ),
    }
    filters = {k: v for k, v in filters.items() if v is not None}
    items, total = user_service.list_users_admin(page, per_page, filters)
    # Badge active warnings/flags on the list (one batched query for the page).
    counts = moderation_service.active_counts([u["id"] for u in items])
    for u in items:
        u["active_warnings"] = counts.get(u["id"], {}).get("warnings", 0)
        u["active_flags"] = counts.get(u["id"], {}).get("flags", 0)
    return paginated_response(items, total, page, per_page)


@admin_users_bp.get("/<user_id>")
@admin_required
def get_user(user_id):
    try:
        data = user_service.get_user_by_id(user_id, include_private=True)
    except UserError as e:
        return error_response(e.message, e.status_code)
    # The admin detail view shows activity stats and streaks alongside the profile.
    activity = user_service.get_user_stats(user_id)
    data["stats"] = activity["stats"]
    data["streak"] = activity["streak"]
    counts = moderation_service.active_counts([user_id]).get(user_id, {})
    data["active_warnings"] = counts.get("warnings", 0)
    data["active_flags"] = counts.get("flags", 0)
    return success_response(data=data)


@admin_users_bp.patch("/<user_id>/suspend")
@admin_required
def suspend_user(user_id):
    body = request.get_json(silent=True) or {}
    errors = _suspend_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _suspend_schema.load(body)
    admin_id = get_jwt_identity()
    try:
        updated = user_service.suspend_user(
            admin_id, user_id, data["suspend"], data.get("reason")
        )
    except UserError as e:
        return error_response(e.message, e.status_code)
    action = "suspended" if data["suspend"] else "unsuspended"
    return success_response(data=updated, message=f"User {action}.")


@admin_users_bp.patch("/<user_id>/role")
@admin_required
def change_role(user_id):
    body = request.get_json(silent=True) or {}
    errors = _role_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _role_schema.load(body)
    admin_id = get_jwt_identity()
    try:
        updated = user_service.change_user_role(admin_id, user_id, data["role"])
    except UserError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=updated, message="Role updated.")


@admin_users_bp.patch("/<user_id>/verify")
@admin_required
def verify_user(user_id):
    try:
        updated = user_service.verify_user(user_id)
    except UserError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=updated, message="User verified.")


# ── Moderation: warnings, flags, history ───────────────────────────────────────

@admin_users_bp.post("/<user_id>/warn")
@moderator_required
def warn_user(user_id):
    body = request.get_json(silent=True) or {}
    errors = _warn_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _warn_schema.load(body)
    admin_id = get_jwt_identity()
    try:
        action = moderation_service.warn_user(admin_id, user_id, data["reason"])
    except ModerationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=action, message="Warning issued and user notified.")


@admin_users_bp.post("/<user_id>/flag")
@moderator_required
def flag_user(user_id):
    body = request.get_json(silent=True) or {}
    errors = _flag_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _flag_schema.load(body)
    admin_id = get_jwt_identity()
    try:
        action = moderation_service.flag_user(admin_id, user_id, data["reason"])
    except ModerationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=action, message="User flagged (internal only).")


@admin_users_bp.get("/<user_id>/moderation-history")
@moderator_required
def moderation_history(user_id):
    try:
        items = moderation_service.list_history(user_id)
    except ModerationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=items)


@admin_users_bp.delete("/moderation-actions/<action_id>")
@moderator_required
def revoke_moderation_action(action_id):
    admin_id = get_jwt_identity()
    try:
        action = moderation_service.revoke_action(admin_id, action_id)
    except ModerationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=action, message="Moderation action revoked.")
