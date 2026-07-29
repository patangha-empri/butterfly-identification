# Deploying to GCP Cloud Run

This backend is a Flask app served by gunicorn (`wsgi.py`), containerized via the
`Dockerfile` in this folder. Cloud Run runs the container, terminates HTTPS, and
scales instances automatically — no server to patch or manage.

The database (Supabase Postgres) and file storage (Bunny CDN) are both external
SaaS, so Cloud Run just needs outbound network access and the right env vars —
no Cloud SQL, VPC connector, or persistent disk required.

## 0. Prerequisites

- [gcloud CLI](https://cloud.google.com/sdk/docs/install) installed and authenticated:
  ```bash
  gcloud auth login
  gcloud config set project YOUR_GCP_PROJECT_ID
  ```
- Enable the required APIs (one-time per project):
  ```bash
  gcloud services enable run.googleapis.com artifactregistry.googleapis.com \
    cloudbuild.googleapis.com secretmanager.googleapis.com
  ```

## 1. Put secrets in Secret Manager (don't pass them as plain env vars)

Anything sensitive — DB URL, API keys, JWT secret — should live in Secret Manager
rather than `--set-env-vars`, since env vars set that way are visible in the Cloud
Run revision's YAML config to anyone with read access to the service.

```bash
# Run once per secret. Repeat for each value below.
echo -n "postgresql://postgres.xxxx:PASSWORD@aws-0-region.pooler.supabase.com:5432/postgres" | \
  gcloud secrets create DATABASE_URL --data-file=- --replication-policy=automatic

echo -n "your-jwt-secret"        | gcloud secrets create JWT_SECRET_KEY --data-file=- --replication-policy=automatic
echo -n "your-flask-secret"      | gcloud secrets create SECRET_KEY --data-file=- --replication-policy=automatic
echo -n "your-supabase-url"      | gcloud secrets create SUPABASE_URL --data-file=- --replication-policy=automatic
echo -n "your-supabase-svc-key"  | gcloud secrets create SUPABASE_SERVICE_KEY --data-file=- --replication-policy=automatic
echo -n "your-bunny-api-key"     | gcloud secrets create BUNNY_STORAGE_API_KEY --data-file=- --replication-policy=automatic
echo -n "your-openai-key"        | gcloud secrets create OPENAI_API_KEY --data-file=- --replication-policy=automatic
echo -n "your-vertex-ai-key"     | gcloud secrets create VERTEX_AI_API_KEY --data-file=- --replication-policy=automatic
echo -n "your-firebase-key"      | gcloud secrets create FIREBASE_SERVER_KEY --data-file=- --replication-policy=automatic
echo -n "your-superadmin-pw"     | gcloud secrets create SUPERADMIN_PASSWORD --data-file=- --replication-policy=automatic
```

To update a secret later: `echo -n "new-value" | gcloud secrets versions add DATABASE_URL --data-file=-`

## 2. Deploy

Cloud Build will detect the `Dockerfile` automatically and build from it.

```bash
gcloud run deploy butterfly-api \
  --source . \
  --region asia-south1 \
  --platform managed \
  --allow-unauthenticated \
  --port 8080 \
  --max-instances 10 \
  --set-env-vars "FLASK_ENV=production,BUNNY_STORAGE_ZONE=butterfly-identification,BUNNY_STORAGE_REGION=de,BUNNY_CDN_URL=https://butterfly-identification.b-cdn.net,VERTEX_AI_PROJECT=passiton-489007,VERTEX_AI_LOCATION=asia-south1,VERTEX_AI_MODEL=gemini-2.5-flash,VERTEX_AI_API_VERSION=v1beta,JWT_ACCESS_TOKEN_EXPIRES_HOURS=24,JWT_REFRESH_TOKEN_EXPIRES_DAYS=30,MAX_CONTENT_LENGTH=10485760,MAX_IMAGES_PER_OBSERVATION=5,SUPERADMIN_EMAIL=superadmin@butterfly.org,SUPERADMIN_NAME=Super Admin,SUPERADMIN_USERNAME=superadmin,CORS_ORIGINS=https://your-admin-domain.com,https://your-portal-domain.com" \
  --set-secrets "DATABASE_URL=DATABASE_URL:latest,JWT_SECRET_KEY=JWT_SECRET_KEY:latest,SECRET_KEY=SECRET_KEY:latest,SUPABASE_URL=SUPABASE_URL:latest,SUPABASE_SERVICE_KEY=SUPABASE_SERVICE_KEY:latest,BUNNY_STORAGE_API_KEY=BUNNY_STORAGE_API_KEY:latest,OPENAI_API_KEY=OPENAI_API_KEY:latest,VERTEX_AI_API_KEY=VERTEX_AI_API_KEY:latest,FIREBASE_SERVER_KEY=FIREBASE_SERVER_KEY:latest,SUPERADMIN_PASSWORD=SUPERADMIN_PASSWORD:latest"
```

Notes:
- **Region**: `asia-south1` (Mumbai) is closest to Karnataka users. Your Supabase
  DB is in `ap-southeast-1` (Singapore) — the cross-region hop to the DB adds a
  little latency per query, but keeps the API itself fast for end users. Change
  `--region` if you'd rather colocate with the DB.
- **`--allow-unauthenticated`**: required so the mobile app and portal (which
  authenticate via your own JWT layer, not Google IAM) can reach the API at all.
- **`--max-instances`**: caps how many container instances can run concurrently.
  Each instance opens its own SQLAlchemy pool (`pool_size=5, max_overflow=10` —
  see `config.py`), so 10 instances could open up to 150 DB connections against
  Supabase's pooler. Check your Supabase plan's connection limit and adjust
  `--max-instances` (or the pool sizes in `config.py`) accordingly before going
  to real traffic.
- Fill in the actual `CORS_ORIGINS` values (your deployed admin/portal domains)
  before running this — the placeholder above won't work as-is.

## 3. Database migrations

The database is external Supabase, not Cloud SQL, so migrations aren't part of
the container's job — run them from your machine (or CI) against the same
`DATABASE_URL`, same as you do today:

```bash
cd backend
flask db upgrade
```

## 4. Verify

```bash
curl https://<your-cloud-run-url>/health
# {"status": "ok", "service": "butterfly-api", "version": "2.0"}
```

## 5. Point the mobile app / admin / portal at the new URL

Update whatever base-URL config those clients use to the Cloud Run service URL
(or a custom domain mapped to it via `gcloud run domain-mappings create`).

## Redeploying after code changes

```bash
gcloud run deploy butterfly-api --source . --region asia-south1
```
Cloud Run keeps the previous revision's env vars/secrets, so you don't need to
repeat `--set-env-vars`/`--set-secrets` on every redeploy unless they changed.
