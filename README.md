# Pathanga — Butterfly Identification System

**An open-source citizen-science platform for identifying and recording the butterflies of India.**

Photograph a butterfly, get an AI-assisted species identification, and log a geotagged sighting that feeds a shared, moderated biodiversity dataset. The first focus region is **Karnataka and the Western Ghats**, one of the world's biodiversity hotspots.

🌐 Live: [pathanga.com](https://pathanga.com)

---

## Why this exists

Global platforms such as iNaturalist and GBIF are general-purpose, and they are weakest exactly where Indian naturalists need them most. Many Western Ghats butterflies are missing from global backbones or lumped into other species (GBIF resolves *Ypthima tabella* to *Y. philomela*, *Halpe hindu* to *H. homolea*). Regional knowledge is scattered across PDFs, printed field guides and chat groups.

Pathanga provides:

- an **India-focused, provenance-tracked butterfly database**,
- a **mobile app** that makes recording a sighting take seconds, and
- a **moderation workflow** so the resulting data is trustworthy enough for research.

## The species dataset

The catalogue is built by reproducible scripts in [`backend/scripts/`](backend/scripts), not by hand-copying from field guides.

| | |
|---|---|
| Species records | **1,555** (1,444 active) across 6 families and 400+ genera |
| Taxonomy | GBIF backbone, with iNaturalist fallback where GBIF lumps regional taxa |
| Distribution | ~7,800 state-level records (GBIF occurrences) |
| Larval host plants | ~3,700 records (GloBI `hasHost` interactions) |
| Conservation | IUCN Red List category where assessed |
| Images | Openly licensed only (CC0 / CC-BY / CC-BY-SA / public domain), license and photographer stored per image |

**No fabricated data.** Every species row carries a `field_provenance` record. When a value can't be verified from a source, it is stored as `NULL` with the reason recorded, not guessed.

Data sources: [GBIF](https://www.gbif.org), [iNaturalist](https://www.inaturalist.org), [GloBI](https://www.globalbioticinteractions.org), [Wikimedia Commons](https://commons.wikimedia.org), Wikipedia.

## Architecture

```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Flutter app  │  │ Public portal│  │ Admin panel  │  │ Landing site │
│  (mobile/)   │  │  (portal/)   │  │  (admin/)    │  │  (landing/)  │
└──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────────────┘
       └─────────────────┼─────────────────┘
                         │ REST + JWT
                ┌────────▼────────┐
                │  Flask API      │──► Gemini Vision (identification)
                │  (backend/)     │──► Bunny Storage / CDN (images)
                └────────┬────────┘──► Firebase Cloud Messaging (push)
                         │
                ┌────────▼────────┐
                │ PostgreSQL      │
                │ (Supabase)      │
                └─────────────────┘
```

| Folder | What it is | Stack |
|---|---|---|
| [`backend/`](backend) | REST API, AI identification, moderation, reports, data pipeline scripts | Python, Flask, SQLAlchemy, Marshmallow, JWT |
| [`mobile/`](mobile) | Field app: camera capture, identification, sightings, achievements | Flutter, Riverpod, Firebase Messaging |
| [`portal/`](portal) | Public species wiki, articles, sighting feed | Next.js, Tailwind CSS, shadcn/ui |
| [`admin/`](admin) | Moderator dashboard: verify sightings, manage species/users, exports | Next.js, Tailwind CSS, shadcn/ui |
| [`landing/`](landing) | Marketing site | Next.js, Tailwind CSS |

A detailed API reference lives in [`project_analysis.md`](project_analysis.md).

## Getting started

### Prerequisites

- Python 3.11+
- Node.js 20+
- Flutter 3.x
- PostgreSQL 14+ (local, or a free Supabase project)
- A Google Gemini API key (for identification)

### Backend

```bash
cd backend
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env            # then fill in DATABASE_URL, SECRET_KEY, GEMINI_API_KEY, ...
flask db upgrade
flask seed-all                  # roles, geography, starter species, achievements
flask create-admin
flask run
```

Bunny CDN and Firebase keys are optional for local development. Images fall back to the local `uploads/` folder.

Run the tests:

```bash
cd backend
pytest
```

### Web apps (portal, admin, landing)

```bash
cd portal        # or admin / landing
npm install
npm run dev
```

### Mobile app

```bash
cd mobile
flutter pub get
flutter run --dart-define=FLAVOR=dev
```

When testing on a physical Android device against a local backend, `run_adb_reverse.sh` / `.bat` forwards the API port to the device.

## Roadmap

- [ ] Merge duplicate species created by GBIF synonym pairs
- [ ] Cross-check the catalogue against published Indian regional checklists
- [ ] Replace ~370 non-species-specific reference images with real field photos
- [ ] Fill morphology and life-cycle descriptions with cited sources
- [ ] Nectar-plant data from GloBI
- [ ] Evaluation set for the identification model, built from verified sightings
- [ ] Expand beyond Karnataka to other Indian states
- [ ] Publish the curated dataset as an open-data release

## Contributing

Contributions are welcome, from naturalists as well as developers. Species corrections, missing regional species and licensed photographs are just as valuable as code. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Code is released under the [MIT License](LICENSE).

Species images keep their **original licenses** (recorded per image in the database), and third-party data remains subject to the terms of its source (GBIF, iNaturalist, GloBI, Wikimedia Commons).
