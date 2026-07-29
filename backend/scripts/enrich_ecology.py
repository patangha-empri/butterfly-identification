"""
Ecology enrichment: Indian-state distribution + larval host plants + nectar plants,
for species that don't have them yet. All from authoritative structured sources —
nothing fabricated:

  - Distribution  : GBIF occurrence stateProvince facet (country=IN) -> india_states.
                    abundance is a documented GBIF occurrence-frequency proxy
                    (top states 'common', rest 'uncommon') — not a formal abundance survey.
  - Host plants   : GloBI interactionType=hasHost, targets in kingdom Plantae (larval hosts).
  - Nectar plants : GloBI interactionType=visitsFlowersOf (adult nectar sources).

Resumable: distribution / host inserts are each skipped if already present for a species.

Usage:
  python scripts/enrich_ecology.py --limit 10
  python scripts/enrich_ecology.py
"""
import argparse
import json
import re
import sys
import time
from difflib import SequenceMatcher

import psycopg2
import requests
from psycopg2.extras import Json, RealDictCursor
from dotenv import dotenv_values

CFG = dotenv_values(r"D:\thardeye_projects\Butterfly Identification system\backend\.env")
DB_URL = CFG["DATABASE_URL"]
GBIF = "https://api.gbif.org/v1"
GLOBI = "https://api.globalbioticinteractions.org/interaction"
UA = "ButterflyIdentificationSystem/1.0 (contact: abhinabajana900@gmail.com)"

S = requests.Session()
S.headers.update({"User-Agent": UA})

# GBIF stateProvince strings -> india_states.name
STATE_ALIASES = {
    "nct of delhi": "Delhi", "national capital territory of delhi": "Delhi",
    "orissa": "Odisha", "uttaranchal": "Uttarakhand", "pondicherry": "Puducherry",
    "jammu & kashmir": "Jammu and Kashmir", "jammu and kashmir": "Jammu and Kashmir",
    "andaman & nicobar islands": "Andaman and Nicobar Islands",
    "andaman and nicobar": "Andaman and Nicobar Islands",
    "dadra & nagar haveli": "Dadra and Nagar Haveli and Daman and Diu",
    "dadra and nagar haveli": "Dadra and Nagar Haveli and Daman and Diu",
    "daman and diu": "Dadra and Nagar Haveli and Daman and Diu",
}


def get_json(url, params=None, tries=4, timeout=45):
    r = None
    for i in range(tries):
        try:
            r = S.get(url, params=params, timeout=timeout)
        except requests.exceptions.RequestException:
            time.sleep(1.2 * (i + 1)); continue
        if r.status_code == 200:
            try:
                return r.json()
            except ValueError:
                return None
        if r.status_code in (429, 503):
            time.sleep(2 * (i + 1)); continue
        return None
    return None


def load_states(cur):
    cur.execute("SELECT id, name FROM india_states")
    by_lower, names = {}, []
    for r in cur.fetchall():
        by_lower[r["name"].lower()] = r["id"]
        names.append((r["name"], r["id"]))
    return by_lower, names


def match_state(raw, by_lower, names):
    if not raw:
        return None
    k = raw.strip().lower()
    if k in STATE_ALIASES:
        k = STATE_ALIASES[k].lower()
    if k in by_lower:
        return by_lower[k]
    # fuzzy
    best, best_id = 0.0, None
    for nm, sid in names:
        s = SequenceMatcher(None, nm.lower(), k).ratio()
        if s > best:
            best, best_id = s, sid
    return best_id if best >= 0.86 else None


def gbif_key(sci):
    m = get_json(f"{GBIF}/species/match", params={"name": sci})
    if not m or m.get("matchType") == "NONE":
        return None
    return m.get("acceptedUsageKey") or m.get("usageKey")


def gbif_states(key):
    j = get_json(f"{GBIF}/occurrence/search", params={
        "country": "IN", "taxonKey": key, "facet": "stateProvince",
        "facetLimit": 45, "limit": 0})
    facets = (j or {}).get("facets", [])
    return facets[0]["counts"] if facets else []


