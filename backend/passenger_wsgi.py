"""
cPanel Passenger entry point.
Place this file in the root of your Python app directory on cPanel.
cPanel Passenger will automatically use this file as the WSGI entry point.
"""
import sys
import os

# Add the app directory to Python path
# On cPanel, adjust this path to match your deployment directory
app_dir = os.path.dirname(os.path.abspath(__file__))
if app_dir not in sys.path:
    sys.path.insert(0, app_dir)

# Load environment variables from .env file
from dotenv import load_dotenv
load_dotenv(os.path.join(app_dir, ".env"))

# Import the Flask application
from app import create_app

# Create the application instance
flask_app = create_app()

# Passenger expects the WSGI callable to be named 'application'
application = flask_app
