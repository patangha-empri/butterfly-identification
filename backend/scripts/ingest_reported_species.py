"""
Ingest the species reported missing by the Karnataka field researcher.

Why these needed a separate path: the original catalog was enumerated from the
GBIF backbone, which does not treat most of these names as accepted species —
they resolve to genus-only or are lumped as synonyms of a broader taxon (e.g.
GBIF folds Ypthima tabella into Y. philomela, Halpe hindu into H. homolea).
Regional Indian taxonomy recognises them. So GBIF cannot be the naming authority
here; the researcher's checklist is, and GBIF/iNaturalist/Wikipedia supply
whatever verifiable detail they hold.

Anti-fabrication rules, unchanged from the rest of the pipeline:
  * nothing is invented — unavailable fields are stored NULL with a recorded
    reason in field_provenance
  * images are only ever real, licensed files with attribution; iNaturalist
    photographs are preferred over Wikimedia plates, because a scanned plate
    page shows 50-150 species at once and is useless as a species reference
  * every row records where each value came from

Idempotent: re-running skips species already present.

    backend/venv/Scripts/python.exe scripts/ingest_reported_species.py --dry-run
    backend/venv/Scripts/python.exe scripts/ingest_reported_species.py
    ... --only "Ypthima striata"      one species
    ... --allow-nc                    accept CC-BY-NC photos (labelled as such)
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
from psycopg2.extras import Json, RealDictCursor
from dotenv import dotenv_values
from PIL import Image
from slugify import slugify

sys.path.insert(0, __file__.rsplit("\\", 1)[0])
from enrich_species import to_webp, bunny_put, now_iso  # noqa: E402

CFG = dotenv_values(r"D:\thardeye_projects\Butterfly Identification system\backend\.env")
DB_URL = CFG["DATABASE_URL"]
GBIF = "https://api.gbif.org/v1"
INAT = "https://api.inaturalist.org/v1"
UA = ("ButterflyIdentificationSystem/1.0 "
      "(https://butterfly-identification.b-cdn.net; contact: abhinabajana900@gmail.com)")
S = requests.Session()
S.headers.update({"User-Agent": UA})

SOURCE = "Karnataka field researcher checklist (2026-08)"

# Reported name -> common name, exactly as supplied by the researcher.
REPORTED = [
    ("Graphium teredon", "Narrow-banded Bluebottle"),
    ("Charaxes bharata", "Indian Nawab"),
    ("Athyma inara", "Colour Sergeant"),
    ("Cethosia mahratta", "Sahyadri Lacewing"),
    ("Tarucus indica", "Transparent Pierrot"),
    ("Acytolepis lilacea", "Lilac Hedge Blue"),
    ("Cephrenes acalle", "Variable Plain Palm Dart"),
    ("Hyarotis coorga", "Kodagu Brush Flitter"),
    ("Halpe hindu", "Sahyadri Banded Ace"),
    ("Halpemorpha hyrtacus", "White-branded Ace"),
    ("Celaenorrhinus fusca", "Dusky Spotted Flat"),
    ("Horaga viola", "Brown Onyx"),
    ("Cigaritis schistacea", "Plumbeous Silverline"),
    ("Cigaritis abnormis", "Abnormal Silverline"),
    ("Bindahara moorei", "Blue-bordered Plane"),
    ("Ypthima tabella", "Baby Five Ring"),
    ("Mycalesis orcha", "Pale-brand Bushbrown"),
    ("Ypthima striata", "Striated Five-ring"),
    ("Ypthima singala", "Sinhalese Five-ring"),
]

# Already in the database under a different name — no new row, but the reported
# name is recorded as a synonym so a search for it succeeds.
ALREADY_PRESENT = [
    ("Charaxes psaphon", "Charaxes psaphon", "Plain Tawny Rajah"),
    ("Eurema andersonii", "Eurema andersoni", "One-spot Grass Yellow"),
    ("Virachola perse", "Deudorix perse", "Large Guava Blue"),
    ("Chilades pandava", "Luthrodes pandava", "Plains Cupid"),
    ("Coladenia indrani", "Cogia indrani", "Tricolour Pied Flat"),
]

PLATE_PAT = re.compile(
    r"seitz|macrolepidoptera|\bplate[\s_]*\d|\btaf\.?\s*\d|tafel|planche|lithograph|"
    r"illustrations?_of_|catalogue|\b1[6-9]\d{2}\b", re.I)
FREE = {"cc0", "cc-by", "cc-by-sa"}
NC = {"cc-by-nc", "cc-by-nc-sa"}
LIC_LABEL = {"cc0": "CC0", "cc-by": "CC BY", "cc-by-sa": "CC BY-SA",
             "cc-by-nc": "CC BY-NC", "cc-by-nc-sa": "CC BY-NC-SA"}


def get(url, params=None, tries=4, timeout=45):
    for i in range(tries):
        try:
            r = S.get(url, params=params, timeout=timeout)
        except requests.RequestException:
            time.sleep(1.5 * (i + 1)); continue
        if r.status_code == 200:
            return r
        if r.status_code in (429, 503):
            time.sleep(2 * (i + 1)); continue
        return None
    return None


def js(url, params=None):
    r = get(url, params)
    try:
        return r.json() if r else None
    except ValueError:
        return None


def prov(source, conf, note=None):
    d = {"source": source, "confidence": conf, "verified": conf >= 0.9, "last_verified": now_iso()}
    if note:
        d["note"] = note
    return d


def null_prov(note):
    return {"source": None, "confidence": 0.0, "verified": False, "note": note,
            "last_verified": now_iso()}


def clip(s, n):
    s = (s or "").strip()
    return s[:n - 1] + "…" if len(s) > n else s


# ── taxonomy ──────────────────────────────────────────────────────────────────
def clean_authority(raw):
    """GBIF authorship sometimes carries scraped page text after the citation."""
    a = (raw or "").strip()
    if not a:
        return None
    m = re.match(r"^\(?[^()]*?(1[6-9]\d{2}|20\d{2})\)?", a)
    if m:
        a = m.group(0)
        if a.count("(") > a.count(")"):
            a += ")"
    return clip(a, 200) or None


def gbif_name_record(name):
    """Any GBIF usage for this exact binomial — even a synonym carries authorship."""
    j = js(f"{GBIF}/species/search", params={"q": name, "rank": "SPECIES", "limit": 20})
    for r in (j or {}).get("results", []):
        if (r.get("canonicalName") or "").lower() == name.lower():
            return r
    return None


def inat_taxon(name):
    j = js(f"{INAT}/taxa", params={"q": name, "rank": "species", "per_page": 5})
    for t in (j or {}).get("results", []):
        if (t.get("name") or "").lower() == name.lower():
            # the search result carries ancestor ids but not the ancestor records;
            # the detail endpoint is what actually names the family
            d = js(f"{INAT}/taxa/{t['id']}")
            return ((d or {}).get("results") or [t])[0]
    return None


def resolve_taxonomy(name):
    """family/genus/authority/year from whichever source actually holds them."""
    genus = name.split()[0]
    out = {"family": None, "genus": genus, "species_epithet": name.split()[1],
           "authority": None, "taxon_year": None, "sources": {}}

    rec = gbif_name_record(name)
    if rec:
        out["family"] = rec.get("family")
        out["authority"] = clean_authority(rec.get("authorship"))
        out["sources"]["gbif_usage"] = rec.get("key")
        m = re.search(r"(1[6-9]\d{2}|20\d{2})", out["authority"] or "")
        if m:
            out["taxon_year"] = int(m.group(1))

    if not out["family"]:
        t = inat_taxon(name)
        if t:
            for a in t.get("ancestors", []) or []:
                if a.get("rank") == "family":
                    out["family"] = a.get("name")
            out["sources"]["inat_taxon"] = t.get("id")

    if not out["family"]:
        # last resort: the genus is enough to place the family
        j = js(f"{GBIF}/species/match", params={"name": genus, "rank": "GENUS"})
        if j and j.get("family"):
            out["family"] = j["family"]
            out["sources"]["gbif_genus"] = j.get("usageKey")
    return out


def wikipedia(name):
    r = get("https://en.wikipedia.org/api/rest_v1/page/summary/" + name.replace(" ", "_"))
    if not r:
        return None
    j = r.json()
    if j.get("type") == "disambiguation":
        return None
    # Guard against a redirect to the genus or another species: the page must be
    # about this binomial.
    title = (j.get("title") or "").lower()
    if title != name.lower() and name.split()[1].lower() not in title:
        return None
    ex = (j.get("extract") or "").strip()
    if len(ex) < 40:
        return None
    return {"extract": ex, "url": j.get("content_urls", {}).get("desktop", {}).get("page")}


# ── images ────────────────────────────────────────────────────────────────────
def same_taxon(a, b):
    """Tolerate the -i/-ii ending split (Eurema andersoni vs andersonii) and case."""
    def norm(s):
        s = (s or "").strip().lower()
        return re.sub(r"i+$", "i", s)
    return norm(a) == norm(b)


def inat_photo(name, accepted):
    for qg in ("research", None):
        params = {"taxon_name": name, "photo_license": ",".join(sorted(accepted)),
                  "per_page": 10, "order_by": "votes", "order": "desc", "locale": "en"}
        if qg:
            params["quality_grade"] = qg
        j = js(f"{INAT}/observations", params=params)
        for obs in (j or {}).get("results", []):
            # only trust an observation actually identified to this species
            tx = (obs.get("taxon") or {}).get("name", "")
            if not same_taxon(tx, name):
                continue
            for ph in obs.get("photos", []):
                lic = (ph.get("license_code") or "").lower()
                if lic not in accepted or not ph.get("url"):
                    continue
                user = obs.get("user") or {}
                return {
                    "url": re.sub(r"/(square|small|medium)\.", "/large.", ph["url"]),
                    "license": LIC_LABEL.get(lic, lic.upper()),
                    "photographer": user.get("name") or user.get("login") or "iNaturalist user",
                    "page": obs.get("uri") or f"https://www.inaturalist.org/observations/{obs.get('id')}",
                    "source": "iNaturalist",
                }
    return None


def commons_photo(name):
    r = get("https://commons.wikimedia.org/w/api.php", params={
        "action": "query", "generator": "search",
        "gsrsearch": f"filetype:bitmap {name}", "gsrnamespace": "6", "gsrlimit": "12",
        "prop": "imageinfo", "iiprop": "url|size|mime|extmetadata", "format": "json"})
    if not r:
        return None
    best = None
    for p in ((r.json().get("query") or {}).get("pages") or {}).values():
        info = (p.get("imageinfo") or [{}])[0]
        if not info or info.get("mime") not in ("image/jpeg", "image/png"):
            continue
        title = p.get("title", "")
        if PLATE_PAT.search(title):
            continue  # the whole point of this pass is to not repeat the plate mistake
        ext = info.get("extmetadata", {}) or {}
        lic = (ext.get("LicenseShortName", {}).get("value", "") or "").strip()
        if not any(t in lic.lower() for t in ("cc0", "cc by", "cc-by", "public domain", "pd")):
            continue
        if info.get("width", 0) < 500:
            continue
        artist = re.sub(r"<[^>]+>", "", ext.get("Artist", {}).get("value", "")).strip() or "Unknown"
        cand = {"url": info["url"], "license": lic, "photographer": artist,
                "page": info.get("descriptionurl") or title, "source": "Wikimedia Commons"}
        if best is None:
            best = cand
    return best


def build_image(name, family, cand):
    r = get(cand["url"], tries=2)
    if not r or not r.content:
        return None
    try:
        im = Image.open(io.BytesIO(r.content)).convert("RGB")
    except Exception:
        return None
    main_bytes, dims = to_webp(im, 1600)
    thumb_bytes, _ = to_webp(im, 400)
    gs = slugify(name).replace("-", "_")
    base = f"species/{(family or 'unknown').lower()}/{gs}"
    main_path, thumb_path = f"{base}/adult_reference.webp", f"{base}/thumbs/adult_reference.webp"
    return {
        "image_url": bunny_put(main_bytes, main_path),
        "thumbnail_url": bunny_put(thumb_bytes, thumb_path),
        "storage_path": main_path, "width": dims[0], "height": dims[1],
        "file_size_bytes": len(main_bytes), "mime_type": "image/webp",
        "checksum": hashlib.sha256(main_bytes).hexdigest(),
        "original_url": clip(cand["url"], 500), "source_page_url": clip(cand["page"], 500),
        "license": clip(cand["license"], 100), "photographer": clip(cand["photographer"], 300),
        "source": clip(cand["source"], 200),
    }


# ── ingest ────────────────────────────────────────────────────────────────────
def ingest_one(conn, name, common, accepted, dry):
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT id FROM species WHERE lower(scientific_name)=lower(%s)", (name,))
    if cur.fetchone():
        return "exists", None

    tax = resolve_taxonomy(name)
    wiki = wikipedia(name)
    cand = inat_photo(name, accepted) or commons_photo(name)

    fp = {
        "scientific_name": prov(SOURCE, 0.95, "Reported by field researcher; regional Indian taxonomy"),
        "common_name": prov(SOURCE, 0.95),
        "family": prov("GBIF/iNaturalist taxonomy", 0.95) if tax["family"] else null_prov("family not resolvable"),
        "authority": prov("GBIF name record", 0.9) if tax["authority"] else null_prov(
            "no authorship found in GBIF for this binomial"),
        "description": prov(wiki["url"], 0.85) if wiki else null_prov(
            "no English Wikipedia article for this binomial"),
    }
    for f in ("morphology", "lifecycle", "distribution", "host_plants"):
        fp[f] = null_prov("not sourced in this pass — no verifiable source consulted")
    # conservation_status is NOT NULL in the app schema; every other row carries the
    # same 'LC' placeholder. Recorded as a placeholder, not as an assessment.
    fp["conservation_status"] = {
        "source": "placeholder", "confidence": 0.0, "verified": False,
        "note": "Not IUCN-assessed. 'LC' written only to satisfy the NOT NULL app column.",
        "last_verified": now_iso()}
    fp["iucn_status"] = null_prov("no IUCN assessment found for this taxon")

    notes = ("Added from the Karnataka field-researcher checklist. Not an accepted species in the "
             "GBIF backbone at ingestion time (GBIF returns genus-level or lumps it as a synonym), "
             "which is why the original GBIF-driven import missed it.")

    if dry:
        cur.close()
        return "dry", {"family": tax["family"], "authority": tax["authority"],
                       "desc": bool(wiki), "image": (cand or {}).get("source")}

    sid = str(uuid.uuid4())
    cur.execute(
        "INSERT INTO species (id, common_name, scientific_name, family, genus, species_epithet, "
        "authority, taxon_year, accepted_name, description, conservation_status, is_migratory, "
        "slug, is_active, source_urls, data_source, confidence_score, verification_status, "
        "last_verified, field_provenance, taxonomic_notes, created_at, updated_at) "
        "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s) "
        "ON CONFLICT (scientific_name) DO NOTHING",
        (sid, common, name, tax["family"], tax["genus"], tax["species_epithet"],
         tax["authority"], tax["taxon_year"], name,
         wiki["extract"] if wiki else None, "LC", False, slugify(name), True,
         Json([u for u in [wiki["url"] if wiki else None] if u]),
         SOURCE, 0.85, "partial" if not wiki else "verified", now_iso(),
         Json(fp), notes, now_iso(), now_iso()))
    if not cur.rowcount:
        conn.rollback(); cur.close()
        return "conflict", None

    img_status = "none"
    if cand:
        try:
            img = build_image(name, tax["family"], cand)
        except Exception as e:
            img = None
            print(f"      image error: {e!r}")
        if img:
            cur.execute(
                "INSERT INTO species_images (id, species_id, image_url, thumbnail_url, image_type, "
                "is_primary, credit, source, photographer, license, source_page_url, original_url, "
                "storage_path, width, height, file_size_bytes, checksum, mime_type, "
                "verification_status, created_at) "
                "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",
                (str(uuid.uuid4()), sid, img["image_url"], img["thumbnail_url"], "reference",
                 True, clip(f"{img['photographer']} ({img['license']})", 300), img["source"],
                 img["photographer"], img["license"], img["source_page_url"], img["original_url"],
                 img["storage_path"], img["width"], img["height"], img["file_size_bytes"],
                 img["checksum"], img["mime_type"], "verified", now_iso()))
            img_status = f"{img['source']} / {img['license']}"
    conn.commit()
    cur.close()
    return "inserted", {"family": tax["family"], "authority": tax["authority"],
                        "desc": bool(wiki), "image": img_status}


def add_synonyms(conn, dry):
    """Record the researcher's names on the rows that already hold those species."""
    cur = conn.cursor(cursor_factory=RealDictCursor)
    done = []
    for reported, in_db, common in ALREADY_PRESENT:
        cur.execute("SELECT id, synonyms FROM species WHERE lower(scientific_name)=lower(%s)", (in_db,))
        row = cur.fetchone()
        if not row:
            done.append((reported, in_db, "target row not found")); continue
        syns = row["synonyms"] or []
        names = {(s if isinstance(s, str) else s.get("name", "")).lower() for s in syns}
        if reported.lower() in names:
            done.append((reported, in_db, "already recorded")); continue
        if dry:
            done.append((reported, in_db, "would add")); continue
        syns.append(reported)
        cur.execute(
            "UPDATE species SET synonyms=%s, field_provenance = field_provenance || %s, updated_at=%s "
            "WHERE id=%s",
            (Json(syns), Json({"synonyms": prov(SOURCE, 0.95, f"'{reported}' reported in use for this species")}),
             now_iso(), row["id"]))
        conn.commit()
        done.append((reported, in_db, "added"))
    cur.close()
    return done


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--only")
    ap.add_argument("--allow-nc", action="store_true",
                    help="also accept CC-BY-NC photos (recorded with the licence)")
    args = ap.parse_args()

    accepted = FREE | NC if args.allow_nc else set(FREE)
    todo = [(n, c) for n, c in REPORTED if not args.only or n.lower() == args.only.lower()]

    conn = psycopg2.connect(DB_URL, connect_timeout=30)
    conn.autocommit = False

    print(f"{'species':26} {'result':10} {'family':14} {'desc':5} image")
    counts = {}
    for name, common in todo:
        try:
            status, info = ingest_one(conn, name, common, accepted, args.dry_run)
        except Exception as e:
            conn.rollback()
            status, info = "ERROR", None
            print(f"  {name}: {e!r}")
        counts[status] = counts.get(status, 0) + 1
        i = info or {}
        print(f"{name:26} {status:10} {str(i.get('family')):14} "
              f"{'Y' if i.get('desc') else '-':5} {i.get('image') or '-'}")
        time.sleep(0.3)

    print("\nsynonyms on existing rows:")
    for reported, in_db, what in add_synonyms(conn, args.dry_run):
        print(f"  {reported:24} -> {in_db:24} {what}")

    conn.close()
    print("\n" + "  ".join(f"{k}={v}" for k, v in sorted(counts.items())))


if __name__ == "__main__":
    main()
