"""
Answer "why isn't this species in the database?" for a list of names.

A species a field researcher reports as missing is usually one of four things,
and only the last is a real gap:

  PRESENT           active row, exactly as named
  HIDDEN            row exists but is_active=false, so the app and admin lists
                    do not show it. Reason is recorded in field_provenance.
                    Reversible with a single flag — no re-ingestion needed.
  NAME_MISMATCH     present under a different accepted name. Indian literature
                    (Evans, Wynter-Blyth, ifoundbutterflies) often uses an older
                    genus than the GBIF backbone this catalog was built from —
                    Spindasis/Cigaritis, Bibasis/Burara, Pathysa/Graphium.
  ABSENT            genuinely not in the catalog. The catalog was enumerated
                    from GBIF occurrence records tagged country=IN, so a species
                    with no digitised Indian occurrence was never seen — common
                    for Western Ghats endemics known from literature and local
                    checklists rather than from GBIF-exported datasets.

Matching runs local first (exact, case-insensitive, epithet-across-genus,
recorded synonyms, common name) and then optionally asks GBIF to resolve the
supplied name to its accepted name and retries — that is what catches the
genus-rename cases.

    backend/venv/Scripts/python.exe scripts/check_missing_species.py --file names.txt
    backend/venv/Scripts/python.exe scripts/check_missing_species.py --names "Spindasis elima" "Papilio buddha"
    ... --no-gbif      skip the network step
    ... --csv out.csv  also write a spreadsheet
"""
import argparse
import csv
import os
import re
import sys
import time

import psycopg2
import requests
from psycopg2.extras import RealDictCursor
from dotenv import dotenv_values

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CFG = dotenv_values(os.path.join(ROOT, ".env"))
GBIF = "https://api.gbif.org/v1"
UA = ("ButterflyIdentificationSystem/1.0 "
      "(https://butterfly-identification.b-cdn.net; contact: abhinabajana900@gmail.com)")

S = requests.Session()
S.headers.update({"User-Agent": UA})


def norm(name):
    return re.sub(r"\s+", " ", (name or "").strip()).lower()


def load_catalog(conn):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("""
        SELECT id, scientific_name, common_name, family, is_active, synonyms,
               field_provenance->'is_active'->>'note' AS inactive_note
          FROM species
    """)
    rows = cur.fetchall()
    cur.close()

    by_sci, by_common, by_epithet, by_synonym = {}, {}, {}, {}
    for r in rows:
        by_sci[norm(r["scientific_name"])] = r
        if r["common_name"]:
            by_common.setdefault(norm(r["common_name"]), r)
        parts = (r["scientific_name"] or "").split()
        if len(parts) == 2:
            by_epithet.setdefault(norm(parts[1]), []).append(r)
        for syn in (r["synonyms"] or []):
            key = norm(syn if isinstance(syn, str) else syn.get("name", ""))
            if key:
                by_synonym.setdefault(key, r)
    return rows, by_sci, by_common, by_epithet, by_synonym


def gbif_accepted(name):
    """Resolve a name to the GBIF accepted binomial, or None."""
    try:
        r = S.get(f"{GBIF}/species/match", params={"name": name}, timeout=30)
    except requests.RequestException:
        return None
    if r.status_code != 200:
        return None
    j = r.json()
    if j.get("matchType") == "NONE":
        return None
    return j.get("species") or j.get("canonicalName")


def verdict_for(name, cat, use_gbif):
    rows, by_sci, by_common, by_epithet, by_synonym = cat
    n = norm(name)

    hit, how = by_sci.get(n), "exact name"
    if not hit and n in by_synonym:
        hit, how = by_synonym[n], "recorded synonym"
    if not hit and n in by_common:
        hit, how = by_common[n], "common name"

    if not hit and use_gbif:
        acc = gbif_accepted(name)
        time.sleep(0.2)
        if acc and norm(acc) != n and norm(acc) in by_sci:
            hit, how = by_sci[norm(acc)], f"GBIF accepted name: {acc}"

    if not hit:
        parts = n.split()
        if len(parts) == 2:
            cands = by_epithet.get(parts[1], [])
            if len(cands) == 1:
                hit, how = cands[0], f"same epithet, different genus: {cands[0]['scientific_name']}"
            elif len(cands) > 1:
                names = ", ".join(c["scientific_name"] for c in cands[:4])
                hit, how = cands[0], f"epithet matches several: {names}"

    if not hit:
        return {"verdict": "ABSENT", "how": "no match in catalog", "row": None}

    if not hit["is_active"]:
        return {"verdict": "HIDDEN", "how": how, "row": hit}
    if how == "exact name":
        return {"verdict": "PRESENT", "how": how, "row": hit}
    return {"verdict": "NAME_MISMATCH", "how": how, "row": hit}


EXPLAIN = {
    "PRESENT": "In the database and visible in the app.",
    "HIDDEN": "Row exists but is deactivated, so the app hides it. Reversible — set is_active=true.",
    "NAME_MISMATCH": "In the database under a different accepted name. Searchable once the "
                     "old name is added as a synonym.",
    "ABSENT": "Not in the catalog — no GBIF-digitised Indian occurrence record at ingestion "
              "time, so the discovery pass never saw it. Needs manual addition.",
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--file", help="text file, one species name per line")
    ap.add_argument("--names", nargs="*", default=[])
    ap.add_argument("--no-gbif", action="store_true")
    ap.add_argument("--csv")
    args = ap.parse_args()

    names = list(args.names)
    if args.file:
        with open(args.file, encoding="utf-8") as fh:
            names += [l.strip() for l in fh if l.strip() and not l.startswith("#")]
    if not names:
        sys.exit("give --names or --file")

    conn = psycopg2.connect(CFG["DATABASE_URL"])
    cat = load_catalog(conn)
    conn.close()

    results = []
    for name in names:
        v = verdict_for(name, cat, use_gbif=not args.no_gbif)
        row = v["row"]
        results.append({
            "queried_name": name,
            "verdict": v["verdict"],
            "matched_as": row["scientific_name"] if row else "",
            "common_name": (row or {}).get("common_name", ""),
            "family": (row or {}).get("family", ""),
            "matched_by": v["how"],
            "reason_if_hidden": (row or {}).get("inactive_note") or "",
            "what_it_means": EXPLAIN[v["verdict"]],
            "species_id": (row or {}).get("id", ""),
        })

    width = max(len(r["queried_name"]) for r in results) + 2
    for r in results:
        print(f"{r['queried_name']:<{width}} {r['verdict']:<14} {r['matched_by']}")
    print()
    counts = {}
    for r in results:
        counts[r["verdict"]] = counts.get(r["verdict"], 0) + 1
    for k, v in sorted(counts.items()):
        print(f"  {k:<14} {v}")

    if args.csv:
        with open(args.csv, "w", newline="", encoding="utf-8") as fh:
            w = csv.DictWriter(fh, fieldnames=list(results[0].keys()))
            w.writeheader()
            w.writerows(results)
        print(f"\nCSV: {args.csv}")


if __name__ == "__main__":
    main()
