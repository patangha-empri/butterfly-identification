"""Public CMS — published articles and active banners."""
from flask import Blueprint, request

from app.services import cms_service
from app.services.cms_service import CmsError
from app.utils.pagination import get_pagination_params
from app.utils.responses import success_response, error_response, paginated_response

cms_bp = Blueprint("cms", __name__)


@cms_bp.get("/articles")
def list_articles():
    page, per_page = get_pagination_params()
    article_type = request.args.get("type")
    items, total = cms_service.list_articles(page, per_page, article_type)
    return paginated_response(items, total, page, per_page)


@cms_bp.get("/articles/<slug>")
def get_article(slug):
    try:
        data = cms_service.get_article(slug)
    except CmsError as e:
        return error_response(e.message, e.status_code)
    return success_response(data=data)


@cms_bp.get("/banners")
def list_banners():
    placement = request.args.get("placement")
    banners = cms_service.list_banners(placement)
    return success_response(data=banners)
