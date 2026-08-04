"""Species listing, filtering, and admin CRUD — via Supabase PostgREST."""
import uuid
from datetime import datetime, timezone

# pyrefly: ignore [missing-import]
from slugify import slugify

from app.supabase_client import get_supabase

_SELECT = "*, species_images(*), species_host_plants(*), species_india_distribution(*, india_states(name, code))"

# Research columns added by migration 001. They live in real columns but were
# never surfaced by _to_dict, so the ingested research data was invisible to the
# API, the admin panel and the app. Grouped here to keep _to_dict readable and
# to give the admin form and the update whitelist a single source of truth.
TAXONOMY_FIELDS = (
    "subfamily", "tribe", "species_epithet", "subspecies", "authority",
    "taxon_year", "accepted_name", "synonyms", "taxonomic_notes",
)
MORPHOLOGY_FIELDS = (
    "identification_notes", "male_description", "female_description",
    "upperside_description", "underside_description", "wing_pattern",
    "wing_colour", "body_colour", "body_length_min_mm", "body_length_max_mm",
)
LIFECYCLE_FIELDS = (
    "egg_description", "larva_description", "pupa_description",
    "adult_description", "life_cycle", "flight_period", "breeding_season",
)
ECOLOGY_FIELDS = (
    "nectar_plants", "forest_type", "altitude_min_m", "altitude_max_m",
    "behaviour", "migration_notes", "predators",
)
DISTRIBUTION_FIELDS = ("countries", "protected_areas")
CONSERVATION_FIELDS = ("iucn_status", "iucn_assessment_url", "legal_protection")
KNOWLEDGE_FIELDS = ("interesting_facts", "research_notes", "citations", "source_urls")
PROVENANCE_FIELDS = (
    "confidence_score", "verification_status", "last_verified", "data_source",
    "field_provenance",
)

RESEARCH_FIELDS = (
    TAXONOMY_FIELDS + MORPHOLOGY_FIELDS + LIFECYCLE_FIELDS + ECOLOGY_FIELDS
    + DISTRIBUTION_FIELDS + CONSERVATION_FIELDS + KNOWLEDGE_FIELDS + PROVENANCE_FIELDS
)

# Research fields stored as JSONB arrays — default to [] rather than None so the
# admin form can bind list editors without null checks.
_LIST_FIELDS = frozenset({
    "synonyms", "nectar_plants", "countries", "protected_areas",
    "citations", "source_urls",
})

# Reserved keys a custom field may not use: anything that is already a real
# column would silently shadow it in the admin form.
RESERVED_FIELD_KEYS = frozenset(RESEARCH_FIELDS) | {
    "id", "common_name", "scientific_name", "family", "genus", "description",
    "description_short", "habitat", "rarity", "conservation_status",
    "wingspan_mm", "wing_span_min_mm", "wing_span_max_mm", "flight_months",
    "seasonal_appearance", "color_tags", "slug", "is_active", "is_migratory",
    "primary_image_url", "primary_image", "observation_count", "custom_fields",
    "created_by", "created_at", "updated_at", "images", "host_plants",
    "states", "distribution_states",
}


class SpeciesError(Exception):
    def __init__(self, message: str, status_code: int = 400):
        self.message = message
        self.status_code = status_code
        super().__init__(message)


def _observation_count(species_id: str) -> int:
    sb = get_supabase()
    res = (
        sb.table("observations")
        .select("id", count="exact")
        .eq("species_id", species_id)
        .execute()
    )
    return res.count or 0


