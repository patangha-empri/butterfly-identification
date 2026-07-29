"""User profile, stats, achievements, and FCM token management — via Supabase PostgREST."""
from datetime import datetime, timezone

from app.supabase_client import get_supabase
from app.services.user_repo import USER_SELECT, get_user_row, user_to_dict


class UserError(Exception):
    def __init__(self, message: str, status_code: int = 400):
        self.message = message
        self.status_code = status_code
        super().__init__(message)


def _now() -> str:
    return datetime.now(timezone.utc).isoformat()


def get_user_by_id(user_id: str, include_private: bool = False) -> dict:
    user = get_user_row(user_id)
    if not user:
        raise UserError("User not found.", 404)
    return user_to_dict(user, include_private=include_private)


def deactivate_account(user_id: str) -> None:
    """Soft-delete: deactivate the account and hide the user's content from the
    public feed. Reversible by support; login is blocked while inactive."""
    sb = get_supabase()
    user = get_user_row(user_id)
    if not user:
        raise UserError("User not found.", 404)
    sb.table("users").update({"is_active": False, "updated_at": _now()}).eq("id", user_id).execute()
    # Pull the user's observations out of public view.
    sb.table("observations").update({"privacy": "private", "updated_at": _now()}) \
        .eq("user_id", user_id).execute()


def get_user_by_username(username: str) -> dict:
    sb = get_supabase()
    res = sb.table("users").select(USER_SELECT).eq("username", username).eq("is_active", True).execute()
    if not res.data:
        raise UserError("User not found.", 404)
    return user_to_dict(res.data[0], include_private=False)


def update_profile(user_id: str, data: dict) -> dict:
    sb = get_supabase()
    user = get_user_row(user_id)
    if not user:
        raise UserError("User not found.", 404)

    update_fields = {}
    if "username" in data and data["username"] != user["username"]:
        existing = sb.table("users").select("id").eq("username", data["username"]).execute()
        if existing.data:
            raise UserError("Username is already taken.", 409)
        update_fields["username"] = data["username"]

    for field in ("full_name", "bio", "preferred_state_id"):
        if field in data:
            update_fields[field] = data[field]

    if update_fields:
        update_fields["updated_at"] = _now()
        sb.table("users").update(update_fields).eq("id", user_id).execute()

    return user_to_dict(get_user_row(user_id), include_private=True)


def update_profile_image(user_id: str, image_url: str) -> dict:
    sb = get_supabase()
    user = get_user_row(user_id)
    if not user:
        raise UserError("User not found.", 404)
    sb.table("users").update({"profile_image_url": image_url, "updated_at": _now()}) \
        .eq("id", user_id).execute()
    return user_to_dict(get_user_row(user_id), include_private=True)


def update_fcm_token(user_id: str, fcm_token: str) -> None:
    sb = get_supabase()
    pref = sb.table("notification_preferences").select("id").eq("user_id", user_id).execute()
    if pref.data:
        sb.table("notification_preferences").update({"fcm_token": fcm_token, "updated_at": _now()}) \
            .eq("user_id", user_id).execute()
    else:
        sb.table("notification_preferences").insert({
            "user_id": user_id, "fcm_token": fcm_token,
            "identification_complete": True, "new_species_nearby": True,
            "admin_verification": True, "educational_alerts": True, "events": True,
            "updated_at": _now(),
        }).execute()


def get_user_stats(user_id: str) -> dict:
    sb = get_supabase()
    stats_res = sb.table("user_stats").select("*").eq("user_id", user_id).execute()
    streak_res = sb.table("user_streaks").select("*").eq("user_id", user_id).execute()
    stats = stats_res.data[0] if stats_res.data else None
    streak = streak_res.data[0] if streak_res.data else None
    return {
        "stats": {
            "total_observations": stats["total_observations"],
            "total_identifications": stats["total_identifications"],
            "total_species_observed": stats["total_species_observed"],
            "total_states_explored": stats["total_states_explored"],
            "total_points": stats["total_points"],
        } if stats else {},
        "streak": {
            "current_streak": streak["current_streak"],
            "longest_streak": streak["longest_streak"],
            "last_observation_date": streak.get("last_observation_date"),
        } if streak else {},
    }


