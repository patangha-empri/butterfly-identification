import uuid
from datetime import datetime
from app.extensions import db


class Role(db.Model):
    __tablename__ = "roles"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    # Possible values: super_admin, admin, moderator, user
    description = db.Column(db.String(200))
    permissions = db.Column(db.JSON, default=dict, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    users = db.relationship("User", back_populates="role", lazy="dynamic")

    def __repr__(self):
        return f"<Role {self.name}>"

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "permissions": self.permissions,
        }


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    email = db.Column(db.String(255), unique=True, nullable=False, index=True)
    password_hash = db.Column(db.String(255), nullable=False)
    full_name = db.Column(db.String(200), nullable=False)
    username = db.Column(db.String(100), unique=True, nullable=False, index=True)
    profile_image_url = db.Column(db.String(500))
    bio = db.Column(db.Text)
    role_id = db.Column(db.Integer, db.ForeignKey("roles.id"), nullable=False)
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    is_verified = db.Column(db.Boolean, default=False, nullable=False)
    is_suspended = db.Column(db.Boolean, default=False, nullable=False)
    suspension_reason = db.Column(db.Text)
    preferred_state_id = db.Column(db.Integer, db.ForeignKey("india_states.id"))
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    last_login_at = db.Column(db.DateTime)

    # Relationships
    role = db.relationship("Role", back_populates="users")
    preferred_state = db.relationship("IndiaState", back_populates="users")
    observations = db.relationship("Observation", back_populates="user", lazy="dynamic", foreign_keys="[Observation.user_id]")
    identification_results = db.relationship("IdentificationResult", back_populates="user", lazy="dynamic")
    notifications = db.relationship("Notification", back_populates="user", lazy="dynamic")
    notification_preference = db.relationship(
        "NotificationPreference", back_populates="user", uselist=False
    )
    achievements = db.relationship("UserAchievement", back_populates="user", lazy="dynamic")
    streak = db.relationship("UserStreak", back_populates="user", uselist=False)
    stats = db.relationship("UserStats", back_populates="user", uselist=False)
    cms_articles = db.relationship("CmsArticle", back_populates="author", lazy="dynamic")

    def __repr__(self):
        return f"<User {self.username}>"

    def to_dict(self, include_private=False):
        data = {
            "id": self.id,
            "username": self.username,
            "full_name": self.full_name,
            "profile_image_url": self.profile_image_url,
            "bio": self.bio,
            "is_verified": self.is_verified,
            "role": self.role.name if self.role else None,
            "preferred_state_id": self.preferred_state_id,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }
        if include_private:
            data.update({
                "email": self.email,
                "is_active": self.is_active,
                "is_suspended": self.is_suspended,
                "last_login_at": self.last_login_at.isoformat() if self.last_login_at else None,
            })
        return data
