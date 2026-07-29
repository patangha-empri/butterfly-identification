"""Observation CRUD, image management, privacy, and share links — via Supabase PostgREST."""
import secrets
import uuid
from datetime import datetime, timezone

from app.supabase_client import get_supabase
from app.services.user_repo import get_user_row, role_name

# observations has two FKs to users (user_id, verified_by) — the embed must name
# the FK constraint so PostgREST knows which relation to follow.
OBS_SELECT = (
    "*, observation_images(*), india_states(name), india_districts(name), "
    "species(id, common_name), "
    "identification_results(*, identification_matches(*)), "
    "users!observations_user_id_fkey(id, username, full_name, profile_image_url, bio, "
    "is_verified, preferred_state_id, created_at, roles(name))"
)

_STAFF_ROLES = ("admin", "super_admin", "moderator")


class ObservationError(Exception):
    def __init__(self, message: str, status_code: int = 400):
        self.message = message
        self.status_code = status_code
        super().__init__(message)


def _now() -> str:
    return datetime.now(timezone.utc).isoformat()


def _is_staff(user_id: str) -> bool:
    if not user_id:
        return False
    user = get_user_row(user_id)
    return bool(user) and role_name(user) in _STAFF_ROLES


def _check_ownership(obs: dict, user_id: str, allow_admin: bool = False) -> None:
    if obs["user_id"] != user_id:
        if allow_admin and _is_staff(user_id):
            return
        raise ObservationError("You do not have permission to modify this observation.", 403)


def _one(rel):
    """PostgREST returns to-one embeds as dict (unique FK) or one-element list."""
    if isinstance(rel, list):
        return rel[0] if rel else None
    return rel


def _social_counts(obs_ids: list, current_user_id: str = None) -> dict:
    """Batch-fetch like/comment counts (and current user's likes) for a page of rows."""
    social = {"likes": {}, "comments": {}, "liked": set()}
    if not obs_ids:
        return social
    sb = get_supabase()
    likes = sb.table("observation_likes").select("observation_id, user_id").in_("observation_id", obs_ids).execute()
    for row in likes.data:
        social["likes"][row["observation_id"]] = social["likes"].get(row["observation_id"], 0) + 1
        if current_user_id and row["user_id"] == current_user_id:
            social["liked"].add(row["observation_id"])
    comments = sb.table("observation_comments").select("observation_id").in_("observation_id", obs_ids).execute()
    for row in comments.data:
        social["comments"][row["observation_id"]] = social["comments"].get(row["observation_id"], 0) + 1
    return social