def globi_plants(sci, interaction):
    j = get_json(GLOBI, params={
        "sourceTaxon": sci, "interactionType": interaction,
        "field": ["target_taxon_name", "target_taxon_path"], "limit": 300})
    if not j:
        return []
    seen, out = set(), []
    for row in j.get("data", []):
        name = (row[0] or "").strip() if len(row) > 0 else ""
        path = (row[1] or "") if len(row) > 1 else ""
        if not name or "Plantae" not in path:
            continue
        if name.lower() in seen or name.lower() == sci.lower():
            continue
        seen.add(name.lower())
        out.append(name[:200])
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--limit", type=int, default=0)
    args = ap.parse_args()

    conn = psycopg2.connect(DB_URL, connect_timeout=30); conn.autocommit = False
    cur = conn.cursor(cursor_factory=RealDictCursor)
    by_lower, names = load_states(cur)

    cur.execute("""SELECT s.id, s.scientific_name,
        EXISTS(SELECT 1 FROM species_india_distribution d WHERE d.species_id=s.id) has_dist,
        EXISTS(SELECT 1 FROM species_host_plants h WHERE h.species_id=s.id) has_host,
        (s.nectar_plants IS NOT NULL) has_nectar
        FROM species s
        WHERE NOT EXISTS(SELECT 1 FROM species_india_distribution d WHERE d.species_id=s.id)
           OR NOT EXISTS(SELECT 1 FROM species_host_plants h WHERE h.species_id=s.id)
        ORDER BY s.scientific_name""")
    todo = cur.fetchall()
    if args.limit:
        todo = todo[:args.limit]
    print(f"Species needing ecology data: {len(todo)}", flush=True)

    dist_sp = host_sp = nectar_sp = 0
    dist_rows = host_rows = 0
    for n, sp in enumerate(todo, 1):
        sci = sp["scientific_name"]
        try:
            key = None
            # ── distribution ──
            if not sp["has_dist"]:
                key = gbif_key(sci)
                counts = gbif_states(key) if key else []
                if counts:
                    mx = max(c["count"] for c in counts)
                    placed = {}
                    for c in counts:
                        sid = match_state(c["name"], by_lower, names)
                        if not sid or sid in placed:
                            continue
                        placed[sid] = "common" if c["count"] >= 0.25 * mx else "uncommon"
                    if placed:
                        with conn.cursor() as ic:
                            ic.executemany(
                                "INSERT INTO species_india_distribution (species_id, state_id, abundance) "
                                "VALUES (%s,%s,%s)",
                                [(sp["id"], sid, ab) for sid, ab in placed.items()])
                        dist_rows += len(placed); dist_sp += 1

            # ── host plants (GloBI hasHost) ──
            if not sp["has_host"]:
                hosts = globi_plants(sci, "hasHost")[:15]
                if hosts:
                    with conn.cursor() as ic:
                        ic.executemany(
                            "INSERT INTO species_host_plants (species_id, plant_name, plant_scientific_name) "
                            "VALUES (%s,%s,%s)",
                            [(sp["id"], h, h) for h in hosts])
                    host_rows += len(hosts); host_sp += 1

            # ── nectar plants (GloBI visitsFlowersOf) -> jsonb column ──
            if not sp["has_nectar"]:
                nectar = globi_plants(sci, "visitsFlowersOf")[:15]
                if nectar:
                    with conn.cursor() as uc:
                        uc.execute("UPDATE species SET nectar_plants=%s WHERE id=%s AND nectar_plants IS NULL",
                                   (Json(nectar), sp["id"]))
                    nectar_sp += 1

            conn.commit()
        except (psycopg2.InterfaceError, psycopg2.OperationalError) as e:
            print(f"[{n}] reconnect after {e!r}", flush=True)
            try:
                conn.close()
            except Exception:
                pass
            conn = psycopg2.connect(DB_URL, connect_timeout=30); conn.autocommit = False
            cur = conn.cursor(cursor_factory=RealDictCursor)
            continue
        except Exception as e:
            conn.rollback()
            print(f"[{n}] ERR {sci}: {e!r}", flush=True)
            continue

        if n % 25 == 0:
            print(f"  ...{n}/{len(todo)} | dist_sp={dist_sp} host_sp={host_sp} nectar_sp={nectar_sp}", flush=True)
        time.sleep(0.35)

    cur.close(); conn.close()
    print(f"\nDONE. distribution: {dist_sp} species ({dist_rows} rows) | "
          f"host: {host_sp} species ({host_rows} rows) | nectar: {nectar_sp} species", flush=True)


if __name__ == "__main__":
    main()
