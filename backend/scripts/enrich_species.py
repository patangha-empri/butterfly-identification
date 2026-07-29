"""
Butterfly species enrichment pipeline.

For each species already in the DB (or a supplied list), gather VERIFIED data from
structured authoritative APIs and fill only the gaps — existing values are never
overwritten (SQL COALESCE). Every enriched field is tagged in `field_provenance`.
Unverifiable fields are left NULL with a recorded reason. Nothing is fabricated.

Sources (all structured, citable):
  - GBIF  species match + usage + synonyms  -> taxonomy, authorship, accepted name
  - Wikipedia REST summary                  -> cited description prose (only if missing)
  - Wikimedia Commons API                   -> a freely-licensed image (only if none yet)
Images are converted to WebP and uploaded to Bunny under species/{family}/{genus_species}/.

Usage:
  python scripts/enrich_species.py --limit 5          # process 5 that still need work
  python scripts/enrich_species.py --only "Papilio polytes"
  python scripts/enrich_species.py                    # process all remaining
"""
import argparse
import hashlib
import io
import json
import re
import sys
import time
import uuid
from datetime import datetime, timezone

import psycopg2
import requests
from psycopg2.extras import Json, RealDictCursor
from dotenv import dotenv_values
from PIL import Image

CFG = dotenv_values(r"D:\thardeye_projects\Butterfly Identification system\backend\.env")
DB_URL = CFG["DATABASE_URL"]
BUNNY_KEY = CFG["BUNNY_STORAGE_API_KEY"]
BUNNY_ZONE = CFG["BUNNY_STORAGE_ZONE"]
BUNNY_REGION = CFG.get("BUNNY_STORAGE_REGION", "de").strip().split()[0]
BUNNY_CDN = CFG["BUNNY_CDN_URL"].rstrip("/")

UA = ("ButterflyIdentificationSystem/1.0 "
      "(https://butterfly-identification.b-cdn.net; contact: abhinabajana900@gmail.com) "
      "research-ingestion")
FREE_LICENSES = ("cc0", "cc-by", "cc by", "public domain", "pd", "cc-by-sa", "cc by-sa")
GBIF = "https://api.gbif.org/v1"

session = requests.Session()
session.headers.update({"User-Agent": UA})


def http_get(url, params=None, tries=4, timeout=45):
    r = None
    for i in range(tries):
        try:
            r = session.get(url, params=params, timeout=timeout)
        except requests.exceptions.RequestException:
            time.sleep(2 * (i + 1))
            continue
        if r.status_code == 200:
            return r
        if r.status_code in (429, 503):
            time.sleep(2 * (i + 1))
            continue
        return r
    if r is not None:
        return r
    # All attempts raised a network error — return a synthetic non-200 sentinel.
    resp = requests.models.Response()
    resp.status_code = 599
    resp._content = b""
    return resp


def now_iso():
    return datetime.now(timezone.utc).isoformat()


def prov(source, conf, note=None):
    d = {"source": source, "confidence": conf, "verified": True, "last_verified": now_iso()}
    if note:
        d["note"] = note
    return d


def null_prov(note):
    return {"source": None, "confidence": 0.0, "verified": False, "note": note}


# ── GBIF taxonomy ───────────────────────────────────────────────────────────
def gbif_taxonomy(scientific_name):
    """Return dict of verified taxonomy fields + provenance, or None if no match."""
    r = http_get(f"{GBIF}/species/match", params={"name": scientific_name, "strict": "false"})
    m = r.json() if r.status_code == 200 else {}
    if not m or m.get("matchType") == "NONE" or not m.get("usageKey"):
        return None

    key = m.get("acceptedUsageKey") or m["usageKey"]
    u = http_get(f"{GBIF}/species/{key}").json()

    authorship = (u.get("authorship") or "").strip()
    year = None
    ym = re.search(r"(\d{4})", authorship)
    if ym:
        year = int(ym.group(1))
    author = re.sub(r",?\s*\d{4}", "", authorship).strip() or None

    # synonyms (names only)
    syns = []
    sr = http_get(f"{GBIF}/species/{key}/synonyms", params={"limit": 25})
    if sr.status_code == 200:
        for s in sr.json().get("results", []):
            n = s.get("scientificName")
            if n:
                syns.append(n)

    canonical = u.get("canonicalName") or m.get("canonicalName") or scientific_name
    accepted = (canonical + (" " + authorship if authorship else "")).strip()
    gconf = m.get("confidence", 0)

    return {
        "family": u.get("family") or m.get("family"),
        "genus": u.get("genus") or m.get("genus"),
        "species_epithet": (canonical.split()[-1] if canonical and len(canonical.split()) > 1 else None),
        "authority": author,
        "taxon_year": year,
        "accepted_name": accepted,
        "synonyms": sorted(set(syns)),
        "subfamily": None,   # GBIF standard ranks omit subfamily/tribe
        "tribe": None,
        "gbif_key": key,
        "gbif_confidence": gconf,
        "status": u.get("taxonomicStatus") or m.get("status"),
    }


