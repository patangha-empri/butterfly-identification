"""Standardized JSON response helpers for all API endpoints."""
import re
from datetime import datetime

from flask import jsonify

# A bare ISO datetime with no timezone suffix, e.g. "2026-07-16T09:26:27.949693".
# Postgres `timestamp` columns come back through PostgREST in exactly this shape
# even though every value in this project is UTC. Clients (JS `new Date`, Dart
# `DateTime.parse`) treat suffix-less strings as LOCAL time, shifting every
# displayed time by the viewer's UTC offset (+5:30 in India). Tag them as UTC.
_NAIVE_ISO_DT = re.compile(r"^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2}(\.\d+)?$")


def _utcize(value):
    """Recursively append +00:00 to naive ISO datetime strings in a payload."""
    if isinstance(value, dict):
        return {k: _utcize(v) for k, v in value.items()}
    if isinstance(value, list):
        return [_utcize(v) for v in value]
    if isinstance(value, str) and _NAIVE_ISO_DT.match(value):
        return value + "+00:00"
    if isinstance(value, datetime) and value.tzinfo is None:
        return value.isoformat() + "+00:00"
    return value


def success_response(data=None, message=None, status_code=200, meta=None):
    response = {"success": True}
    if message:
        response["message"] = message
    if data is not None:
        response["data"] = _utcize(data)
    if meta:
        response["meta"] = meta
    return jsonify(response), status_code


def error_response(message, status_code=400, errors=None):
    response = {"success": False, "message": message}
    if errors:
        response["errors"] = errors
    return jsonify(response), status_code


def paginated_response(items, total, page, per_page, status_code=200):
    total_pages = max(1, (total + per_page - 1) // per_page)
    meta = {
        "total": total,
        "page": page,
        "per_page": per_page,
        "total_pages": total_pages,
        "pages": total_pages,  # alias — admin frontend reads meta.pages
        "has_next": page * per_page < total,
        "has_prev": page > 1,
    }
    return success_response(data=items, meta=meta, status_code=status_code)
