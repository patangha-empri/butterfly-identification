"""Identification trigger and result retrieval."""
from flask import Blueprint, request
# pyrefly: ignore [missing-import]
from flask_jwt_extended import jwt_required, get_jwt_identity

from app.extensions import limiter, rate_limit_key_by_user
from app.services import identification_service
from app.services.identification_service import IdentificationError
from app.utils.decorators import moderator_required
from app.utils.responses import success_response, error_response
from app.utils.validators import validate_image_file

identifications_bp = Blueprint("identifications", __name__)

# One shared budget across every AI-identification endpoint: a user gets
# 10 identifications per day total, whether via quick scan or observation
# identify. Keyed by user id, not IP.
identification_daily_limit = limiter.shared_limit(
    "10 per day",
    scope="ai-identification",
    key_func=rate_limit_key_by_user,
    error_message="Daily identification limit reached (10 per day). Try again tomorrow.",
)


@identifications_bp.post("/scan")
@jwt_required()
@identification_daily_limit
def quick_scan():
    """
    Stateless identification: analyse an uploaded photo with Gemini WITHOUT
    creating an observation. Used by the submit form's inline suggest card so
    species recognition works before anything is saved.
    """
    file = request.files.get("image")
    ok, err = validate_image_file(file)
    if not ok:
        return error_response(err, 400)

    from app.services import gemini_service
    try:
        result = gemini_service.identify_butterfly([file.read()])
    except ValueError as e:
        return error_response(str(e), 502)

    return success_response(data={
        "is_butterfly": result["is_butterfly"],
        "identified": result["identified"],
        "image_quality": result["image_quality"],
        "matches": [
            {
                "common_name": m["common_name"],
                "scientific_name": m["scientific_name"],
                "confidence": m["confidence"],
            }
            for m in result["matches"]
        ],
    })


@identifications_bp.post("/observations/<obs_id>/identify")
@jwt_required()
@identification_daily_limit
def trigger(obs_id):
    """
    Trigger synchronous Gemini identification for an observation.
    Runs the AI call inline — response may take 5-15 seconds.
    Returns 200 with the completed (or failed) result.
    """
    user_id = get_jwt_identity()
    try:
        result = identification_service.trigger_identification(obs_id, user_id)
    except IdentificationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=result)


@identifications_bp.get("/observations/<obs_id>/result")
@jwt_required()
def get_result(obs_id):
    """Get the stored identification result for an observation."""
    user_id = get_jwt_identity()
    try:
        result = identification_service.get_identification_result(obs_id, user_id)
    except IdentificationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=result)


@identifications_bp.post("/results/<result_id>/matches/<int:match_id>/accept")
@moderator_required
def accept_match(result_id, match_id):
    """
    Admin / moderator: override the AI result by accepting a specific match.
    Sets is_accepted=True, updates the observation's species and verification status.
    """
    body = request.get_json(silent=True) or {}
    admin_notes = body.get("admin_notes")
    try:
        result = identification_service.admin_accept_match(result_id, match_id, admin_notes)
    except IdentificationError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=result, message="Match accepted.")
