"""API v1 blueprint — aggregates all sub-blueprints."""
from flask import Blueprint, jsonify

api_v1_bp = Blueprint("api_v1", __name__)

# ── Import and register all sub-blueprints ─────────────────────────────────────
from app.api.v1.auth import auth_bp
from app.api.v1.users import users_bp
from app.api.v1.species import species_bp
from app.api.v1.geography import geography_bp
from app.api.v1.observations import observations_bp
from app.api.v1.identifications import identifications_bp
from app.api.v1.notifications import notifications_bp
from app.api.v1.gamification import gamification_bp
from app.api.v1.cms import cms_bp
from app.api.v1.admin import admin_bp

api_v1_bp.register_blueprint(auth_bp,            url_prefix="/auth")
api_v1_bp.register_blueprint(users_bp,           url_prefix="/users")
api_v1_bp.register_blueprint(species_bp,         url_prefix="/species")
api_v1_bp.register_blueprint(geography_bp,       url_prefix="/geography")
api_v1_bp.register_blueprint(observations_bp,    url_prefix="/observations")
api_v1_bp.register_blueprint(identifications_bp, url_prefix="/identifications")
api_v1_bp.register_blueprint(notifications_bp,   url_prefix="/notifications")
api_v1_bp.register_blueprint(gamification_bp,    url_prefix="/gamification")
api_v1_bp.register_blueprint(cms_bp,             url_prefix="/cms")
api_v1_bp.register_blueprint(admin_bp,           url_prefix="/admin")


# ── Global JSON error handlers ─────────────────────────────────────────────────
@api_v1_bp.app_errorhandler(404)
def not_found(e):
    return jsonify({"success": False, "message": "Endpoint not found."}), 404


@api_v1_bp.app_errorhandler(405)
def method_not_allowed(e):
    return jsonify({"success": False, "message": "Method not allowed."}), 405


@api_v1_bp.app_errorhandler(413)
def payload_too_large(e):
    return jsonify({"success": False, "message": "File too large. Maximum 10 MB."}), 413


@api_v1_bp.app_errorhandler(429)
def rate_limit_exceeded(e):
    # flask-limiter puts a custom error_message in e.description; without one,
    # the description is just the raw limit string (e.g. "200 per 1 hour").
    import re
    desc = str(getattr(e, "description", "") or "")
    if desc and not re.match(r"^\d+ per ", desc):
        message = desc
    else:
        message = "Too many requests. Slow down."
    return jsonify({"success": False, "message": message}), 429


@api_v1_bp.app_errorhandler(500)
def internal_error(e):
    return jsonify({"success": False, "message": "Internal server error."}), 500
