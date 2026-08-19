"""
Fill in the species the researcher asked for specifically: fuller text data and a
usable photograph.

Two problems this fixes for those rows:

  thin data   the original pass stored only Wikipedia's *summary* (one short
              paragraph, ~200 chars). The full article usually carries Description,
              Habitat, Range and Life-cycle sections. This pulls the whole article
              and files each section in the column that matches it, rather than
              dumping everything into `description`.

  bad photo   some rows point at a pinned museum specimen (a paratype plate photo)
              rather than a living butterfly. Where iNaturalist has a licensed
              field photograph, it replaces the specimen shot.

Wikipedia is consulted under whichever name has the article — several of these
species are filed under a name other than the one in our database — and the name
actually used is recorded in field_provenance.

Nothing is invented: a section that does not exist stays NULL.

    backend/venv/Scripts/python.exe scripts/enrich_reported_gaps.py --dry-run
    backend/venv/Scripts/python.exe scripts/enrich_reported_gaps.py
"""
import argparse
import hashlib
import io
import re
import sys
import uuid

import psycopg2
import requests
from psycopg2.extras import Json, RealDictCursor
from dotenv import dotenv_values
from PIL import Image
from slugify import slugify

sys.path.insert(0, __file__.rsplit("\\", 1)[0])
from enrich_species import to_webp, bunny_put, now_iso  # noqa: E402
from ingest_reported_species import get, js, inat_photo, prov, clip, FREE, NC  # noqa: E402

CFG = dotenv_values(r"D:\thardeye_projects\Butterfly Identification system\backend\.env")
DB_URL = CFG["DATABASE_URL"]

# db name -> (wikipedia/iNat search names, common name to set, force new photo?)
TARGETS = [
    ("Eurema andersoni",  ["Eurema andersonii"],  "One-spot Grass Yellow",   True),
    ("Cogia indrani",     ["Coladenia indrani"],  "Tricolour Pied Flat",     False),
    ("Hyarotis coorga",   ["Hyarotis coorga"],    "Kodagu Brush Flitter",    True),
    ("Deudorix perse",    ["Virachola perse", "Deudorix perse"], "Large Guava Blue", False),
    ("Luthrodes pandava", ["Chilades pandava", "Luthrodes pandava"], "Plains Cupid", False),
]

# Wikipedia section heading -> species column. Everything else is ignored rather
# than guessed at.
SECTION_MAP = [
    (r"^description$|^identification$|^appearance$", "identification_notes"),
    (r"habitat|distribution|range", "habitat"),
    (r"life ?cycle|biology|breeding|larva", "life_cycle"),
    (r"behaviou?r|habits", "behaviour"),
    (r"flight|season", "flight_period"),
]

# A photo of a pinned specimen is legitimate but poor as a field reference.
SPECIMEN_PAT = re.compile(r"_PT\.|paratype|holotype|syntype|specimen|museum|BMNH|NHMUK|_HT\.", re.I)


def wiki_full(name):
    """Full plain-text article, split into (intro, {section: text})."""
    r = get("https://en.wikipedia.org/w/api.php", params={
        "action": "query", "prop": "extracts", "explaintext": "1",
        "redirects": "1", "titles": name, "format": "json"})
    if not r:
        return None
    pages = ((r.json().get("query") or {}).get("pages") or {})
    for pid, page in pages.items():
        if pid == "-1" or not page.get("extract"):
            continue
        text = page["extract"]
        title = page.get("title")
        # sanity: the article must be about this binomial, not the genus
        if name.split()[-1].lower() not in (title or "").lower() and \
           name.split()[-1].lower() not in text[:300].lower():
            return None
        parts = re.split(r"\n==+ ([^=]+?) ==+\n", text)
        intro = parts[0].strip()
        sections = {}
        for i in range(1, len(parts) - 1, 2):
            head = parts[i].strip().lower()
            body = parts[i + 1].strip()
            if body:
                sections[head] = body
        return {"title": title, "intro": intro, "sections": sections,
                "url": f"https://en.wikipedia.org/wiki/{(title or name).replace(' ', '_')}"}
    return None


def map_sections(sections):
    out = {}
    for head, body in sections.items():
        if head in ("references", "external links", "see also", "gallery", "cited references",
                    "further reading", "notes", "sources"):
            continue
        for pat, col in SECTION_MAP:
            if re.search(pat, head) and col not in out:
                out[col] = body
                break
    return out


