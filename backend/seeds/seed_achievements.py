"""Seed achievement definitions."""
from app.extensions import db
from app.models.achievement import AchievementDefinition


ACHIEVEMENTS = [
    {
        "name": "First Flutter",
        "description": "Submit your very first butterfly observation.",
        "achievement_type": "first_observation",
        "threshold_value": 1,
        "points": 10,
    },
    {
        "name": "Week Warrior",
        "description": "Observe butterflies for 7 consecutive days.",
        "achievement_type": "streak_7",
        "threshold_value": 7,
        "points": 25,
    },
    {
        "name": "Month Master",
        "description": "Observe butterflies for 30 consecutive days.",
        "achievement_type": "streak_30",
        "threshold_value": 30,
        "points": 100,
    },
    {
        "name": "Century Streak",
        "description": "Observe butterflies for 100 consecutive days.",
        "achievement_type": "streak_100",
        "threshold_value": 100,
        "points": 500,
    },
    {
        "name": "Budding Naturalist",
        "description": "Identify 10 different butterfly species.",
        "achievement_type": "species_10",
        "threshold_value": 10,
        "points": 30,
    },
    {
        "name": "Field Expert",
        "description": "Identify 50 different butterfly species.",
        "achievement_type": "species_50",
        "threshold_value": 50,
        "points": 150,
    },
    {
        "name": "Species Centurion",
        "description": "Identify 100 different butterfly species.",
        "achievement_type": "species_100",
        "threshold_value": 100,
        "points": 400,
    },
    {
        "name": "State Explorer",
        "description": "Record butterfly observations in 5 different states.",
        "achievement_type": "state_explorer",
        "threshold_value": 5,
        "points": 75,
    },
    {
        "name": "Rare Finder",
        "description": "Successfully identify a Vulnerable or Endangered species.",
        "achievement_type": "rare_finder",
        "threshold_value": 1,
        "points": 200,
    },
    {
        "name": "Verified Contributor",
        "description": "Have 10 observations expert-verified.",
        "achievement_type": "verified_10",
        "threshold_value": 10,
        "points": 100,
    },
    {
        "name": "Top Contributor",
        "description": "Submit 100 total observations.",
        "achievement_type": "top_contributor",
        "threshold_value": 100,
        "points": 300,
    },
    {
        "name": "Photo Pro",
        "description": "Submit 50 observations with multiple images.",
        "achievement_type": "photo_pro",
        "threshold_value": 50,
        "points": 150,
    },
]


def run():
    print("  → Seeding achievements...")
    created = 0
    for ach_data in ACHIEVEMENTS:
        existing = AchievementDefinition.query.filter_by(
            achievement_type=ach_data["achievement_type"]
        ).first()
        if not existing:
            achievement = AchievementDefinition(**ach_data)
            db.session.add(achievement)
            created += 1
    db.session.commit()
    print(
        f"  ✅ Achievements: {created} created, "
        f"{len(ACHIEVEMENTS) - created} already existed."
    )
