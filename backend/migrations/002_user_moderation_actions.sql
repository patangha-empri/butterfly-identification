-- Migration 002: user_moderation_actions — warnings, flags, and other
-- moderation actions taken by staff against users.
--
-- Additive and idempotent. IDs are app-generated uuid4 strings (VARCHAR 36),
-- matching the convention used by the rest of the schema.
--
-- action_type values: warning | flag | suspension | unsuspension | content_removed
--   warning  → user-visible, sends a notification
--   flag     → internal staff marker, silent
-- revoked_at is set when a staff member withdraws the action; "active" actions
-- are rows with revoked_at IS NULL.

BEGIN;

CREATE TABLE IF NOT EXISTS user_moderation_actions (
    id                  VARCHAR(36) PRIMARY KEY,
    user_id             VARCHAR(36) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    admin_id            VARCHAR(36) REFERENCES users(id) ON DELETE SET NULL,
    action_type         VARCHAR(30) NOT NULL,
    reason              TEXT,
    related_entity_type VARCHAR(50),
    related_entity_id   VARCHAR(36),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    revoked_at          TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS ix_user_moderation_actions_user
    ON user_moderation_actions (user_id);
CREATE INDEX IF NOT EXISTS ix_user_moderation_actions_type
    ON user_moderation_actions (action_type);
CREATE INDEX IF NOT EXISTS ix_user_moderation_actions_created
    ON user_moderation_actions (created_at);

COMMIT;
