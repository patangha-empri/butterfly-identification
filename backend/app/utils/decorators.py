"""Role-based access control decorators."""
from functools import wraps
from flask_jwt_extended import verify_jwt_in_request, get_jwt_identity
from app.utils.responses import error_response


def roles_required(*roles):
    """Decorator: require JWT + one of the listed role names."""
    def decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            verify_jwt_in_request()
            from app.services.user_repo import get_user_row, role_name
            user_id = get_jwt_identity()
            user = get_user_row(user_id)
            if not user or not user.get("is_active"):
                return error_response("Account not found or inactive.", 401)
            if user.get("is_suspended"):
                return error_response("Account is suspended.", 403)
            if role_name(user) not in roles:
                return error_response("Insufficient permissions.", 403)
            return fn(*args, **kwargs)
        return wrapper
    return decorator


def admin_required(fn):
    """Shortcut: admin or super_admin only."""
    return roles_required("admin", "super_admin")(fn)


def moderator_required(fn):
    """Shortcut: moderator, admin, or super_admin."""
    return roles_required("moderator", "admin", "super_admin")(fn)


def active_user_required(fn):
    """Shortcut: any active, non-suspended user (all roles)."""
    return roles_required("user", "moderator", "admin", "super_admin")(fn)
