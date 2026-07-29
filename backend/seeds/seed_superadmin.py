"""Seed default superadmin user."""
import os
from app.extensions import db, bcrypt
from app.models.user import User, Role


def run():
    print("  -> Seeding superadmin...")

    # Load settings from environment variables or use custom defaults
    email = os.environ.get("SUPERADMIN_EMAIL", "superadmin@butterfly.org")
    password = os.environ.get("SUPERADMIN_PASSWORD", "BflySuperAdmin#2026")
    name = os.environ.get("SUPERADMIN_NAME", "Super Admin")
    username = os.environ.get("SUPERADMIN_USERNAME", "superadmin")

    role = Role.query.filter_by(name="super_admin").first()
    if not role:
        print("  [ERROR] Roles must be seeded first! Run seed-roles command or seed-all.")
        return

    # Check by both email and username to find any existing admin/user to update
    existing_user = User.query.filter(
        (User.email == email) | (User.username == username)
    ).first()

    if not existing_user:
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
        print(f"  [OK] Superadmin '{username}' ({email}) created successfully.")
    else:
        # Overwrite/update existing user with the configured credentials to guarantee access
        existing_user.role_id = role.id
        existing_user.password_hash = bcrypt.generate_password_hash(password).decode("utf-8")
        existing_user.email = email
        existing_user.full_name = name
        existing_user.username = username
        existing_user.is_active = True
        existing_user.is_verified = True
        db.session.commit()
        print(f"  [OK] Superadmin credentials updated: username='{username}', email='{email}'.")
