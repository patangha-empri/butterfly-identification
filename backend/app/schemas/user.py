#
# pyrefly: ignore [missing-import]
from marshmallow import fields, validate, validates, pre_load, ValidationError
from app.extensions import ma


def _strip_password_fields(data, *field_names):
    """Trim stray leading/trailing whitespace (copy-paste, autofill) from password fields."""
    if not isinstance(data, dict):
        return data
    for name in field_names:
        if isinstance(data.get(name), str):
            data[name] = data[name].strip()
    return data


class RegisterSchema(ma.Schema):
    email = fields.Email(required=True)
    password = fields.Str(
        required=True,
        validate=validate.Length(min=8, max=128),
        load_only=True,
    )
    full_name = fields.Str(required=True, validate=validate.Length(min=2, max=200))
    username = fields.Str(
        required=True,
        validate=[
            validate.Length(min=3, max=50),
            validate.Regexp(
                r"^[a-zA-Z0-9_]+$",
                error="Username may only contain letters, numbers, and underscores.",
            ),
        ],
    )
    preferred_state_id = fields.Int(load_default=None)

    @pre_load
    def strip_password(self, data, **kwargs):
        return _strip_password_fields(data, "password")


class LoginSchema(ma.Schema):
    email = fields.Email(required=True)
    password = fields.Str(required=True, load_only=True)

    @pre_load
    def strip_password(self, data, **kwargs):
        return _strip_password_fields(data, "password")


class UpdateProfileSchema(ma.Schema):
    full_name = fields.Str(validate=validate.Length(min=2, max=200))
    username = fields.Str(
        validate=[
            validate.Length(min=3, max=50),
            validate.Regexp(
                r"^[a-zA-Z0-9_]+$",
                error="Username may only contain letters, numbers, and underscores.",
            ),
        ]
    )
    bio = fields.Str(validate=validate.Length(max=500))
    preferred_state_id = fields.Int(allow_none=True)


class FCMTokenSchema(ma.Schema):
    fcm_token = fields.Str(required=True, validate=validate.Length(min=10, max=500))


class ChangePasswordSchema(ma.Schema):
    current_password = fields.Str(required=True, load_only=True)
    new_password = fields.Str(
        required=True,
        validate=validate.Length(min=8, max=128),
        load_only=True,
    )

    @pre_load
    def strip_password(self, data, **kwargs):
        return _strip_password_fields(data, "current_password", "new_password")