def _to_dict(row: dict, include_related: bool = False) -> dict:
    wingspan = ""
    if row.get("wing_span_min_mm") and row.get("wing_span_max_mm"):
        wingspan = f"{row['wing_span_min_mm']}-{row['wing_span_max_mm']} mm"
    elif row.get("wing_span_min_mm"):
        wingspan = f"{row['wing_span_min_mm']} mm"

    images = row.get("species_images") or []
    primary_img = next((i for i in images if i.get("is_primary")), None)

    description = row.get("description")
    desc_short = description[:150] + "..." if description and len(description) > 150 else description

    data = {
        "id": row["id"],
        "common_name": row["common_name"],
        "scientific_name": row["scientific_name"],
        "family": row["family"],
        "genus": row["genus"],
        "description": description,
        "description_short": desc_short,
        "habitat": row.get("habitat"),
        "rarity": "Common",
        "conservation_status": row.get("conservation_status"),
        "wingspan_mm": wingspan,
        "flight_months": row.get("seasonal_appearance") or [],
        "color_tags": row.get("color_tags") or [],
        "slug": row["slug"],
        "primary_image_url": primary_img["image_url"] if primary_img else None,
        "observation_count": _observation_count(row["id"]),
        # Needed by the admin panel to show and toggle app visibility. Public
        # reads are already filtered to is_active=True, so this is always true
        # for app clients.
        "is_active": row.get("is_active", True),
        "is_migratory": row.get("is_migratory", False),
        "wing_span_min_mm": row.get("wing_span_min_mm"),
        "wing_span_max_mm": row.get("wing_span_max_mm"),
        "custom_fields": row.get("custom_fields") or {},
    }
    data["primary_image"] = _image_to_dict(primary_img) if primary_img else None

    # Research columns (migration 001). Additive — clients that don't know these
    # keys ignore them.
    for field in RESEARCH_FIELDS:
        value = row.get(field)
        if value is None and field in _LIST_FIELDS:
            value = []
        data[field] = value

    if include_related:
        data["host_plants"] = [
            {"name": p["plant_name"], "scientific_name": p.get("plant_scientific_name")}
            for p in (row.get("species_host_plants") or [])
        ]
        data["states"] = [
            d["india_states"]["name"]
            for d in (row.get("species_india_distribution") or [])
            if d.get("india_states")
        ]
        data["images"] = [
            {
                "image_url": img["image_url"],
                "caption": f"{row['common_name']} - {img.get('image_type')}",
                "credit": img.get("credit"),
                "is_primary": img.get("is_primary"),
            }
            for img in images
        ]
        data["distribution_states"] = [_distribution_to_dict(d) for d in (row.get("species_india_distribution") or [])]

    return data


def _image_to_dict(img: dict) -> dict:
    return {
        "id": img["id"],
        "image_url": img["image_url"],
        "thumbnail_url": img.get("thumbnail_url"),
        "image_type": img.get("image_type"),
        "is_primary": img.get("is_primary"),
        "credit": img.get("credit"),
    }


def _distribution_to_dict(d: dict) -> dict:
    state = d.get("india_states") or {}
    return {
        "state_id": d["state_id"],
        "state_name": state.get("name"),
        "state_code": state.get("code"),
        "abundance": d.get("abundance"),
    }


def list_species_admin(filters: dict, page: int, per_page: int) -> tuple:
    """
    Admin listing. Deliberately does NOT filter on is_active — staff must be
    able to see, find and reactivate deactivated species. The public
    list_species() below is the one that hides them from the app.
    """
    sb = get_supabase()
    query = sb.table("species").select(_SELECT, count="exact")

    status = filters.get("status")
    if status == "active":
        query = query.eq("is_active", True)
    elif status == "inactive":
        query = query.eq("is_active", False)

    if filters.get("search"):
        term = filters["search"]
        query = query.or_(f"common_name.ilike.%{term}%,scientific_name.ilike.%{term}%")
    if filters.get("family"):
        query = query.ilike("family", f"%{filters['family']}%")
    if filters.get("conservation_status"):
        query = query.eq("conservation_status", filters["conservation_status"])

    start = (page - 1) * per_page
    res = query.order("common_name").range(start, start + per_page - 1).execute()
    return [_to_dict(row, include_related=True) for row in res.data], res.count or 0


