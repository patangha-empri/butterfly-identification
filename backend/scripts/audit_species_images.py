"""
Audit species reference images for stand-ins — pictures that are technically
present and correctly licensed, but do not actually show the species on its own.

Two problems the image backfill left behind, neither of which the earlier
"1,430/1,430 have an image" count could see:

  PLATE      the image is a scanned page from an antique work (mostly Seitz,
             "Macrolepidoptera of the World"). One page carries 50-150 named
             specimens; the species in question is one small figure on it, so
             as a species reference the picture is unusable.
  SHARED     the identical file is the reference image for several species —
             the same plate page reused across every species that appears on
             it. Different species, byte-identical picture.

Detection is on stored metadata only (no downloads): `original_url` /
`source_page_url` filenames for the plate signature, `checksum` and
`original_url` for reuse. Read-only — it writes a CSV and changes nothing.

    backend/venv/Scripts/python.exe scripts/audit_species_images.py [--csv PATH]
"""
import argparse
import collections
import csv
import os
import re
import sys

import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import dotenv_values

# load_dotenv() alone does not populate DATABASE_URL here — an empty env var
# shadows the file. dotenv_values reads the file directly.
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CONFIG = dotenv_values(os.path.join(ROOT, ".env"))

# Antique-plate signatures seen in Commons filenames for this dataset.
PLATE_PAT = re.compile(
    r"seitz|macrolepidoptera|\bplate[\s_]*\d|\btaf\.?\s*\d|tafel|planche|"
    r"lithograph|illustrations?_of_|catalogue|\b1[6-9]\d{2}\b",
    re.I,
)


def fetch(conn):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute(
        """
        SELECT s.id, s.scientific_name, s.common_name, s.family, s.is_active,
               i.id AS image_id, i.image_url, i.is_primary, i.license,
               i.source_page_url, i.original_url, i.checksum
          FROM species s
          LEFT JOIN species_images i ON i.species_id = s.id
         ORDER BY s.family, s.scientific_name
        """
    )
    rows = cur.fetchall()
    cur.close()

    species = collections.OrderedDict()
    for r in rows:
        d = species.setdefault(r["id"], {"row": r, "imgs": []})
        if r["image_id"]:
            d["imgs"].append(r)
    return species


def source_filename(img):
    url = img["original_url"] or img["source_page_url"] or img["image_url"] or ""
    return url.rsplit("/", 1)[-1]


def classify(species):
    """Return (verdict, detail) per species id."""
    # Reuse is counted across the whole table, so a plate shared by five species
    # is flagged on all five.
    users = collections.defaultdict(set)
    for sid, d in species.items():
        for im in d["imgs"]:
            for key in (im["checksum"], im["original_url"]):
                if key:
                    users[key].add(sid)

    out = {}
    for sid, d in species.items():
        imgs = d["imgs"]
        if not imgs:
            out[sid] = ("NO_IMAGE", "no image record")
            continue
        img = next((i for i in imgs if i["is_primary"]), imgs[0])
        fname = source_filename(img)
        shared = max(
            (len(users.get(k, ())) for k in (img["checksum"], img["original_url"]) if k),
            default=1,
        )
        is_plate = bool(PLATE_PAT.search(fname))

        if is_plate and shared > 1:
            out[sid] = ("PLATE_SHARED", f"{fname} — plate page, also used by {shared - 1} other species")
        elif is_plate:
            out[sid] = ("PLATE", f"{fname} — plate page (many species on one image)")
        elif shared > 1:
            out[sid] = ("SHARED", f"{fname} — identical file on {shared - 1} other species")
        elif not img["license"] or not (img["source_page_url"] or img["original_url"]):
            out[sid] = ("NO_PROVENANCE", fname or "(no source recorded)")
        else:
            out[sid] = ("OK", fname)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--csv", default=os.path.join(ROOT, "scripts", "species_image_audit.csv"))
    ap.add_argument("--active-only", action="store_true", help="ignore deactivated species")
    args = ap.parse_args()

    url = CONFIG.get("DATABASE_URL")
    if not url:
        sys.exit("DATABASE_URL missing from backend/.env")

    conn = psycopg2.connect(url)
    species = fetch(conn)
    conn.close()

    verdicts = classify(species)
    if args.active_only:
        species = {k: v for k, v in species.items() if v["row"]["is_active"]}

    rows = []
    for sid, d in species.items():
        s = d["row"]
        verdict, detail = verdicts[sid]
        if verdict == "OK":
            continue
        img = next((i for i in d["imgs"] if i["is_primary"]), d["imgs"][0] if d["imgs"] else {})
        rows.append({
            "verdict": verdict,
            "scientific_name": s["scientific_name"],
            "common_name": s["common_name"],
            "family": s["family"],
            "is_active": s["is_active"],
            "detail": detail,
            "image_url": img.get("image_url", ""),
            "license": img.get("license", ""),
            "source_page_url": img.get("source_page_url", ""),
            "species_id": s["id"],
        })

    rows.sort(key=lambda r: (r["verdict"], r["family"] or "", r["scientific_name"]))
    with open(args.csv, "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)

    counts = collections.Counter(verdicts[sid][0] for sid in species)
    active_counts = collections.Counter(
        verdicts[sid][0] for sid, d in species.items() if d["row"]["is_active"]
    )
    total = len(species)
    print(f"species examined: {total}  (active: {sum(active_counts.values())})\n")
    print(f"{'verdict':16} {'all':>6} {'active':>8}")
    for v, n in counts.most_common():
        print(f"{v:16} {n:6} {active_counts.get(v, 0):8}")

    bad = [sid for sid in species if verdicts[sid][0] not in ("OK",)]
    fam = collections.Counter(
        species[sid]["row"]["family"] for sid in bad if species[sid]["row"]["is_active"]
    )
    print("\naffected active species by family:")
    for f, n in fam.most_common():
        print(f"  {f or '(none)':16} {n}")
    print(f"\nCSV written: {args.csv}")


if __name__ == "__main__":
    main()
