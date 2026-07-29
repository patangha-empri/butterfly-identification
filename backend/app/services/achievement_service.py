"""Check and award achievements; update streaks and stats — via Supabase PostgREST."""
from datetime import date, datetime, timedelta, timezone

from app.supabase_client import get_supabase


def _now() -> str:
    return datetime.now(timezone.utc).isoformat()


def _get_stats(sb, user_id: str) -> dict | None:
    res = sb.table("user_stats").select("*").eq("user_id", user_id).execute()
    return res.data[0] if res.data else None


def _get_streak(sb, user_id: str) -> dict | None:
    res = sb.table("user_streaks").select("*").eq("user_id", user_id).execute()
    return res.data[0] if res.data else None


def recalculate_stats(user_id: str) -> None:
    """Recompute all user_stats counters from live DB data."""
    sb = get_supabase()

    total_observations = (
        sb.table("observations").select("id", count="exact", head=True)
        .eq("user_id", user_id).eq("is_active", True).execute().count or 0
    )
    total_identifications = (
        sb.table("observations").select("id", count="exact", head=True)
        .eq("user_id", user_id).eq("is_active", True)
        .in_("verification_status", ["ai_identified", "expert_verified", "community_verified"])
        .execute().count or 0
    )
    # PostgREST has no DISTINCT — fetch the columns and dedupe client-side.
    rows = (
        sb.table("observations").select("species_id, state_id")
        .eq("user_id", user_id).eq("is_active", True).limit(10000).execute().data
    )
    total_species = len({r["species_id"] for r in rows if r.get("species_id")})
    total_states = len({r["state_id"] for r in rows if r.get("state_id")})

    fields = {
        "total_observations": total_observations,
        "total_identifications": total_identifications,
        "total_species_observed": total_species,
        "total_states_explored": total_states,
        "updated_at": _now(),
    }
    if _get_stats(sb, user_id):
        sb.table("user_stats").update(fields).eq("user_id", user_id).execute()
    else:
        sb.table("user_stats").insert({"user_id": user_id, "total_points": 0, **fields}).execute()


def update_streak(user_id: str, observed_date: date) -> None:
    """Extend or reset the observation streak for the given user."""
    sb = get_supabase()
    streak = _get_streak(sb, user_id)

    today = observed_date if isinstance(observed_date, date) else observed_date.date()
    last = streak.get("last_observation_date") if streak else None
    if isinstance(last, str):
        last = date.fromisoformat(last)

    current = (streak.get("current_streak") if streak else 0) or 0
    longest = (streak.get("longest_streak") if streak else 0) or 0

    if last is None:
        current = 1
    elif today == last:
        pass  # same day — no change
    elif today == last + timedelta(days=1):
        current += 1
    else:
        current = 1  # gap → reset

    fields = {
        "current_streak": current,
        "last_observation_date": today.isoformat(),
        "longest_streak": max(longest, current),
        "updated_at": _now(),
    }
    if streak:
        sb.table("user_streaks").update(fields).eq("user_id", user_id).execute()
    else:
        sb.table("user_streaks").insert({"user_id": user_id, **fields}).execute()


def award_achievement(user_id: str, achievement_type: str) -> bool:
    """Grant an achievement if not already earned. Returns True if newly awarded."""
    sb = get_supabase()
    defn_res = sb.table("achievement_definitions").select("id, points") \
        .eq("achievement_type", achievement_type).execute()
    if not defn_res.data:
        return False
    defn = defn_res.data[0]

    already = sb.table("user_achievements").select("id") \
        .eq("user_id", user_id).eq("achievement_id", defn["id"]).execute()
    if already.data:
        return False

    sb.table("user_achievements").insert({
        "user_id": user_id,
        "achievement_id": defn["id"],
        "earned_at": _now(),
    }).execute()

    # Add points to stats
    stats = _get_stats(sb, user_id)
    if stats:
        sb.table("user_stats").update({
            "total_points": (stats.get("total_points") or 0) + defn["points"],
            "updated_at": _now(),
        }).eq("user_id", user_id).execute()
    return True


def check_and_award(user_id: str) -> list:
    """
    Check all achievement thresholds and award any that are newly met.
    Returns list of newly-earned achievement_type strings.
    """
    sb = get_supabase()
    stats = _get_stats(sb, user_id)
    streak = _get_streak(sb, user_id)
    if not stats:
        return []

    newly_earned = []

    checks = [
        ("first_observation", stats["total_observations"] >= 1),
        ("species_10", stats["total_species_observed"] >= 10),
        ("species_50", stats["total_species_observed"] >= 50),
        ("species_100", stats["total_species_observed"] >= 100),
        ("state_explorer", stats["total_states_explored"] >= 5),
        ("verified_10", stats["total_identifications"] >= 10),
        ("top_contributor", stats["total_observations"] >= 100),
    ]
    if streak:
        checks += [
            ("streak_7", (streak.get("current_streak") or 0) >= 7),
            ("streak_30", (streak.get("current_streak") or 0) >= 30),
            ("streak_100", (streak.get("current_streak") or 0) >= 100),
        ]

    for achievement_type, condition in checks:
        if condition and award_achievement(user_id, achievement_type):
            newly_earned.append(achievement_type)

    return newly_earned


def post_observation_hooks(user_id: str, observed_at) -> list:
    """
    Run all post-observation stat/streak/achievement updates.
    Call this after any observation is created or restored.
    Returns list of newly-earned achievement types.
    """
    recalculate_stats(user_id)
    if observed_at:
        if isinstance(observed_at, str):
            observed_at = datetime.fromisoformat(observed_at.replace("Z", "+00:00"))
        obs_date = observed_at.date() if hasattr(observed_at, "date") else observed_at
        update_streak(user_id, obs_date)
    return check_and_award(user_id)
