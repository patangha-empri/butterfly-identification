-- Migration 005: decide, per custom field, whether app users see it.
--
-- Additive and idempotent.
--
-- Migration 004 gave admins a way to invent fields. Those values were already
-- being serialised into the public species payload, so the moment the app
-- rendered custom_fields every field would have become public — including the
-- ones staff invent for internal bookkeeping (review notes, source rankings,
-- "needs a better photo").
--
-- is_public makes that a deliberate choice per field. It defaults to FALSE so
-- every field that already exists stays admin-only until someone opts it in,
-- and so a newly created field can never leak by accident.

BEGIN;

ALTER TABLE species_field_definitions
    ADD COLUMN IF NOT EXISTS is_public BOOLEAN NOT NULL DEFAULT false;

-- The public species endpoints resolve the visible key set on every read, so
-- keep that lookup off a sequential scan.
CREATE INDEX IF NOT EXISTS ix_species_field_definitions_public
    ON species_field_definitions (is_public, is_active);

COMMIT;