def list_species(filters: dict, page: int, per_page: int) -> tuple:
    """Public listing with optional filters. Returns (items_list, total)."""
    sb = get_supabase()
    select = _SELECT
    if filters.get("state_id"):
        # !inner forces PostgREST to only return species that have a matching
        # distribution row, so the state_id filter below actually restricts results.
        select = select.replace(
            "species_india_distribution(*, india_states(name, code))",
            "species_india_distribution!inner(*, india_states(name, code))",
        )

    query = sb.table("species").select(select, count="exact").eq("is_active", True)

    if filters.get("family"):
        query = query.ilike("family", f"%{filters['family']}%")
    if filters.get("conservation_status"):
        query = query.eq("conservation_status", filters["conservation_status"])
    if filters.get("is_migratory") is not None:
        query = query.eq("is_migratory", filters["is_migratory"])
    if filters.get("search"):
        term = filters["search"]
        query = query.or_(f"common_name.ilike.%{term}%,scientific_name.ilike.%{term}%")
    if filters.get("state_id"):
        query = query.eq("species_india_distribution.state_id", filters["state_id"])
    if filters.get("color"):
        query = query.contains("color_tags", [filters["color"]])

    query = query.order("common_name")
    start = (page - 1) * per_page
    query = query.range(start, start + per_page - 1)

    res = query.execute()
    items = [_to_dict(row, include_related=True) for row in res.data]
    return items, res.count or 0


def get_species(slug_or_id: str) -> dict:
    """Get full species detail by slug or UUID."""
    sb = get_supabase()
    res = (
        sb.table("species")
        .select(_SELECT)
        .eq("slug", slug_or_id)
        .eq("is_active", True)
        .execute()
    )
    row = res.data[0] if res.data else None
    if not row:
        res = (
            sb.table("species")
            .select(_SELECT)
            .eq("id", slug_or_id)
            .eq("is_active", True)
            .execute()
        )
        row = res.data[0] if res.data else None
    if not row:
        raise SpeciesError("Species not found.", 404)
    return _to_dict(row, include_related=True)


def get_species_admin(species_id: str) -> dict:
    """
    Admin detail lookup by id or slug, WITHOUT the is_active filter.

    get_species() below 404s on a deactivated species — correct for the app, but
    it would leave staff unable to open a species in order to reactivate it.
    """
    sb = get_supabase()
    res = sb.table("species").select(_SELECT).eq("id", species_id).execute()
    row = res.data[0] if res.data else None
    if not row:
        res = sb.table("species").select(_SELECT).eq("slug", species_id).execute()
        row = res.data[0] if res.data else None
    if not row:
        raise SpeciesError("Species not found.", 404)
    return _to_dict(row, include_related=True)


def get_similar_species(slug_or_id: str) -> list:
    """Get similar species by family or genus, excluding the source species."""
    sb = get_supabase()
    res = sb.table("species").select("id, family").eq("slug", slug_or_id).eq("is_active", True).execute()
    row = res.data[0] if res.data else None
    if not row:
        res = sb.table("species").select("id, family").eq("id", slug_or_id).eq("is_active", True).execute()
        row = res.data[0] if res.data else None
    if not row:
        raise SpeciesError("Species not found.", 404)

    res = (
        sb.table("species")
        .select(_SELECT)
        .eq("family", row["family"])
        .neq("id", row["id"])
        .eq("is_active", True)
        .limit(5)
        .execute()
    )
    similar = res.data

    if not similar:
        res = (
            sb.table("species")
            .select(_SELECT)
            .neq("id", row["id"])
            .eq("is_active", True)
            .limit(5)
            .execute()
        )
        similar = res.data

    return [_to_dict(s, include_related=True) for s in similar]


# ── Admin CRUD ─────────────────────────────────────────────────────────────────

