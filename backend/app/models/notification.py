import uuid
from datetime import datetime
from app.extensions import db


class Notification(db.Model):
    __tablename__ = "notifications"

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = db.Column(db.String(36), db.ForeignKey("users.id"), nullable=False)

    # identification_complete, new_species_nearby, admin_verification,
    # educational_alert, event, system
    type = db.Column(db.String(40), nullable=False, index=True)
    title = db.Column(db.String(300), nullable=False)
    body = db.Column(db.Text, nullable=False)

    # Extra payload passed to the app (observation_id, species_id, etc.)
    data = db.Column(db.JSON, default=dict)

    is_read = db.Column(db.Boolean, default=False, nullable=False, index=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    user = db.relationship("User", back_populates="notifications")

    __table_args__ = (
        db.Index("ix_notifications_user_id", "user_id"),
        db.Index("ix_notifications_created_at", "created_at"),
    )

    def __repr__(self):
        return f"<Notification {self.type} user={self.user_id[:8]}>"

    def to_dict(self):
        return {
            "id": self.id,
            "type": self.type,
            "title": self.title,
            "body": self.body,
            "data": self.data,
            "is_read": self.is_read,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }


class NotificationPreference(db.Model):
    __tablename__ = "notification_preferences"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(
        db.String(36), db.ForeignKey("users.id"), unique=True, nullable=False
    )

    # Push notification toggles
    identification_complete = db.Column(db.Boolean, default=True, nullable=False)
    new_species_nearby = db.Column(db.Boolean, default=True, nullable=False)
    admin_verification = db.Column(db.Boolean, default=True, nullable=False)
    educational_alerts = db.Column(db.Boolean, default=True, nullable=False)
    events = db.Column(db.Boolean, default=True, nullable=False)

    # Firebase FCM device token
    fcm_token = db.Column(db.String(500))
    updated_at = db.Column(
        db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False
    )

    # Relationships
    user = db.relationship("User", back_populates="notification_preference")

    def to_dict(self):
        return {
            "identification_complete": self.identification_complete,
            "new_species_nearby": self.new_species_nearby,
            "admin_verification": self.admin_verification,
            "educational_alerts": self.educational_alerts,
            "events": self.events,
        }
