"""
Verify the backend is wired to the intended Supabase project.

Checks both access paths independently, because they are configured separately
and can silently disagree:
  - DATABASE_URL      -> direct Postgres (used by the scripts/ ingestion tools)
  - SUPABASE_URL/KEY  -> PostgREST (used by every app service via get_supabase())

A mismatch between the two is the dangerous case: ingestion scripts would write
to one project while the API reads from another.

Usage:
  venv/Scripts/python.exe scripts/check_supabase_config.py
"""
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

import psycopg2
from dotenv import dotenv_values

# Tables to spot-check, with the row counts expected after the migration.
EXPECTED_ROWS = {
    "species": 1534,
    "species_images": 1487,
    "species_india_distribution": 7832,
    "species_host_plants": 3752,
    "observations": 184,
    "users": 32,
}

OK, FAIL, WARN = "[ OK ]", "[FAIL]", "[WARN]"
failures = []


def ref_from_db_url(url: str) -> str | None:
    """Supabase pooler usernames are 'postgres.<project_ref>'."""
    m = re.search(r"postgres\.([a-z0-9]{20})", url or "")
    return m.group(1) if m else None


def ref_from_api_url(url: str) -> str | None:
    m = re.search(r"https://([a-z0-9]{20})\.supabase\.co", url or "")
    return m.group(1) if m else None


def check(cond, msg, detail=""):
    print(f"{OK if cond else FAIL} {msg}{(' -> ' + detail) if detail else ''}")
    if not cond:
        failures.append(msg)
    return cond


env = dotenv_values(Path(__file__).resolve().parent.parent / ".env")
db_url = env.get("DATABASE_URL", "")
api_url = env.get("SUPABASE_URL", "")
api_key = env.get("SUPABASE_SERVICE_KEY", "")

db_ref, api_ref = ref_from_db_url(db_url), ref_from_api_url(api_url)

print("\n=== project identity ===")
check(bool(db_ref), "DATABASE_URL names a Supabase project", db_ref or "unparsable")
check(bool(api_ref), "SUPABASE_URL names a Supabase project", api_ref or "unparsable")
check(
    db_ref is not None and db_ref == api_ref,
    "DATABASE_URL and SUPABASE_URL point at the SAME project",
    f"db={db_ref} api={api_ref}",
)

print("\n=== direct Postgres (DATABASE_URL) ===")
pg_counts = {}
try:
    conn = psycopg2.connect(db_url, connect_timeout=20)
    cur = conn.cursor()
    cur.execute("select count(*) from pg_tables where schemaname = 'public'")
    check(cur.fetchone()[0] == 27, "27 public tables present")
    for table, expected in EXPECTED_ROWS.items():
        cur.execute(f'select count(*) from public."{table}"')
        pg_counts[table] = cur.fetchone()[0]
        check(pg_counts[table] == expected, f"{table} row count", f"{pg_counts[table]} (expected {expected})")
    conn.close()
except Exception as exc:
    check(False, "connect via DATABASE_URL", str(exc)[:160])

print("\n=== PostgREST (SUPABASE_URL + SUPABASE_SERVICE_KEY) ===")
if not api_key:
    print(f"{FAIL} SUPABASE_SERVICE_KEY is empty — paste the new project's "
          f"service_role key into .env (Dashboard -> Project Settings -> API Keys).")
    failures.append("SUPABASE_SERVICE_KEY is empty")
else:
    try:
        # Import late: only meaningful once a key exists.
        from app.supabase_client import get_supabase

        sb = get_supabase()
        for table, expected in EXPECTED_ROWS.items():
            res = sb.table(table).select("*", count="exact").limit(1).execute()
            got = res.count
            same_as_pg = table not in pg_counts or got == pg_counts[table]
            check(
                got == expected and same_as_pg,
                f"{table} readable via REST",
                f"{got} (expected {expected})" + ("" if same_as_pg else " — DISAGREES WITH DATABASE_URL"),
            )
    except Exception as exc:
        check(False, "query via PostgREST", str(exc)[:200])

print()
if failures:
    print(f"{FAIL} {len(failures)} check(s) failed:")
    for f in failures:
        print(f"       - {f}")
    sys.exit(1)
print(f"{OK} backend is correctly configured against project {api_ref}")