def _obs_to_dict(row: dict, include_user=False, include_images=True,
                 current_user_id=None, social=None,
                 include_admin_notes=False) -> dict:
    images = row.get("observation_images") or [] if include_images else []
    primary = next((i for i in images if i.get("is_primary")), images[0] if images else None)

    user = _one(row.get("users"))
    species = _one(row.get("species"))
    ident = _one(row.get("identification_results"))
    matches = (ident.get("identification_matches") or []) if ident else []
    matches.sort(key=lambda m: m.get("rank") or 0)

    identified_species_id = None
    identified_species_name = None
    identification_confidence = None
    identification_status = ident.get("status") if ident else None
    identification_reasoning = None

    if species:
        identified_species_id = species["id"]
        identified_species_name = species["common_name"]
        match = next((m for m in matches if m.get("species_id") == row.get("species_id")), None)
        if match:
            identification_confidence = match.get("confidence_score")
    elif ident and ident.get("status") == "completed":
        top_match = next((m for m in matches if m.get("rank") == 1), None)
        if top_match:
            identified_species_id = top_match.get("species_id")
            identified_species_name = top_match.get("matched_common_name")
            identification_confidence = top_match.get("confidence_score")

    raw_response = ident.get("raw_gemini_response") if ident else None
    if raw_response:
        try:
            raw_matches = raw_response.get("matches", [])
            if raw_matches:
                match_data = None
                if identified_species_name:
                    match_data = next(
                        (m for m in raw_matches
                         if m.get("common_name") == identified_species_name
                         or m.get("scientific_name") == identified_species_name),
                        None,
                    )
                if not match_data:
                    match_data = raw_matches[0]
                identification_reasoning = match_data.get("reasoning")
        except Exception:
            pass

    state = _one(row.get("india_states"))
    district = _one(row.get("india_districts"))
    social = social or {"likes": {}, "comments": {}, "liked": set()}

    data = {
        "id": row["id"],
        "user_id": row.get("user_id"),
        "species_id": row.get("species_id"),
        "title": row.get("title"),
        "notes": row.get("notes"),
        "weather": row.get("weather"),
        "butterfly_activity": row.get("butterfly_activity"),
        "count_observed": row.get("count_observed"),
        "observed_at": row.get("observed_at"),
        "state_id": row.get("state_id"),
        "state_name": state.get("name") if state else None,
        "district_id": row.get("district_id"),
        "district_name": district.get("name") if district else None,
        "latitude": row.get("latitude"),
        "longitude": row.get("longitude"),
        "location_name": row.get("location_name"),
        "privacy": row.get("privacy"),
        "verification_status": row.get("verification_status"),
        "created_at": row.get("created_at"),
        # ── Integration / AI ──
        "user_avatar_url": user.get("profile_image_url") if user else None,
        "identification_status": identification_status,
        "identified_species_id": identified_species_id,
        "identified_species_name": identified_species_name,
        "identification_confidence": identification_confidence,
        "identification_reasoning": identification_reasoning,
        "raw_gemini_response": raw_response,
        # ── Social ──
        "like_count": social["likes"].get(row["id"], 0),
        "comment_count": social["comments"].get(row["id"], 0),
        "primary_image_url": (primary.get("optimized_url") or primary.get("original_url")) if primary else None,
    }
    if current_user_id is not None:
        data["is_liked"] = row["id"] in social["liked"]
    # The moderation note (e.g. rejection reason) is only for the owner and staff.
    is_owner = current_user_id is not None and row.get("user_id") == current_user_id
    if include_admin_notes or is_owner:
        data["admin_notes"] = row.get("admin_notes")
    if include_user and row.get("privacy") != "anonymous_public":
        data["user"] = {
            "id": user["id"],
            "username": user["username"],
            "full_name": user["full_name"],
            "profile_image_url": user.get("profile_image_url"),
            "bio": user.get("bio"),
            "is_verified": user.get("is_verified"),
            "role": role_name(user),
            "preferred_state_id": user.get("preferred_state_id"),
            "created_at": user.get("created_at"),
        } if user else None
        data["user_name"] = user.get("full_name") if user else None
        data["user_username"] = user.get("username") if user else None
    if include_images:
        data["images"] = [_image_to_dict(img) for img in images]
    return data


def _image_to_dict(img: dict) -> dict:
    return {
        "id": img["id"],
        "original_url": img["original_url"],
        "optimized_url": img.get("optimized_url"),
        "thumbnail_url": img.get("thumbnail_url"),
        "is_primary": img.get("is_primary"),
        "width": img.get("width"),
        "height": img.get("height"),
    }


def _fetch_obs(obs_id: str) -> dict | None:
    sb = get_supabase()
    res = sb.table("observations").select(OBS_SELECT).eq("id", obs_id).eq("is_active", True).execute()
    return res.data[0] if res.data else None


def _serialize_page(rows: list, current_user_id=None, include_user=True,
                    include_admin_notes=False) -> list:
    social = _social_counts([r["id"] for r in rows], current_user_id)
    return [
        _obs_to_dict(r, include_user=include_user, include_images=True,
                     current_user_id=current_user_id, social=social,
                     include_admin_notes=include_admin_notes)
        for r in rows
    ]


# ── Create ─────────────────────────────────────────────────────────────────────

