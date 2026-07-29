"""Seed 50 butterfly species with host plants and India distribution."""
from slugify import slugify
from app.extensions import db
from app.models.species import Species, SpeciesHostPlant, SpeciesIndiaDistribution
from app.models.geography import IndiaState
from seeds.data.species_data import BUTTERFLY_SPECIES


def run():
    print("  → Seeding butterfly species...")

    # Build a state_code → state_id map for efficiency
    states = {s.code: s.id for s in IndiaState.query.all()}
    if not states:
        print("  ❌  No states found. Run seed-geography first.")
        return

    created = 0
    skipped = 0

    for sp_data in BUTTERFLY_SPECIES:
        # Skip if already exists
        existing = Species.query.filter_by(
            scientific_name=sp_data["scientific_name"]
        ).first()
        if existing:
            skipped += 1
            continue

        slug = slugify(sp_data["common_name"])
        # Ensure slug uniqueness
        if Species.query.filter_by(slug=slug).first():
            slug = slugify(sp_data["scientific_name"])

        species = Species(
            common_name=sp_data["common_name"],
            scientific_name=sp_data["scientific_name"],
            family=sp_data["family"],
            genus=sp_data["genus"],
            description=sp_data.get("description"),
            habitat=sp_data.get("habitat"),
            seasonal_appearance=sp_data.get("seasonal_appearance", []),
            conservation_status=sp_data.get("conservation_status", "LC"),
            wing_span_min_mm=sp_data.get("wing_span_min_mm"),
            wing_span_max_mm=sp_data.get("wing_span_max_mm"),
            is_migratory=sp_data.get("is_migratory", False),
            color_tags=sp_data.get("color_tags", []),
            slug=slug,
            is_active=True,
        )
        db.session.add(species)
        db.session.flush()  # get species.id

        # Add host plants
        for plant_data in sp_data.get("host_plants", []):
            plant = SpeciesHostPlant(
                species_id=species.id,
                plant_name=plant_data["plant_name"],
                plant_scientific_name=plant_data.get("plant_scientific_name"),
            )
            db.session.add(plant)

        # Add India distribution
        for state_code in set(sp_data.get("states", [])):
            state_id = states.get(state_code)
            if state_id:
                dist = SpeciesIndiaDistribution(
                    species_id=species.id,
                    state_id=state_id,
                    abundance="common",
                )
                db.session.add(dist)

        created += 1

    db.session.commit()
    print(f"  ✅ Species: {created} created, {skipped} already existed.")
