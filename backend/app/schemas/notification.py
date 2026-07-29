from marshmallow import fields
from app.extensions import ma


class NotificationPreferenceSchema(ma.Schema):
    identification_complete = fields.Bool()
    new_species_nearby = fields.Bool()
    admin_verification = fields.Bool()
    educational_alerts = fields.Bool()
    events = fields.Bool()
