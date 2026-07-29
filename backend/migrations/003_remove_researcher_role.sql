-- Migration 003: retire the "researcher" role.
-- It was never enforced anywhere in the backend (no endpoint checked for it),
-- so it acted as a cosmetic label only. Any user holding it is moved back to
-- the standard "user" role, then the role row is deleted.
--
-- Idempotent: safe to run when the role is already gone.

BEGIN;

UPDATE users
SET role_id = (SELECT id FROM roles WHERE name = 'user')
WHERE role_id IN (SELECT id FROM roles WHERE name = 'researcher');

DELETE FROM roles WHERE name = 'researcher';

COMMIT;