def get_user_achievements(user_id: str) -> list:
    sb = get_supabase()
    res = sb.table("user_achievements").select("*, achievement_definitions(*)") \
        .eq("user_id", user_id).execute()
    out = []
    for row in res.data:
        ach = row.get("achievement_definitions")
        if isinstance(ach, list):
            ach = ach[0] if ach else None
        out.append({
            "id": row["id"],
            "achievement": {
                "id": ach["id"],
                "name": ach["name"],
                "description": ach["description"],
                "badge_image_url": ach.get("badge_image_url"),
                "achievement_type": ach["achievement_type"],
                "threshold_value": ach["threshold_value"],
                "points": ach["points"],
            } if ach else None,
            "earned_at": row.get("earned_at"),
        })
    return out


def list_users_admin(page: int, per_page: int, filters: dict) -> tuple:
    """Admin: paginated user list with optional filters."""
    sb = get_supabase()
    query = sb.table("users").select(USER_SELECT, count="exact")

    if filters.get("search"):
        term = filters["search"]
        query = query.or_(
            f"username.ilike.%{term}%,email.ilike.%{term}%,full_name.ilike.%{term}%"
        )
    if filters.get("role"):
        role_res = sb.table("roles").select("id").eq("name", filters["role"]).execute()
        if role_res.data:
            query = query.eq("role_id", role_res.data[0]["id"])
    if filters.get("is_suspended") is not None:
        query = query.eq("is_suspended", filters["is_suspended"])

    start = (page - 1) * per_page
    res = query.order("created_at", desc=True).range(start, start + per_page - 1).execute()
    return [user_to_dict(u, include_private=True) for u in res.data], res.count or 0


def suspend_user(admin_id: str, target_id: str, suspend: bool, reason: str = None) -> dict:
    sb = get_supabase()
    user = get_user_row(target_id)
    if not user:
        raise UserError("User not found.", 404)
    if admin_id == target_id:
        raise UserError("Cannot suspend your own account.", 400)
    sb.table("users").update({
        "is_suspended": suspend,
        "suspension_reason": reason if suspend else None,
        "updated_at": _now(),
    }).eq("id", target_id).execute()

    from app.services.moderation_service import record_action, log_admin_activity
    try:
        record_action(admin_id, target_id,
                      "suspension" if suspend else "unsuspension", reason)
    except Exception:
        pass  # history is best-effort; the suspension itself already applied
    log_admin_activity(admin_id, "suspend_user" if suspend else "unsuspend_user",
                       reason or "", entity_type="User", entity_id=target_id)

    from app.services.notification_service import notify_moderation
    if suspend:
        body = "Your account has been suspended by a moderator."
        if reason:
            body += f" Reason: {reason}"
        notify_moderation(target_id, "Account suspended", body,
                          data={"action": "suspended"})
    else:
        notify_moderation(
            target_id, "Account reinstated",
            "Your account suspension has been lifted. Welcome back!",
            data={"action": "unsuspended"})

    return user_to_dict(get_user_row(target_id), include_private=True)


def change_user_role(admin_id: str, target_id: str, role_name: str) -> dict:
    sb = get_supabase()
    user = get_user_row(target_id)
    if not user:
        raise UserError("User not found.", 404)
    role_res = sb.table("roles").select("id").eq("name", role_name).execute()
    if not role_res.data:
        raise UserError(f"Role '{role_name}' not found.", 404)
    sb.table("users").update({"role_id": role_res.data[0]["id"], "updated_at": _now()}) \
        .eq("id", target_id).execute()

    from app.services.notification_service import notify_moderation
    notify_moderation(
        target_id, "Your role was updated",
        f"An admin changed your account role to '{role_name}'.",
        data={"action": "role_changed", "role": role_name})

    return user_to_dict(get_user_row(target_id), include_private=True)


def verify_user(target_id: str) -> dict:
    sb = get_supabase()
    user = get_user_row(target_id)
    if not user:
        raise UserError("User not found.", 404)
    sb.table("users").update({"is_verified": True, "updated_at": _now()}).eq("id", target_id).execute()
    return user_to_dict(get_user_row(target_id), include_private=True)
