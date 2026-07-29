"""
manage.py — CLI entry point for Flask + custom seed/admin commands.

Usage:
    flask db init              # Initialize migrations folder (run once)
    flask db migrate -m "msg"  # Generate a new migration
    flask db upgrade           # Apply migrations to the database

    flask seed-roles           # Seed roles
    flask seed-geography       # Seed India states + districts
    flask seed-species         # Seed 50 butterfly species
    flask seed-achievements    # Seed achievement definitions
    flask seed-all             # Run all seeds in order

    flask create-admin         # Interactively create a super admin user
    flask drop-db              # ⚠ Drop ALL tables (dev only)
"""
import os
import click
from flask.cli import with_appcontext
from app import create_app
from app.extensions import db

app = create_app()


# ── seed-roles ─────────────────────────────────────────────────────────────────
@app.cli.command("seed-roles")
@with_appcontext
def seed_roles():
    """Seed default roles into the database."""
    from seeds.seed_roles import run
    run()


# ── seed-superadmin ────────────────────────────────────────────────────────────
@app.cli.command("seed-superadmin")
@with_appcontext
def seed_superadmin_cmd():
    """Seed super admin user from environment variables or defaults."""
    from seeds.seed_superadmin import run
    run()


# ── seed-geography ─────────────────────────────────────────────────────────────
@app.cli.command("seed-geography")
@with_appcontext
def seed_geography():
    """Seed India states and districts."""
    from seeds.seed_geography import run
    run()


# ── seed-species ───────────────────────────────────────────────────────────────
@app.cli.command("seed-species")
@with_appcontext
def seed_species_cmd():
    """Seed 50 butterfly species with host plants and distribution."""
    from seeds.seed_species import run
    run()


# ── seed-achievements ──────────────────────────────────────────────────────────
@app.cli.command("seed-achievements")
@with_appcontext
def seed_achievements():
    """Seed achievement definitions."""
    from seeds.seed_achievements import run
    run()


# ── seed-all ───────────────────────────────────────────────────────────────────
@app.cli.command("seed-all")
@with_appcontext
def seed_all():
    """Run all seed scripts in dependency order."""
    from seeds.run_all import run
    run()


# ── create-admin ───────────────────────────────────────────────────────────────
@app.cli.command("create-admin")
@click.option("--email", prompt="Admin email")
@click.option("--password", prompt="Admin password", hide_input=True, confirmation_prompt=True)
@click.option("--name", prompt="Full name")
@click.option("--username", prompt="Username")
@with_appcontext
def create_admin(email, password, name, username):
    """Create a super admin user."""
    from app.models.user import User, Role
    from app.extensions import bcrypt

    role = Role.query.filter_by(name="super_admin").first()
    if not role:
        click.echo("❌  Run 'flask seed-roles' first.")
        return

    if User.query.filter_by(email=email).first():
        click.echo(f"❌  User with email {email} already exists.")
        return

    user = User(
        email=email,
        password_hash=bcrypt.generate_password_hash(password).decode("utf-8"),
        full_name=name,
        username=username,
        role_id=role.id,
        is_active=True,
        is_verified=True,
    )
    db.session.add(user)
    db.session.commit()
    click.echo(f"✅  Super admin '{username}' created successfully.")


# ── drop-db ────────────────────────────────────────────────────────────────────
@app.cli.command("drop-db")
@click.option("--confirm", is_flag=True, help="Confirm you want to drop all tables.")
@with_appcontext
def drop_db(confirm):
    """⚠ Drop ALL tables. For development only."""
    if not confirm:
        click.echo("Use --confirm to actually drop tables. This is irreversible.")
        return
    db.drop_all()
    click.echo("✅  All tables dropped.")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