def create_species(data: dict, admin_id: str) -> dict:
    sb = get_supabase()
    existing = sb.table("species").select("id").eq("scientific_name", data["scientific_name"]).execute()
    if existing.data:
        raise SpeciesError("A species with this scientific name already exists.", 409)

    slug = slugify(data["common_name"])
    if sb.table("species").select("id").eq("slug", slug).execute().data:
        slug = slugify(data["scientific_name"])

    now = datetime.now(timezone.utc).isoformat()
    row = {
        "id": str(uuid.uuid4()),
        "common_name": data["common_name"],
        "scientific_name": data["scientific_name"],
        "family": data["family"],
        "genus": data["genus"],
        "description": data.get("description"),
        "habitat": data.get("habitat"),
        "seasonal_appearance": data.get("seasonal_appearance", []),
        "conservation_status": data.get("conservation_status", "LC"),
        "wing_span_min_mm": data.get("wing_span_min_mm"),
        "wing_span_max_mm": data.get("wing_span_max_mm"),
        "is_migratory": data.get("is_migratory", False),
        "color_tags": data.get("color_tags", []),
        "custom_fields": data.get("custom_fields") or {},
        "slug": slug,
        "is_active": True,
        "created_by": admin_id,
        "created_at": now,
        "updated_at": now,
    }
    # Research columns are optional — only write the ones actually supplied so
    # the DB defaults apply to the rest.
    for field in RESEARCH_FIELDS:
        if field in data:
            row[field] = data[field]

    res = sb.table("species").insert(row).select(_SELECT).execute()
    return _to_dict(res.data[0], include_related=True)


def update_species(species_id: str, data: dict) -> dict:
    sb = get_supabase()
    existing = sb.table("species").select("*").eq("id", species_id).execute()
    if not existing.data:
        raise SpeciesError("Species not found.", 404)
    species = existing.data[0]

    if "scientific_name" in data and data["scientific_name"] != species["scientific_name"]:
        dupe = sb.table("species").select("id").eq("scientific_name", data["scientific_name"]).execute()
        if dupe.data:
            raise SpeciesError("Scientific name already used by another species.", 409)

    allowed = {
        "common_name", "scientific_name", "family", "genus", "description",
        "habitat", "seasonal_appearance", "conservation_status",
        "wing_span_min_mm", "wing_span_max_mm", "is_migratory", "color_tags",
        "is_active", "custom_fields",
    } | set(RESEARCH_FIELDS)
    update_fields = {k: v for k, v in data.items() if k in allowed}

    if "common_name" in data:
        new_slug = slugify(data["common_name"])
        clash = sb.table("species").select("id").eq("slug", new_slug).neq("id", species_id).execute()
        if clash.data:
            new_slug = slugify(data.get("scientific_name", species["scientific_name"]))
        update_fields["slug"] = new_slug

    update_fields["updated_at"] = datetime.now(timezone.utc).isoformat()

    sb.table("species").update(update_fields).eq("id", species_id).execute()
    res = sb.table("species").select(_SELECT).eq("id", species_id).execute()
    return _to_dict(res.data[0], include_related=True)


def deactivate_species(species_id: str) -> None:
    """
    Soft delete. The row stays put and keeps its observations and identification
    matches intact; every public read filters is_active, so the species simply
    stops appearing in the app. Reverse with activate_species().
    """
    sb = get_supabase()
    existing = sb.table("species").select("id").eq("id", species_id).execute()
    if not existing.data:
        raise SpeciesError("Species not found.", 404)
    sb.table("species").update({
        "is_active": False,
        "updated_at": datetime.now(timezone.utc).isoformat(),
    }).eq("id", species_id).execute()


def activate_species(species_id: str) -> dict:
    """Undo deactivate_species — the species becomes visible in the app again."""
    sb = get_supabase()
    existing = sb.table("species").select("id").eq("id", species_id).execute()
    if not existing.data:
        raise SpeciesError("Species not found.", 404)
    sb.table("species").update({
        "is_active": True,
        "updated_at": datetime.now(timezone.utc).isoformat(),
    }).eq("id", species_id).execute()
    res = sb.table("species").select(_SELECT).eq("id", species_id).execute()
    return _to_dict(res.data[0], include_related=True)


