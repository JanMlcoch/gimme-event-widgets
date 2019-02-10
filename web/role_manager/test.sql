BEGIN TRANSACTION;
UPDATE user_roles
SET
  "permissions" = '{"edit-user":"own","show-user":"own","show-event":"any","delete-user":"own","request-merge-place":"own"}'
WHERE "role" = unproven;
SELECT
  user_roles."role",
  user_roles."permissions"
FROM user_roles
WHERE "role" = unproven;
COMMIT TRANSACTION;