def create_observation(user_id: str, data: dict) -> dict:
    sb = get_supabase()
    observed_at = data.get("observed_at") or datetime.now(timezone.utc)
    if isinstance(observed_at, datetime):
        observed_at = observed_at.isoformat()

    now = _now()
    obs_id = str(uuid.uuid4())
    sb.table("observations").insert({
        "id": obs_id,
        "user_id": user_id,
        "title": data.get("title"),
        "notes": data.get("notes"),
        "weather": data.get("weather"),
        "butterfly_activity": data.get("butterfly_activity"),
        "count_observed": data.get("count_observed", 1),
        "observed_at": observed_at,
        "state_id": data["state_id"],
        "district_id": data.get("district_id"),
        "latitude": data.get("latitude"),
        "longitude": data.get("longitude"),
        "location_name": data.get("location_name"),
        "privacy": data.get("privacy", "public"),
        "verification_status": "pending",
        "is_active": True,
        "created_at": now,
        "updated_at": now,
    }).execute()

    # Update stats/streak/achievements. Still SQLAlchemy-backed — never let a
    # hooks failure roll back the (already committed) observation insert.
    try:
        from app.services.achievement_service import post_observation_hooks
        post_observation_hooks(user_id, observed_at)
    except Exception:
        import logging
        logging.getLogger(__name__).exception("post_observation_hooks failed for %s", obs_id)

    row = _fetch_obs(obs_id)
    social = _social_counts([obs_id], user_id)
    return _obs_to_dict(row, include_images=True, social=social)


# ── Read ───────────────────────────────────────────────────────────────────────

def get_observation(obs_id: str, requesting_user_id: str) -> dict:
    obs = _fetch_obs(obs_id)
    if not obs:
        raise ObservationError("Observation not found.", 404)

    is_owner = obs["user_id"] == requesting_user_id
    is_staff = False if is_owner else _is_staff(requesting_user_id)

    if not is_owner and not is_staff:
        if obs.get("privacy") == "private":
            raise ObservationError("This observation is private.", 403)
        # Rejected sightings are hidden from everyone but the owner and staff —
        # 404 (not 403) so their existence isn't leaked.
        if obs.get("verification_status") == "rejected":
            raise ObservationError("Observation not found.", 404)

    social = _social_counts([obs_id], requesting_user_id)
    return _obs_to_dict(obs, include_user=True, include_images=True,
                        current_user_id=requesting_user_id, social=social,
                        include_admin_notes=is_owner or is_staff)


def list_user_observations(owner_id: str, requesting_user_id: str,
                           page: int, per_page: int, filters: dict) -> tuple:
    sb = get_supabase()
    query = sb.table("observations").select(OBS_SELECT, count="exact") \
        .eq("user_id", owner_id).eq("is_active", True)

    if owner_id != requesting_user_id and not _is_staff(requesting_user_id):
        query = query.neq("privacy", "private")
        # Rejected sightings are visible only to the owner and staff.
        query = query.neq("verification_status", "rejected")

    if filters.get("state_id"):
        query = query.eq("state_id", filters["state_id"])
    if filters.get("species_id"):
        query = query.eq("species_id", filters["species_id"])
    if filters.get("verification_status"):
        query = query.eq("verification_status", filters["verification_status"])

    start = (page - 1) * per_page
    res = query.order("observed_at", desc=True).range(start, start + per_page - 1).execute()
    items = _serialize_page(res.data, current_user_id=requesting_user_id, include_user=False)
    return items, res.count or 0


