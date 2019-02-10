DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE migrations (
  "version" VARCHAR(6)
);
INSERT INTO migrations VALUES (NULL);