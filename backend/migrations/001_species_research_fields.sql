-- Migration 001: Extend species + species_images for the full India butterfly
-- research dataset (taxonomy depth, morphology, lifecycle, ecology, conservation,
-- and per-record + per-field data provenance).
--
-- Additive and idempotent (ADD COLUMN IF NOT EXISTS). Existing app code reads
-- `SELECT *` and ignores unknown columns, and inserts only the legacy field set,
-- so this is backward-compatible with the running application.
--
-- Provenance model: scalar research fields live in real, queryable columns.
-- The spec's per-field {source, confidence, verification, last_verified} contract
-- is satisfied by `field_provenance` (JSONB map keyed by column name), plus
-- record-level confidence_score / verification_status / last_verified / data_source.

BEGIN;

-- ── species: taxonomy ───────────────────────────────────────────────────────
ALTER TABLE species ADD COLUMN IF NOT EXISTS subfamily        VARCHAR(100);
ALTER TABLE species ADD COLUMN IF NOT EXISTS tribe            VARCHAR(100);
ALTER TABLE species ADD COLUMN IF NOT EXISTS species_epithet  VARCHAR(100);
ALTER TABLE species ADD COLUMN IF NOT EXISTS subspecies       VARCHAR(100);
ALTER TABLE species ADD COLUMN IF NOT EXISTS authority        VARCHAR(200);   -- describing author
ALTER TABLE species ADD COLUMN IF NOT EXISTS taxon_year       INTEGER;        -- year described
ALTER TABLE species ADD COLUMN IF NOT EXISTS accepted_name    VARCHAR(200);
ALTER TABLE species ADD COLUMN IF NOT EXISTS synonyms         JSONB DEFAULT '[]'::jsonb;
ALTER TABLE species ADD COLUMN IF NOT EXISTS taxonomic_notes  TEXT;

-- ── species: morphology / identification ────────────────────────────────────
ALTER TABLE species ADD COLUMN IF NOT EXISTS identification_notes TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS male_description     TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS female_description   TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS upperside_description TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS underside_description TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS wing_pattern         TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS wing_colour          VARCHAR(200);
ALTER TABLE species ADD COLUMN IF NOT EXISTS body_colour          VARCHAR(200);
ALTER TABLE species ADD COLUMN IF NOT EXISTS body_length_min_mm   INTEGER;
ALTER TABLE species ADD COLUMN IF NOT EXISTS body_length_max_mm   INTEGER;

-- ── species: lifecycle ──────────────────────────────────────────────────────
ALTER TABLE species ADD COLUMN IF NOT EXISTS egg_description   TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS larva_description TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS pupa_description  TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS adult_description TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS life_cycle        TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS flight_period     TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS breeding_season   TEXT;

-- ── species: ecology ────────────────────────────────────────────────────────
ALTER TABLE species ADD COLUMN IF NOT EXISTS nectar_plants   JSONB DEFAULT '[]'::jsonb;
ALTER TABLE species ADD COLUMN IF NOT EXISTS forest_type     VARCHAR(200);
ALTER TABLE species ADD COLUMN IF NOT EXISTS altitude_min_m  INTEGER;
ALTER TABLE species ADD COLUMN IF NOT EXISTS altitude_max_m  INTEGER;
ALTER TABLE species ADD COLUMN IF NOT EXISTS behaviour       TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS migration_notes TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS predators       TEXT;

-- ── species: distribution (beyond the india_states child table) ─────────────
ALTER TABLE species ADD COLUMN IF NOT EXISTS countries       JSONB DEFAULT '[]'::jsonb;
ALTER TABLE species ADD COLUMN IF NOT EXISTS protected_areas JSONB DEFAULT '[]'::jsonb;

-- ── species: conservation ───────────────────────────────────────────────────
ALTER TABLE species ADD COLUMN IF NOT EXISTS iucn_status         VARCHAR(10);
ALTER TABLE species ADD COLUMN IF NOT EXISTS iucn_assessment_url VARCHAR(500);
ALTER TABLE species ADD COLUMN IF NOT EXISTS legal_protection    TEXT;

-- ── species: knowledge / references ─────────────────────────────────────────
ALTER TABLE species ADD COLUMN IF NOT EXISTS interesting_facts TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS research_notes    TEXT;
ALTER TABLE species ADD COLUMN IF NOT EXISTS citations         JSONB DEFAULT '[]'::jsonb;
ALTER TABLE species ADD COLUMN IF NOT EXISTS source_urls       JSONB DEFAULT '[]'::jsonb;

-- ── species: data provenance / quality ──────────────────────────────────────
ALTER TABLE species ADD COLUMN IF NOT EXISTS confidence_score    NUMERIC(3,2);         -- 0.00–1.00 record-level
ALTER TABLE species ADD COLUMN IF NOT EXISTS verification_status VARCHAR(20) DEFAULT 'unverified';
ALTER TABLE species ADD COLUMN IF NOT EXISTS last_verified       TIMESTAMPTZ;
ALTER TABLE species ADD COLUMN IF NOT EXISTS data_source         VARCHAR(100);
ALTER TABLE species ADD COLUMN IF NOT EXISTS field_provenance    JSONB DEFAULT '{}'::jsonb;  -- {column: {source, confidence, verified, last_verified}}

-- ── species_images: rich image metadata + provenance ────────────────────────
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS source              VARCHAR(200);
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS photographer        VARCHAR(300);
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS license             VARCHAR(100);
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS copyright           VARCHAR(300);
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS source_page_url     VARCHAR(500);
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS original_url        VARCHAR(500);
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS storage_path        VARCHAR(500);
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS capture_location    VARCHAR(300);
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS capture_date        DATE;
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS confidence          NUMERIC(3,2);
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS verification_status VARCHAR(20) DEFAULT 'unverified';
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS width               INTEGER;
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS height              INTEGER;
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS file_size_bytes     INTEGER;
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS checksum            VARCHAR(128);
ALTER TABLE species_images ADD COLUMN IF NOT EXISTS mime_type           VARCHAR(50);

COMMIT;
