"""
Alternative image source (iNaturalist) for species with no Wikimedia Commons image.

For each species still lacking an image, search iNaturalist for a freely licensed
photo (CC0 / CC-BY / CC-BY-SA only, to match the legal-reuse policy), preferring
research-grade observations, convert to WebP, upload to Bunny, and insert a
species_images row with full attribution + link back to the iNat observation.

Nothing fabricated; species with no free iNat photo are left as-is.

Usage:
  python scripts/inat_images.py --limit 5
  python scripts/inat_images.py
"""
import argparse
import hashlib
import io
import re
import sys
import time
import uuid

import psycopg2
import requests
from psycopg2.extras import RealDictCursor
from dotenv import dotenv_values
from PIL import Image

sys.path.insert(0, __file__.rsplit("\\", 1)[0])
from enrich_species import to_webp, bunny_put, now_iso  # noqa: E402

CFG = dotenv_values(r"D:\thardeye_projects\Butterfly Identification system\backend\.env")
DB_URL = CFG["DATABASE_URL"]
FREE = "cc0,cc-by,cc-by-sa"
INAT = "https://api.inaturalist.org/v1"

S = requests.Session()
S.headers.update({"User-Agent": "ButterflyIdentificationSystem/1.0 (contact: abhinabajana900@gmail.com)"})


def get(url, params=None, tries=4, timeout=45):
    r = None
    for i in range(tries):
        try:
            r = S.get(url, params=params, timeout=timeout)
        except requests.exceptions.RequestException:
            time.sleep(1.5 * (i + 1)); continue
        if r.status_code == 200:
            return r.json()
        if r.status_code in (429, 503):
            time.sleep(2 * (i + 1)); continue
        return None
    return None


def pick_photo(sci, licenses, accepted):
    """Return (large_image_url, license_code, attribution, photographer, page_url) or None."""
    for qg in ("research", None):
        params = {"taxon_name": sci, "photo_license": licenses, "per_page": 8,
                  "order_by": "votes", "order": "desc", "locale": "en"}
        if qg:
            params["quality_grade"] = qg
        j = get(f"{INAT}/observations", params=params)
        for obs in (j or {}).get("results", []):
            for ph in obs.get("photos", []):
                lic = (ph.get("license_code") or "").lower()
                if lic not in accepted:
                    continue
                url = ph.get("url") or ""
                if not url:
                    continue
                large = re.sub(r"/(square|small|medium)\.", "/large.", url)
                user = obs.get("user", {}) or {}
                photographer = user.get("name") or user.get("login") or "iNaturalist user"
                page = obs.get("uri") or f"https://www.inaturalist.org/observations/{obs.get('id')}"
                return large, lic, (ph.get("attribution") or ""), photographer, page
    # fallback: taxon default photo
    j = get(f"{INAT}/taxa", params={"q": sci, "rank": "species", "per_page": 3})
    for t in (j or {}).get("results", []):
        dp = t.get("default_photo") or {}
        lic = (dp.get("license_code") or "").lower()
        if lic in accepted and dp.get("medium_url"):
            large = re.sub(r"/(square|small|medium)\.", "/large.", dp["medium_url"])
            return large, lic, (dp.get("attribution") or ""), "iNaturalist", \
                f"https://www.inaturalist.org/taxa/{t.get('id')}"
    return None


def lic_label(code):
    return {"cc0": "CC0", "cc-by": "CC BY", "cc-by-sa": "CC BY-SA",
            "cc-by-nc": "CC BY-NC", "cc-by-nc-sa": "CC BY-NC-SA"}.get(code, code.upper())


def clip(s, n):
    s = (s or "").strip()
    return s[:n - 1] + "…" if len(s) > n else s


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--allow-nc", action="store_true",
                    help="also accept non-commercial CC-BY-NC / CC-BY-NC-SA photos")
    args = ap.parse_args()

    if args.allow_nc:
        licenses = "cc0,cc-by,cc-by-sa,cc-by-nc,cc-by-nc-sa"
        accepted = {"cc0", "cc-by", "cc-by-sa", "cc-by-nc", "cc-by-nc-sa"}
    else:
        licenses, accepted = FREE, {"cc0", "cc-by", "cc-by-sa"}

    conn = psycopg2.connect(DB_URL, connect_timeout=30); conn.autocommit = False
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("""SELECT s.id, s.scientific_name, s.family FROM species s
        WHERE NOT EXISTS (SELECT 1 FROM species_images i WHERE i.species_id=s.id)
          AND s.family IS NOT NULL AND s.is_active = True ORDER BY s.scientific_name""")
    todo = cur.fetchall()
    if args.limit:
        todo = todo[:args.limit]
    print(f"Active species needing an image (iNat, allow_nc={args.allow_nc}): {len(todo)}", flush=True)

    added = missing = failed = 0
    for n, sp in enumerate(todo, 1):
        sci, family = sp["scientific_name"], sp["family"]
        try:
            hit = pick_photo(sci, licenses, accepted)
            if not hit:
                missing += 1
                print(f"[{n}/{len(todo)}] no-inat  {sci}", flush=True)
                time.sleep(0.8); continue
            img_url, lic, attribution, photographer, page = hit
            resp = S.get(img_url, timeout=45)
            if resp.status_code != 200 or not resp.content:
                missing += 1; print(f"[{n}/{len(todo)}] dl-fail  {sci}", flush=True)
                time.sleep(0.8); continue
            img = Image.open(io.BytesIO(resp.content)).convert("RGB")
            main_bytes, dims = to_webp(img, 1600)
            thumb_bytes, _ = to_webp(img, 400)
            gs = re.sub(r"[^a-z0-9]+", "_", sci.lower()).strip("_")
            base = f"species/{family.lower()}/{gs}"
            main_url = bunny_put(main_bytes, f"{base}/adult_reference.webp")
            thumb_url = bunny_put(thumb_bytes, f"{base}/thumbs/adult_reference.webp")
            checksum = hashlib.sha256(main_bytes).hexdigest()
            label = lic_label(lic)
            with conn.cursor() as ic:
                ic.execute(
                    "INSERT INTO species_images (id, species_id, image_url, thumbnail_url, image_type, "
                    "is_primary, credit, source, photographer, license, copyright, source_page_url, "
                    "original_url, storage_path, confidence, verification_status, width, height, "
                    "file_size_bytes, checksum, mime_type, created_at) "
                    "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",
                    (str(uuid.uuid4()), sp["id"], main_url, thumb_url, "reference", True,
                     clip(f"{photographer}, {label}, via iNaturalist", 300), "iNaturalist",
                     clip(photographer, 300), clip(label, 100),
                     clip(attribution or f"(c) {photographer}, licensed {label}", 300),
                     clip(page, 500), clip(img_url, 500), f"{base}/adult_reference.webp",
                     0.55, "verified", dims[0], dims[1], len(main_bytes), checksum, "image/webp", now_iso()))
            conn.commit()
            added += 1
            print(f"[{n}/{len(todo)}] OK {label:8s} {sci}", flush=True)
        except Exception as e:
            try:
                conn.rollback()
            except Exception:
                conn = psycopg2.connect(DB_URL, connect_timeout=30); conn.autocommit = False
            failed += 1
            print(f"[{n}/{len(todo)}] ERR {sci}: {e!r}", flush=True)
        time.sleep(1.0)  # polite to iNat API

    cur.close(); conn.close()
    print(f"\nDONE. added={added} no-image={missing} failed={failed} of {len(todo)}", flush=True)


if __name__ == "__main__":
    main()
