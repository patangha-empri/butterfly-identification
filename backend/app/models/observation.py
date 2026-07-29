import uuid
from datetime import datetime
from app.extensions import db


class Observation(db.Model):
    __tablename__ = "observations"

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = db.Column(db.String(36), db.ForeignKey("users.id"), nullable=False)
    species_id = db.Column(db.String(36), db.ForeignKey("species.id"), nullable=True)

    # ── Observation details ────────────────────────────────────────────────────
    title = db.Column(db.String(300))
    notes = db.Column(db.Text)
    # sunny, cloudy, rainy, windy, partly_cloudy, overcast
    weather = db.Column(db.String(30))
    # feeding, resting, mating, flying, ovipositing, puddling, basking
    butterfly_activity = db.Column(db.String(30))
    count_observed = db.Column(db.Integer, default=1)
    observed_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

    # ── Location ───────────────────────────────────────────────────────────────
    state_id = db.Column(db.Integer, db.ForeignKey("india_states.id"), nullable=False)
    district_id = db.Column(db.Integer, db.ForeignKey("india_districts.id"))
    latitude = db.Column(db.Float, nullable=True)   # optional — not all sightings have GPS
    longitude = db.Column(db.Float, nullable=True)
    location_name = db.Column(db.String(500))   # user-typed place name

    # ── Privacy ────────────────────────────────────────────────────────────────
    # public, anonymous_public, private
    privacy = db.Column(db.String(20), default="public", nullable=False, index=True)

    # ── Verification ──────────────────────────────────────────────────────────
    # pending, ai_identified, expert_verified, community_verified, rejected
    verification_status = db.Column(
        db.String(30), default="pending", nullable=False, index=True
    )
    verified_by = db.Column(db.String(36), db.ForeignKey("users.id"))
    verified_at = db.Column(db.DateTime)
    admin_notes = db.Column(db.Text)

    is_active = db.Column(db.Boolean, default=True, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(
        db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False
    )

    # ── Relationships ──────────────────────────────────────────────────────────
    user = db.relationship("User", back_populates="observations", foreign_keys=[user_id])
    species = db.relationship("Species", back_populates="observations")
    state = db.relationship("IndiaState", back_populates="observations")
    district = db.relationship("IndiaDistrict", back_populates="observations")
    images = db.relationship(
        "ObservationImage", back_populates="observation", lazy="dynamic",
        cascade="all, delete-orphan"
    )
    identification_result = db.relationship(
        "IdentificationResult", back_populates="observation", uselist=False,
        cascade="all, delete-orphan"
    )
    public_share = db.relationship(
        "PublicShare", back_populates="observation", uselist=False,
        cascade="all, delete-orphan"
    )
    likes = db.relationship(
        "ObservationLike", back_populates="observation", lazy="dynamic",
        cascade="all, delete-orphan"
    )
    comments = db.relationship(
        "ObservationComment", back_populates="observation", lazy="dynamic",
        cascade="all, delete-orphan"
    )
    verifier = db.relationship("User", foreign_keys=[verified_by], overlaps="user")

    __table_args__ = (
        db.Index("ix_observations_user_id", "user_id"),
        db.Index("ix_observations_species_id", "species_id"),
        db.Index("ix_observations_state_id", "state_id"),
        db.Index("ix_observations_district_id", "district_id"),
        db.Index("ix_observations_observed_at", "observed_at"),
    )

    def __repr__(self):
        return f"<Observation {self.id[:8]}>"

    def to_dict(self, include_user=False, include_images=True, current_user_id=None):
        images = self.images.all() if include_images else []
        primary = next((i for i in images if i.is_primary), images[0] if images else None)

        # Resolve AI species identification status and values
        identified_species_id = None
        identified_species_name = None
        identification_confidence = None
        identification_status = self.identification_result.status if self.identification_result else None
        identification_reasoning = None

        if self.species:
            identified_species_id = self.species.id
            identified_species_name = self.species.common_name
            if self.identification_result:
                match = next((m for m in self.identification_result.matches if m.species_id == self.species_id), None)
                if match:
                    identification_confidence = match.confidence_score
        elif self.identification_result and self.identification_result.status == "completed":
            top_match = next((m for m in self.identification_result.matches if m.rank == 1), None)
            if top_match:
                identified_species_id = top_match.species_id
                identified_species_name = top_match.matched_common_name
                identification_confidence = top_match.confidence_score

        if self.identification_result and self.identification_result.raw_gemini_response:
            try:
                raw_json = self.identification_result.raw_gemini_response
                matches = raw_json.get("matches", [])
                if matches:
                    match_data = None
                    if identified_species_name:
                        match_data = next((m for m in matches if m.get("common_name") == identified_species_name or m.get("scientific_name") == identified_species_name), None)
                    if not match_data:
                        match_data = matches[0]
                    identification_reasoning = match_data.get("reasoning")
            except Exception:
                pass

        data = {
            "id": self.id,
            "species_id": self.species_id,
            "title": self.title,
            "notes": self.notes,
            "weather": self.weather,
            "butterfly_activity": self.butterfly_activity,
            "count_observed": self.count_observed,
            "observed_at": self.observed_at.isoformat() if self.observed_at else None,
            "state_id": self.state_id,
            "state_name": self.state.name if self.state else None,
            "district_id": self.district_id,
            "district_name": self.district.name if self.district else None,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "location_name": self.location_name,
            "privacy": self.privacy,
            "verification_status": self.verification_status,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            # ── Integration / AI ──
            "user_avatar_url": self.user.profile_image_url if self.user else None,
            "identification_status": identification_status,
            "identified_species_id": identified_species_id,
            "identified_species_name": identified_species_name,
            "identification_confidence": identification_confidence,
            "identification_reasoning": identification_reasoning,
            "raw_gemini_response": self.identification_result.raw_gemini_response if self.identification_result else None,
            # ── Social ──
            "like_count": self.likes.count(),
            "comment_count": self.comments.count(),
            "primary_image_url": (primary.optimized_url or primary.original_url)
            if primary else None,
        }
        if current_user_id is not None:
            data["is_liked"] = (
                self.likes.filter_by(user_id=current_user_id).first() is not None
            )
        if include_user and self.privacy != "anonymous_public":
            data["user"] = self.user.to_dict() if self.user else None
            data["user_name"] = self.user.full_name if self.user else None
            data["user_username"] = self.user.username if self.user else None
        if include_images:
            data["images"] = [img.to_dict() for img in images]
        return data


class ObservationImage(db.Model):
    __tablename__ = "observation_images"

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    observation_id = db.Column(
        db.String(36), db.ForeignKey("observations.id"), nullable=False
    )
    original_url = db.Column(db.String(500), nullable=False)
    optimized_url = db.Column(db.String(500))
    thumbnail_url = db.Column(db.String(500))
    is_primary = db.Column(db.Boolean, default=False, nullable=False)
    file_size_bytes = db.Column(db.Integer)
    width = db.Column(db.Integer)
    height = db.Column(db.Integer)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    observation = db.relationship("Observation", back_populates="images")

    __table_args__ = (
        db.Index("ix_obs_images_observation_id", "observation_id"),
    )

    def to_dict(self):
        return {
            "id": self.id,
            "original_url": self.original_url,
            "optimized_url": self.optimized_url,
            "thumbnail_url": self.thumbnail_url,
            "is_primary": self.is_primary,
            "width": self.width,
            "height": self.height,
        }


class PublicShare(db.Model):
    __tablename__ = "public_shares"

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    observation_id = db.Column(
        db.String(36), db.ForeignKey("observations.id"), nullable=False, unique=True
    )
    share_token = db.Column(db.String(64), unique=True, nullable=False, index=True)
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    view_count = db.Column(db.Integer, default=0, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    observation = db.relationship("Observation", back_populates="public_share")

    def to_dict(self):
        return {
            "id": self.id,
            "share_token": self.share_token,
            "view_count": self.view_count,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }


class ObservationLike(db.Model):
    __tablename__ = "observation_likes"

    id = db.Column(db.Integer, primary_key=True)
    observation_id = db.Column(
        db.String(36), db.ForeignKey("observations.id"), nullable=False
    )
    user_id = db.Column(db.String(36), db.ForeignKey("users.id"), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    observation = db.relationship("Observation", back_populates="likes")

    __table_args__ = (
        db.UniqueConstraint("observation_id", "user_id", name="uq_like_obs_user"),
        db.Index("ix_likes_observation_id", "observation_id"),
    )


class ObservationComment(db.Model):
    __tablename__ = "observation_comments"

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    observation_id = db.Column(
        db.String(36), db.ForeignKey("observations.id"), nullable=False
    )
    user_id = db.Column(db.String(36), db.ForeignKey("users.id"), nullable=False)
    body = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    observation = db.relationship("Observation", back_populates="comments")
    user = db.relationship("User")

    __table_args__ = (
        db.Index("ix_comments_observation_id", "observation_id"),
    )

    def to_dict(self):
        return {
            "id": self.id,
            "body": self.body,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "user": {
                "id": self.user.id,
                "username": self.user.username,
                "full_name": self.user.full_name,
                "profile_image_url": self.user.profile_image_url,
            } if self.user else None,
        }
