"""Notification creation, listing, and FCM push dispatch — via Supabase PostgREST."""
import uuid
from datetime import datetime, timezone

from app.supabase_client import get_supabase


class NotificationError(Exception):
    def __init__(self, message: str, status_code: int = 400):
        self.message = message
        self.status_code = status_code
        super().__init__(message)


def _now() -> str:
    return datetime.now(timezone.utc).isoformat()


def _notif_to_dict(n: dict) -> dict:
    return {
        "id": n["id"],
        "type": n["type"],
        "title": n["title"],
        "body": n["body"],
        "data": n.get("data"),
        "is_read": n.get("is_read"),
        "created_at": n.get("created_at"),
    }


def _pref_to_dict(p: dict) -> dict:
    return {
        "identification_complete": p.get("identification_complete"),
        "new_species_nearby": p.get("new_species_nearby"),
        "admin_verification": p.get("admin_verification"),
        "educational_alerts": p.get("educational_alerts"),
        "events": p.get("events"),
    }


def _default_pref_row(user_id: str) -> dict:
    return {
        "user_id": user_id,
        "identification_complete": True,
        "new_species_nearby": True,
        "admin_verification": True,
        "educational_alerts": True,
        "events": True,
        "updated_at": _now(),
    }


def create_notification(
    user_id: str,
    notif_type: str,
    title: str,
    body: str,
    data: dict = None,
    send_push: bool = True,
) -> dict:
    """Create a DB notification and optionally send FCM push."""
    sb = get_supabase()
    notif_id = str(uuid.uuid4())
    res = sb.table("notifications").insert({
        "id": notif_id,
        "user_id": user_id,
        "type": notif_type,
        "title": title,
        "body": body,
        "data": data or {},
        "is_read": False,
        "created_at": _now(),
    }).execute()

    if send_push:
        push_data = dict(data or {})
        push_data["notification_id"] = notif_id
        _send_fcm(user_id, notif_type, title, body, push_data)

    return _notif_to_dict(res.data[0])


def notify_moderation(user_id: str, title: str, body: str, data: dict = None):
    """
    Best-effort "a moderator did X to you / your content" notification.
    Never raises — a notification failure must not break the admin action.
    """
    try:
        return create_notification(user_id, "admin_action", title, body, data=data)
    except Exception:
        import logging
        logging.getLogger(__name__).exception(
            "moderation notification failed for user %s", user_id)
        return None


def _send_fcm(user_id: str, notif_type: str, title: str, body: str, data: dict) -> None:
    """Send FCM push notification (Phase 3 will flesh this out fully)."""
    try:
        sb = get_supabase()
        res = sb.table("notification_preferences").select("*").eq("user_id", user_id).execute()
        pref = res.data[0] if res.data else None
        if not pref or not pref.get("fcm_token"):
            return

        # Check preference toggle
        toggle_map = {
            "identification_complete": pref.get("identification_complete"),
            "new_species_nearby": pref.get("new_species_nearby"),
            "admin_verification": pref.get("admin_verification"),
            # Moderation actions share the admin_verification push toggle.
            "admin_action": pref.get("admin_verification"),
            "educational_alert": pref.get("educational_alerts"),
            "event": pref.get("events"),
        }
        if not toggle_map.get(notif_type, True):
            return

        import firebase_admin
        from firebase_admin import messaging
        from flask import current_app

        # Initialize Firebase app once
        if not firebase_admin._apps:
            cred_path = current_app.config.get("FIREBASE_CREDENTIALS_PATH", "")
            server_key = current_app.config.get("FIREBASE_SERVER_KEY", "")
            if cred_path:
                import firebase_admin.credentials as creds
                firebase_admin.initialize_app(creds.Certificate(cred_path))
            elif server_key:
                # Legacy HTTP API — skip for now
                return
            else:
                return  # Not configured

        str_data = {k: str(v) for k, v in data.items()}
        message = messaging.Message(
            notification=messaging.Notification(title=title, body=body),
            data=str_data,
            token=pref["fcm_token"],
        )
        messaging.send(message)
    except Exception:
        pass  # Never let push failure break the main request


def list_notifications(user_id: str, page: int, per_page: int) -> tuple:
    sb = get_supabase()
    start = (page - 1) * per_page
    res = (
        sb.table("notifications").select("*", count="exact")
        .eq("user_id", user_id)
        .order("created_at", desc=True)
        .range(start, start + per_page - 1)
        .execute()
    )
    unread_count = (
        sb.table("notifications").select("id", count="exact", head=True)
        .eq("user_id", user_id).eq("is_read", False).execute().count or 0
    )
    return [_notif_to_dict(n) for n in res.data], res.count or 0, unread_count


def mark_read(notif_id: str, user_id: str) -> dict:
    sb = get_supabase()
    res = sb.table("notifications").select("id").eq("id", notif_id).eq("user_id", user_id).execute()
    if not res.data:
        raise NotificationError("Notification not found.", 404)
    updated = sb.table("notifications").update({"is_read": True}) \
        .eq("id", notif_id).eq("user_id", user_id).execute()
    return _notif_to_dict(updated.data[0])


def mark_all_read(user_id: str) -> int:
    sb = get_supabase()
    res = sb.table("notifications").update({"is_read": True}) \
        .eq("user_id", user_id).eq("is_read", False).execute()
    return len(res.data or [])


def get_preferences(user_id: str) -> dict:
    sb = get_supabase()
    res = sb.table("notification_preferences").select("*").eq("user_id", user_id).execute()
    if res.data:
        return _pref_to_dict(res.data[0])
    created = sb.table("notification_preferences").insert(_default_pref_row(user_id)).execute()
    return _pref_to_dict(created.data[0])


def update_preferences(user_id: str, data: dict) -> dict:
    sb = get_supabase()
    existing = sb.table("notification_preferences").select("id").eq("user_id", user_id).execute()

    fields = {}
    for field in (
        "identification_complete", "new_species_nearby",
        "admin_verification", "educational_alerts", "events",
    ):
        if field in data:
            fields[field] = data[field]

    if existing.data:
        if fields:
            fields["updated_at"] = _now()
            sb.table("notification_preferences").update(fields).eq("user_id", user_id).execute()
    else:
        row = _default_pref_row(user_id)
        row.update(fields)
        sb.table("notification_preferences").insert(row).execute()

    res = sb.table("notification_preferences").select("*").eq("user_id", user_id).execute()
    return _pref_to_dict(res.data[0])
