"""Seed default roles."""
from app.extensions import db
from app.models.user import Role


ROLES = [
    {
        "name": "super_admin",
        "description": "Full access to everything — platform owner",
        "permissions": {
            "users": ["read", "write", "delete", "suspend"],
            "species": ["read", "write", "delete"],
            "observations": ["read", "write", "delete", "verify"],
            "cms": ["read", "write", "delete", "publish"],
            "reports": ["read", "export"],
            "settings": ["read", "write"],
            "roles": ["read", "write"],
        },
    },
    {
        "name": "admin",
        "description": "Full platform management except role assignment",
        "permissions": {
            "users": ["read", "write", "suspend"],
            "species": ["read", "write", "delete"],
            "observations": ["read", "write", "delete", "verify"],
            "cms": ["read", "write", "delete", "publish"],
            "reports": ["read", "export"],
        },
    },
    {
        "name": "moderator",
        "description": "Manages observations, verifies identifications, moderates users",
        "permissions": {
            "users": ["read", "suspend"],
            "species": ["read", "write"],
            "observations": ["read", "write", "verify"],
            "cms": ["read", "write"],
            "reports": ["read"],
        },
    },
    {
        "name": "user",
        "description": "Standard app user — can submit observations and use identification",
        "permissions": {
            "observations": ["read", "write"],
            "species": ["read"],
        },
    },
]


def run():
    print("  → Seeding roles...")
    created = 0
    for role_data in ROLES:
        existing = Role.query.filter_by(name=role_data["name"]).first()
        if not existing:
            role = Role(**role_data)
            db.session.add(role)
            created += 1
    db.session.commit()
    print(f"  ✅ Roles: {created} created, {len(ROLES) - created} already existed.")
