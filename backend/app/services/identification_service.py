"""
Identification service — Phase 3 — via Supabase PostgREST.
Synchronous Gemini Vision call: runs inside the HTTP request (no workers needed).
"""
import time
import uuid
import logging
from datetime import datetime, timezone

from flask import current_app

from app.supabase_client import get_supabase
from app.services.user_repo import get_user_row, role_name

log = logging.getLogger(__name__)

_STAFF_ROLES = ("admin", "super_admin", "moderator")

# Full species embed inside each match, mirroring Species.to_dict(include_related=True)
RESULT_SELECT = (
    "*, identification_matches(*, species(*, species_images(*), species_host_plants(*), "
    "species_india_distribution(*, india_states(name, code))))"
)


class IdentificationError(Exception):
    def __init__(self, message: str, status_code: int = 400):
        self.message   = message
        self.status_code = status_code
        super().__init__(message)


def _now() -> str:
    return datetime.now(timezone.utc).isoformat()


def _match_to_dict(m: dict) -> dict:
    from app.services.species_service import _to_dict as species_to_dict
    species = m.get("species")
    if isinstance(species, list):
        species = species[0] if species else None
    return {
        "id": m["id"],
        "rank": m.get("rank"),
        "confidence_score": m.get("confidence_score"),
        "matched_common_name": m.get("matched_common_name"),
        "matched_scientific_name": m.get("matched_scientific_name"),
        "species_id": m.get("species_id"),
        "species": species_to_dict(species, include_related=True) if species else None,
        "is_accepted": m.get("is_accepted"),
    }


def _result_to_dict(r: dict, include_matches: bool = True) -> dict:
    data = {
        "id": r["id"],
        "observation_id": r["observation_id"],
        "status": r.get("status"),
        "error_message": r.get("error_message"),
        "processing_time_ms": r.get("processing_time_ms"),
        "gemini_model_version": r.get("gemini_model_version"),
        "created_at": r.get("created_at"),
        "completed_at": r.get("completed_at"),
        "raw_gemini_response": r.get("raw_gemini_response"),
        "input_token_count": r.get("input_token_count"),
        "output_token_count": r.get("output_token_count"),
        "total_token_count": r.get("total_token_count"),
    }
    if include_matches:
        matches = r.get("identification_matches") or []
        matches.sort(key=lambda m: m.get("rank") or 0)
        data["matches"] = [_match_to_dict(m) for m in matches]
    return data


def _fetch_result(result_id: str) -> dict | None:
    sb = get_supabase()
    res = sb.table("identification_results").select(RESULT_SELECT).eq("id", result_id).execute()
    return res.data[0] if res.data else None


def _delete_result_with_matches(result_id: str) -> None:
    """The old SQLAlchemy cascade was ORM-level, not DB-level — delete children first."""
    sb = get_supabase()
    sb.table("identification_matches").delete().eq("identification_result_id", result_id).execute()
    sb.table("identification_results").delete().eq("id", result_id).execute()


# ── Public API ─────────────────────────────────────────────────────────────────

