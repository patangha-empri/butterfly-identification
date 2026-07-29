"""Admin blueprint — aggregates all admin sub-blueprints."""
from flask import Blueprint

admin_bp = Blueprint("admin", __name__)

from app.api.v1.admin.users import admin_users_bp
from app.api.v1.admin.observations import admin_obs_bp
from app.api.v1.admin.species import admin_species_bp
from app.api.v1.admin.cms import admin_cms_bp
from app.api.v1.admin.reports import admin_reports_bp
from app.api.v1.admin.dashboard import admin_dashboard_bp
from app.api.v1.admin.identifications import admin_ident_bp

admin_bp.register_blueprint(admin_users_bp,     url_prefix="/users")
admin_bp.register_blueprint(admin_obs_bp,       url_prefix="/observations")
admin_bp.register_blueprint(admin_species_bp,   url_prefix="/species")
admin_bp.register_blueprint(admin_cms_bp,       url_prefix="/cms")
admin_bp.register_blueprint(admin_reports_bp,   url_prefix="/reports")
admin_bp.register_blueprint(admin_dashboard_bp, url_prefix="/dashboard")
admin_bp.register_blueprint(admin_ident_bp,     url_prefix="/identifications")
