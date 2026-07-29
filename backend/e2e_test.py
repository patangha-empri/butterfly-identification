import requests
import json
import time

BASE_URL = "http://localhost:5000"

# Register user
email = f"test_{int(time.time())}@example.com"
password = "password123"

# 1. Register
print("Registering user...")
res = requests.post(f"{BASE_URL}/api/v1/auth/register", json={
    "full_name": "Test User",
    "username": f"testuser_{int(time.time())}",
    "email": email,
    "password": password
})
if res.status_code != 201:
    print(f"Registration failed: {res.text}")
    exit(1)

# 2. Login
print("\nLogging in...")
res = requests.post(f"{BASE_URL}/api/v1/auth/login", json={
    "email": email,
    "password": password
})
token = res.json()['data']['access_token']
headers = {"Authorization": f"Bearer {token}"}
print("Login successful.")

# 3. Create observation
print("\nCreating observation...")
res = requests.post(f"{BASE_URL}/api/v1/observations/", headers=headers, json={
    "state_id": 1,
    "latitude": 13.0,
    "longitude": 77.0,
    "location_name": "Test",
    "privacy": "public",
    "title": "My Butterfly"
})
if res.status_code != 201:
    print(f"Observation creation failed: {res.text}")
    exit(1)
obs_id = res.json()['data']['id']
print(f"Observation ID: {obs_id}")

# 4. Upload photo
print("\nUploading photo...")
import io
from PIL import Image
img = Image.new("RGB", (100, 100), color=(255, 128, 0)) # Orange
buf = io.BytesIO()
img.save(buf, format="JPEG")
files = {"image": ("test.jpg", buf.getvalue(), "image/jpeg")}
res = requests.post(f"{BASE_URL}/api/v1/observations/{obs_id}/images", headers=headers, files=files)
if res.status_code != 201:
    print(f"Photo upload failed: {res.text}")
    exit(1)
print("Photo uploaded.")

# 5. Trigger identification
print("\nTriggering AI Identification...")
res = requests.post(f"{BASE_URL}/api/v1/identifications/observations/{obs_id}/identify", headers=headers)
print(f"Status Code: {res.status_code}")
print(json.dumps(res.json(), indent=2))