def list_public_feed(page: int, per_page: int, filters: dict, current_user_id: str = None) -> tuple:
    """Community feed — public + anonymous_public observations (plus optional user private)."""
    sb = get_supabase()
    privacy_filter = filters.get("privacy", "public")

    query = sb.table("observations").select(OBS_SELECT, count="exact").eq("is_active", True)

    if privacy_filter == "private":
        if not current_user_id:
            return [], 0
        query = query.eq("user_id", current_user_id).eq("privacy", "private")
    elif privacy_filter == "all" and current_user_id:
        query = query.or_(
            "privacy.in.(public,anonymous_public),"
            f"and(user_id.eq.{current_user_id},privacy.eq.private)"
        )
        # Rejected sightings never appear in the community feed (owners still
        # see theirs under "My observations").
        query = query.neq("verification_status", "rejected")
    else:
        query = query.in_("privacy", ["public", "anonymous_public"])
        query = query.neq("verification_status", "rejected")

    if filters.get("state_id"):
        query = query.eq("state_id", filters["state_id"])
    if filters.get("species_id"):
        query = query.eq("species_id", filters["species_id"])
    if filters.get("verification_status"):
        query = query.eq("verification_status", filters["verification_status"])

    start = (page - 1) * per_page
    res = query.order("observed_at", desc=True).range(start, start + per_page - 1).execute()

    social = _social_counts([r["id"] for r in res.data], current_user_id)
    result = []
    for row in res.data:
        d = _obs_to_dict(
            row,
            include_images=True,
            include_user=(row.get("privacy") == "public"),
            current_user_id=current_user_id,
            social=social,
        )
        if row.get("privacy") == "anonymous_public":
            d["user"] = None  # hide identity
        result.append(d)
    return result, res.count or 0


# ── Update ─────────────────────────────────────────────────────────────────────

def update_observation(obs_id: str, user_id: str, data: dict) -> dict:
    sb = get_supabase()
    obs = _fetch_obs(obs_id)
    if not obs:
        raise ObservationError("Observation not found.", 404)
    # Staff can edit any sighting (the owner is notified below).
    _check_ownership(obs, user_id, allow_admin=True)

    allowed = [
        "title", "notes", "weather", "butterfly_activity", "count_observed",
        "observed_at", "state_id", "district_id", "latitude", "longitude",
        "location_name", "privacy", "species_id",
    ]
    update_fields = {}
    for field in allowed:
        if field in data:
            value = data[field]
            if isinstance(value, datetime):
                value = value.isoformat()
            update_fields[field] = value

    # Manual species pick by the owner: the species must exist, and the
    # sighting stays "pending" until a moderator verifies the claim.
    if update_fields.get("species_id"):
        species = sb.table("species").select("id") \
            .eq("id", update_fields["species_id"]).limit(1).execute().data
        if not species:
            raise ObservationError("Species not found.", 404)
        update_fields["verification_status"] = "pending"

    update_fields["updated_at"] = _now()

    sb.table("observations").update(update_fields).eq("id", obs_id).execute()

    # Staff editing someone else's sighting → audit + notify the owner.
    if obs["user_id"] != user_id:
        from app.services.moderation_service import log_admin_activity
        changed = ", ".join(k for k in update_fields if k != "updated_at")
        log_admin_activity(user_id, "edit_observation", f"Changed: {changed}",
                           entity_type="Observation", entity_id=obs_id)
        from app.services.notification_service import notify_moderation
        notify_moderation(
            obs["user_id"],
            "Your sighting was edited",
            "A moderator updated details of your butterfly sighting "
            f"({changed}).",
            data={"observation_id": obs_id, "action": "edited"},
        )

    row = _fetch_obs(obs_id)
    social = _social_counts([obs_id], user_id)
    return _obs_to_dict(row, include_images=True, social=social,
                        include_admin_notes=obs["user_id"] == user_id)


def update_privacy(obs_id: str, user_id: str, privacy: str) -> dict:
    sb = get_supabase()
    obs = _fetch_obs(obs_id)
    if not obs:
        raise ObservationError("Observation not found.", 404)
    _check_ownership(obs, user_id)
    sb.table("observations").update({"privacy": privacy, "updated_at": _now()}).eq("id", obs_id).execute()
    row = _fetch_obs(obs_id)
    social = _social_counts([obs_id], user_id)
    return _obs_to_dict(row, include_images=True, social=social)


# ── Delete ─────────────────────────────────────────────────────────────────────

