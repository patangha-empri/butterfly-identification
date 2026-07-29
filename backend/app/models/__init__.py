"""
Import all models here so Flask-Migrate and SQLAlchemy can discover them.
The order matters for tables with foreign key dependencies.
"""
from app.models.geography import IndiaState, IndiaDistrict
from app.models.user import Role, User
from app.models.species import Species, SpeciesImage, SpeciesHostPlant, SpeciesIndiaDistribution
from app.models.observation import (
    Observation, ObservationImage, PublicShare,
    ObservationLike, ObservationComment,
)
from app.models.identification import IdentificationResult, IdentificationMatch
from app.models.notification import Notification, NotificationPreference
from app.models.cms import CmsArticle, CmsBanner
from app.models.achievement import AchievementDefinition, UserAchievement, UserStreak, UserStats
from app.models.audit import AuditLog, AdminActivityLog, UserModerationAction

__all__ = [
    "IndiaState",
    "IndiaDistrict",
    "Role",
    "User",
    "Species",
    "SpeciesImage",
    "SpeciesHostPlant",
    "SpeciesIndiaDistribution",
    "Observation",
    "ObservationImage",
    "PublicShare",
    "IdentificationResult",
    "IdentificationMatch",
    "Notification",
    "NotificationPreference",
    "CmsArticle",
    "CmsBanner",
    "AchievementDefinition",
    "UserAchievement",
    "UserStreak",
    "UserStats",
    "AuditLog",
    "AdminActivityLog",
    "UserModerationAction",
]
