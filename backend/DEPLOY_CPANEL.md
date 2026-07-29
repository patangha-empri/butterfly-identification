# Deploying the Butterfly India backend to cPanel

This walkthrough is specific to **this Flask app on cPanel + Python 3.11 + PostgreSQL**.
Estimated time the first time: ~45 minutes.

---

## 0. Prerequisites
- cPanel account with **Setup Python App** + **PostgreSQL Databases** available.
- A domain pointing at this cPanel.
- SSH access enabled in cPanel (preferred) or comfort with cPanel File Manager.
- A Gemini API key from <https://aistudio.google.com/app/apikey> (free tier is fine).

---

## 1. Create the subdomain (~2 min)
cPanel → **Domains → Create A New Domain**.

- Domain: `api.yourdomain.com`
- Document root: leave default (cPanel will set it under `public_html/api`).

Then cPanel → **SSL/TLS Status** → tick `api.yourdomain.com` → **Run AutoSSL**. Wait until the cert says "Active".

---

## 2. Create the PostgreSQL database (~3 min)
cPanel → **PostgreSQL Databases**.

1. **Create database**: name it `butterfly` → cPanel will save it as `<cpaneluser>_butterfly`.
2. **Create user**: name `bfly` → strong password → save it.
3. **Add user to database** with **ALL PRIVILEGES**.

Note your **`DATABASE_URL`** (you'll paste this into env in step 5):
```
postgresql://<cpaneluser>_bfly:<password>@localhost:5432/<cpaneluser>_butterfly
```

---

## 3. Create the Python App (~5 min)
cPanel → **Setup Python App** → **Create Application**.

| Field | Value |
|---|---|
| Python version | **3.11** |
| Application root | `butterfly_backend` (under your home dir) |
| Application URL | `api.yourdomain.com` |
| Application startup file | `passenger_wsgi.py` |
| Application entry point | `application` |

Click **Create**. cPanel will show a "source activation" command — copy it; you'll need it in step 6.

---

## 4. Upload the code (~5 min)
**Option A — via SSH (easiest if available):**
```bash
cd ~/butterfly_backend
git clone <your-repo-url> .
# Or upload via SCP / rsync, excluding venv/, __pycache__/, .env, uploads/
```

**Option B — via cPanel File Manager:**
Zip your local `backend/` folder **excluding** `venv/`, `__pycache__/`, `.env`, `uploads/`,
upload the zip to `~/butterfly_backend/`, then **Extract**.

`passenger_wsgi.py`, `manage.py`, `requirements.txt`, `app/`, `migrations/`,
`config.py` and `.env.example` should all be at the application root.

---

## 5. Set environment variables (~5 min)
cPanel → **Setup Python App** → open your app → scroll to **Environment Variables**.
Add one row per variable. Use `.env.example` as the checklist.

**Required for any deploy:**
| Key | Value |
|---|---|
| `FLASK_ENV` | `production` |
| `FLASK_APP` | `manage.py` |
| `SECRET_KEY` | a fresh random string (`python -c "import secrets;print(secrets.token_urlsafe(48))"`) |
| `JWT_SECRET_KEY` | another fresh random string (different from SECRET_KEY) |
| `DATABASE_URL` | from step 2 |
| `GEMINI_API_KEY` | your Gemini key |
| `UPLOAD_DIR` | `/home/<cpaneluser>/uploads` |
| `CORS_ORIGINS` | `https://api.yourdomain.com` (add admin/web origins if any) |

**Optional:** `BUNNY_*` if using a CDN, `OPENAI_*` if paying for OpenAI fallback,
`FIREBASE_SERVER_KEY` if you wire FCM later.

**Important — read this carefully.** cPanel's Environment Variables panel only
injects values into the running WSGI process; it does **NOT** put them in your
SSH shell. That means `flask db upgrade` / `flask seed-all` won't see them and
will fall back to the hardcoded defaults in `config.py`.

So you actually need **both**:

1. **A `.env` file on the server** at `~/butterfly_backend/.env`, `chmod 600`,
   for CLI ops. `passenger_wsgi.py` loads it and Flask's CLI auto-loads it via
   python-dotenv.
2. **The same values in cPanel's Env Variables panel**, as a defense-in-depth
   layer so the running app has config even if `.env` is missing.

Create the `.env` from the template:

```bash
cp .env.example .env
chmod 600 .env
nano .env        # fill in DATABASE_URL, SECRET_KEY, JWT_SECRET_KEY, GEMINI_API_KEY, etc.
```

Click **Save**.

---

## 6. Install dependencies + run migrations (~10 min)
Open **Terminal** in cPanel (or SSH in). Run the activation command from step 3,
then:

```bash
cd ~/butterfly_backend
pip install --upgrade pip
pip install -r requirements.txt   # ~5 min the first time

# Create the uploads directory outside the app root
mkdir -p ~/uploads
chmod 750 ~/uploads

# Create the DB schema
flask db upgrade

# Seed reference data (idempotent — safe to re-run)
flask seed-all
```

If `flask db upgrade` says "Target database is not up to date", run
`flask db migrate -m "init"` once, inspect the generated file in
`migrations/versions/`, and re-run `flask db upgrade`.

---

## 7. Restart and smoke-test (~2 min)
cPanel → **Setup Python App** → your app → **Restart**.

From your laptop:
```bash
curl https://api.yourdomain.com/api/v1/observations/feed
```
Expect a JSON response (`{"success":true,"data":[...],"meta":{...}}`).

If you get **500**, check **Setup Python App → Application Errors** for the
Python traceback.

---

## 8. Point the Flutter app at production (~3 min)
Open `mobile/lib/core/api/dio_client.dart` and update:

```dart
static const String prodBaseUrl = 'https://api.yourdomain.com';
```

Then build a release variant:
```bash
cd mobile
flutter build apk --release --dart-define=FLAVOR=prod
# or for Play Store
flutter build appbundle --release --dart-define=FLAVOR=prod
```

---

## What can go wrong (and how to fix it)

| Symptom | Likely cause | Fix |
|---|---|---|
| **502 Bad Gateway** | App didn't start | Check Application Errors panel; usually a missing env var or import error. |
| **`psycopg2` install fails** | OS lacks PostgreSQL dev headers | We use `psycopg2-binary` (prebuilt) — this shouldn't happen. If it does, ask host to install `postgresql-devel`. |
| **`OperationalError: connection refused`** | Wrong `DATABASE_URL` | Confirm host is `localhost` (cPanel Postgres is local) and the user actually has rights on the DB. |
| **404 on `/uploads/<file>`** | `UPLOAD_DIR` mismatch | The dir must be the absolute path on the server, e.g. `/home/<user>/uploads`. The route reads from this dir. |
| **CORS error from the admin web** | `CORS_ORIGINS` doesn't include the admin domain | Add it, comma-separated, then **Restart** the app. |
| **Workers / async tasks not running** | We don't use ARQ on cPanel | If you ever need scheduled tasks, use cPanel **Cron Jobs** to invoke a Flask CLI command. |
| **Out of disk** | Uploads bloat `~/uploads` | Move to Bunny CDN (set `BUNNY_*` env vars) and the local fallback won't be used. |

---

## Going forward
After the first deploy, redeploys are quick:
```bash
# from SSH
cd ~/butterfly_backend
git pull
pip install -r requirements.txt   # only if deps changed
flask db upgrade                  # only if migrations added
```
Then cPanel → Setup Python App → **Restart**.

That's it. The mobile app should now hit `https://api.yourdomain.com` and
everything continues working as it does locally.
