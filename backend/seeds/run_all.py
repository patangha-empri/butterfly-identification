"""Run all seed scripts in the correct dependency order."""
from seeds.seed_roles import run as seed_roles
from seeds.seed_superadmin import run as seed_superadmin
from seeds.seed_geography import run as seed_geography
from seeds.seed_species import run as seed_species
from seeds.seed_achievements import run as seed_achievements


def run():
    print("\n🌱  Running all seeds...\n")
    seed_roles()
    seed_superadmin()
    seed_geography()
    seed_species()
    seed_achievements()
    print("\n✅  All seeds completed.\n")
