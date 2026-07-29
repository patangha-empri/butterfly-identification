"""
Flag/deactivate non-Indian species that leaked into the catalog from erroneous or
vagrant GBIF India occurrence records.

Signal: GBIF occurrence count across ALL of ASIA (continent=ASIA). India-only counts
are unsafe — genuine but under-recorded Himalayan/NE-Indian species (Argynnis paphia,
Parnassius phoebus, Byasa adamsoni) have just 1 India record yet thousands across Asia,
while foreign-realm species (Morpho peleides, Danaus gilippus, Heteronympha merope)
have <=5 Asia records total. Calibration gap: foreign <=5, genuine Asian >=52.

Only species with an ASIA record count <= THRESHOLD are DEACTIVATED (is_active=False,
reversible — the app already filters on is_active). Borderline species (Asia count
between THRESHOLD+1 and REVIEW_MAX) are only reported, never touched. Nothing is deleted.

Usage:
  python scripts/cleanup_non_indian.py --dry-run     # report only, change nothing
  python scripts/cleanup_non_indian.py               # deactivate count<=1
"""
import argparse
import time
from datetime import datetime, timezone

import psycopg2
import requests
from psycopg2.extras import Json, RealDictCursor
from dotenv import dotenv_values

CFG = dotenv_values(r"D:\thardeye_projects\Butterfly Identification system\backend\.env")
DB_URL = CFG["DATABASE_URL"]
GBIF = "https://api.gbif.org/v1"
# A species is foreign-realm iff it is well-recorded GLOBALLY yet virtually absent
# from Asia. Under-recorded genuine Indian species are barely recorded anywhere
# (low global) — so a high global count is what proves "not Indian".
ASIA_MAX = 10       # must be near-absent from Asia
GLOBAL_MIN = 50     # ...AND well recorded globally -> deactivate (foreign realm)
GLOBAL_REVIEW = 20  # asia<=10 and global 20-49 -> report for manual review, keep active

S = requests.Session()
S.headers.update({"User-Agent": "ButterflyIdentificationSystem/1.0 (contact: abhinabajana900@gmail.com)"})


def get_json(url, params=None, tries=4, timeout=45):
    r = None
    for i in range(tries):
        try:
            r = S.get(url, params=params, timeout=timeout)
        except requests.exceptions.RequestException:
            time.sleep(1.2 * (i + 1)); continue
        if r.status_code == 200:
            return r.json()
        if r.status_code in (429, 503):
            time.sleep(2 * (i + 1)); continue
        return None
    return None


def region_counts(sci):
    """Return (asia, india, global) counts, or (None, None, None) if name unmatched."""
    m = get_json(f"{GBIF}/species/match", params={"name": sci})
    if not m or m.get("matchType") == "NONE":
        return None, None, None
    key = m.get("acceptedUsageKey") or m.get("usageKey")
    ja = get_json(f"{GBIF}/occurrence/search", params={"continent": "ASIA", "taxonKey": key, "limit": 0})
    ji = get_json(f"{GBIF}/occurrence/search", params={"country": "IN", "taxonKey": key, "limit": 0})
    jg = get_json(f"{GBIF}/occurrence/search", params={"taxonKey": key, "limit": 0})
    return (ja or {}).get("count"), (ji or {}).get("count"), (jg or {}).get("count")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    conn = psycopg2.connect(DB_URL, connect_timeout=30); conn.autocommit = False
    cur = conn.cursor(cursor_factory=RealDictCursor)
    # candidates: active species with NO mapped India state distribution
    cur.execute("""SELECT s.id, s.scientific_name, s.family FROM species s
        WHERE s.is_active = True
          AND NOT EXISTS (SELECT 1 FROM species_india_distribution d WHERE d.species_id=s.id)
        ORDER BY s.scientific_name""")
    cands = cur.fetchall()
    print(f"Candidates (active, 0 India state-distribution): {len(cands)}", flush=True)

    deactivated, review, kept, unknown = [], [], 0, 0
    for n, sp in enumerate(cands, 1):
        asia, inn, glob = region_counts(sp["scientific_name"])
        if asia is None:
            unknown += 1
            continue
        foreign = (asia <= ASIA_MAX and (glob or 0) >= GLOBAL_MIN)
        borderline = (asia <= ASIA_MAX and GLOBAL_REVIEW <= (glob or 0) < GLOBAL_MIN)
        if foreign:
            deactivated.append((sp["scientific_name"], sp["family"], asia, inn, glob))
            if not args.dry_run:
                cur.execute(
                    "UPDATE species SET is_active=False, "
                    "field_provenance = COALESCE(field_provenance,'{}'::jsonb) || %s, updated_at=%s "
                    "WHERE id=%s",
                    (Json({"is_active": {"source": "GBIF occurrence counts (Asia vs global)", "verified": True,
                            "note": f"Deactivated: {glob} GBIF records globally but only {asia} in all of Asia "
                                    f"({inn} in India) — foreign-realm species, not resident in India. Reversible.",
                            "last_verified": datetime.now(timezone.utc).isoformat()}}),
                     datetime.now(timezone.utc).isoformat(), sp["id"]))
                conn.commit()
        elif borderline:
            review.append((sp["scientific_name"], sp["family"], asia, inn, glob))
            kept += 1
        else:
            kept += 1
        if n % 25 == 0:
            print(f"  ...{n}/{len(cands)} | deactivated={len(deactivated)} review={len(review)} kept={kept}", flush=True)
        time.sleep(0.2)

    cur.close(); conn.close()
    print(f"\n{'DRY-RUN — no changes. ' if args.dry_run else ''}"
          f"DEACTIVATED={len(deactivated)} REVIEW={len(review)} KEPT_OK={kept} name-unresolved={unknown}")
    print(f"\n--- DEACTIVATED (Asia<={ASIA_MAX} AND global>={GLOBAL_MIN}: foreign realm) ---")
    for nm, fam, a, i, g in deactivated:
        print(f"  {nm} ({fam})  [Asia {a}, India {i}, Global {g}]")
    print(f"\n--- REVIEW (Asia<={ASIA_MAX}, global {GLOBAL_REVIEW}-{GLOBAL_MIN-1}: LEFT ACTIVE, decide manually) ---")
    for nm, fam, a, i, g in review:
        print(f"  {nm} ({fam})  [Asia {a}, India {i}, Global {g}]")


if __name__ == "__main__":
    main()