# ── Custom field definitions ───────────────────────────────────────────────────
# The shared vocabulary behind species.custom_fields. See migration 004.

def _field_definition_to_dict(row: dict) -> dict:
    return {
        "id": row["id"],
        "field_key": row["field_key"],
        "label": row["label"],
        "field_type": row.get("field_type", "text"),
        "help_text": row.get("help_text"),
        "group_name": row.get("group_name") or "Custom fields",
        "sort_order": row.get("sort_order", 0),
        "is_active": row.get("is_active", True),
        "created_at": row.get("created_at"),
    }


def list_field_definitions(include_retired: bool = False) -> list:
    sb = get_supabase()
    query = sb.table("species_field_definitions").select("*")
    if not include_retired:
        query = query.eq("is_active", True)
    res = query.order("sort_order").order("label").execute()
    return [_field_definition_to_dict(r) for r in res.data]


def create_field_definition(data: dict, admin_id: str) -> dict:
    sb = get_supabase()
    key = (data.get("field_key") or "").strip().lower()

    # A key matching a real column would shadow it in the admin form and never
    # be readable back, so refuse rather than silently accept.
    if key in RESERVED_FIELD_KEYS:
        raise SpeciesError(
            f"'{key}' is already a built-in species field. Choose a different key.", 409
        )
    if sb.table("species_field_definitions").select("id").eq("field_key", key).execute().data:
        raise SpeciesError(f"A custom field with the key '{key}' already exists.", 409)

    now = datetime.now(timezone.utc).isoformat()
    row = {
        "id": str(uuid.uuid4()),
        "field_key": key,
        "label": data["label"].strip(),
        "field_type": data.get("field_type", "text"),
        "help_text": data.get("help_text"),
        "group_name": data.get("group_name") or "Custom fields",
        "sort_order": data.get("sort_order", 0),
        "is_active": True,
        "created_by": admin_id,
        "created_at": now,
        "updated_at": now,
    }
    res = sb.table("species_field_definitions").insert(row).execute()
    return _field_definition_to_dict(res.data[0])


def update_field_definition(definition_id: str, data: dict) -> dict:
    """
    Edits presentation only. field_key is immutable — changing it would orphan
    every value already stored under the old key in species.custom_fields.
    """
    sb = get_supabase()
    existing = sb.table("species_field_definitions").select("*").eq("id", definition_id).execute()
    if not existing.data:
        raise SpeciesError("Custom field not found.", 404)

    allowed = {"label", "field_type", "help_text", "group_name", "sort_order", "is_active"}
    update_fields = {k: v for k, v in data.items() if k in allowed}
    update_fields["updated_at"] = datetime.now(timezone.utc).isoformat()

    sb.table("species_field_definitions").update(update_fields).eq("id", definition_id).execute()
    res = sb.table("species_field_definitions").select("*").eq("id", definition_id).execute()
    return _field_definition_to_dict(res.data[0])


def retire_field_definition(definition_id: str) -> None:
    """
    Removes the field from the picker WITHOUT touching values already stored on
    species. Data an admin captured is never destroyed by a vocabulary change;
    re-activating the definition brings the existing values back into view.
    """
    sb = get_supabase()
    existing = sb.table("species_field_definitions").select("id").eq("id", definition_id).execute()
    if not existing.data:
        raise SpeciesError("Custom field not found.", 404)
    sb.table("species_field_definitions").update({
        "is_active": False,
        "updated_at": datetime.now(timezone.utc).isoformat(),
    }).eq("id", definition_id).execute()


# ── Species images ─────────────────────────────────────────────────────────────

