from datetime import datetime
from app.extensions import db


class AchievementDefinition(db.Model):
    __tablename__ = "achievement_definitions"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), unique=True, nullable=False)
    description = db.Column(db.String(400), nullable=False)
    badge_image_url = db.Column(db.String(500))

    # first_observation, streak_7, streak_30, streak_100,
    # species_10, species_50, species_100, state_explorer,
    # rare_finder, verified_10, top_contributor
    achievement_type = db.Column(db.String(50), unique=True, nullable=False)
    threshold_value = db.Column(db.Integer, default=1, nullable=False)
    points = db.Column(db.Integer, default=10, nullable=False)

    # Relationships
    user_achievements = db.relationship(
        "UserAchievement", back_populates="achievement", lazy="dynamic"
    )

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "badge_image_url": self.badge_image_url,
            "achievement_type": self.achievement_type,
            "threshold_value": self.threshold_value,
            "points": self.points,
        }


class UserAchievement(db.Model):
    __tablename__ = "user_achievements"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey("users.id"), nullable=False)
    achievement_id = db.Column(
        db.Integer, db.ForeignKey("achievement_definitions.id"), nullable=False
    )
    earned_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    user = db.relationship("User", back_populates="achievements")
    achievement = db.relationship("AchievementDefinition", back_populates="user_achievements")

    __table_args__ = (
        db.UniqueConstraint("user_id", "achievement_id", name="uq_user_achievement"),
        db.Index("ix_user_achievements_user_id", "user_id"),
    )

    def to_dict(self):
        return {
            "id": self.id,
            "achievement": self.achievement.to_dict() if self.achievement else None,
            "earned_at": self.earned_at.isoformat() if self.earned_at else None,
        }


class UserStreak(db.Model):
    __tablename__ = "user_streaks"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey("users.id"), unique=True, nullable=False)
    current_streak = db.Column(db.Integer, default=0, nullable=False)
    longest_streak = db.Column(db.Integer, default=0, nullable=False)
    last_observation_date = db.Column(db.Date)
    updated_at = db.Column(
        db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False
    )

    # Relationships
    user = db.relationship("User", back_populates="streak")

    def to_dict(self):
        return {
            "current_streak": self.current_streak,
            "longest_streak": self.longest_streak,
            "last_observation_date": (
                self.last_observation_date.isoformat()
                if self.last_observation_date
                else None
            ),
        }


class UserStats(db.Model):
    __tablename__ = "user_stats"

    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey("users.id"), unique=True, nullable=False)
    total_observations = db.Column(db.Integer, default=0, nullable=False)
    total_identifications = db.Column(db.Integer, default=0, nullable=False)
    total_species_observed = db.Column(db.Integer, default=0, nullable=False)
    total_states_explored = db.Column(db.Integer, default=0, nullable=False)
    total_points = db.Column(db.Integer, default=0, nullable=False)
    updated_at = db.Column(
        db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False
    )

    # Relationships
    user = db.relationship("User", back_populates="stats")

    def to_dict(self):
        return {
            "total_observations": self.total_observations,
            "total_identifications": self.total_identifications,
            "total_species_observed": self.total_species_observed,
            "total_states_explored": self.total_states_explored,
            "total_points": self.total_points,
        }
