"""Authentication — register, login, token management — via Supabase PostgREST."""
import uuid
from datetime import datetime, timezone

from flask_jwt_extended import create_access_token, create_refresh_token
from postgrest.exceptions import APIError

from app.extensions import bcrypt
from app.supabase_client import get_supabase
from app.services.user_repo import (
    USER_SELECT, get_user_row, get_user_by_email, get_user_by_username, user_to_dict,
)


class AuthError(Exception):
    """Raised for expected auth failures (wrong password, duplicate email…)."""
    def __init__(self, message: str, status_code: int = 400):
        self.message = message
        self.status_code = status_code
        super().__init__(message)


def _now() -> str:
    return datetime.now(timezone.utc).isoformat()


def register(data: dict) -> dict:
    """
    Create a new user account. Returns the serialized user (private fields included).
    Raises AuthError on validation failures (duplicate email/username).
    """
    sb = get_supabase()
    email = data["email"].lower().strip()
    username = data["username"].strip()

    if get_user_by_email(email):
        raise AuthError("An account with this email already exists.", 409)
    if get_user_by_username(username):
        raise AuthError("This username is already taken.", 409)

    role_res = sb.table("roles").select("id").eq("name", "user").execute()
    if not role_res.data:
        raise AuthError("Default role not found. Run seed-roles first.", 500)
    role_id = role_res.data[0]["id"]

    now = _now()
    user_id = str(uuid.uuid4())
    row = {
        "id": user_id,
        "email": email,
        "password_hash": bcrypt.generate_password_hash(data["password"]).decode("utf-8"),
        "full_name": data["full_name"].strip(),
        "username": username,
        "role_id": role_id,
        "preferred_state_id": data.get("preferred_state_id"),
        "is_active": True,
        "is_verified": False,
        "is_suspended": False,
        "created_at": now,
        "updated_at": now,
    }
    try:
        sb.table("users").insert(row).execute()
    except APIError as e:
        # 23505 = unique violation — covers races the pre-checks missed
        if getattr(e, "code", None) == "23505":
            raise AuthError("An account with this email or username already exists.", 409)
        raise

    # ── Companion rows (DB has no server-side defaults — supply everything) ────
    sb.table("user_streaks").insert({
        "user_id": user_id, "current_streak": 0, "longest_streak": 0, "updated_at": now,
    }).execute()
    sb.table("user_stats").insert({
        "user_id": user_id, "total_observations": 0, "total_identifications": 0,
        "total_species_observed": 0, "total_states_explored": 0, "total_points": 0,
        "updated_at": now,
    }).execute()
    sb.table("notification_preferences").insert({
        "user_id": user_id, "identification_complete": True, "new_species_nearby": True,
        "admin_verification": True, "educational_alerts": True, "events": True,
        "updated_at": now,
    }).execute()

    user = get_user_row(user_id)
    return user_to_dict(user, include_private=True)


def login(email: str, password: str) -> dict:
    """
    Verify credentials and return JWT tokens + serialized user.
    Raises AuthError on failure.
    """
    email = email.lower().strip()
    user = get_user_by_email(email)

    if not user or not bcrypt.check_password_hash(user["password_hash"], password):
        raise AuthError("Invalid email or password.", 401)
    if not user.get("is_active"):
        raise AuthError("Account is deactivated.", 403)
    if user.get("is_suspended"):
        raise AuthError(f"Account is suspended. Reason: {user.get('suspension_reason') or 'N/A'}", 403)

    sb = get_supabase()
    sb.table("users").update({"last_login_at": _now()}).eq("id", user["id"]).execute()
    user["last_login_at"] = _now()

    return {
        "access_token": create_access_token(identity=user["id"]),
        "refresh_token": create_refresh_token(identity=user["id"]),
        "user": user_to_dict(user, include_private=True),
    }


def refresh_access_token(user_id: str) -> str:
    """Generate a new access token for an existing user."""
    user = get_user_row(user_id)
    if not user or not user.get("is_active") or user.get("is_suspended"):
        raise AuthError("Cannot refresh token for this account.", 401)
    return create_access_token(identity=user_id)


def change_password(user_id: str, current_password: str, new_password: str) -> None:
    """Verify current password then set new one."""
    user = get_user_row(user_id)
    if not user:
        raise AuthError("User not found.", 404)
    if not bcrypt.check_password_hash(user["password_hash"], current_password):
        raise AuthError("Current password is incorrect.", 400)
    sb = get_supabase()
    sb.table("users").update({
        "password_hash": bcrypt.generate_password_hash(new_password).decode("utf-8"),
        "updated_at": _now(),
    }).eq("id", user_id).execute()