def delete_observation(obs_id: str, user_id: str, reason: str = None) -> None:
    sb = get_supabase()
    obs = _fetch_obs(obs_id)
    if not obs:
        raise ObservationError("Observation not found.", 404)
    _check_ownership(obs, user_id, allow_admin=True)
    sb.table("observations").update({"is_active": False, "updated_at": _now()}).eq("id", obs_id).execute()

    # A moderator removing someone else's sighting → tell the owner why.
    if obs["user_id"] != user_id:
        from app.services.moderation_service import record_action, log_admin_activity
        try:
            record_action(user_id, obs["user_id"], "content_removed", reason,
                          related_entity_type="Observation", related_entity_id=obs_id)
        except Exception:
            pass
        log_admin_activity(user_id, "delete_observation", reason or "",
                           entity_type="Observation", entity_id=obs_id)

        from app.services.notification_service import notify_moderation
        body = "A moderator removed your butterfly sighting."
        if reason:
            body += f" Reason: {reason}"
        notify_moderation(
            obs["user_id"],
            "Your sighting was removed",
            body,
            data={"observation_id": obs_id, "action": "deleted"},
        )


# ── Images ─────────────────────────────────────────────────────────────────────

def add_image(obs_id: str, user_id: str, file_storage) -> dict:
    from flask import current_app
    from app.services.storage_service import upload_file

    sb = get_supabase()
    obs = _fetch_obs(obs_id)
    if not obs:
        raise ObservationError("Observation not found.", 404)
    _check_ownership(obs, user_id)

    existing_count = len(obs.get("observation_images") or [])
    max_images = current_app.config.get("MAX_IMAGES_PER_OBSERVATION", 5)
    if existing_count >= max_images:
        raise ObservationError(f"Maximum {max_images} images per observation.", 400)

    urls = upload_file(file_storage, folder=f"observations/{obs_id}")
    res = sb.table("observation_images").insert({
        "id": str(uuid.uuid4()),
        "observation_id": obs_id,
        "original_url": urls["original_url"],
        "optimized_url": urls["optimized_url"],
        "thumbnail_url": urls["thumbnail_url"],
        "is_primary": existing_count == 0,
        "file_size_bytes": urls["file_size_bytes"],
        "width": urls["width"],
        "height": urls["height"],
        "created_at": _now(),
    }).execute()
    return _image_to_dict(res.data[0])


def delete_image(obs_id: str, image_id: str, user_id: str) -> None:
    sb = get_supabase()
    obs = _fetch_obs(obs_id)
    if not obs:
        raise ObservationError("Observation not found.", 404)
    _check_ownership(obs, user_id)

    img = sb.table("observation_images").select("id").eq("id", image_id).eq("observation_id", obs_id).execute()
    if not img.data:
        raise ObservationError("Image not found.", 404)
    sb.table("observation_images").delete().eq("id", image_id).execute()


# ── Share link ─────────────────────────────────────────────────────────────────

def _share_to_dict(share: dict) -> dict:
    return {
        "id": share["id"],
        "share_token": share["share_token"],
        "view_count": share["view_count"],
        "created_at": share.get("created_at"),
    }


def get_or_create_share_link(obs_id: str, user_id: str) -> dict:
    sb = get_supabase()
    obs = _fetch_obs(obs_id)
    if not obs:
        raise ObservationError("Observation not found.", 404)
    _check_ownership(obs, user_id)

    existing = sb.table("public_shares").select("*").eq("observation_id", obs_id).execute()
    if existing.data:
        return _share_to_dict(existing.data[0])

    res = sb.table("public_shares").insert({
        "id": str(uuid.uuid4()),
        "observation_id": obs_id,
        "share_token": secrets.token_urlsafe(32),
        "is_active": True,
        "view_count": 0,
        "created_at": _now(),
    }).execute()
    return _share_to_dict(res.data[0])


