"""Moderation actions against users — warnings, flags, history — via Supabase PostgREST."""
import uuid
from datetime import datetime, timezone

from app.supabase_client import get_supabase
from app.services.user_repo import get_user_row


class ModerationError(Exception):
    def __init__(self, message: str, status_code: int = 400):
        self.message = message
        self.status_code = status_code
        super().__init__(message)


def _now() -> str:
    return datetime.now(timezone.utc).isoformat()


def _action_to_dict(row: dict, admins: dict = None) -> dict:
    admin = (admins or {}).get(row.get("admin_id"))
    return {
        "id": row["id"],
        "user_id": row["user_id"],
        "admin_id": row.get("admin_id"),
        "admin_username": admin.get("username") if admin else None,
        "admin_full_name": admin.get("full_name") if admin else None,
        "action_type": row["action_type"],
        "reason": row.get("reason"),
        "related_entity_type": row.get("related_entity_type"),
        "related_entity_id": row.get("related_entity_id"),
        "created_at": row.get("created_at"),
        "revoked_at": row.get("revoked_at"),
    }


def log_admin_activity(admin_id: str, action: str, description: str,
                       entity_type: str = None, entity_id: str = None) -> None:
    """Best-effort admin audit trail — never breaks the main request."""
    try:
        get_supabase().table("admin_activity_logs").insert({
            "admin_user_id": admin_id,
            "action": action,
            "description": description,
            "entity_type": entity_type,
            "entity_id": entity_id,
            "created_at": _now(),
        }).execute()
    except Exception:
        import logging
        logging.getLogger(__name__).exception("admin activity log failed")


def record_action(admin_id: str, user_id: str, action_type: str, reason: str = None,
                  related_entity_type: str = None, related_entity_id: str = None) -> dict:
    """Insert a moderation action row (no notification — callers decide)."""
    sb = get_supabase()
    row = {
        "id": str(uuid.uuid4()),
        "user_id": user_id,
        "admin_id": admin_id,
        "action_type": action_type,
        "reason": reason,
        "related_entity_type": related_entity_type,
        "related_entity_id": related_entity_id,
        "created_at": _now(),
    }
    try:
        res = sb.table("user_moderation_actions").insert(row).execute()
    except Exception as e:
        if _table_missing(e):
            raise ModerationError(
                "Moderation storage is not set up — run migration "
                "002_user_moderation_actions.sql in the Supabase SQL editor.", 500)
        raise
    return _action_to_dict(res.data[0])


def _table_missing(exc: Exception) -> bool:
    """PostgREST 'table not in schema cache' (migration 002 not applied yet)."""
    return "PGRST205" in str(exc) or "user_moderation_actions" in str(exc)


def warn_user(admin_id: str, user_id: str, reason: str) -> dict:
    """User-visible warning: recorded + the user is notified."""
    if not get_user_row(user_id):
        raise ModerationError("User not found.", 404)
    if admin_id == user_id:
        raise ModerationError("Cannot warn your own account.", 400)

    action = record_action(admin_id, user_id, "warning", reason)
    log_admin_activity(admin_id, "warn_user", f"Warned user: {reason}",
                       entity_type="User", entity_id=user_id)

    from app.services.notification_service import notify_moderation
    notify_moderation(
        user_id,
        "⚠️ You received a warning",
        f"The moderation team issued a warning on your account: {reason} "
        "Repeated violations may lead to suspension.",
        data={"action": "warning", "moderation_action_id": action["id"]},
    )
    return action


def flag_user(admin_id: str, user_id: str, reason: str) -> dict:
    """Flag a user: recorded + the user is notified."""
    if not get_user_row(user_id):
        raise ModerationError("User not found.", 404)

    action = record_action(admin_id, user_id, "flag", reason)
    log_admin_activity(admin_id, "flag_user", f"Flagged user: {reason}",
                       entity_type="User", entity_id=user_id)

    from app.services.notification_service import notify_moderation
    notify_moderation(
        user_id,
        "⚠️ Account Warning",
        f"Your account has been flagged: {reason}",
        data={"action": "flag", "moderation_action_id": action["id"]},
    )
    return action


def list_history(user_id: str) -> list:
    """Full moderation timeline for one user, newest first."""
    sb = get_supabase()
    try:
        res = sb.table("user_moderation_actions").select("*") \
            .eq("user_id", user_id).order("created_at", desc=True).limit(500).execute()
    except Exception as e:
        if _table_missing(e):
            return []  # migration 002 not applied yet — show an empty timeline
        raise
    rows = res.data or []

    # Resolve admin names in one batch.
    admin_ids = list({r["admin_id"] for r in rows if r.get("admin_id")})
    admins = {}
    if admin_ids:
        a_res = sb.table("users").select("id, username, full_name") \
            .in_("id", admin_ids).execute()
        admins = {a["id"]: a for a in a_res.data or []}
    return [_action_to_dict(r, admins) for r in rows]


def revoke_action(admin_id: str, action_id: str) -> dict:
    sb = get_supabase()
    try:
        res = sb.table("user_moderation_actions").select("*").eq("id", action_id).execute()
    except Exception as e:
        if _table_missing(e):
            raise ModerationError(
                "Moderation storage is not set up — run migration "
                "002_user_moderation_actions.sql in the Supabase SQL editor.", 500)
        raise
    if not res.data:
        raise ModerationError("Moderation action not found.", 404)
    if res.data[0].get("revoked_at"):
        raise ModerationError("Action is already revoked.", 400)

    updated = sb.table("user_moderation_actions").update({"revoked_at": _now()}) \
        .eq("id", action_id).execute()
    log_admin_activity(admin_id, "revoke_moderation_action",
                       f"Revoked {res.data[0]['action_type']}",
                       entity_type="UserModerationAction", entity_id=action_id)
    return _action_to_dict(updated.data[0])


def active_counts(user_ids: list) -> dict:
    """
    Batch: {user_id: {"warnings": n, "flags": n}} for non-revoked actions.
    Used to badge the admin user list without N+1 queries.
    """
    counts = {uid: {"warnings": 0, "flags": 0} for uid in user_ids}
    if not user_ids:
        return counts
    sb = get_supabase()
    try:
        res = sb.table("user_moderation_actions").select("user_id, action_type") \
            .in_("user_id", user_ids).is_("revoked_at", "null") \
            .in_("action_type", ["warning", "flag"]).execute()
    except Exception:
        # Never let badge counters break user listings (e.g. migration 002
        # not applied yet) — degrade to zeros.
        import logging
        logging.getLogger(__name__).exception("moderation counts unavailable")
        return counts
    for row in res.data or []:
        bucket = counts.setdefault(row["user_id"], {"warnings": 0, "flags": 0})
        if row["action_type"] == "warning":
            bucket["warnings"] += 1
        else:
            bucket["flags"] += 1
    return counts
