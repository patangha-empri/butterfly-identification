"""Species listing and detail (public read, no auth required)."""
from flask import Blueprint, request

from app.services import species_service
from app.services.species_service import SpeciesError
from app.utils.pagination import get_pagination_params
from app.utils.responses import success_response, error_response, paginated_response

species_bp = Blueprint("species", __name__)


@species_bp.get("/")
def list_species():
    page, per_page = get_pagination_params()
    filters = {
        "family": request.args.get("family"),
        "conservation_status": request.args.get("conservation_status"),
        "state_id": request.args.get("state_id", type=int),
        "color": request.args.get("color"),
        "search": request.args.get("search"),
        "is_migratory": (
            request.args.get("is_migratory", "").lower() == "true"
            if request.args.get("is_migratory") is not None
            else None
        ),
    }
    # Remove None filters
    filters = {k: v for k, v in filters.items() if v is not None}

    items, total = species_service.list_species(filters, page, per_page)
    return paginated_response(items, total, page, per_page)


@species_bp.get("/<slug_or_id>")
def get_species(slug_or_id):
    try:
        data = species_service.get_species(slug_or_id)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=data)


@species_bp.get("/<slug_or_id>/similar")
def get_similar_species(slug_or_id):
    try:
        data = species_service.get_similar_species(slug_or_id)
    except SpeciesError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=data)
