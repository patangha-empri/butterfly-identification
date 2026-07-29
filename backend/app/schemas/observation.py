from marshmallow import fields, validate
from app.extensions import ma

WEATHER_VALUES = ["sunny", "cloudy", "rainy", "windy", "partly_cloudy", "overcast"]
ACTIVITY_VALUES = ["feeding", "resting", "mating", "flying", "ovipositing", "puddling", "basking"]
PRIVACY_VALUES = ["public", "anonymous_public", "private"]


class CreateObservationSchema(ma.Schema):
    title = fields.Str(validate=validate.Length(max=300))
    notes = fields.Str(validate=validate.Length(max=5000))
    weather = fields.Str(validate=validate.OneOf(WEATHER_VALUES))
    butterfly_activity = fields.Str(validate=validate.OneOf(ACTIVITY_VALUES))
    count_observed = fields.Int(validate=validate.Range(min=1, max=9999), load_default=1)
    observed_at = fields.DateTime(load_default=None)

    state_id = fields.Int(required=True)
    district_id = fields.Int(load_default=None)
    # Optional: many sightings (incl. AI quick-scans) have no GPS fix.
    # The India-bounds check still applies whenever a coordinate is provided.
    latitude = fields.Float(
        load_default=None, allow_none=True,
        validate=validate.Range(min=8.0, max=37.5),  # India lat bounds
    )
    longitude = fields.Float(
        load_default=None, allow_none=True,
        validate=validate.Range(min=68.0, max=97.5),  # India lon bounds
    )
    location_name = fields.Str(validate=validate.Length(max=500))
    privacy = fields.Str(
        validate=validate.OneOf(PRIVACY_VALUES), load_default="public"
    )


class UpdateObservationSchema(ma.Schema):
    title = fields.Str(validate=validate.Length(max=300))
    notes = fields.Str(validate=validate.Length(max=5000))
    weather = fields.Str(validate=validate.OneOf(WEATHER_VALUES))
    butterfly_activity = fields.Str(validate=validate.OneOf(ACTIVITY_VALUES))
    count_observed = fields.Int(validate=validate.Range(min=1, max=9999))
    observed_at = fields.DateTime()
    state_id = fields.Int()
    district_id = fields.Int(allow_none=True)
    latitude = fields.Float(validate=validate.Range(min=8.0, max=37.5))
    longitude = fields.Float(validate=validate.Range(min=68.0, max=97.5))
    location_name = fields.Str(validate=validate.Length(max=500))
    privacy = fields.Str(validate=validate.OneOf(PRIVACY_VALUES))
    # Owner's manual species pick (e.g. when AI identification found a
    # butterfly but no confident match). Verification stays "pending".
    species_id = fields.Str(allow_none=True)


class PrivacyUpdateSchema(ma.Schema):
    privacy = fields.Str(
        required=True, validate=validate.OneOf(PRIVACY_VALUES)
    )
