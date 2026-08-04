-- Migration 004: admin-defined custom fields for species.
--
-- Additive and idempotent. IDs are app-generated uuid4 strings (VARCHAR 36),
-- matching the convention used by the rest of the schema.
--
-- Two pieces:
--   species.custom_fields        JSONB map of {field_key: value} per species.
--   species_field_definitions    the shared vocabulary of those keys.
--
-- Why JSONB rather than creating a real column per field: the admin UI lets
-- staff invent fields at will, and running DDL from a web request would need
-- DDL privileges on the app role, stale PostgREST's schema cache until it is
-- reloaded, race when two admins add the same field, and be undoable only by
-- dropping data. A JSONB column plus a definitions table gives the same admin
-- experience with none of that.
--
-- The definitions table is what makes the fields consistent across species —
-- without it every record would grow its own spelling of "wing texture".
-- Retiring a definition (is_active = false) hides it from the picker but never
-- touches values already stored in species.custom_fields.
--
-- field_type values: text | textarea | number | boolean | date | url | list

BEGIN;

ALTER TABLE species ADD COLUMN IF NOT EXISTS custom_fields JSONB DEFAULT '{}'::jsonb;

-- Lets us query "which species define this field" without a full scan.
CREATE INDEX IF NOT EXISTS ix_species_custom_fields
    ON species USING GIN (custom_fields);

CREATE TABLE IF NOT EXISTS species_field_definitions (
    id          VARCHAR(36) PRIMARY KEY,
    field_key   VARCHAR(63)  NOT NULL UNIQUE,   -- snake_case; key inside custom_fields
    label       VARCHAR(200) NOT NULL,          -- what the admin sees
    field_type  VARCHAR(20)  NOT NULL DEFAULT 'text',
    help_text   TEXT,
    group_name  VARCHAR(100) NOT NULL DEFAULT 'Custom fields',
    sort_order  INTEGER      NOT NULL DEFAULT 0,
    is_active   BOOLEAN      NOT NULL DEFAULT true,
    created_by  VARCHAR(36) REFERENCES users(id) ON DELETE SET NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS ix_species_field_definitions_active
    ON species_field_definitions (is_active, sort_order);

COMMIT;