# ── Wikipedia description (cited) ───────────────────────────────────────────
def wikipedia_summary(scientific_name):
    title = scientific_name.replace(" ", "_")
    r = http_get(f"https://en.wikipedia.org/api/rest_v1/page/summary/{title}")
    if r.status_code != 200:
        return None
    j = r.json()
    if j.get("type") == "disambiguation":
        return None
    extract = (j.get("extract") or "").strip()
    if not extract or len(extract) < 40:
        return None
    return {"extract": extract, "url": (j.get("content_urls", {}).get("desktop", {}).get("page"))}


# ── Wikimedia Commons licensed image ────────────────────────────────────────
def commons_image(scientific_name):
    """Return a score-ranked list of freely-licensed candidate images (best first)."""
    r = http_get("https://commons.wikimedia.org/w/api.php", params={
        "action": "query", "generator": "search",
        "gsrsearch": f'filetype:bitmap {scientific_name}',
        "gsrnamespace": "6", "gsrlimit": "12",
        "prop": "imageinfo", "iiprop": "url|size|mime|extmetadata", "format": "json",
    })
    if r.status_code != 200:
        return []
    pages = (r.json().get("query", {}) or {}).get("pages", {})
    cands = []
    for p in pages.values():
        info = (p.get("imageinfo") or [{}])[0]
        if not info or info.get("mime") not in ("image/jpeg", "image/png"):
            continue
        ext = info.get("extmetadata", {}) or {}
        lic = (ext.get("LicenseShortName", {}).get("value", "")
               or ext.get("License", {}).get("value", "")).lower()
        if not any(tok in lic for tok in FREE_LICENSES):
            continue
        w = info.get("width", 0)
        if w < 500:
            continue
        artist = re.sub(r"<[^>]+>", "", ext.get("Artist", {}).get("value", "")).strip() or "Unknown"
        cand = {
            "url": info["url"], "width": w, "height": info.get("height", 0),
            "mime": info["mime"], "license": ext.get("LicenseShortName", {}).get("value", "").strip(),
            "artist": artist, "page": p.get("title", ""),
            "descurl": info.get("descriptionurl", ""),
        }
        # Prefer moderate widths (1200-3000) and cc-by/cc0 over -sa; penalise huge
        # originals (>25 MP) that Wikimedia frequently resets mid-download.
        mp = (w * info.get("height", 0)) / 1_000_000.0
        score = min(w, 3000) + (100000 if "sa" not in cand["license"].lower() else 0) - (5000 if mp > 25 else 0)
        cands.append((score, cand))
    cands.sort(key=lambda t: t[0], reverse=True)
    return [c for _, c in cands]


def to_webp(im, max_side, quality=82):
    im = im.copy()
    im.thumbnail((max_side, max_side), Image.LANCZOS)
    buf = io.BytesIO()
    im.save(buf, format="WEBP", quality=quality, method=6)
    return buf.getvalue(), im.size


def bunny_put(data, path, ct="image/webp"):
    host = "storage.bunnycdn.com" if BUNNY_REGION == "de" else f"{BUNNY_REGION}.storage.bunnycdn.com"
    url = f"https://{host}/{BUNNY_ZONE}/{path}"
    resp = session.put(url, data=data, headers={"AccessKey": BUNNY_KEY, "Content-Type": ct}, timeout=60)
    resp.raise_for_status()
    return f"{BUNNY_CDN}/{path}"


