from marshmallow import fields, validate
from app.extensions import ma

ARTICLE_TYPES = ["educational", "facts", "news", "events"]
ARTICLE_STATUSES = ["draft", "published", "archived"]
PLACEMENT_VALUES = ["app_home", "app_species", "portal_home"]


class ArticleCreateSchema(ma.Schema):
    title = fields.Str(required=True, validate=validate.Length(min=5, max=400))
    content = fields.Str(required=True, validate=validate.Length(min=10))
    excerpt = fields.Str(validate=validate.Length(max=500), allow_none=True)
    cover_image_url = fields.Str(validate=validate.Length(max=500), allow_none=True)
    article_type = fields.Str(
        validate=validate.OneOf(ARTICLE_TYPES), load_default="educational"
    )
    status = fields.Str(
        validate=validate.OneOf(ARTICLE_STATUSES), load_default="draft"
    )


class ArticleUpdateSchema(ma.Schema):
    title = fields.Str(validate=validate.Length(min=5, max=400))
    content = fields.Str(validate=validate.Length(min=10))
    excerpt = fields.Str(validate=validate.Length(max=500), allow_none=True)
    cover_image_url = fields.Str(validate=validate.Length(max=500), allow_none=True)
    article_type = fields.Str(validate=validate.OneOf(ARTICLE_TYPES))
    status = fields.Str(validate=validate.OneOf(ARTICLE_STATUSES))


class BannerCreateSchema(ma.Schema):
    title = fields.Str(required=True, validate=validate.Length(min=2, max=300))
    link_url = fields.Url(allow_none=True, load_default=None)
    placement = fields.Str(
        validate=validate.OneOf(PLACEMENT_VALUES), load_default="app_home"
    )
    display_order = fields.Int(load_default=0)


class BannerUpdateSchema(ma.Schema):
    title = fields.Str(validate=validate.Length(min=2, max=300))
    link_url = fields.Url(allow_none=True)
    placement = fields.Str(validate=validate.OneOf(PLACEMENT_VALUES))
    display_order = fields.Int()
    is_active = fields.Bool()
