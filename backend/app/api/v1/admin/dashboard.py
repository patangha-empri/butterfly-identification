"""Admin dashboard — platform-wide statistics — via Supabase PostgREST."""
from collections import Counter
from datetime import datetime, timedelta, timezone

from flask import Blueprint

from app.supabase_client import get_supabase
from app.utils.decorators import admin_required
from app.utils.responses import success_response

admin_dashboard_bp = Blueprint("admin_dashboard", __name__)


def _count(sb, table: str, **eq_filters) -> int:
    query = sb.table(table).select("id", count="exact", head=True)
    for col, val in eq_filters.items():
        query = query.eq(col, val)
    res = query.execute()
    return res.count or 0


@admin_dashboard_bp.get("/stats")
@admin_required
def get_stats():
    sb = get_supabase()

    total_users = _count(sb, "users", is_active=True)
    total_observations = _count(sb, "observations", is_active=True)
    total_species = _count(sb, "species", is_active=True)
    total_identifications = _count(sb, "identification_results", status="completed")
    pending_observations = _count(sb, "observations", is_active=True, verification_status="pending")
    suspended_users = _count(sb, "users", is_suspended=True)
    rejected_observations = _count(sb, "observations", is_active=True, verification_status="rejected")

    # Users with at least one active (non-revoked) warning or flag.
    try:
        mod_rows = (
            sb.table("user_moderation_actions").select("user_id, action_type")
            .is_("revoked_at", "null")
            .in_("action_type", ["warning", "flag"]).limit(10000).execute().data
        )
        warned_users = len({r["user_id"] for r in mod_rows if r["action_type"] == "warning"})
        flagged_users = len({r["user_id"] for r in mod_rows if r["action_type"] == "flag"})
    except Exception:
        # Table missing until migration 002 runs — degrade gracefully.
        warned_users = 0
        flagged_users = 0

    thirty_days_ago = (datetime.now(timezone.utc) - timedelta(days=30)).isoformat()
    new_users_30d = (
        sb.table("users").select("id", count="exact", head=True)
        .gte("created_at", thirty_days_ago).execute().count or 0
    )
    new_obs_30d = (
        sb.table("observations").select("id", count="exact", head=True)
        .eq("is_active", True).gte("created_at", thirty_days_ago).execute().count or 0
    )

    # Top 5 states by observations — PostgREST has no GROUP BY, so aggregate
    # the state_id column client-side. Fine at current data volumes; switch to
    # a Postgres function (RPC) if observations grow past a few thousand rows.
    state_rows = (
        sb.table("observations").select("state_id")
        .eq("is_active", True).limit(10000).execute().data
    )
    top_states = Counter(r["state_id"] for r in state_rows if r.get("state_id")).most_common(5)

    return success_response(data={
        "total_users": total_users,
        "total_observations": total_observations,
        "total_species": total_species,
        "total_identifications": total_identifications,
        "pending_observations": pending_observations,
        "rejected_observations": rejected_observations,
        "suspended_users": suspended_users,
        "warned_users": warned_users,
        "flagged_users": flagged_users,
        "new_users_30d": new_users_30d,
        "new_observations_30d": new_obs_30d,
        "top_states_by_observations": [
            {"state_id": state_id, "count": count} for state_id, count in top_states
        ],
    })
