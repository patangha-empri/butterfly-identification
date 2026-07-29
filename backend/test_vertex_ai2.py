import os
import io
import json
import requests
from dotenv import load_dotenv

load_dotenv(".env")

api_key = os.environ.get("VERTEX_AI_API_KEY")
project = os.environ.get("VERTEX_AI_PROJECT")
location = os.environ.get("VERTEX_AI_LOCATION")
model_name = os.environ.get("VERTEX_AI_MODEL", "gemini-2.5-flash")
api_version = os.environ.get("VERTEX_AI_API_VERSION", "v1beta")

endpoint = f"https://{location}-aiplatform.googleapis.com/{api_version}/projects/{project}/locations/{location}/publishers/google/models/{model_name}:generateContent"
url = f"{endpoint}?key={api_key}"

payload = {
    "contents": [
        {
            "role": "user",
            "parts": [{"text": "Hello"}]
        }
    ]
}

print(f"Testing URL: {url}")
try:
    response = requests.post(url, json=payload)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.text}")
except Exception as e:
    print(e)