def replace_photo(conn, sp, search_names, allow_nc, dry):
    """Swap in a licensed field photograph. Returns a status string."""
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT id, original_url, source_page_url, source FROM species_images "
                "WHERE species_id=%s", (sp["id"],))
    current = cur.fetchall()
    cur_src = " ".join((c["original_url"] or "") + (c["source_page_url"] or "") for c in current)
    is_specimen = bool(SPECIMEN_PAT.search(cur_src))
    if current and not is_specimen:
        cur.close()
        return "kept (already a field photo)"

    accepted = set(FREE) | set(NC) if allow_nc else set(FREE)
    cand = None
    for n in search_names:
        cand = inat_photo(n, accepted)
        if cand:
            break
    if not cand:
        cur.close()
        return "no licensed photo found"
    if dry:
        cur.close()
        return f"would replace with {cand['source']} / {cand['license']}"

    r = get(cand["url"], tries=3)
    if not r or not r.content:
        cur.close()
        return "download failed"
    im = Image.open(io.BytesIO(r.content)).convert("RGB")
    main_bytes, dims = to_webp(im, 1600)
    thumb_bytes, _ = to_webp(im, 400)
    gs = slugify(sp["scientific_name"]).replace("-", "_")
    base = f"species/{(sp['family'] or 'unknown').lower()}/{gs}"
    main_path, thumb_path = f"{base}/adult_reference.webp", f"{base}/thumbs/adult_reference.webp"
    main_url = bunny_put(main_bytes, main_path)
    thumb_url = bunny_put(thumb_bytes, thumb_path)

    cur.execute("DELETE FROM species_images WHERE species_id=%s", (sp["id"],))
    cur.execute(
        "INSERT INTO species_images (id, species_id, image_url, thumbnail_url, image_type, is_primary, "
        "credit, source, photographer, license, source_page_url, original_url, storage_path, width, "
        "height, file_size_bytes, checksum, mime_type, verification_status, created_at) "
        "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",
        (str(uuid.uuid4()), sp["id"], main_url, thumb_url, "reference", True,
         clip(f"{cand['photographer']} ({cand['license']})", 300), cand["source"],
         clip(cand["photographer"], 300), clip(cand["license"], 100), clip(cand["page"], 500),
         clip(cand["url"], 500), main_path, dims[0], dims[1], len(main_bytes),
         hashlib.sha256(main_bytes).hexdigest(), "image/webp", "verified", now_iso()))
    cur.close()
    return f"replaced with {cand['source']} / {cand['license']}"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--allow-nc", action="store_true",
                    help="accept CC-BY-NC photos where nothing freer exists")
    args = ap.parse_args()

    conn = psycopg2.connect(DB_URL, connect_timeout=30)
    conn.autocommit = False
    cur = conn.cursor(cursor_factory=RealDictCursor)

    for db_name, search_names, common, force in TARGETS:
        cur.execute("SELECT * FROM species WHERE scientific_name=%s", (db_name,))
        sp = cur.fetchone()
        if not sp:
            print(f"{db_name:20} NOT FOUND")
            continue

        art = None
        used = None
        for n in search_names:
            art = wiki_full(n)
            if art:
                used = n
                break

        fields, fp = {}, {}
        if art:
            if len(art["intro"]) > len(sp["description"] or ""):
                fields["description"] = art["intro"]
                fp["description"] = prov(art["url"], 0.85, f"English Wikipedia article '{art['title']}'")
            for col, text in map_sections(art["sections"]).items():
                if not sp.get(col):
                    fields[col] = text
                    fp[col] = prov(art["url"], 0.85, f"Wikipedia section, article '{art['title']}'")
        if common and sp["common_name"] != common:
            fields["common_name"] = common
            fp["common_name"] = prov("Karnataka field researcher checklist (2026-08)", 0.95)

        got = ", ".join(sorted(fields)) or "no new text"
        if fields and not args.dry_run:
            sets = ", ".join(f"{k}=%s" for k in fields)
            cur.execute(
                f"UPDATE species SET {sets}, source_urls = CASE WHEN %s::text IS NULL THEN source_urls "
                f"ELSE (COALESCE(source_urls,'[]'::jsonb) || to_jsonb(ARRAY[%s::text])) END, "
                f"field_provenance = field_provenance || %s, updated_at=%s WHERE id=%s",
                (*fields.values(), art["url"] if art else None, art["url"] if art else None,
                 Json(fp), now_iso(), sp["id"]))
            conn.commit()

        photo = replace_photo(conn, sp, search_names, args.allow_nc, args.dry_run)
        if not args.dry_run:
            conn.commit()

        print(f"{db_name:20} wiki={used or 'none':20} fields[{got}]  photo: {photo}")

    cur.close()
    conn.close()


if __name__ == "__main__":
    main()
