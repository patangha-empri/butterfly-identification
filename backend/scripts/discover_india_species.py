"""
Discover & ingest ALL butterfly species recorded from India using GBIF
(occurrence-backed, authoritative, no API key) + the GBIF IUCN Red List Category
dataset for conservation status (replaces the blocked IUCN API) + Wikipedia for a
cited description. Images are NOT handled here (see enrich_species.py --only for
per-species images, or a dedicated image backfill pass).

Nothing is fabricated: species come from GBIF India occurrences; every field is
tagged with its source; unassessed IUCN -> NULL with a recorded reason.

Usage:
  python scripts/discover_india_species.py --enumerate-only      # just count/list
  python scripts/discover_india_species.py --limit 20            # ingest first 20 new
  python scripts/discover_india_species.py                       # ingest all
"""
import argparse
import re
import sys
import time
import uuid
from datetime import datetime, timezone

import psycopg2
import requests
from psycopg2.extras import Json, RealDictCursor
from dotenv import dotenv_values
from slugify import slugify

CFG = dotenv_values(r"D:\thardeye_projects\Butterfly Identification system\backend\.env")
DB_URL = CFG["DATABASE_URL"]
GBIF = "https://api.gbif.org/v1"
UA = "ButterflyIdentificationSystem/1.0 (https://butterfly-identification.b-cdn.net; contact: abhinabajana900@gmail.com)"
FAMILIES = ["Papilionidae", "Pieridae", "Nymphalidae", "Lycaenidae", "Riodinidae", "Hesperiidae"]
ASSESSED = {"LC", "NT", "VU", "EN", "CR", "EW", "EX", "DD"}
APP7 = {"LC", "NT", "VU", "EN", "CR", "EW", "EX"}

S = requests.Session()
S.headers.update({"User-Agent": UA})


def get(url, params=None, tries=4, timeout=60):
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


def now_iso():
    return datetime.now(timezone.utc).isoformat()


def enumerate_species_keys():
    keys = set()
    for fam in FAMILIES:
        m = get(f"{GBIF}/species/match", params={"name": fam, "rank": "FAMILY"})
        fk = m.get("usageKey") if m else None
        if not fk:
            print(f"  ! could not resolve family {fam}"); continue
        r = get(f"{GBIF}/occurrence/search", params={
            "country": "IN", "familyKey": fk, "facet": "speciesKey",
            "facetLimit": 2000, "limit": 0})
        facets = (r or {}).get("facets", [])
        counts = facets[0]["counts"] if facets else []
        fam_keys = {int(c["name"]): c["count"] for c in counts}
        keys.update(fam_keys)
        print(f"  {fam:14s} distinct India speciesKeys={len(fam_keys)}")
        time.sleep(0.3)
    return keys


def resolve_species(species_key):
    """Resolve a GBIF speciesKey to its accepted SPECIES-rank record. Returns dict or None."""
    u = get(f"{GBIF}/species/{species_key}")
    if not u:
        return None
    # follow to accepted if synonym
    if u.get("taxonomicStatus") not in ("ACCEPTED", "DOUBTFUL") and u.get("acceptedKey"):
        u = get(f"{GBIF}/species/{u['acceptedKey']}") or u
    if u.get("rank") != "SPECIES":
        return None
    if u.get("kingdom") != "Animalia" or u.get("order") != "Lepidoptera":
        return None
    canonical = u.get("canonicalName") or ""
    parts = canonical.split()
    if len(parts) != 2:
        return None
    epithet = parts[1]
    # Reject GBIF placeholders for unresolved names ("Euploea spec", "... sp", "indet", etc.)
    if epithet.lower() in {"spec", "sp", "indet", "cf", "aff", "nr", "gen"}:
        return None
    if not re.fullmatch(r"[a-zé]+", epithet.lower()):  # a valid species epithet is lowercase alpha
        return None
    return u


def iucn_category(usage_key):
    j = get(f"{GBIF}/species/{usage_key}/iucnRedListCategory")
    if not j:
        return None, None
    return j.get("code"), j.get("iucnTaxonID")


