import os
from datetime import timedelta
from dotenv import load_dotenv

load_dotenv()


class BaseConfig:
    # ── Flask ──────────────────────────────────────────────────────────────────
    SECRET_KEY = os.environ.get("SECRET_KEY", "dev-secret-key-change-in-production")

    # ── Database ───────────────────────────────────────────────────────────────
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        "DATABASE_URL",
        "postgresql://postgres:postgres@localhost:5432/butterfly_db",
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ENGINE_OPTIONS = {
        "pool_pre_ping": True,
        "pool_recycle": 300,
        "pool_size": 5,
        "max_overflow": 10,
    }

    # ── JWT ────────────────────────────────────────────────────────────────────
    JWT_SECRET_KEY = os.environ.get("JWT_SECRET_KEY", "jwt-secret-change-in-production")
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(
        hours=int(os.environ.get("JWT_ACCESS_TOKEN_EXPIRES_HOURS", 24))
    )
    JWT_REFRESH_TOKEN_EXPIRES = timedelta(
        days=int(os.environ.get("JWT_REFRESH_TOKEN_EXPIRES_DAYS", 30))
    )
    JWT_TOKEN_LOCATION = ["headers"]
    JWT_HEADER_NAME = "Authorization"
    JWT_HEADER_TYPE = "Bearer"

    # ── Uploads ────────────────────────────────────────────────────────────────
    MAX_CONTENT_LENGTH = int(os.environ.get("MAX_CONTENT_LENGTH", 10 * 1024 * 1024))
    MAX_IMAGES_PER_OBSERVATION = int(os.environ.get("MAX_IMAGES_PER_OBSERVATION", 5))
    ALLOWED_IMAGE_EXTENSIONS = {"jpg", "jpeg", "png", "webp"}

    # ── Bunny CDN / Storage ────────────────────────────────────────────────────
    BUNNY_STORAGE_API_KEY = os.environ.get("BUNNY_STORAGE_API_KEY", "")
    BUNNY_STORAGE_ZONE = os.environ.get("BUNNY_STORAGE_ZONE", "")
    BUNNY_STORAGE_REGION = os.environ.get("BUNNY_STORAGE_REGION", "de")
    BUNNY_CDN_URL = os.environ.get("BUNNY_CDN_URL", "")

    # Local filesystem path used when Bunny CDN is not configured. In production
    # (cPanel) set UPLOAD_DIR to a writable folder outside the app dir, e.g.
    # /home/<user>/uploads, so files survive code redeploys.
    UPLOAD_DIR = os.environ.get("UPLOAD_DIR", "")

    # ── Gemini / Vertex AI ────────────────────────────────────────────
    GEMINI_API_KEY = os.environ.get("GEMINI_API_KEY", "")
    GEMINI_MODEL = os.environ.get("GEMINI_MODEL", "gemini-1.5-flash")
    VERTEX_AI_API_KEY = os.environ.get("VERTEX_AI_API_KEY", "")
    VERTEX_AI_PROJECT = os.environ.get("VERTEX_AI_PROJECT", "")
    VERTEX_AI_LOCATION = os.environ.get("VERTEX_AI_LOCATION", "")
    VERTEX_AI_MODEL = os.environ.get("VERTEX_AI_MODEL", "gemini-1.5-flash")
    VERTEX_AI_API_VERSION = os.environ.get("VERTEX_AI_API_VERSION", "v1beta")

    # ── OpenAI Vision (primary AI identification) ──────────────────────────────
    OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY", "")
    OPENAI_MODEL = os.environ.get("OPENAI_MODEL", "gpt-4o-mini")
    # "low" = 85 tokens / cheapest (good for thumbnails); "high" = best for IDs.
    OPENAI_IMAGE_DETAIL = os.environ.get("OPENAI_IMAGE_DETAIL", "high")

    # ── Firebase FCM ──────────────────────────────────────────────────────────
    FIREBASE_SERVER_KEY = os.environ.get("FIREBASE_SERVER_KEY", "")

    # ── Supabase REST (PostgREST) — fallback where direct Postgres is blocked ──
    SUPABASE_URL = os.environ.get("SUPABASE_URL", "")
    SUPABASE_SERVICE_KEY = os.environ.get("SUPABASE_SERVICE_KEY", "")

    # ── CORS ───────────────────────────────────────────────────────────────────
    CORS_ORIGINS = [
        "http://localhost:3000",  # admin
        "http://localhost:3001",  # portal
        "http://localhost:3002",  # portal (preview / alt port)
        "https://butterfly-identification-system.vercel.app",
    ]


class DevelopmentConfig(BaseConfig):
    DEBUG = True
    SQLALCHEMY_ECHO = False  # Set True to log all SQL queries


class ProductionConfig(BaseConfig):
    DEBUG = False
    SQLALCHEMY_ECHO = False

    # ── Cookie / URL hardening for HTTPS-only deployment ──────────────────────
    SESSION_COOKIE_SECURE = True
    SESSION_COOKIE_HTTPONLY = True
    SESSION_COOKIE_SAMESITE = "Lax"
    PREFERRED_URL_SCHEME = "https"

    # CORS — set CORS_ORIGINS env in cPanel to a comma-separated list, e.g.
    #   CORS_ORIGINS=https://admin.yoursite.com,https://yoursite.com
    _cors_env = os.environ.get("CORS_ORIGINS", "").strip()
    if _cors_env:
        CORS_ORIGINS = [o.strip() for o in _cors_env.split(",") if o.strip()]


class TestingConfig(BaseConfig):
    TESTING = True
    SQLALCHEMY_DATABASE_URI = "postgresql://postgres:postgres@localhost:5432/butterfly_db_test"
    RATELIMIT_ENABLED = False  # don't trip the 10/day identification cap in tests


config_map = {
    "development": DevelopmentConfig,
    "production": ProductionConfig,
    "testing": TestingConfig,
}


def get_config():
    env = os.environ.get("FLASK_ENV", "development")
    return config_map.get(env, DevelopmentConfig)
