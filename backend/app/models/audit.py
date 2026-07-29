import uuid
from datetime import datetime
from app.extensions import db


class AuditLog(db.Model):
    """Tracks all data-changing actions across the platform (create / update / delete)."""

    __tablename__ = "audit_logs"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey("users.id"), nullable=True)
    action = db.Column(db.String(30), nullable=False)      # CREATE, UPDATE, DELETE, LOGIN, LOGOUT
    entity_type = db.Column(db.String(50), nullable=False) # User, Observation, Species, etc.
    entity_id = db.Column(db.String(36))
    old_values = db.Column(db.JSON)
    new_values = db.Column(db.JSON)
    ip_address = db.Column(db.String(45))
    user_agent = db.Column(db.String(500))
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)

    __table_args__ = (
        db.Index("ix_audit_logs_user_id", "user_id"),
        db.Index("ix_audit_logs_entity", "entity_type", "entity_id"),
    )

    def __repr__(self):
        return f"<AuditLog {self.action} {self.entity_type}/{self.entity_id}>"

    def to_dict(self):
        return {
            "id": self.id,
            "user_id": self.user_id,
            "action": self.action,
            "entity_type": self.entity_type,
            "entity_id": self.entity_id,
            "old_values": self.old_values,
            "new_values": self.new_values,
            "ip_address": self.ip_address,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }


class AdminActivityLog(db.Model):
    """Detailed log of actions taken by admin/moderator users."""

    __tablename__ = "admin_activity_logs"

    id = db.Column(db.Integer, primary_key=True)
    admin_user_id = db.Column(db.String(36), db.ForeignKey("users.id"), nullable=False)
    action = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text)
    entity_type = db.Column(db.String(50))
    entity_id = db.Column(db.String(36))
    ip_address = db.Column(db.String(45))
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)

    # Relationships
    admin_user = db.relationship("User")

    __table_args__ = (
        db.Index("ix_admin_logs_admin_user_id", "admin_user_id"),
        db.Index("ix_admin_logs_created_at", "created_at"),
    )

    def to_dict(self):
        return {
            "id": self.id,
            "admin_user": self.admin_user.to_dict() if self.admin_user else None,
            "action": self.action,
            "description": self.description,
            "entity_type": self.entity_type,
            "entity_id": self.entity_id,
            "ip_address": self.ip_address,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }


class UserModerationAction(db.Model):
    """Warning / flag / suspension record against a user (see migration 002)."""

    __tablename__ = "user_moderation_actions"

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = db.Column(db.String(36), db.ForeignKey("users.id"), nullable=False)
    admin_id = db.Column(db.String(36), db.ForeignKey("users.id"))
    # warning | flag | suspension | unsuspension | content_removed
    action_type = db.Column(db.String(30), nullable=False)
    reason = db.Column(db.Text)
    related_entity_type = db.Column(db.String(50))
    related_entity_id = db.Column(db.String(36))
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False, index=True)
    revoked_at = db.Column(db.DateTime)

    __table_args__ = (
        db.Index("ix_user_moderation_actions_user", "user_id"),
        db.Index("ix_user_moderation_actions_type", "action_type"),
    )

    def to_dict(self):
        return {
            "id": self.id,
            "user_id": self.user_id,
            "admin_id": self.admin_id,
            "action_type": self.action_type,
            "reason": self.reason,
            "related_entity_type": self.related_entity_type,
            "related_entity_id": self.related_entity_id,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "revoked_at": self.revoked_at.isoformat() if self.revoked_at else None,
        }
