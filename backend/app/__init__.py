from flask import Flask
from config import get_config
from app.extensions import db, migrate, jwt, bcrypt, cors, ma, limiter


def create_app(config_class=None):
    """Flask application factory."""
    app = Flask(__name__)

    # ── Load config ────────────────────────────────────────────────────────────
    if config_class is None:
        config_class = get_config()
    app.config.from_object(config_class)

    # ── Initialize extensions ──────────────────────────────────────────────────
    db.init_app(app)
    migrate.init_app(app, db)
    jwt.init_app(app)
    bcrypt.init_app(app)
    cors.init_app(app, resources={r"/api/*": {"origins": app.config.get("CORS_ORIGINS", "*")}})
    ma.init_app(app)
    limiter.init_app(app)

    with app.app_context():
        from app import models  # noqa: F401 — registers all ORM models

    # ── Register API blueprints ────────────────────────────────────────────────
    from app.api.v1 import api_v1_bp
    app.register_blueprint(api_v1_bp, url_prefix="/api/v1")

    # ── JWT error handlers ─────────────────────────────────────────────────────
    from flask import jsonify
    from flask_jwt_extended.exceptions import NoAuthorizationError, InvalidHeaderError

    @jwt.unauthorized_loader
    def missing_token(reason):
        return jsonify({"success": False, "message": f"Missing token: {reason}"}), 401

    @jwt.invalid_token_loader
    def invalid_token(reason):
        return jsonify({"success": False, "message": f"Invalid token: {reason}"}), 422

    @jwt.expired_token_loader
    def expired_token(jwt_header, jwt_data):
        return jsonify({"success": False, "message": "Token has expired."}), 401

    @jwt.revoked_token_loader
    def revoked_token(jwt_header, jwt_data):
        return jsonify({"success": False, "message": "Token has been revoked."}), 401

    # ── Health check ───────────────────────────────────────────────────────────
    @app.route("/health")
    def health():
        return {"status": "ok", "service": "butterfly-api", "version": "2.0"}, 200

    # ── Local uploads (dev: when no CDN is configured) ──────────────────────────
    from pathlib import Path
    from flask import send_from_directory, abort

    @app.route("/uploads/<path:filename>")
    def serve_upload(filename):
        configured = app.config.get("UPLOAD_DIR", "")
        uploads_dir = Path(configured) if configured else \
            Path(app.root_path).parent / "uploads"
        if not (uploads_dir / filename).exists():
            abort(404)
        return send_from_directory(uploads_dir, filename)

    return app
