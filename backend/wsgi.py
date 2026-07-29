"""
WSGI entry point for containerized deployment (Cloud Run / gunicorn).
Unlike passenger_wsgi.py (cPanel), this does not load a local .env file —
Cloud Run injects configuration via environment variables / Secret Manager.
"""
from app import create_app

app = create_app()
