"""
Supabase PostgREST client — used by services running on hosts where a direct
Postgres connection (port 5432/6543) is firewalled and only HTTPS (443) is open.

Uses the service_role key: this client only ever runs on the trusted backend,
never exposed to browsers, so it intentionally bypasses Row Level Security.
"""
import os
from functools import lru_cache

from supabase import create_client, Client


@lru_cache(maxsize=1)
def get_supabase() -> Client:
    url = os.environ.get("SUPABASE_URL")
    key = os.environ.get("SUPABASE_SERVICE_KEY")
    if not url or not key:
        raise RuntimeError(
            "SUPABASE_URL and SUPABASE_SERVICE_KEY must be set to use the Supabase REST client."
        )
    return create_client(url, key)
