"""Shared user lookups via Supabase PostgREST.

Used by auth_service, decorators, and routes that previously did
`User.query...` directly. Rows come back as plain dicts with the role
embedded under "roles" (PostgREST relation syntax).
"""
from app.supabase_client import get_supabase

USER_SELECT = "*, roles(name)"


def get_user_row(user_id: str) -> dict | None:
    sb = get_supabase()
    res = sb.table("users").select(USER_SELECT).eq("id", user_id).execute()
    return res.data[0] if res.data else None


def get_user_by_email(email: str) -> dict | None:
    sb = get_supabase()
    res = sb.table("users").select(USER_SELECT).eq("email", email).execute()
    return res.data[0] if res.data else None


def get_user_by_username(username: str) -> dict | None:
    sb = get_supabase()
    res = sb.table("users").select(USER_SELECT).eq("username", username).execute()
    return res.data[0] if res.data else None


def role_name(row: dict) -> str | None:
    return (row.get("roles") or {}).get("name")


def user_to_dict(row: dict, include_private: bool = False) -> dict:
    """Mirror User.to_dict() so API responses keep the same shape."""
    data = {
        "id": row["id"],
        "username": row["username"],
        "full_name": row["full_name"],
        "profile_image_url": row.get("profile_image_url"),
        "bio": row.get("bio"),
        "is_verified": row.get("is_verified"),
        "role": role_name(row),
        "preferred_state_id": row.get("preferred_state_id"),
        "created_at": row.get("created_at"),
    }
    if include_private:
        data.update({
            "email": row["email"],
            "is_active": row.get("is_active"),
            "is_suspended": row.get("is_suspended"),
            "last_login_at": row.get("last_login_at"),
        })
    return data
