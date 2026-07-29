import os
import io
import json
from PIL import Image
from dotenv import load_dotenv

# Load env variables directly to avoid needing full flask app config
load_dotenv(".env")

from flask import Flask
app = Flask(__name__)
app.config["VERTEX_AI_API_KEY"] = os.environ.get("VERTEX_AI_API_KEY")
app.config["VERTEX_AI_PROJECT"] = os.environ.get("VERTEX_AI_PROJECT")
app.config["VERTEX_AI_LOCATION"] = os.environ.get("VERTEX_AI_LOCATION")
app.config["VERTEX_AI_MODEL"] = os.environ.get("VERTEX_AI_MODEL", "gemini-2.5-flash")
app.config["VERTEX_AI_API_VERSION"] = os.environ.get("VERTEX_AI_API_VERSION", "v1beta")

# Make a tiny valid JPEG image
img = Image.new("RGB", (100, 100), color=(128, 128, 0)) # Yellowish
buf = io.BytesIO()
img.save(buf, format="JPEG")
test_img_bytes = buf.getvalue()

from app.services.gemini_service import identify_butterfly

with app.app_context():
    print("Testing Vertex AI identify_butterfly...")
    try:
        res = identify_butterfly([test_img_bytes])
        print("Success!")
        print(json.dumps(res, indent=2))
    except Exception as e:
        print("Failed!")
        print(str(e))
