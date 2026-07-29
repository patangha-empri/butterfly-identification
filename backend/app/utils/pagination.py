"""Pagination helpers."""
from flask import request


def get_pagination_params(default_per_page=20, max_per_page=100):
    """Extract and clamp page/per_page from query string."""
    page = request.args.get("page", 1, type=int)
    per_page = request.args.get("per_page", default_per_page, type=int)
    page = max(1, page)
    per_page = min(max(1, per_page), max_per_page)
    return page, per_page


def paginate_query(query, page, per_page):
    """Run a SQLAlchemy query with OFFSET/LIMIT. Returns (items, total)."""
    total = query.count()
    items = query.offset((page - 1) * per_page).limit(per_page).all()
    return items, total
