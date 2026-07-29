from marshmallow import fields, validate
from app.extensions import ma

CONSERVATION_STATUSES = ["LC", "NT", "VU", "EN", "CR", "EW", "EX"]
ROLES = ["user", "moderator", "admin", "super_admin"]
VERIFICATION_STATUSES = ["pending", "ai_identified", "expert_verified", "community_verified", "rejected"]
ABUNDANCE_VALUES = ["common", "uncommon", "rare", "very_rare"]


class SpeciesCreateSchema(ma.Schema):
    common_name = fields.Str(required=True, validate=validate.Length(min=2, max=200))
    scientific_name = fields.Str(required=True, validate=validate.Length(min=3, max=200))
    family = fields.Str(required=True, validate=validate.Length(min=2, max=100))
    genus = fields.Str(required=True, validate=validate.Length(min=2, max=100))
    description = fields.Str()
    habitat = fields.Str()
    seasonal_appearance = fields.List(fields.Int(validate=validate.Range(min=1, max=12)), load_default=[])
    conservation_status = fields.Str(
        validate=validate.OneOf(CONSERVATION_STATUSES), load_default="LC"
    )
    wing_span_min_mm = fields.Int(validate=validate.Range(min=5, max=400), allow_none=True)
    wing_span_max_mm = fields.Int(validate=validate.Range(min=5, max=400), allow_none=True)
    is_migratory = fields.Bool(load_default=False)
    color_tags = fields.List(fields.Str(), load_default=[])


class SpeciesUpdateSchema(ma.Schema):
    common_name = fields.Str(validate=validate.Length(min=2, max=200))
    scientific_name = fields.Str(validate=validate.Length(min=3, max=200))
    family = fields.Str(validate=validate.Length(min=2, max=100))
    genus = fields.Str(validate=validate.Length(min=2, max=100))
    description = fields.Str()
    habitat = fields.Str()
    seasonal_appearance = fields.List(fields.Int(validate=validate.Range(min=1, max=12)))
    conservation_status = fields.Str(validate=validate.OneOf(CONSERVATION_STATUSES))
    wing_span_min_mm = fields.Int(validate=validate.Range(min=5, max=400), allow_none=True)
    wing_span_max_mm = fields.Int(validate=validate.Range(min=5, max=400), allow_none=True)
    is_migratory = fields.Bool()
    color_tags = fields.List(fields.Str())
    is_active = fields.Bool()


class SuspendUserSchema(ma.Schema):
    suspend = fields.Bool(required=True)
    reason = fields.Str(validate=validate.Length(max=500))


class ChangeRoleSchema(ma.Schema):
    role = fields.Str(required=True, validate=validate.OneOf(ROLES))


class WarnUserSchema(ma.Schema):
    reason = fields.Str(required=True, validate=validate.Length(min=5, max=500))


class FlagUserSchema(ma.Schema):
    reason = fields.Str(required=True, validate=validate.Length(min=3, max=500))


class VerifyObservationSchema(ma.Schema):
    species_id = fields.Str(allow_none=True)
    admin_notes = fields.Str(validate=validate.Length(max=1000))


class RejectObservationSchema(ma.Schema):
    admin_notes = fields.Str(required=True, validate=validate.Length(min=5, max=1000))


class DistributionSchema(ma.Schema):
    state_id = fields.Int(required=True)
    abundance = fields.Str(
        validate=validate.OneOf(ABUNDANCE_VALUES), load_default="common"
    )


class HostPlantSchema(ma.Schema):
    plant_name = fields.Str(required=True, validate=validate.Length(min=2, max=200))
    plant_scientific_name = fields.Str(validate=validate.Length(max=200), allow_none=True)
