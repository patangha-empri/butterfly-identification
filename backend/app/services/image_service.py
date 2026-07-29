"""Pillow-based image compression and thumbnail generation."""
import io
from PIL import Image

# Target sizes
OPTIMIZED_MAX_PX = 1920        # max width or height for optimized image
THUMBNAIL_SIZE = (400, 400)    # thumbnail bounding box
OPTIMIZED_QUALITY = 82         # JPEG quality for optimized
THUMBNAIL_QUALITY = 75


def _to_jpeg_bytes(img: Image.Image, quality: int) -> bytes:
    """Convert any PIL image to JPEG bytes."""
    if img.mode in ("RGBA", "P"):
        img = img.convert("RGB")
    buf = io.BytesIO()
    img.save(buf, format="JPEG", quality=quality, optimize=True)
    return buf.getvalue()


def compress_image(file_storage) -> bytes:
    """
    Read a Flask FileStorage, resize if needed, return JPEG bytes.
    Original aspect ratio is preserved.
    """
    img = Image.open(file_storage.stream)
    img.thumbnail((OPTIMIZED_MAX_PX, OPTIMIZED_MAX_PX), Image.LANCZOS)
    return _to_jpeg_bytes(img, OPTIMIZED_QUALITY)


def make_thumbnail(file_storage) -> bytes:
    """
    Read a Flask FileStorage, crop to a square thumbnail, return JPEG bytes.
    """
    file_storage.seek(0)
    img = Image.open(file_storage.stream)

    # Center-crop to square first
    w, h = img.size
    side = min(w, h)
    left = (w - side) // 2
    top = (h - side) // 2
    img = img.crop((left, top, left + side, top + side))
    img = img.resize(THUMBNAIL_SIZE, Image.LANCZOS)
    return _to_jpeg_bytes(img, THUMBNAIL_QUALITY)


def get_image_dimensions(file_storage) -> tuple[int, int]:
    """Return (width, height) of the image."""
    file_storage.seek(0)
    img = Image.open(file_storage.stream)
    return img.size
