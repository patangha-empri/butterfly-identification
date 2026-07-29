"""File and input validators."""
from flask import current_app

ALLOWED_IMAGE_EXTENSIONS = {"jpg", "jpeg", "png", "webp"}


def allowed_image(filename: str) -> bool:
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_IMAGE_EXTENSIONS


def validate_image_file(file):
    """
    Validate an uploaded FileStorage object.
    Returns (ok: bool, error_message: str | None).
    """
    if not file or not file.filename:
        return False, "No file provided."
    if not allowed_image(file.filename):
        return False, f"Invalid file type. Allowed: {', '.join(sorted(ALLOWED_IMAGE_EXTENSIONS))}."
    # Measure size without reading all bytes into memory at once
    file.seek(0, 2)
    size = file.tell()
    file.seek(0)
    max_size = current_app.config.get("MAX_CONTENT_LENGTH", 10 * 1024 * 1024)
    if size > max_size:
        return False, f"File too large. Maximum: {max_size // (1024 * 1024)} MB."
    return True, None