def get_by_share_token(token: str) -> dict:
    sb = get_supabase()
    res = sb.table("public_shares").select("*").eq("share_token", token).eq("is_active", True).execute()
    share = res.data[0] if res.data else None
    if not share:
        raise ObservationError("Share link not found or expired.", 404)

    obs = _fetch_obs(share["observation_id"])
    if not obs:
        raise ObservationError("Share link not found or expired.", 404)
    # Share links are anonymous — a rejected sighting is hidden here too.
    if obs.get("verification_status") == "rejected":
        raise ObservationError("Share link not found or expired.", 404)

    sb.table("public_shares").update({"view_count": share["view_count"] + 1}).eq("id", share["id"]).execute()

    social = _social_counts([obs["id"]])
    d = _obs_to_dict(obs, include_images=True, social=social)
    user = _one(obs.get("users"))
    if obs.get("privacy") == "anonymous_public":
        d["user"] = None
    else:
        d["user"] = {
            "id": user["id"],
            "username": user["username"],
            "full_name": user["full_name"],
            "profile_image_url": user.get("profile_image_url"),
            "bio": user.get("bio"),
            "is_verified": user.get("is_verified"),
            "role": role_name(user),
            "preferred_state_id": user.get("preferred_state_id"),
            "created_at": user.get("created_at"),
        } if user else None
    return d


# ── Admin actions ──────────────────────────────────────────────────────────────

def admin_list_observations(page: int, per_page: int, filters: dict) -> tuple:
    sb = get_supabase()
    query = sb.table("observations").select(OBS_SELECT, count="exact").eq("is_active", True)

    if filters.get("user_id"):
        query = query.eq("user_id", filters["user_id"])
    if filters.get("state_id"):
        query = query.eq("state_id", filters["state_id"])
    if filters.get("verification_status"):
        query = query.eq("verification_status", filters["verification_status"])
    if filters.get("species_id"):
        query = query.eq("species_id", filters["species_id"])
    if filters.get("search"):
        term = filters["search"]
        query = query.or_(f"title.ilike.%{term}%,location_name.ilike.%{term}%,notes.ilike.%{term}%")

    start = (page - 1) * per_page
    res = query.order("created_at", desc=True).range(start, start + per_page - 1).execute()
    items = _serialize_page(res.data, include_user=True, include_admin_notes=True)
    return items, res.count or 0


def admin_verify_observation(obs_id: str, admin_id: str, species_id: str = None, notes: str = None) -> dict:
    sb = get_supabase()
    obs = _fetch_obs(obs_id)
    if not obs:
        raise ObservationError("Observation not found.", 404)

    update_fields = {
        "verification_status": "expert_verified",
        "verified_by": admin_id,
        "verified_at": _now(),
        "admin_notes": notes,
        "updated_at": _now(),
    }
    if species_id:
        update_fields["species_id"] = species_id
    sb.table("observations").update(update_fields).eq("id", obs_id).execute()

    from app.services.notification_service import notify_moderation
    notify_moderation(
        obs["user_id"],
        "Your sighting was verified ✅",
        "A moderator expert-verified your butterfly sighting. "
        "It now counts as a confirmed record.",
        data={"observation_id": obs_id, "action": "verified"},
    )

    row = _fetch_obs(obs_id)
    social = _social_counts([obs_id])
    return _obs_to_dict(row, include_user=True, include_images=True, social=social,
                        include_admin_notes=True)


def admin_reject_observation(obs_id: str, admin_id: str, notes: str) -> dict:
    sb = get_supabase()
    obs = _fetch_obs(obs_id)
    if not obs:
        raise ObservationError("Observation not found.", 404)

    sb.table("observations").update({
        "verification_status": "rejected",
        "verified_by": admin_id,
        "verified_at": _now(),
        "admin_notes": notes,
        "updated_at": _now(),
    }).eq("id", obs_id).execute()

    from app.services.notification_service import notify_moderation
    notify_moderation(
        obs["user_id"],
        "Your sighting was rejected",
        f"A moderator rejected your butterfly sighting. Reason: {notes} "
        "It is now hidden from the community, but you can still see it "
        "under My Sightings.",
        data={"observation_id": obs_id, "action": "rejected"},
    )

    row = _fetch_obs(obs_id)
    social = _social_counts([obs_id])
    return _obs_to_dict(row, include_user=True, include_images=True, social=social,
                        include_admin_notes=True)