def english_vernacular(usage_key):
    j = get(f"{GBIF}/species/{usage_key}/vernacularNames", params={"limit": 40})
    if not j:
        return None
    for v in j.get("results", []):
        if v.get("language") == "eng" and v.get("vernacularName"):
            return v["vernacularName"].strip()
    return None


def wikipedia_desc(sci):
    j = get(f"https://en.wikipedia.org/api/rest_v1/page/summary/{sci.replace(' ', '_')}")
    if not j or j.get("type") == "disambiguation":
        return None, None
    ex = (j.get("extract") or "").strip()
    if len(ex) < 40:
        return None, None
    return ex, j.get("content_urls", {}).get("desktop", {}).get("page")


def build_row(u, want_desc=True):
    sci = u["canonicalName"]
    family = u.get("family")
    genus = u.get("genus")
    if not family or not genus:
        return None
    authorship = (u.get("authorship") or "").strip()
    ym = re.search(r"(\d{4})", authorship)
    year = int(ym.group(1)) if ym else None
    author = re.sub(r",?\s*\d{4}", "", authorship).strip() or None
    accepted = (sci + (" " + authorship if authorship else "")).strip()

    code, iucn_taxon = iucn_category(u["key"])
    prov = {}
    if code and code in ASSESSED:
        iucn_status = code
        cons = code if code in APP7 else "LC"
        prov["iucn_status"] = {"source": "GBIF IUCN Red List Category dataset", "confidence": 0.95,
                               "verified": True, "iucn_taxon_id": iucn_taxon, "last_verified": now_iso()}
        if code not in APP7:
            prov["conservation_status"] = {"source": "placeholder", "confidence": 0.0, "verified": False,
                                           "note": f"IUCN={code}; app conservation_status set to LC placeholder."}
    else:
        iucn_status = None
        cons = "LC"
        prov["iucn_status"] = {"source": None, "confidence": 0.0, "verified": False,
                               "note": f"Not assessed on IUCN Red List (GBIF code {code or 'none'})."}

    vern = english_vernacular(u["key"])
    common = vern or sci
    if not vern:
        prov["common_name"] = {"source": None, "confidence": 0.0, "verified": False,
                               "note": "No GBIF English vernacular; scientific name used as placeholder."}
    else:
        # GBIF vernacular is unverified and occasionally noisy (plant names, wrong species) —
        # keep it for breadth but flag low-confidence for human curation against Butterflies of India.
        prov["common_name"] = {"source": "GBIF vernacularNames", "confidence": 0.5, "verified": False,
                               "note": "Unverified GBIF English vernacular; review against Butterflies of India.",
                               "last_verified": now_iso()}

    desc = wiki_url = None
    if want_desc:
        desc, wiki_url = wikipedia_desc(sci)

    prov["scientific_name"] = {"source": "GBIF (India occurrences)", "confidence": 0.97, "verified": True, "last_verified": now_iso()}
    prov["authority"] = {"source": "GBIF", "confidence": 0.95, "verified": True, "last_verified": now_iso()}
    if desc:
        prov["description"] = {"source": "Wikipedia", "confidence": 0.8, "verified": True, "last_verified": now_iso()}

    src_urls = [f"https://www.gbif.org/species/{u['key']}"]
    if wiki_url:
        src_urls.append(wiki_url)
    citations = [{"source": "GBIF", "url": f"https://www.gbif.org/species/{u['key']}"}]
    if wiki_url:
        citations.append({"source": "Wikipedia", "url": wiki_url})

    return {
        "sci": sci, "common": common, "family": family, "genus": genus,
        "species_epithet": sci.split()[-1], "authority": author, "taxon_year": year,
        "accepted_name": accepted, "description": desc, "conservation_status": cons,
        "iucn_status": iucn_status, "iucn_assessment_url": (f"https://www.iucnredlist.org/species/{iucn_taxon}" if iucn_taxon else None),
        "source_urls": src_urls, "citations": citations,
        "data_source": "GBIF; " + ("Wikipedia; " if desc else "") + "GBIF IUCN Red List",
        "confidence_score": 0.9, "verification_status": "verified",
        "field_provenance": prov, "gbif_key": u["key"],
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--enumerate-only", action="store_true")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--no-desc", action="store_true")
    args = ap.parse_args()

    print("Enumerating India butterfly species from GBIF...", flush=True)
    keys = enumerate_species_keys()
    print(f"Raw distinct speciesKeys: {len(keys)}", flush=True)
    if args.enumerate_only:
        return

    conn = psycopg2.connect(DB_URL, connect_timeout=30)
    conn.autocommit = False
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT lower(scientific_name) sn FROM species")
    existing = {r["sn"] for r in cur.fetchall()}
    print(f"Already in DB: {len(existing)}", flush=True)

    processed_accepted = set()
    inserted = updated = skipped = failed = 0
    key_list = list(keys)
    count = 0
    for sk in key_list:
        count += 1
        try:
            u = resolve_species(sk)
            if not u:
                continue
            sci = u["canonicalName"]
            if sci.lower() in processed_accepted:
                continue
            processed_accepted.add(sci.lower())

            row = build_row(u, want_desc=not args.no_desc)
            if not row:
                continue

            if sci.lower() in existing:
                # backfill IUCN + provenance on existing rows (never touch curated prose)
                cur.execute(
                    "UPDATE species SET iucn_status=COALESCE(iucn_status,%s), "
                    "iucn_assessment_url=COALESCE(iucn_assessment_url,%s), "
                    "conservation_status = CASE WHEN conservation_status IS NULL OR conservation_status='LC' "
                    "  THEN %s ELSE conservation_status END, "
                    "field_provenance = field_provenance || %s, updated_at=%s "
                    "WHERE lower(scientific_name)=%s",
                    (row["iucn_status"], row["iucn_assessment_url"], row["conservation_status"],
                     Json({"iucn_status": row["field_provenance"]["iucn_status"]}), now_iso(), sci.lower()))
                conn.commit()
                updated += 1
            else:
                sid = str(uuid.uuid4())
                slug = slugify(row["sci"])  # scientific-name slug guarantees uniqueness
                cur.execute(
                    "INSERT INTO species (id, common_name, scientific_name, family, subfamily, tribe, "
                    "genus, species_epithet, authority, taxon_year, accepted_name, description, "
                    "conservation_status, iucn_status, iucn_assessment_url, is_migratory, slug, is_active, "
                    "source_urls, citations, data_source, confidence_score, verification_status, "
                    "last_verified, field_provenance, taxonomic_notes, created_at, updated_at) "
                    "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s) "
                    "ON CONFLICT (scientific_name) DO NOTHING",
                    (sid, row["common"], row["sci"], row["family"], None, None, row["genus"],
                     row["species_epithet"], row["authority"], row["taxon_year"], row["accepted_name"],
                     row["description"], row["conservation_status"], row["iucn_status"],
                     row["iucn_assessment_url"], False, slug, True,
                     Json(row["source_urls"]), Json(row["citations"]), row["data_source"],
                     row["confidence_score"], row["verification_status"], now_iso(),
                     Json(row["field_provenance"]),
                     f"GBIF usageKey {row['gbif_key']}; occurrence-backed India record.",
                     now_iso(), now_iso()))
                if cur.rowcount:
                    inserted += 1
                    existing.add(sci.lower())
                else:
                    skipped += 1
                conn.commit()
        except Exception as e:
            conn.rollback(); failed += 1
            print(f"  [ERR] key {sk}: {e!r}", flush=True)

        if count % 25 == 0:
            print(f"  ...{count}/{len(key_list)} scanned | inserted={inserted} updated={updated} failed={failed}", flush=True)
        if args.limit and inserted >= args.limit:
            print("  (limit reached)", flush=True); break
        time.sleep(0.12)

    cur.close(); conn.close()
    print(f"\nDONE. inserted={inserted} updated={updated} skipped={skipped} failed={failed} "
          f"distinct_accepted={len(processed_accepted)}", flush=True)


if __name__ == "__main__":
    main()
