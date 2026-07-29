"""Gamification: explorer profile (stats + streak + points) and achievements — via Supabase PostgREST."""
from flask import Blueprint
from flask_jwt_extended import jwt_required, get_jwt_identity

from app.supabase_client import get_supabase
from app.services import achievement_service
from app.utils.responses import success_response

gamification_bp = Blueprint("gamification", __name__)


@gamification_bp.get("/me")
@jwt_required()
def my_gamification():
    """The current user's gamification profile (recomputed on read)."""
    user_id = get_jwt_identity()
    sb = get_supabase()

    # Recompute from live data so the profile is always accurate.
    achievement_service.recalculate_stats(user_id)
    achievement_service.check_and_award(user_id)

    stats_res = sb.table("user_stats").select("*").eq("user_id", user_id).execute()
    streak_res = sb.table("user_streaks").select("*").eq("user_id", user_id).execute()
    stats = stats_res.data[0] if stats_res.data else None
    streak = streak_res.data[0] if streak_res.data else None
    earned = (
        sb.table("user_achievements").select("id", count="exact", head=True)
        .eq("user_id", user_id).execute().count or 0
    )

    return success_response(data={
        "stats": {
            "total_observations": stats["total_observations"],
            "total_identifications": stats["total_identifications"],
            "total_species_observed": stats["total_species_observed"],
            "total_states_explored": stats["total_states_explored"],
            "total_points": stats["total_points"],
        } if stats else {
            "total_observations": 0,
            "total_identifications": 0,
            "total_species_observed": 0,
            "total_states_explored": 0,
            "total_points": 0,
        },
        "streak": {
            "current_streak": streak["current_streak"],
            "longest_streak": streak["longest_streak"],
            "last_observation_date": streak.get("last_observation_date"),
        } if streak else {
            "current_streak": 0,
            "longest_streak": 0,
            "last_observation_date": None,
        },
        "achievements_earned": earned,
    })


@gamification_bp.get("/achievements")
@jwt_required()
def all_achievements():
    """All achievement definitions, flagged with the user's earned status."""
    user_id = get_jwt_identity()
    sb = get_supabase()

    defns = sb.table("achievement_definitions").select("*").order("threshold_value").execute().data
    earned_rows = sb.table("user_achievements").select("achievement_id, earned_at") \
        .eq("user_id", user_id).execute().data
    earned = {r["achievement_id"]: r for r in earned_rows}

    result = []
    for d in defns:
        ua = earned.get(d["id"])
        result.append({
            "id": d["id"],
            "name": d["name"],
            "description": d["description"],
            "badge_image_url": d.get("badge_image_url"),
            "achievement_type": d["achievement_type"],
            "threshold_value": d["threshold_value"],
            "points": d["points"],
            "is_earned": ua is not None,
            "earned_at": ua.get("earned_at") if ua else None,
        })

    return success_response(data=result)
