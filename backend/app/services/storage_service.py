"""
Bunny Storage integration.
Phase 2: dev stub — saves to local uploads/ if no API key configured.
Phase 3: real Bunny CDN upload replaces the stub.
"""
import os
import uuid
import warnings
from pathlib import Path
from flask import current_app


def _local_uploads_dir() -> Path:
    """Resolve the uploads directory.

    Honors the UPLOAD_DIR env / config value (used in production on cPanel to
    keep uploads outside the app dir so they survive redeploys); otherwise
    falls back to the dev-friendly ./uploads next to the app.
    """
    configured = current_app.config.get("UPLOAD_DIR", "")
    base = Path(configured) if configured else Path(current_app.root_path).parent / "uploads"
    base.mkdir(parents=True, exist_ok=True)
    return base


def upload_bytes(data: bytes, remote_path: str, content_type: str = "image/jpeg") -> str:
    """
    Upload raw bytes to Bunny Storage and return the public CDN URL.
    Falls back to a local save in development if BUNNY_STORAGE_API_KEY is not set.
    """
    api_key = current_app.config.get("BUNNY_STORAGE_API_KEY", "")
    cdn_url = current_app.config.get("BUNNY_CDN_URL", "")
    zone = current_app.config.get("BUNNY_STORAGE_ZONE", "")
    region = current_app.config.get("BUNNY_STORAGE_REGION", "de")

    if api_key and cdn_url and zone:
        import requests as req
        hostname = (
            "storage.bunnycdn.com"
            if region == "de"
            else f"{region}.storage.bunnycdn.com"
        )
        url = f"https://{hostname}/{zone}/{remote_path}"
        resp = req.put(
            url,
            data=data,
            headers={
                "AccessKey": api_key,
                "Content-Type": content_type,
            },
            timeout=30,
        )
        resp.raise_for_status()
        return f"{cdn_url.rstrip('/')}/{remote_path}"
    else:
        # ── Dev fallback: write to local uploads/ and serve via /uploads ──────
        warnings.warn(
            "BUNNY_STORAGE_API_KEY not set — saving image locally (dev mode).",
            stacklevel=2,
        )
        dest = _local_uploads_dir() / remote_path
        dest.parent.mkdir(parents=True, exist_ok=True)
        dest.write_bytes(data)

        # Return an absolute URL so mobile clients can load it directly.
        from flask import request, has_request_context
        if has_request_context():
            return f"{request.host_url.rstrip('/')}/uploads/{remote_path}"
        return f"/uploads/{remote_path}"


def upload_file(file_storage, folder: str, filename: str | None = None) -> dict:
    """
    Upload a Flask FileStorage to Bunny (or local).
    Returns {"original_url": ..., "optimized_url": ..., "thumbnail_url": ...,
             "width": int, "height": int, "file_size_bytes": int}
    """
    from app.services.image_service import compress_image, make_thumbnail, get_image_dimensions

    if filename is None:
        filename = f"{uuid.uuid4().hex}.jpg"

    # Get dimensions from original
    width, height = get_image_dimensions(file_storage)

    # Compress + thumbnail
    file_storage.seek(0)
    optimized_bytes = compress_image(file_storage)
    file_storage.seek(0)
    thumb_bytes = make_thumbnail(file_storage)

    # Original (still compressed to avoid huge uploads)
    original_bytes = optimized_bytes

    optimized_path = f"{folder}/{filename}"
    thumb_path = f"{folder}/thumbs/{filename}"

    optimized_url = upload_bytes(optimized_bytes, optimized_path)
    thumbnail_url = upload_bytes(thumb_bytes, thumb_path)

    return {
        "original_url": optimized_url,      # optimized = original for this platform
        "optimized_url": optimized_url,
        "thumbnail_url": thumbnail_url,
        "width": width,
        "height": height,
        "file_size_bytes": len(original_bytes),
    }


def delete_file(remote_path: str) -> bool:
    """Delete a file from Bunny Storage. Returns True on success."""
    api_key = current_app.config.get("BUNNY_STORAGE_API_KEY", "")
    zone = current_app.config.get("BUNNY_STORAGE_ZONE", "")
    region = current_app.config.get("BUNNY_STORAGE_REGION", "de")

    if not api_key or not zone:
        return True  # dev mode — nothing to delete remotely

    import requests as req
    hostname = (
        "storage.bunnycdn.com"
        if region == "de"
        else f"{region}.storage.bunnycdn.com"
    )
    url = f"https://{hostname}/{zone}/{remote_path}"
    resp = req.delete(url, headers={"AccessKey": api_key}, timeout=15)
    return resp.status_code in (200, 204, 404)
