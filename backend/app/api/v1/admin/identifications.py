"""Admin — AI identification results listing — via Supabase PostgREST."""
from flask import Blueprint, request

from app.supabase_client import get_supabase
from app.utils.decorators import moderator_required
from app.utils.pagination import get_pagination_params
from app.utils.responses import paginated_response

admin_ident_bp = Blueprint("admin_ident", __name__)

_LIST_SELECT = (
    "*, identification_matches(*), "
    "observations!inner(*, observation_images(*), "
    "users!observations_user_id_fkey(username, full_name))"
)


def _match_to_dict(m: dict) -> dict:
    return {
        "id": m["id"],
        "rank": m.get("rank"),
        "confidence_score": m.get("confidence_score"),
        "matched_common_name": m.get("matched_common_name"),
        "matched_scientific_name": m.get("matched_scientific_name"),
        "species_id": m.get("species_id"),
        "is_accepted": m.get("is_accepted"),
    }


# The admin frontend calls this without a trailing slash — strict_slashes=False
# avoids Flask's 308 redirect, which browsers reject during CORS preflight.
@admin_ident_bp.get("/", strict_slashes=False)
@moderator_required
def list_identifications():
    page, per_page = get_pagination_params()
    status = request.args.get("status")
    search = request.args.get("search")

    sb = get_supabase()
    query = sb.table("identification_results").select(_LIST_SELECT, count="exact")
    query = query.eq("observations.is_active", True)
    if status and status != "all":
        query = query.eq("status", status)
    if search:
        query = query.ilike("observation_id", f"%{search}%")

    start = (page - 1) * per_page
    res = query.order("created_at", desc=True).range(start, start + per_page - 1).execute()

    items = []
    for r in res.data:
        matches = r.get("identification_matches") or []
        matches.sort(key=lambda m: m.get("rank") or 0)
        
        obs_data = r.get("observations")
        observation = None
        if obs_data:
            obs = obs_data[0] if isinstance(obs_data, list) else obs_data
            if obs and obs.get("is_active", True):
                images = obs.get("observation_images") or []
                primary = next((i for i in images if i.get("is_primary")), images[0] if images else None)
                primary_image_url = (primary.get("optimized_url") or primary.get("original_url")) if primary else None
                
                user_data = obs.get("users")
                if isinstance(user_data, list):
                    user_data = user_data[0] if user_data else None
                
                observation = {
                    "id": obs.get("id"),
                    "title": obs.get("title"),
                    "notes": obs.get("notes"),
                    "location_name": obs.get("location_name"),
                    "latitude": obs.get("latitude"),
                    "longitude": obs.get("longitude"),
                    "verification_status": obs.get("verification_status"),
                    "created_at": obs.get("created_at"),
                    "primary_image_url": primary_image_url,
                    "user": {
                        "username": user_data.get("username") if user_data else None,
                        "full_name": user_data.get("full_name") if user_data else None,
                    } if user_data else None
                }

        if not observation:
            continue

        items.append({
            "id": r["id"],
            "observation_id": r["observation_id"],
            "user_id": r.get("user_id"),
            "status": r.get("status"),
            "error_message": r.get("error_message"),
            "processing_time_ms": r.get("processing_time_ms"),
            "gemini_model_version": r.get("gemini_model_version"),
            "created_at": r.get("created_at"),
            "completed_at": r.get("completed_at"),
            "input_token_count": r.get("input_token_count"),
            "output_token_count": r.get("output_token_count"),
            "total_token_count": r.get("total_token_count"),
            "matches": [_match_to_dict(m) for m in matches],
            "observation": observation,
        })
    return paginated_response(items, res.count or 0, page, per_page)
