from datetime import datetime

from marshmallow import ValidationError, fields, validate, validates_schema
from app.extensions import ma

CONSERVATION_STATUSES = ["LC", "NT", "VU", "EN", "CR", "EW", "EX"]
ROLES = ["user", "moderator", "admin", "super_admin"]
VERIFICATION_STATUSES = ["pending", "ai_identified", "expert_verified", "community_verified", "rejected"]
ABUNDANCE_VALUES = ["common", "uncommon", "rare", "very_rare"]

# Record-level data-quality state from migration 001 — distinct from
# VERIFICATION_STATUSES above, which describes an observation.
DATA_VERIFICATION_STATUSES = ["unverified", "needs_review", "verified", "disputed"]
IUCN_STATUSES = ["DD", "LC", "NT", "VU", "EN", "CR", "EW", "EX", "NE"]
CUSTOM_FIELD_TYPES = ["text", "textarea", "number", "boolean", "date", "url", "list"]


class CitationSchema(ma.Schema):
    """
    One entry of species.citations.

    The column holds {source, url} objects, not strings — the research
    ingestion pipeline records which database a fact came from alongside the
    link. Typing it as a plain string list made every existing record fail
    validation on save. `url` is optional: printed field guides have none.
    """

    source = fields.Str(required=True, validate=validate.Length(min=1, max=200))
    url = fields.Str(allow_none=True, load_default=None, validate=validate.Length(max=1000))


def _research_fields() -> dict:
    """
    The ~47 research columns added by migration 001, as Marshmallow fields.

    Shared by the create and update schemas so the two cannot drift. Marshmallow
    runs with unknown=RAISE, so a column missing from here makes the entire
    request 422 — which is exactly why none of this data could be edited before.
    All are optional; allow_none lets the admin form clear a value.
    """
    text = lambda **kw: fields.Str(allow_none=True, **kw)  # noqa: E731
    str_list = lambda: fields.List(fields.Str(), allow_none=True)  # noqa: E731

    return {
        # Taxonomy
        "subfamily": text(validate=validate.Length(max=100)),
        "tribe": text(validate=validate.Length(max=100)),
        "species_epithet": text(validate=validate.Length(max=100)),
        "subspecies": text(validate=validate.Length(max=100)),
        "authority": text(validate=validate.Length(max=200)),
        "taxon_year": fields.Int(
            allow_none=True,
            validate=validate.Range(min=1700, max=datetime.now().year),
        ),
        "accepted_name": text(validate=validate.Length(max=200)),
        "synonyms": str_list(),
        "taxonomic_notes": text(),
        # Morphology / identification
        "identification_notes": text(),
        "male_description": text(),
        "female_description": text(),
        "upperside_description": text(),
        "underside_description": text(),
        "wing_pattern": text(),
        "wing_colour": text(validate=validate.Length(max=200)),
        "body_colour": text(validate=validate.Length(max=200)),
        "body_length_min_mm": fields.Int(allow_none=True, validate=validate.Range(min=1, max=500)),
        "body_length_max_mm": fields.Int(allow_none=True, validate=validate.Range(min=1, max=500)),
        # Lifecycle
        "egg_description": text(),
        "larva_description": text(),
        "pupa_description": text(),
        "adult_description": text(),
        "life_cycle": text(),
        "flight_period": text(),
        "breeding_season": text(),
        # Ecology
        "nectar_plants": str_list(),
        "forest_type": text(validate=validate.Length(max=200)),
        "altitude_min_m": fields.Int(allow_none=True, validate=validate.Range(min=-500, max=9000)),
        "altitude_max_m": fields.Int(allow_none=True, validate=validate.Range(min=-500, max=9000)),
        "behaviour": text(),
        "migration_notes": text(),
        "predators": text(),
        # Distribution beyond the india_states child table
        "countries": str_list(),
        "protected_areas": str_list(),
        # Conservation
        "iucn_status": fields.Str(allow_none=True, validate=validate.OneOf(IUCN_STATUSES)),
        "iucn_assessment_url": text(validate=validate.Length(max=500)),
        "legal_protection": text(),
        # Knowledge / references
        "interesting_facts": text(),
        "research_notes": text(),
        "citations": fields.List(fields.Nested(CitationSchema), allow_none=True),
        "source_urls": str_list(),
        # Provenance / quality
        "confidence_score": fields.Float(allow_none=True, validate=validate.Range(min=0, max=1)),
        "verification_status": fields.Str(
            allow_none=True, validate=validate.OneOf(DATA_VERIFICATION_STATUSES)
        ),
        "last_verified": fields.DateTime(allow_none=True),
        "data_source": text(validate=validate.Length(max=100)),
        "field_provenance": fields.Dict(keys=fields.Str(), allow_none=True),
        # Admin-defined fields — values keyed by species_field_definitions.field_key.
        # Values are deliberately untyped here; the registry declares the type and
        # the admin form enforces it.
        "custom_fields": fields.Dict(keys=fields.Str(), allow_none=True),
    }


