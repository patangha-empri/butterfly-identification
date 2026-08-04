"""Admin — species CRUD, images, host plants, distribution."""
from flask import Blueprint, request

from app.schemas.admin import (
    SpeciesCreateSchema, SpeciesUpdateSchema,
    DistributionSchema, HostPlantSchema,
    FieldDefinitionCreateSchema, FieldDefinitionUpdateSchema,
    SpeciesImageUpdateSchema,
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
_field_def_create_schema = FieldDefinitionCreateSchema()
_field_def_update_schema = FieldDefinitionUpdateSchema()
_image_update_schema = SpeciesImageUpdateSchema()


@admin_species_bp.get("/")
@admin_required
def list_species():
    """
    Admin listing — includes deactivated species, unlike the public
    GET /species/. Staff need to find and reactivate them; the admin panel
    would otherwise lose a species the moment it was deactivated.
    """
    page, per_page = get_pagination_params()
    filters = {
        "search": request.args.get("search"),
        "status": request.args.get("status"),  # active | inactive | omitted for all
        "family": request.args.get("family"),
        "conservation_status": request.args.get("conservation_status"),
    }
    items, total = species_service.list_species_admin(filters, page, per_page)
    return paginated_response(items, total, page, per_page)


@admin_species_bp.get("/field-definitions")
@admin_required
def list_field_definitions():
    """The admin-defined field vocabulary behind species.custom_fields."""
    include_retired = request.args.get("include_retired") == "true"
    return success_response(data=species_service.list_field_definitions(include_retired))


@admin_species_bp.post("/field-definitions")
@admin_required
def create_field_definition():
    body = request.get_json(silent=True) or {}
    errors = _field_def_create_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _field_def_create_schema.load(body)
    try:
        definition = species_service.create_field_definition(data, get_jwt_identity())
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=definition, status_code=201)


@admin_species_bp.patch("/field-definitions/<definition_id>")
@admin_required
def update_field_definition(definition_id):
    body = request.get_json(silent=True) or {}
    errors = _field_def_update_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _field_def_update_schema.load(body)
    try:
        definition = species_service.update_field_definition(definition_id, data)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=definition)


@admin_species_bp.delete("/field-definitions/<definition_id>")
@admin_required
def retire_field_definition(definition_id):
    """Retires the field from the picker. Values already stored are kept."""
    try:
        species_service.retire_field_definition(definition_id)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(
        message="Custom field retired. Values already saved on species are kept."
    )


@admin_species_bp.get("/<species_id>")
@admin_required
def get_species(species_id):
    """Detail lookup that also resolves deactivated species (the public one won't)."""
    try:
        species = species_service.get_species_admin(species_id)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=species)


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
    """
    Soft delete: hides the species from the mobile app. The record and its
    observations are untouched, and POST /<id>/activate reverses it.
    """
    try:
        species_service.deactivate_species(species_id)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(
        message="Species deactivated. It is now hidden from the mobile app."
    )


@admin_species_bp.post("/<species_id>/activate")
@admin_required
def activate_species(species_id):
    try:
        species = species_service.activate_species(species_id)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(
        data=species, message="Species reactivated. It is visible in the mobile app again."
    )


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
    # Optional details, same set the PATCH below edits. Sent as form fields
    # because the upload itself has to be multipart.
    metadata = {
        key: request.form.get(key)
        for key in species_service.IMAGE_EDITABLE_FIELDS
        if request.form.get(key)
    }
    try:
        img = species_service.add_species_image(
            species_id, file, image_type, credit, metadata
        )
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=img, status_code=201)


@admin_species_bp.patch("/<species_id>/images/<image_id>")
@admin_required
def update_image(species_id, image_id):
    """Edit an image's details. The picture itself is swapped by /file below."""
    body = request.get_json(silent=True) or {}
    errors = _image_update_schema.validate(body)
    if errors:
        return error_response("Validation failed.", 422, errors=errors)
    data = _image_update_schema.load(body)
    try:
        img = species_service.update_species_image(species_id, image_id, data)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=img, message="Image details updated.")


@admin_species_bp.post("/<species_id>/images/<image_id>/file")
@admin_required
def replace_image(species_id, image_id):
    """
    Replace the picture, keeping the same image record — so its primary flag
    and credit/licence details survive a correction.
    """
    file = request.files.get("image")
    ok, err = validate_image_file(file)
    if not ok:
        return error_response(err, 400)
    try:
        img = species_service.replace_species_image(species_id, image_id, file)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=img, message="Image replaced.")


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
