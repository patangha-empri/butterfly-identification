import uuid
from datetime import datetime
from app.extensions import db


class IdentificationResult(db.Model):
    __tablename__ = "identification_results"

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    observation_id = db.Column(
        db.String(36), db.ForeignKey("observations.id"), nullable=False, unique=True
    )
    user_id = db.Column(db.String(36), db.ForeignKey("users.id"), nullable=False)

    # pending, processing, completed, failed
    status = db.Column(db.String(20), default="pending", nullable=False, index=True)

    # Raw JSON response from Gemini — stored as-is for debugging
    raw_gemini_response = db.Column(db.JSON)

    # Normalized text Gemini returned (before DB matching)
    gemini_raw_text = db.Column(db.Text)

    # Processing metadata
    processing_time_ms = db.Column(db.Integer)
    gemini_model_version = db.Column(db.String(50))
    error_message = db.Column(db.Text)
    input_token_count = db.Column(db.Integer)
    output_token_count = db.Column(db.Integer)
    total_token_count = db.Column(db.Integer)

    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    completed_at = db.Column(db.DateTime)

    # ── Relationships ──────────────────────────────────────────────────────────
    observation = db.relationship("Observation", back_populates="identification_result")
    user = db.relationship("User", back_populates="identification_results")
    matches = db.relationship(
        "IdentificationMatch",
        back_populates="identification_result",
        lazy="dynamic",
        cascade="all, delete-orphan",
        order_by="IdentificationMatch.rank",
    )

    __table_args__ = (
        db.Index("ix_id_results_user_id", "user_id"),
        db.Index("ix_id_results_status", "status"),
        db.Index("ix_id_results_created_at", "created_at"),
    )

    def __repr__(self):
        return f"<IdentificationResult {self.id[:8]} status={self.status}>"

    def to_dict(self, include_matches=True):
        data = {
            "id": self.id,
            "observation_id": self.observation_id,
            "status": self.status,
            "error_message": self.error_message,
            "processing_time_ms": self.processing_time_ms,
            "gemini_model_version": self.gemini_model_version,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "completed_at": self.completed_at.isoformat() if self.completed_at else None,
            "raw_gemini_response": self.raw_gemini_response,
            "input_token_count": self.input_token_count,
            "output_token_count": self.output_token_count,
            "total_token_count": self.total_token_count,
        }
        if include_matches:
            data["matches"] = [m.to_dict() for m in self.matches.order_by("rank").all()]
        return data


class IdentificationMatch(db.Model):
    __tablename__ = "identification_matches"

    id = db.Column(db.Integer, primary_key=True)
    identification_result_id = db.Column(
        db.String(36), db.ForeignKey("identification_results.id"), nullable=False
    )
    # Nullable — Gemini may return a species not yet in our DB
    species_id = db.Column(db.String(36), db.ForeignKey("species.id"), nullable=True)

    # What Gemini returned (before DB matching)
    matched_common_name = db.Column(db.String(200))
    matched_scientific_name = db.Column(db.String(200))

    # 0.0 – 1.0 confidence from Gemini response normalization
    confidence_score = db.Column(db.Float, default=0.0, nullable=False)

    # 1 = best match, 2 = second best, etc.
    rank = db.Column(db.Integer, nullable=False, default=1)

    # True if admin/expert confirmed this as the correct match
    is_accepted = db.Column(db.Boolean, default=False, nullable=False)

    # Admin notes when overriding or correcting
    admin_notes = db.Column(db.Text)

    # ── Relationships ──────────────────────────────────────────────────────────
    identification_result = db.relationship("IdentificationResult", back_populates="matches")
    species = db.relationship("Species", back_populates="identification_matches")

    __table_args__ = (
        db.Index("ix_id_matches_result_id", "identification_result_id"),
        db.Index("ix_id_matches_species_id", "species_id"),
    )

    def __repr__(self):
        return f"<IdentificationMatch rank={self.rank} conf={self.confidence_score:.2f}>"

    def to_dict(self):
        return {
            "id": self.id,
            "rank": self.rank,
            "confidence_score": self.confidence_score,
            "matched_common_name": self.matched_common_name,
            "matched_scientific_name": self.matched_scientific_name,
            "species_id": self.species_id,
            "species": self.species.to_dict(include_related=True) if self.species else None,
            "is_accepted": self.is_accepted,
        }
