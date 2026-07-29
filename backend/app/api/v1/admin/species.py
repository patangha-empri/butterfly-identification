"""Admin — species CRUD, images, host plants, distribution."""
from flask import Blueprint, request

from app.schemas.admin import (
    SpeciesCreateSchema, SpeciesUpdateSchema,
    DistributionSchema, HostPlantSchema,
)
from app.services import species_service
from app.services.species_service import SpeciesError
from app.utils.decorators import admin_required
from app.utils.pagination import get_pagination_params
from app.utils.responses import success_response, error_response, paginated_response
from app.utils.validators import validate_image_file
from flask_jwt_extended import get_jwt_identity

admin_species_bp = Blueprint("admin_species", __name__)

_create_schema = SpeciesCreateSchema()
_update_schema = SpeciesUpdateSchema()
_dist_schema = DistributionSchema()
_plant_schema = HostPlantSchema()


@admin_species_bp.get("/")
@admin_required
def list_species():
    page, per_page = get_pagination_params()
    from app.supabase_client import get_supabase
    from app.services.species_service import _SELECT, _to_dict
    sb = get_supabase()
    start = (page - 1) * per_page
    res = sb.table("species").select(_SELECT, count="exact") \
        .order("common_name").range(start, start + per_page - 1).execute()
    return paginated_response([_to_dict(s) for s in res.data], res.count or 0, page, per_page)


@admin_species_bp.post("/")
@admin_required
def create_species():
    body = request.get_json(silent=True) or {}
    errors = _create_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _create_schema.load(body)
    admin_id = get_jwt_identity()
    try:
        species = species_service.create_species(data, admin_id)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=species, status_code=201)


@admin_species_bp.put("/<species_id>")
@admin_required
def update_species(species_id):
    body = request.get_json(silent=True) or {}
    errors = _update_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _update_schema.load(body)
    try:
        species = species_service.update_species(species_id, data)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=species)


@admin_species_bp.delete("/<species_id>")
@admin_required
def deactivate_species(species_id):
    try:
        species_service.deactivate_species(species_id)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(message="Species deactivated.")


# ── Images ─────────────────────────────────────────────────────────────────────

@admin_species_bp.post("/<species_id>/images")
@admin_required
def add_image(species_id):
    file = request.files.get("image")
    ok, err = validate_image_file(file)
    if not ok:
        return error_response(err, 400)
    image_type = request.form.get("image_type", "reference")
    credit = request.form.get("credit")
    try:
        img = species_service.add_species_image(species_id, file, image_type, credit)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=img, status_code=201)


@admin_species_bp.delete("/<species_id>/images/<image_id>")
@admin_required
def delete_image(species_id, image_id):
    try:
        species_service.delete_species_image(species_id, image_id)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(message="Image deleted.")


@admin_species_bp.patch("/<species_id>/images/<image_id>/primary")
@admin_required
def set_primary(species_id, image_id):
    try:
        img = species_service.set_primary_image(species_id, image_id)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=img)


# ── Host plants ────────────────────────────────────────────────────────────────

@admin_species_bp.post("/<species_id>/host-plants")
@admin_required
def add_host_plant(species_id):
    body = request.get_json(silent=True) or {}
    errors = _plant_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _plant_schema.load(body)
    try:
        plant = species_service.add_host_plant(
            species_id, data["plant_name"], data.get("plant_scientific_name")
        )
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=plant, status_code=201)


@admin_species_bp.delete("/<species_id>/host-plants/<int:plant_id>")
@admin_required
def delete_host_plant(species_id, plant_id):
    try:
        species_service.remove_host_plant(species_id, plant_id)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(message="Host plant removed.")


# ── Distribution ───────────────────────────────────────────────────────────────

@admin_species_bp.post("/<species_id>/distribution")
@admin_required
def set_distribution(species_id):
    body = request.get_json(silent=True) or {}
    errors = _dist_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _dist_schema.load(body)
    try:
        dist = species_service.set_distribution(
            species_id, data["state_id"], data.get("abundance", "common")
        )
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=dist)


@admin_species_bp.delete("/<species_id>/distribution/<int:state_id>")
@admin_required
def remove_distribution(species_id, state_id):
    try:
        species_service.remove_distribution(species_id, state_id)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(message="Distribution entry removed.")
