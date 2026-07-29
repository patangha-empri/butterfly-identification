from app.extensions import db


class IndiaState(db.Model):
    __tablename__ = "india_states"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False, unique=True)
    code = db.Column(db.String(5), nullable=False, unique=True)
    region = db.Column(db.String(20), nullable=False)          # North / South / East / West / Northeast / Central
    is_union_territory = db.Column(db.Boolean, default=False, nullable=False)

    # Relationships
    districts = db.relationship("IndiaDistrict", back_populates="state", lazy="dynamic")
    observations = db.relationship("Observation", back_populates="state", lazy="dynamic")
    users = db.relationship("User", back_populates="preferred_state", lazy="dynamic")

    def __repr__(self):
        return f"<IndiaState {self.code}: {self.name}>"

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "code": self.code,
            "region": self.region,
            "is_union_territory": self.is_union_territory,
        }


class IndiaDistrict(db.Model):
    __tablename__ = "india_districts"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    state_id = db.Column(db.Integer, db.ForeignKey("india_states.id"), nullable=False)
    latitude = db.Column(db.Float)    # approximate district center
    longitude = db.Column(db.Float)

    # Relationships
    state = db.relationship("IndiaState", back_populates="districts")
    observations = db.relationship("Observation", back_populates="district", lazy="dynamic")

    # A district name is unique within a state
    __table_args__ = (
        db.UniqueConstraint("name", "state_id", name="uq_district_name_state"),
        db.Index("ix_district_state_id", "state_id"),
    )

    def __repr__(self):
        return f"<IndiaDistrict {self.name}, {self.state_id}>"

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "state_id": self.state_id,
            "state_name": self.state.name if self.state else None,
            "state_code": self.state.code if self.state else None,
            "latitude": self.latitude,
            "longitude": self.longitude,
        }