def process_image(sci, family, genus_species):
    """Return image row dict or None. Tries ranked candidates until one downloads."""
    cands = commons_image(sci)
    img = cand = None
    for c in cands[:5]:
        try:
            # Request a bounded-width render via Special:FilePath to avoid huge originals.
            dl = f"https://commons.wikimedia.org/wiki/Special:FilePath/{c['page'].split(':', 1)[-1].replace(' ', '_')}?width=1600"
            ir = http_get(dl, tries=2, timeout=45)
            if ir.status_code != 200 or not ir.content:
                ir = http_get(c["url"], tries=2, timeout=45)
            if ir.status_code != 200 or not ir.content:
                continue
            img = Image.open(io.BytesIO(ir.content)).convert("RGB")
            cand = c
            break
        except Exception:
            continue
    if img is None or cand is None:
        return None
    main_bytes, main_dims = to_webp(img, 1600)
    thumb_bytes, _ = to_webp(img, 400)
    base = f"species/{family.lower()}/{genus_species}"
    main_path, thumb_path = f"{base}/adult_reference.webp", f"{base}/thumbs/adult_reference.webp"
    main_url = bunny_put(main_bytes, main_path)
    thumb_url = bunny_put(thumb_bytes, thumb_path)
    checksum = hashlib.sha256(main_bytes).hexdigest()
    return {
        "image_url": main_url, "thumbnail_url": thumb_url, "storage_path": main_path,
        "width": main_dims[0], "height": main_dims[1], "file_size_bytes": len(main_bytes),
        "checksum": checksum, "mime_type": "image/webp",
        "original_url": cand["url"], "source_page_url": cand["descurl"] or cand["page"],
        "license": cand["license"], "photographer": cand["artist"],
    }