class _RangeChecks:
    """
    Paired min/max columns were never validated, so a species could be saved
    with a wingspan of 90–20 mm. Mixed into both species schemas.
    """

    _PAIRS = (
        ("wing_span_min_mm", "wing_span_max_mm", "Wingspan"),
        ("body_length_min_mm", "body_length_max_mm", "Body length"),
        ("altitude_min_m", "altitude_max_m", "Altitude"),
    )

    @validates_schema
    def _check_ranges(self, data, **kwargs):
        for min_key, max_key, label in self._PAIRS:
            lo, hi = data.get(min_key), data.get(max_key)
            if lo is not None and hi is not None and lo > hi:
                raise ValidationError(
                    f"{label} minimum ({lo}) cannot be greater than the maximum ({hi}).",
                    field_name=min_key,
                )


class SpeciesCreateSchema(_RangeChecks, ma.Schema):
    common_name = fields.Str(required=True, validate=validate.Length(min=2, max=200))
    scientific_name = fields.Str(required=True, validate=validate.Length(min=3, max=200))
    family = fields.Str(required=True, validate=validate.Length(min=2, max=100))
    genus = fields.Str(required=True, validate=validate.Length(min=2, max=100))
    description = fields.Str(allow_none=True)
    habitat = fields.Str(allow_none=True)
    seasonal_appearance = fields.List(fields.Int(validate=validate.Range(min=1, max=12)), load_default=[])
    conservation_status = fields.Str(
        validate=validate.OneOf(CONSERVATION_STATUSES), load_default="LC"
    )
    wing_span_min_mm = fields.Int(validate=validate.Range(min=5, max=400), allow_none=True)
    wing_span_max_mm = fields.Int(validate=validate.Range(min=5, max=400), allow_none=True)
    is_migratory = fields.Bool(load_default=False)
    color_tags = fields.List(fields.Str(), load_default=[])


class SpeciesUpdateSchema(_RangeChecks, ma.Schema):
    common_name = fields.Str(validate=validate.Length(min=2, max=200))
    scientific_name = fields.Str(validate=validate.Length(min=3, max=200))
    family = fields.Str(validate=validate.Length(min=2, max=100))
    genus = fields.Str(validate=validate.Length(min=2, max=100))
    description = fields.Str(allow_none=True)
    habitat = fields.Str(allow_none=True)
    seasonal_appearance = fields.List(fields.Int(validate=validate.Range(min=1, max=12)))
    conservation_status = fields.Str(validate=validate.OneOf(CONSERVATION_STATUSES))
    wing_span_min_mm = fields.Int(validate=validate.Range(min=5, max=400), allow_none=True)
    wing_span_max_mm = fields.Int(validate=validate.Range(min=5, max=400), allow_none=True)
    is_migratory = fields.Bool()
    color_tags = fields.List(fields.Str())
    is_active = fields.Bool()


# Attach the research columns to both schemas from the single definition above.
for _name, _field in _research_fields().items():
    SpeciesCreateSchema._declared_fields[_name] = _field
    SpeciesUpdateSchema._declared_fields[_name] = _field


class FieldDefinitionCreateSchema(ma.Schema):
    """A new admin-defined species field. field_key is immutable once created."""

    field_key = fields.Str(
        required=True,
        validate=[
            validate.Length(min=2, max=63),
            # snake_case only: the key is a JSON object key and a form field name.
            validate.Regexp(
                r"^[a-z][a-z0-9_]*$",
                error="Key must be lowercase letters, numbers and underscores, starting with a letter.",
            ),
        ],
    )
    label = fields.Str(required=True, validate=validate.Length(min=1, max=200))
    field_type = fields.Str(validate=validate.OneOf(CUSTOM_FIELD_TYPES), load_default="text")
    help_text = fields.Str(allow_none=True, validate=validate.Length(max=500))
    group_name = fields.Str(allow_none=True, validate=validate.Length(max=100))
    sort_order = fields.Int(load_default=0)


class FieldDefinitionUpdateSchema(ma.Schema):
    label = fields.Str(validate=validate.Length(min=1, max=200))
    field_type = fields.Str(validate=validate.OneOf(CUSTOM_FIELD_TYPES))
    help_text = fields.Str(allow_none=True, validate=validate.Length(max=500))
    group_name = fields.Str(allow_none=True, validate=validate.Length(max=100))
    sort_order = fields.Int()
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
