"""Notification listing, read status, and preferences."""
from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt_identity

from app.schemas.notification import NotificationPreferenceSchema
from app.services import notification_service
from app.services.notification_service import NotificationError
from app.utils.pagination import get_pagination_params
from app.utils.responses import success_response, error_response, paginated_response

notifications_bp = Blueprint("notifications", __name__)

_pref_schema = NotificationPreferenceSchema()


@notifications_bp.get("/")
@jwt_required()
def list_notifications():
    user_id = get_jwt_identity()
    page, per_page = get_pagination_params(default_per_page=30)
    items, total, unread_count = notification_service.list_notifications(user_id, page, per_page)
    resp = paginated_response(items, total, page, per_page)
    # Inject unread_count into the meta
    data = resp[0].get_json()
    data["meta"]["unread_count"] = unread_count
    from flask import jsonify
    return jsonify(data), resp[1]


@notifications_bp.patch("/<notif_id>/read")
@jwt_required()
def mark_read(notif_id):
    user_id = get_jwt_identity()
    try:
        notif = notification_service.mark_read(notif_id, user_id)
    except NotificationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=notif)


@notifications_bp.post("/read-all")
@jwt_required()
def mark_all_read():
    user_id = get_jwt_identity()
    count = notification_service.mark_all_read(user_id)
    return success_response(message=f"{count} notifications marked as read.")


@notifications_bp.get("/preferences")
@jwt_required()
def get_preferences():
    user_id = get_jwt_identity()
    prefs = notification_service.get_preferences(user_id)
    return success_response(data=prefs)


@notifications_bp.put("/preferences")
@jwt_required()
def update_preferences():
    body = request.get_json(silent=True) or {}
    errors = _pref_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _pref_schema.load(body)
    user_id = get_jwt_identity()
    prefs = notification_service.update_preferences(user_id, data)
    return success_response(data=prefs)
