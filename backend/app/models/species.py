import uuid
from datetime import datetime
from app.extensions import db


class Species(db.Model):
    __tablename__ = "species"

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    common_name = db.Column(db.String(200), nullable=False)
    scientific_name = db.Column(db.String(200), unique=True, nullable=False, index=True)
    family = db.Column(db.String(100), nullable=False, index=True)
    genus = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text)
    habitat = db.Column(db.Text)
    # JSON array of month numbers: [1, 2, 3] = Jan, Feb, Mar
    seasonal_appearance = db.Column(db.JSON, default=list)
    # LC, NT, VU, EN, CR, EW, EX
    conservation_status = db.Column(db.String(5), nullable=False, default="LC", index=True)
    wing_span_min_mm = db.Column(db.Integer)
    wing_span_max_mm = db.Column(db.Integer)
    is_migratory = db.Column(db.Boolean, default=False, nullable=False)
    # JSON array of color strings for filtering: ["black", "orange", "white"]
    color_tags = db.Column(db.JSON, default=list)
    slug = db.Column(db.String(250), unique=True, nullable=False, index=True)
    is_active = db.Column(db.Boolean, default=True, nullable=False)
    created_by = db.Column(db.String(36), db.ForeignKey("users.id"))
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    images = db.relationship(
        "SpeciesImage", back_populates="species", lazy="dynamic",
        cascade="all, delete-orphan"
    )
    host_plants = db.relationship(
        "SpeciesHostPlant", back_populates="species", lazy="dynamic",
        cascade="all, delete-orphan"
    )
    india_distribution = db.relationship(
        "SpeciesIndiaDistribution", back_populates="species", lazy="dynamic",
        cascade="all, delete-orphan"
    )
    observations = db.relationship("Observation", back_populates="species", lazy="dynamic")
    identification_matches = db.relationship(
        "IdentificationMatch", back_populates="species", lazy="dynamic"
    )

    def __repr__(self):
        return f"<Species {self.scientific_name}>"

    def to_dict(self, include_related=False):
        # Base wingspan string representation from min/max mm
        wingspan = ""
        if self.wing_span_min_mm and self.wing_span_max_mm:
            wingspan = f"{self.wing_span_min_mm}-{self.wing_span_max_mm} mm"
        elif self.wing_span_min_mm:
            wingspan = f"{self.wing_span_min_mm} mm"

        primary_img = self.images.filter_by(is_primary=True).first()
        primary_url = primary_img.image_url if primary_img else None

        desc_short = self.description[:150] + "..." if self.description and len(self.description) > 150 else self.description

        data = {
            "id": self.id,
            "common_name": self.common_name,
            "scientific_name": self.scientific_name,
            "family": self.family,
            "genus": self.genus,
            "description": self.description,
            "description_short": desc_short,
            "habitat": self.habitat,
            "rarity": "Common",  # Fallback rarity
            "conservation_status": self.conservation_status,
            "wingspan_mm": wingspan,
            "flight_months": self.seasonal_appearance or [],
            "color_tags": self.color_tags,
            "slug": self.slug,
            "primary_image_url": primary_url,
            "observation_count": self.observations.count(),
        }
        
        # Keep original fields for backward compatibility if any tests check for them
        data["primary_image"] = primary_img.to_dict() if primary_img else None

        if include_related:
            # host_plants mapping: name -> plant_name, scientific_name -> plant_scientific_name
            data["host_plants"] = [
                {
                    "name": p.plant_name,
                    "scientific_name": p.plant_scientific_name
                } for p in self.host_plants.all()
            ]
            
            # states mapping: list of state names (strings)
            data["states"] = [d.state.name for d in self.india_distribution.all() if d.state]
            
            # images mapping: List<SpeciesImage>
            data["images"] = [
                {
                    "image_url": img.image_url,
                    "caption": f"{self.common_name} - {img.image_type}",
                    "credit": img.credit,
                    "is_primary": img.is_primary
                } for img in self.images.all()
            ]
            
            data["distribution_states"] = [d.to_dict() for d in self.india_distribution.all()]
            
        return data


class SpeciesImage(db.Model):
    __tablename__ = "species_images"

    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    species_id = db.Column(db.String(36), db.ForeignKey("species.id"), nullable=False)
    image_url = db.Column(db.String(500), nullable=False)
    thumbnail_url = db.Column(db.String(500))
    # reference, male, female, open_wing, closed_wing, caterpillar, pupa, egg
    image_type = db.Column(db.String(30), default="reference", nullable=False)
    is_primary = db.Column(db.Boolean, default=False, nullable=False)
    credit = db.Column(db.String(300))
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    species = db.relationship("Species", back_populates="images")

    __table_args__ = (
        db.Index("ix_species_images_species_id", "species_id"),
    )

    def to_dict(self):
        return {
            "id": self.id,
            "image_url": self.image_url,
            "thumbnail_url": self.thumbnail_url,
            "image_type": self.image_type,
            "is_primary": self.is_primary,
            "credit": self.credit,
        }


class SpeciesHostPlant(db.Model):
    __tablename__ = "species_host_plants"

    id = db.Column(db.Integer, primary_key=True)
    species_id = db.Column(db.String(36), db.ForeignKey("species.id"), nullable=False)
    plant_name = db.Column(db.String(200), nullable=False)
    plant_scientific_name = db.Column(db.String(200))

    # Relationships
    species = db.relationship("Species", back_populates="host_plants")

    __table_args__ = (
        db.Index("ix_host_plants_species_id", "species_id"),
    )

    def to_dict(self):
        return {
            "id": self.id,
            "plant_name": self.plant_name,
            "plant_scientific_name": self.plant_scientific_name,
        }


class SpeciesIndiaDistribution(db.Model):
    __tablename__ = "species_india_distribution"

    id = db.Column(db.Integer, primary_key=True)
    species_id = db.Column(db.String(36), db.ForeignKey("species.id"), nullable=False)
    state_id = db.Column(db.Integer, db.ForeignKey("india_states.id"), nullable=False)
    # common, uncommon, rare, very_rare
    abundance = db.Column(db.String(20), default="common", nullable=False)

    # Relationships
    species = db.relationship("Species", back_populates="india_distribution")
    state = db.relationship("IndiaState")

    __table_args__ = (
        db.UniqueConstraint("species_id", "state_id", name="uq_species_state"),
        db.Index("ix_species_distribution_species_id", "species_id"),
        db.Index("ix_species_distribution_state_id", "state_id"),
    )

    def to_dict(self):
        return {
            "state_id": self.state_id,
            "state_name": self.state.name if self.state else None,
            "state_code": self.state.code if self.state else None,
            "abundance": self.abundance,
        }