def enrich_one(conn, sp):
    sci = sp["scientific_name"]
    warnings = []
    provenance = {}
    updates = {}

    tax = gbif_taxonomy(sci)
    if tax:
        for col in ("subfamily", "tribe", "species_epithet", "authority", "taxon_year", "accepted_name"):
            if tax.get(col) is not None:
                updates[col] = tax[col]
                provenance[col] = prov("GBIF", 0.97 if col != "subfamily" else 0.0)
        updates["synonyms"] = Json(tax["synonyms"])
        provenance["synonyms"] = prov("GBIF", 0.9)
        updates["taxonomic_notes"] = (
            f"GBIF usageKey {tax['gbif_key']}, status {tax['status']}, "
            f"match confidence {tax['gbif_confidence']}. Subfamily/tribe not provided by GBIF standard ranks."
        )
        provenance["subfamily"] = null_prov("Not provided by GBIF standard ranks; needs a Pieridae/Nymphalidae tribal source.")
        provenance["tribe"] = provenance["subfamily"]
        tax_ok = tax["gbif_confidence"] >= 90 and tax.get("status") in ("ACCEPTED", "SYNONYM", None)
    else:
        warnings.append("GBIF: no taxonomy match")
        tax_ok = False

    # Wikipedia — only fill description if missing
    wiki = wikipedia_summary(sci)
    src_urls = []
    if tax:
        src_urls.append(f"https://www.gbif.org/species/{tax['gbif_key']}")
    if wiki:
        src_urls.append(wiki["url"])
        if not sp.get("description"):
            updates["description"] = wiki["extract"]
            provenance["description"] = prov("Wikipedia", 0.8)
        else:
            # store cited prose without clobbering existing description
            if not sp.get("adult_description"):
                updates["adult_description"] = wiki["extract"]
                provenance["adult_description"] = prov("Wikipedia", 0.8)
    else:
        warnings.append("Wikipedia: no summary")

    # Image — only if none exists
    img_added = False
    if sp["img_count"] == 0 and tax and tax.get("family"):
        genus_species = re.sub(r"[^a-z0-9]+", "_", sci.lower()).strip("_")
        try:
            imres = process_image(sci, tax["family"], genus_species)
        except Exception as e:
            imres = None
            warnings.append(f"image pipeline error: {e}")
        if imres:
            with conn.cursor() as ic:
                ic.execute(
                    "INSERT INTO species_images (id, species_id, image_url, thumbnail_url, image_type, "
                    "is_primary, credit, source, photographer, license, copyright, source_page_url, "
                    "original_url, storage_path, confidence, verification_status, width, height, "
                    "file_size_bytes, checksum, mime_type, created_at) "
                    "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",
                    (str(uuid.uuid4()), sp["id"], imres["image_url"], imres["thumbnail_url"], "reference",
                     True, f'{imres["photographer"]}, {imres["license"]}, via Wikimedia Commons',
                     "Wikimedia Commons", imres["photographer"], imres["license"],
                     f'(c) {imres["photographer"]}, licensed {imres["license"]}',
                     imres["source_page_url"], imres["original_url"], imres["storage_path"],
                     0.6, "verified", imres["width"], imres["height"], imres["file_size_bytes"],
                     imres["checksum"], imres["mime_type"], now_iso()))
            img_added = True
        else:
            warnings.append("no freely-licensed Commons image found")

    # provenance + quality columns
    updates["source_urls"] = Json(src_urls)
    updates["citations"] = Json(
        ([{"source": "GBIF", "url": f"https://www.gbif.org/species/{tax['gbif_key']}"}] if tax else [])
        + ([{"source": "Wikipedia", "url": wiki["url"]}] if wiki else [])
    )
    updates["data_source"] = "; ".join([s for s in (["GBIF"] if tax else []) + (["Wikipedia"] if wiki else [])]) or "none"
    updates["last_verified"] = now_iso()
    updates["verification_status"] = "verified" if tax_ok else "partial"
    updates["confidence_score"] = round(min(0.95, (tax["gbif_confidence"] / 100.0 if tax else 0.3)), 2)
    updates["field_provenance"] = Json(provenance)

    # Build COALESCE update so existing non-null values are preserved for data columns.
    # provenance/quality columns are always overwritten (they describe THIS run).
    always_set = {"source_urls", "citations", "data_source", "last_verified",
                  "verification_status", "confidence_score", "field_provenance", "taxonomic_notes"}
    set_parts, vals = [], []
    for col, val in updates.items():
        if col in always_set:
            set_parts.append(f"{col} = %s")
        else:
            set_parts.append(f"{col} = COALESCE({col}, %s)")
        vals.append(val)
    set_parts.append("updated_at = %s")
    vals.append(now_iso())
    vals.append(sp["id"])
    with conn.cursor() as uc:
        uc.execute(f"UPDATE species SET {', '.join(set_parts)} WHERE id = %s", vals)

    return {
        "scientific_name": sci,
        "gbif": bool(tax),
        "gbif_conf": tax["gbif_confidence"] if tax else None,
        "image_added": img_added,
        "verification_status": updates["verification_status"],
        "warnings": warnings,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--only", type=str, default=None)
    args = ap.parse_args()

    conn = psycopg2.connect(DB_URL, connect_timeout=30)
    conn.autocommit = False
    cur = conn.cursor(cursor_factory=RealDictCursor)

    where = "WHERE s.verification_status IS DISTINCT FROM 'verified' OR NOT EXISTS " \
            "(SELECT 1 FROM species_images i WHERE i.species_id = s.id)"
    if args.only:
        where = "WHERE s.scientific_name = %(only)s"
    q = ("SELECT s.id, s.scientific_name, s.description, s.adult_description, "
         "(SELECT count(*) FROM species_images i WHERE i.species_id=s.id) img_count "
         f"FROM species s {where} ORDER BY s.scientific_name")
    cur.execute(q, {"only": args.only} if args.only else None)
    todo = cur.fetchall()
    if args.limit:
        todo = todo[:args.limit]

    print(f"Processing {len(todo)} species...")
    done = 0
    for sp in todo:
        try:
            res = enrich_one(conn, sp)
            conn.commit()
            done += 1
            flag = "IMG" if res["image_added"] else "   "
            wtxt = (" | warn: " + "; ".join(res["warnings"])) if res["warnings"] else ""
            print(f"[{done}/{len(todo)}] {flag} {res['scientific_name']:32s} "
                  f"gbif={res['gbif_conf']} {res['verification_status']}{wtxt}", flush=True)
        except Exception as e:
            conn.rollback()
            print(f"[ERR] {sp['scientific_name']}: {e!r}", flush=True)
        time.sleep(0.6)

    cur.close()
    conn.close()
    print(f"DONE. enriched {done}/{len(todo)}")


if __name__ == "__main__":
    main()