def trigger_identification(obs_id: str, user_id: str) -> dict:
    """
    Synchronously identify the butterfly in an observation using Gemini Vision.
    """
    sb = get_supabase()
    obs_res = sb.table("observations").select("*, observation_images(*)") \
        .eq("id", obs_id).eq("is_active", True).execute()
    obs = obs_res.data[0] if obs_res.data else None
    if not obs:
        raise IdentificationError("Observation not found.", 404)
    if obs["user_id"] != user_id:
        raise IdentificationError("Not your observation.", 403)

    images = obs.get("observation_images") or []
    if not images:
        raise IdentificationError(
            "Upload at least one image before requesting identification.", 400
        )
    images.sort(key=lambda i: i.get("created_at") or "")

    # ── (Re-)create result record ──────────────────────────────────────────────
    existing = sb.table("identification_results").select("id").eq("observation_id", obs_id).execute()
    if existing.data:
        _delete_result_with_matches(existing.data[0]["id"])

    model_version = current_app.config.get("GEMINI_MODEL", "gemini-1.5-flash")
    result_id = str(uuid.uuid4())
    sb.table("identification_results").insert({
        "id": result_id,
        "observation_id": obs_id,
        "user_id": user_id,
        "status": "processing",
        "gemini_model_version": model_version,
        "created_at": _now(),
    }).execute()

    # ── Call Gemini ────────────────────────────────────────────────────────────
    t0 = time.monotonic()
    try:
        from app.services import gemini_service

        # Download up to 3 images (most-recently added first)
        image_bytes_list = []
        for img in reversed(images[-3:]):
            url = img.get("optimized_url") or img["original_url"]
            try:
                image_bytes_list.append(gemini_service.download_image_bytes(url))
            except Exception as exc:
                log.warning("Could not download %s: %s", url, exc)

        if not image_bytes_list:
            raise ValueError("None of the observation images could be downloaded.")

        gemini = gemini_service.identify_butterfly(image_bytes_list)

        processing_ms = int((time.monotonic() - t0) * 1000)

        # ── Write matches ──────────────────────────────────────────────────────
        top_species_id   = None
        top_species_name = "Unknown species"

        match_rows = []
        for rank, match in enumerate(gemini["matches"], 1):
            species_id = gemini_service.find_species_id(
                match["scientific_name"], match["common_name"]
            )
            match_rows.append({
                "identification_result_id": result_id,
                "species_id": species_id,
                "matched_common_name": match["common_name"],
                "matched_scientific_name": match["scientific_name"],
                "confidence_score": match["confidence"],
                "rank": rank,
                "is_accepted": False,
            })
            if rank == 1:
                top_species_id   = species_id
                top_species_name = match["common_name"]
        if match_rows:
            sb.table("identification_matches").insert(match_rows).execute()

        # ── Update result + observation ────────────────────────────────────────
        result_fields = {
            "processing_time_ms": processing_ms,
            "raw_gemini_response": gemini["raw_json"],
            "gemini_raw_text": gemini["raw_text"],
            "status": "completed",
            "completed_at": _now(),
            "input_token_count": gemini.get("input_token_count"),
            "output_token_count": gemini.get("output_token_count"),
            "total_token_count": gemini.get("total_token_count"),
        }
        if gemini["identified"] and gemini["is_butterfly"]:
            obs_fields = {"verification_status": "ai_identified", "updated_at": _now()}
            if top_species_id:
                obs_fields["species_id"] = top_species_id
            sb.table("observations").update(obs_fields).eq("id", obs_id).execute()
        else:
            reason = (
                "No butterfly detected in image."
                if not gemini["is_butterfly"]
                else "Image quality too poor to identify."
            )
            result_fields["error_message"] = reason
            
            # Set observation status to rejected and log notes
            obs_fields = {
                "verification_status": "rejected",
                "admin_notes": f"AI identification failed: {reason}",
                "updated_at": _now()
            }
            sb.table("observations").update(obs_fields).eq("id", obs_id).execute()
        sb.table("identification_results").update(result_fields).eq("id", result_id).execute()

        # ── FCM push notification ──────────────────────────────────────────────
        try:
            from app.services import notification_service
            if gemini["identified"] and gemini["is_butterfly"]:
                body = f"Identified as {top_species_name} 🦋"
            else:
                body = result_fields.get("error_message") or "Identification complete."

            notification_service.create_notification(
                user_id     = user_id,
                notif_type  = "identification_complete",
                title       = "Identification Complete",
                body        = body,
                data        = {
                    "observation_id": obs_id,
                    "result_id":      result_id,
                    "status":         result_fields["status"],
                },
            )
        except Exception as exc:
            log.warning("FCM notification failed (non-fatal): %s", exc)

    except Exception as exc:
        # Always persist a failure result — never leave status='processing'
        processing_ms = int((time.monotonic() - t0) * 1000)
        sb.table("identification_results").update({
            "status": "failed",
            "error_message": str(exc),
            "processing_time_ms": processing_ms,
            "completed_at": _now(),
        }).eq("id", result_id).execute()
        log.error("Identification failed for obs %s: %s", obs_id, exc)

    return _result_to_dict(_fetch_result(result_id))


def get_identification_result(obs_id: str, user_id: str) -> dict:
    """Return the identification result for an observation."""
    sb = get_supabase()
    obs_res = sb.table("observations").select("id, user_id").eq("id", obs_id).eq("is_active", True).execute()
    obs = obs_res.data[0] if obs_res.data else None
    if not obs:
        raise IdentificationError("Observation not found.", 404)

    if obs["user_id"] != user_id:
        req_user = get_user_row(user_id)
        if not (req_user and role_name(req_user) in _STAFF_ROLES):
            raise IdentificationError("Not authorized.", 403)

    res = sb.table("identification_results").select(RESULT_SELECT).eq("observation_id", obs_id).execute()
    if not res.data:
        raise IdentificationError(
            "No identification result yet. Trigger identification first.", 404
        )
    return _result_to_dict(res.data[0])


def admin_accept_match(result_id: str, match_id: int, admin_notes: str = None) -> dict:
    """Admin: override the AI result by accepting a specific match."""
    sb = get_supabase()
    result = sb.table("identification_results").select("id, observation_id").eq("id", result_id).execute()
    if not result.data:
        raise IdentificationError("Identification result not found.", 404)
    observation_id = result.data[0]["observation_id"]

    # Clear any previous acceptance
    sb.table("identification_matches").update({"is_accepted": False}) \
        .eq("identification_result_id", result_id).eq("is_accepted", True).execute()

    match_res = sb.table("identification_matches").select("*") \
        .eq("id", match_id).eq("identification_result_id", result_id).execute()
    match = match_res.data[0] if match_res.data else None
    if not match:
        raise IdentificationError("Match not found.", 404)

    sb.table("identification_matches").update({
        "is_accepted": True,
        "admin_notes": admin_notes,
    }).eq("id", match_id).execute()

    if match.get("species_id"):
        sb.table("observations").update({
            "species_id": match["species_id"],
            "verification_status": "expert_verified",
            "updated_at": _now(),
        }).eq("id", observation_id).execute()

        # Tell the owner their sighting's species was confirmed/corrected.
        obs_res = sb.table("observations").select("user_id").eq("id", observation_id).execute()
        if obs_res.data:
            from app.services.notification_service import notify_moderation
            species_name = match.get("matched_common_name") or "a species"
            notify_moderation(
                obs_res.data[0]["user_id"],
                "Your sighting was identified ✅",
                f"A moderator confirmed your sighting as {species_name}. "
                "It is now expert-verified.",
                data={"observation_id": observation_id, "action": "species_confirmed"},
            )

    return _result_to_dict(_fetch_result(result_id))
