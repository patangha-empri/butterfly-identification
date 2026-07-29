"""Seed India states and districts."""
from app.extensions import db
from app.models.geography import IndiaState, IndiaDistrict
from seeds.data.geography_data import INDIA_GEOGRAPHY


def run():
    print("  → Seeding India geography...")
    state_count = 0
    district_count = 0

    for state_data in INDIA_GEOGRAPHY:
        # Upsert state
        state = IndiaState.query.filter_by(code=state_data["code"]).first()
        if not state:
            state = IndiaState(
                name=state_data["name"],
                code=state_data["code"],
                region=state_data["region"],
                is_union_territory=state_data["is_union_territory"],
            )
            db.session.add(state)
            db.session.flush()  # get state.id without committing
            state_count += 1

        # Upsert districts for this state
        for district_name in state_data["districts"]:
            existing = IndiaDistrict.query.filter_by(
                name=district_name, state_id=state.id
            ).first()
            if not existing:
                district = IndiaDistrict(name=district_name, state_id=state.id)
                db.session.add(district)
                district_count += 1

    db.session.commit()
    print(
        f"  ✅ Geography: {state_count} states/UTs created, "
        f"{district_count} districts created."
    )
