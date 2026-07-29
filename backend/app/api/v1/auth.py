"""Authentication endpoints — register, login, refresh, me."""
from flask import Blueprint, request
# pyright: ignore [reportMissingImports]
from flask_jwt_extended import jwt_required, get_jwt_identity

from app.extensions import limiter
from app.schemas.user import RegisterSchema, LoginSchema, ChangePasswordSchema
from app.services import auth_service
from app.utils.responses import success_response, error_response

auth_bp = Blueprint("auth", __name__)

_register_schema = RegisterSchema()
_login_schema = LoginSchema()
_change_password_schema = ChangePasswordSchema()


@auth_bp.post("/register")
@limiter.limit("10 per hour")
def register():
    """Create a new user account."""
    errors = _register_schema.validate(request.get_json(silent=True) or {})
    if errors:
        return error_response("Validation failed.", 422, errors=errors)

    data = _register_schema.load(request.get_json())
    try:
        user = auth_service.register(data)
    except auth_service.AuthError as e:
        return error_response(e.message, e.status_code)

    # pyright: ignore [reportMissingImports]
    from flask_jwt_extended import create_access_token, create_refresh_token
    access_token = create_access_token(identity=user["id"])
    refresh_token = create_refresh_token(identity=user["id"])

    return success_response(
        data={
            "access_token": access_token,
            "refresh_token": refresh_token,
            "user": user,
        },
        message="Account created successfully.",
        status_code=201,
    )


@auth_bp.post("/login")
@limiter.limit("20 per hour")
def login():
    """Authenticate and return JWT tokens."""
    errors = _login_schema.validate(request.get_json(silent=True) or {})
    if errors:
        return error_response("Validation failed.", 422, errors=errors)

    data = _login_schema.load(request.get_json())
    try:
        result = auth_service.login(data["email"], data["password"])
    except auth_service.AuthError as e:
        return error_response(e.message, e.status_code)

    return success_response(data={
        "access_token": result["access_token"],
        "refresh_token": result["refresh_token"],
        "user": result["user"],
    })


@auth_bp.post("/refresh")
@jwt_required(refresh=True)
def refresh():
    """Exchange a refresh token for a new access token."""
    user_id = get_jwt_identity()
    try:
        access_token = auth_service.refresh_access_token(user_id)
    except auth_service.AuthError as e:
        return error_response(e.message, e.status_code)
    return success_response(data={"access_token": access_token})


@auth_bp.get("/me")
@jwt_required()
def me():
    """Return the currently authenticated user."""
    user_id = get_jwt_identity()
    from app.services.user_repo import get_user_row, user_to_dict
    user = get_user_row(user_id)
    if not user:
        return error_response("User not found.", 404)
    return success_response(data=user_to_dict(user, include_private=True))


@auth_bp.post("/change-password")
@jwt_required()
@limiter.limit("5 per hour")
def change_password():
    """Change the current user's password."""
    errors = _change_password_schema.validate(request.get_json(silent=True) or {})
    if errors:
        return error_response("Validation failed.", 422, errors=errors)

    data = _change_password_schema.load(request.get_json())
    user_id = get_jwt_identity()
    try:
        auth_service.change_password(user_id, data["current_password"], data["new_password"])
    except auth_service.AuthError as e:
        return error_response(e.message, e.status_code)
    return success_response(message="Password changed successfully.")


@auth_bp.post("/logout")
@jwt_required()
def logout():
    """Client should discard tokens. Server-side revocation is stateless here."""
    return success_response(message="Logged out successfully.")
