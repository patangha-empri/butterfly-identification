"""Geography — states and districts (public, no auth required) — via Supabase PostgREST."""
from flask import Blueprint

from app.supabase_client import get_supabase
from app.utils.responses import success_response, error_response

geography_bp = Blueprint("geography", __name__)


@geography_bp.get("/states")
def list_states():
    sb = get_supabase()
    res = sb.table("india_states").select("id, name, code, region, is_union_territory") \
        .order("name").limit(100).execute()
    return success_response(data=res.data)


@geography_bp.get("/states/<int:state_id>/districts")
def list_districts(state_id):
    sb = get_supabase()
    state = sb.table("india_states").select("id").eq("id", state_id).execute()
    if not state.data:
        return error_response("State not found.", 404)
    res = sb.table("india_districts").select("id, name, latitude, longitude") \
        .eq("state_id", state_id).order("name").limit(2000).execute()
    return success_response(data=res.data)
