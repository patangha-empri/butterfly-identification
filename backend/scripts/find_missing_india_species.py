"""
Re-run the India species enumeration against GBIF today and diff it against the
database, to find species the original discovery pass never ingested.

Same query the catalog was built from (discover_india_species.py): occurrence
facets on speciesKey, country=IN, per butterfly family. Resolving each key to its
accepted binomial is one API call, so it is threaded.

Read-only against both GBIF and the database — it reports, it does not ingest.

    backend/venv/Scripts/python.exe scripts/find_missing_india_species.py
    ... --min-records 5     only report species with at least N Indian records
"""
import argparse
import collections
import csv
import os
import re
import sys
import threading
import time
from concurrent.futures import ThreadPoolExecutor

import psycopg2
import requests
from psycopg2.extras import RealDictCursor
from dotenv import dotenv_values

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CFG = dotenv_values(os.path.join(ROOT, ".env"))
GBIF = "https://api.gbif.org/v1"
UA = ("ButterflyIdentificationSystem/1.0 "
      "(https://butterfly-identification.b-cdn.net; contact: abhinabajana900@gmail.com)")
FAMILIES = ["Papilionidae", "Pieridae", "Nymphalidae", "Lycaenidae", "Riodinidae", "Hesperiidae"]

_local = threading.local()


def session():
    if not hasattr(_local, "s"):
        s = requests.Session()
        s.headers.update({"User-Agent": UA})
        _local.s = s
    return _local.s


def get(url, params=None, tries=4):
    for i in range(tries):
        try:
            r = session().get(url, params=params, timeout=60)
        except requests.RequestException:
            time.sleep(1.5 * (i + 1))
            continue
        if r.status_code == 200:
            return r.json()
        if r.status_code in (429, 503):
            time.sleep(2 * (i + 1))
            continue
        return None
    return None


def enumerate_keys():
    """{speciesKey: india_record_count} across the six butterfly families."""
    keys = {}
    for fam in FAMILIES:
        m = get(f"{GBIF}/species/match", params={"name": fam, "rank": "FAMILY"})
        fk = m.get("usageKey") if m else None
        if not fk:
            print(f"  ! could not resolve {fam}")
            continue
        r = get(f"{GBIF}/occurrence/search", params={
            "country": "IN", "familyKey": fk, "facet": "speciesKey",
            "facetLimit": 2000, "limit": 0})
        counts = (r or {}).get("facets", [{}])[0].get("counts", []) if r else []
        for c in counts:
            keys[int(c["name"])] = c["count"]
        print(f"  {fam:14s} distinct India speciesKeys = {len(counts)}")
        time.sleep(0.3)
    return keys


def resolve(key):
    """Mirror discover_india_species.resolve_species: accepted, SPECIES rank, real binomial."""
    u = get(f"{GBIF}/species/{key}")
    if not u:
        return None
    if u.get("taxonomicStatus") not in ("ACCEPTED", "DOUBTFUL") and u.get("acceptedKey"):
        u = get(f"{GBIF}/species/{u['acceptedKey']}") or u
    if u.get("rank") != "SPECIES" or u.get("kingdom") != "Animalia" or u.get("order") != "Lepidoptera":
        return None
    parts = (u.get("canonicalName") or "").split()
    if len(parts) != 2:
        return None
    ep = parts[1].lower()
    if ep in {"spec", "sp", "indet", "cf", "aff", "nr", "gen"} or not re.fullmatch(r"[a-zé]+", ep):
        return None
    return {"name": " ".join(parts), "family": u.get("family"), "key": u.get("key")}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--min-records", type=int, default=1)
    ap.add_argument("--csv", default=os.path.join(ROOT, "scripts", "missing_india_species.csv"))
    args = ap.parse_args()

    conn = psycopg2.connect(CFG["DATABASE_URL"])
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT scientific_name, is_active FROM species")
    have = {r["scientific_name"].strip().lower(): r["is_active"] for r in cur.fetchall()}
    cur.close()
    conn.close()
    print(f"database: {len(have)} species rows\n")

    print("enumerating GBIF India occurrences (same query as the original pass):")
    keys = enumerate_keys()
    print(f"\ntotal distinct speciesKeys now: {len(keys)}")

    print("resolving keys to accepted names...")
    resolved = {}
    with ThreadPoolExecutor(max_workers=8) as ex:
        for key, info in zip(keys, ex.map(resolve, keys)):
            if info:
                resolved[key] = info
    print(f"resolved to {len({v['name'] for v in resolved.values()})} distinct accepted species\n")

    missing = {}
    for key, info in resolved.items():
        n = info["name"].lower()
        if n in have:
            continue
        prev = missing.get(info["name"])
        cnt = keys[key] + (prev["india_records"] if prev else 0)
        missing[info["name"]] = {
            "scientific_name": info["name"],
            "family": info["family"],
            "india_records": cnt,
            "gbif_key": info["key"],
        }

    rows = sorted(
        (m for m in missing.values() if m["india_records"] >= args.min_records),
        key=lambda m: -m["india_records"],
    )

    with open(args.csv, "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=["scientific_name", "family", "india_records", "gbif_key"])
        w.writeheader()
        w.writerows(rows)

    print(f"IN GBIF (India) BUT NOT IN DATABASE: {len(rows)} species")
    fam = collections.Counter(r["family"] for r in rows)
    for f, n in fam.most_common():
        print(f"  {f or '(none)':16} {n}")
    print("\ntop by Indian record count:")
    for r in rows[:40]:
        print(f"  {r['india_records']:6}  {r['scientific_name']:34} {r['family']}")
    print(f"\nCSV: {args.csv}")


if __name__ == "__main__":
    main()