def add_species_image(species_id: str, file_storage, image_type: str, credit: str = None) -> dict:
    from app.services.storage_service import upload_file

    sb = get_supabase()
    existing = sb.table("species").select("id").eq("id", species_id).execute()
    if not existing.data:
        raise SpeciesError("Species not found.", 404)

    urls = upload_file(file_storage, folder=f"species/{species_id}", filename=None)
    count_res = sb.table("species_images").select("id", count="exact").eq("species_id", species_id).execute()
    is_primary = (count_res.count or 0) == 0

    row = {
        "id": str(uuid.uuid4()),
        "species_id": species_id,
        "image_url": urls["optimized_url"],
        "thumbnail_url": urls["thumbnail_url"],
        "image_type": image_type,
        "is_primary": is_primary,
        "credit": credit,
        "created_at": datetime.now(timezone.utc).isoformat(),
    }
    res = sb.table("species_images").insert(row).execute()
    return _image_to_dict(res.data[0])


def delete_species_image(species_id: str, image_id: str) -> None:
    sb = get_supabase()
    existing = sb.table("species_images").select("id").eq("id", image_id).eq("species_id", species_id).execute()
    if not existing.data:
        raise SpeciesError("Image not found.", 404)
    sb.table("species_images").delete().eq("id", image_id).eq("species_id", species_id).execute()


def set_primary_image(species_id: str, image_id: str) -> dict:
    sb = get_supabase()
    sb.table("species_images").update({"is_primary": False}).eq("species_id", species_id).eq("is_primary", True).execute()

    existing = sb.table("species_images").select("*").eq("id", image_id).eq("species_id", species_id).execute()
    if not existing.data:
        raise SpeciesError("Image not found.", 404)

    sb.table("species_images").update({"is_primary": True}).eq("id", image_id).eq("species_id", species_id).execute()
    res = sb.table("species_images").select("*").eq("id", image_id).execute()
    return _image_to_dict(res.data[0])


# ── Host plants & Distribution ─────────────────────────────────────────────────

def add_host_plant(species_id: str, plant_name: str, plant_scientific_name: str = None) -> dict:
    sb = get_supabase()
    row = {
        "species_id": species_id,
        "plant_name": plant_name,
        "plant_scientific_name": plant_scientific_name,
    }
    res = sb.table("species_host_plants").insert(row).execute()
    plant = res.data[0]
    return {"id": plant["id"], "plant_name": plant["plant_name"], "plant_scientific_name": plant.get("plant_scientific_name")}


def remove_host_plant(species_id: str, plant_id: int) -> None:
    sb = get_supabase()
    existing = sb.table("species_host_plants").select("id").eq("id", plant_id).eq("species_id", species_id).execute()
    if not existing.data:
        raise SpeciesError("Host plant not found.", 404)
    sb.table("species_host_plants").delete().eq("id", plant_id).eq("species_id", species_id).execute()


def set_distribution(species_id: str, state_id: int, abundance: str = "common") -> dict:
    sb = get_supabase()
    existing = (
        sb.table("species_india_distribution")
        .select("*")
        .eq("species_id", species_id)
        .eq("state_id", state_id)
        .execute()
    )
    if existing.data:
        sb.table("species_india_distribution").update({"abundance": abundance}).eq(
            "species_id", species_id
        ).eq("state_id", state_id).execute()
    else:
        sb.table("species_india_distribution").insert(
            {"species_id": species_id, "state_id": state_id, "abundance": abundance}
        ).execute()

    res = (
        sb.table("species_india_distribution")
        .select("*, india_states(name, code)")
        .eq("species_id", species_id)
        .eq("state_id", state_id)
        .execute()
    )
    return _distribution_to_dict(res.data[0])


def remove_distribution(species_id: str, state_id: int) -> None:
    sb = get_supabase()
    sb.table("species_india_distribution").delete().eq("species_id", species_id).eq("state_id", state_id).execute()
