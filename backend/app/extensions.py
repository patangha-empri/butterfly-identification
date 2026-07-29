"""
Flask extensions — initialized here, bound to the app in create_app().
Import from here anywhere in the project to avoid circular imports.
"""
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_jwt_extended import JWTManager
from flask_bcrypt import Bcrypt
from flask_cors import CORS
from flask_marshmallow import Marshmallow
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

db = SQLAlchemy()
migrate = Migrate()
jwt = JWTManager()
bcrypt = Bcrypt()
cors = CORS()
ma = Marshmallow()
limiter = Limiter(key_func=get_remote_address, default_limits=["1000 per day", "200 per hour"])


def rate_limit_key_by_user():
    """
    Rate-limit key: the authenticated user's id, so limits follow the account
    across devices/IPs. Falls back to the remote IP when no valid JWT is present
    (those requests get rejected by @jwt_required anyway).
    """
    # pyrefly: ignore [missing-import]
    from flask_jwt_extended import verify_jwt_in_request, get_jwt_identity
    try:
        verify_jwt_in_request(optional=True)
        identity = get_jwt_identity()
        if identity:
            return f"user:{identity}"
    except Exception:
        pass
    return get_remote_address()
