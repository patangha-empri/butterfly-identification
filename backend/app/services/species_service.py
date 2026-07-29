"""Species listing, filtering, and admin CRUD — via Supabase PostgREST."""
import uuid
from datetime import datetime, timezone

# pyrefly: ignore [missing-import]
from slugify import slugify

from app.supabase_client import get_supabase

_SELECT = "*, species_images(*), species_host_plants(*), species_india_distribution(*, india_states(name, code))"


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
    }
    data["primary_image"] = _image_to_dict(primary_img) if primary_img else None

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
        "slug": slug,
        "is_active": True,
        "created_by": admin_id,
        "created_at": now,
        "updated_at": now,
    }
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

    allowed = [
        "common_name", "scientific_name", "family", "genus", "description",
        "habitat", "seasonal_appearance", "conservation_status",
        "wing_span_min_mm", "wing_span_max_mm", "is_migratory", "color_tags", "is_active",
    ]
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
    sb = get_supabase()
    existing = sb.table("species").select("id").eq("id", species_id).execute()
    if not existing.data:
        raise SpeciesError("Species not found.", 404)
    sb.table("species").update({"is_active": False}).eq("id", species_id).execute()


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
