"""
Image backfill (Stage B): for every species that has no image yet, find a freely
licensed photo on Wikimedia Commons, convert to WebP, upload to Bunny, and insert a
species_images row with full attribution. Resumable — re-run any time; it only
targets species that still lack an image. Species with no free image are logged and
skipped (nothing fabricated, nothing unlicensed uploaded).

Usage:
  python scripts/backfill_images.py --limit 5      # try 5
  python scripts/backfill_images.py                # all remaining
"""
import argparse
import sys
import time
import uuid
import re
from datetime import datetime, timezone

import psycopg2
from psycopg2.extras import RealDictCursor
from dotenv import dotenv_values

# Reuse the proven image pipeline from enrich_species.py (same directory).
sys.path.insert(0, __file__.rsplit("\\", 1)[0])
from enrich_species import process_image, now_iso  # noqa: E402

CFG = dotenv_values(r"D:\thardeye_projects\Butterfly Identification system\backend\.env")
DB_URL = CFG["DATABASE_URL"]


def connect():
    c = psycopg2.connect(DB_URL, connect_timeout=30)
    c.autocommit = False
    return c


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--limit", type=int, default=0)
    args = ap.parse_args()

    conn = connect()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("""SELECT s.id, s.scientific_name, s.family
        FROM species s
        WHERE NOT EXISTS (SELECT 1 FROM species_images i WHERE i.species_id = s.id)
          AND s.family IS NOT NULL
        ORDER BY s.scientific_name""")
    todo = cur.fetchall()
    if args.limit:
        todo = todo[:args.limit]
    print(f"Species needing an image: {len(todo)}", flush=True)

    added = missing = failed = 0
    for n, sp in enumerate(todo, 1):
        sci, family = sp["scientific_name"], sp["family"]
        genus_species = re.sub(r"[^a-z0-9]+", "_", sci.lower()).strip("_")
        try:
            im = process_image(sci, family, genus_species)
        except Exception as e:
            im = None
            failed += 1
            print(f"[{n}/{len(todo)}] ERR  {sci}: {e!r}", flush=True)
            continue
        if not im:
            missing += 1
            if n % 20 == 0:
                print(f"  ...{n}/{len(todo)} | added={added} no-image={missing} failed={failed}", flush=True)
            continue

        def clip(s, limit):
            s = (s or "").strip()
            return s[:limit - 1] + "…" if len(s) > limit else s

        photographer = clip(im["photographer"], 300)
        license_ = clip(im["license"], 100)
        credit = clip(f'{photographer}, {license_}, via Wikimedia Commons', 300)
        copyright_ = clip(f'(c) {photographer}, licensed {license_}', 300)
        params = (str(uuid.uuid4()), sp["id"], im["image_url"], im["thumbnail_url"], "reference",
                  True, credit, "Wikimedia Commons", photographer, license_, copyright_,
                  clip(im["source_page_url"], 500), clip(im["original_url"], 500), im["storage_path"],
                  0.6, "verified", im["width"], im["height"], im["file_size_bytes"],
                  im["checksum"], im["mime_type"], now_iso())
        sql = ("INSERT INTO species_images (id, species_id, image_url, thumbnail_url, image_type, "
               "is_primary, credit, source, photographer, license, copyright, source_page_url, "
               "original_url, storage_path, confidence, verification_status, width, height, "
               "file_size_bytes, checksum, mime_type, created_at) "
               "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)")
        inserted_ok = False
        for db_attempt in range(2):
            try:
                with conn.cursor() as ic:
                    ic.execute(sql, params)
                conn.commit()
                inserted_ok = True
                break
            except (psycopg2.InterfaceError, psycopg2.OperationalError) as e:
                # Pooler dropped the connection — reconnect and retry once.
                print(f"[{n}/{len(todo)}] reconnect after: {e!r}", flush=True)
                try:
                    conn.close()
                except Exception:
                    pass
                conn = connect()
                continue
            except Exception as e:
                try:
                    conn.rollback()
                except Exception:
                    conn = connect()
                failed += 1
                print(f"[{n}/{len(todo)}] DB-ERR {sci}: {e!r}", flush=True)
                break
        if not inserted_ok:
            continue
        added += 1
        if added % 10 == 0 or n % 20 == 0:
            print(f"  ...{n}/{len(todo)} | added={added} no-image={missing} failed={failed}", flush=True)
        time.sleep(0.4)

    cur.close(); conn.close()
    print(f"\nDONE. added={added} no-image={missing} failed={failed} of {len(todo)}", flush=True)


if __name__ == "__main__":
    main()
