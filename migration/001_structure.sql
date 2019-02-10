BEGIN TRANSACTION;
-- DROP SCHEMA public CASCADE;
-- CREATE SCHEMA public;
------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.first_agg(ANYELEMENT, ANYELEMENT)
  RETURNS ANYELEMENT LANGUAGE SQL IMMUTABLE STRICT AS $$
SELECT $1;
$$;

-- And then wrap an aggregate around it
CREATE AGGREGATE public.FIRST( ANYELEMENT ) (
SFUNC = PUBLIC.first_agg,
STYPE = ANYELEMENT
);
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE user_roles
(
  role        VARCHAR,
  permissions JSONB NOT NULL DEFAULT '{}',
  PRIMARY KEY (role)
);
INSERT INTO user_roles VALUES ('unproven', '{
  "show-event": "future",
  "show-user": "own",
  "edit-user": "own",
  "delete-user": "own"
}'),
  ('user', '{
    "create-event": "any",
    "show-event": "future",
    "edit-event": "own",
    "delete-event": "own",
    "comment-event": "any",
    "create-place": "any",
    "edit-place": "none",
    "request-merge-place": "none",
    "merge-place": "none",
    "delete-place": "own-unused",
    "create-organizer": "any",
    "edit-organizer": "own",
    "delete-organizer": "own",
    "edit-permission": "none",
    "create-user": "any",
    "show-user": "own",
    "edit-user": "own",
    "edit-userPermission": "none",
    "delete-user": "own"
  }'),
  ('agent', '{
    "create-event": "any",
    "show-event": "any",
    "edit-event": "any",
    "delete-event": "own",
    "comment-event": "any",
    "create-place": "any",
    "edit-place": "own",
    "request-merge-place": "any",
    "merge-place": "any",
    "delete-place": "any-unused",
    "create-organizer": "any",
    "edit-organizer": "any",
    "delete-organizer": "own",
    "edit-permission": "none",
    "create-user": "any",
    "show-user": "own",
    "edit-user": "own",
    "edit-userPermission": "none",
    "delete-user": "none"
  }'),
  ('admin', '{
    "create-event": "any",
    "show-event": "any",
    "edit-event": "any",
    "delete-event": "any",
    "comment-event": "any",
    "create-place": "any",
    "edit-place": "any",
    "request-merge-place": "none",
    "merge-place": "any",
    "delete-place": "unused",
    "create-organizer": "any",
    "edit-organizer": "any",
    "delete-organizer": "any",
    "edit-permission": "any",
    "create-user": "any",
    "show-user": "any",
    "edit-user": "any",
    "edit-userPermission": "any",
    "delete-user": "any"
  }'),
  ('superadmin', '{
    "create-event": "any",
    "show-event": "any",
    "edit-event": "any",
    "delete-event": "any",
    "comment-event": "any",
    "create-place": "any",
    "edit-place": "any",
    "request-merge-place": "none",
    "merge-place": "any",
    "delete-place": "any",
    "create-organizer": "any",
    "edit-organizer": "any",
    "delete-organizer": "any",
    "edit-permission": "any",
    "create-user": "any",
    "show-user": "any",
    "edit-user": "any",
    "edit-userPermission": "any",
    "delete-user": "any"
  }');

CREATE TABLE users
(
  id                     SERIAL PRIMARY KEY NOT NULL,
  login                  VARCHAR            NOT NULL,
  password               VARCHAR            NOT NULL,
  proven                 BOOL               NOT NULL DEFAULT FALSE,
  role                   VARCHAR            NOT NULL DEFAULT 'unproven',
  "preferenceTagIds"     JSONB              NOT NULL DEFAULT '[]',
  "firstName"            VARCHAR,
  surname                VARCHAR,
  "middleNames"          VARCHAR,
  "birthDate"            DATE,
  "maleGender"           BOOL,
  "residenceLatitude"    DOUBLE PRECISION,
  "residenceLongitude"   DOUBLE PRECISION,
  "residenceTown"        VARCHAR,
  "clientSettings"       JSONB,
  "serverSettings"       JSONB,
  "calendarSettings"     JSONB,
  "notificationSettings" JSONB,
  "imprintCache"         JSONB,
  "profileQuality"       DOUBLE PRECISION   NOT NULL DEFAULT 0.0,
  email                  VARCHAR,
  "authenticationToken"  VARCHAR            NOT NULL DEFAULT concat(md5(random() :: TEXT), md5(random() :: TEXT),
                                                                    md5(random() :: TEXT)),
  "insertionTime"        TIMESTAMPTZ        NOT NULL DEFAULT now(),
  language               VARCHAR            NOT NULL DEFAULT 'en',
  CONSTRAINT "user_role_fkey" FOREIGN KEY ("role") REFERENCES user_roles (role) ON DELETE SET DEFAULT
);
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE cost_types
(
  name       VARCHAR PRIMARY KEY NOT NULL,
  isVIP      BOOL                NOT NULL DEFAULT FALSE,
  minimalAge INT                 NOT NULL DEFAULT 0,
  maximalAge INT                 NOT NULL DEFAULT 200,
  queryBy    BOOL                NOT NULL DEFAULT FALSE
);
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE tag_master_repository
(
  id         SERIAL PRIMARY KEY        NOT NULL,
  repository JSONB,
  inserted   TIMESTAMPTZ               NOT NULL DEFAULT now(),
  settings   JSONB,
  version    INT DEFAULT 0             NOT NULL
);
CREATE TABLE tags
(
  id                SERIAL PRIMARY KEY NOT NULL,
  name              VARCHAR            NOT NULL UNIQUE,
  type              SMALLINT           NOT NULL DEFAULT 2,
  "createdById"     INT,
  flags             JSONB,
  "insertionTime"   TIMESTAMP          NOT NULL DEFAULT now(),
  "parentSynonymId" INT,
  "relations"       JSONB              NOT NULL DEFAULT '[]',
  CONSTRAINT "tags_type_interval" CHECK (type > 0 AND type < 10),
  CONSTRAINT "tags_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT "tags_parentSynonymId_fkey" FOREIGN KEY ("parentSynonymId") REFERENCES tags (id) ON DELETE SET DEFAULT
);
-- CREATE TABLE translated_tags
-- (
--   "masterTagId"   INT         NOT NULL,
--   name            VARCHAR     NOT NULL,
--   language        VARCHAR     NOT NULL DEFAULT 'en',
--   "createdById"   INT,
--   flags           JSONB,
--   "insertionTime" TIMESTAMPTZ NOT NULL DEFAULT now(),
--   PRIMARY KEY ("masterTagId", "language"),
--   CONSTRAINT "translated_tags_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
--   CONSTRAINT "translated_tags_masterTagId_fkey" FOREIGN KEY ("masterTagId") REFERENCES tags (id) ON DELETE CASCADE ON UPDATE CASCADE
-- );
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE places
(
  id              SERIAL PRIMARY KEY NOT NULL,
  latitude        DOUBLE PRECISION   NOT NULL,
  longitude       DOUBLE PRECISION   NOT NULL,
  name            VARCHAR            NOT NULL,
  description     VARCHAR,
  deleted         BOOL               NOT NULL DEFAULT FALSE,
  city            VARCHAR            NOT NULL,
  address         VARCHAR,
  "insertionTime" TIMESTAMPTZ        NOT NULL DEFAULT now(),
  "ownerId"       INT                NOT NULL,
  CONSTRAINT "places_latitude_check" CHECK (latitude BETWEEN -180.1 AND 180.1),
  CONSTRAINT "places_longitude_check" CHECK (longitude BETWEEN -180.1 AND 180.1),
  CONSTRAINT "places_ownerId" FOREIGN KEY ("ownerId") REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE
);
--INSERT INTO places VALUES (1,49.8856713,16.8764397,'Default place','change it immediately',FALSE ,'',NULL,now(),1);
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE events
(
  id                     SERIAL PRIMARY KEY NOT NULL,
  name                   VARCHAR            NOT NULL,
  "from"                 TIMESTAMPTZ        NOT NULL,
  "to"                   TIMESTAMPTZ        NOT NULL,
  "tagIds"               JSONB              NOT NULL DEFAULT '[]',
  language               VARCHAR            NOT NULL DEFAULT 'en',
  description            VARCHAR,
  price                  NUMERIC            NOT NULL DEFAULT 0.0,
  "costs"                JSONB              NOT NULL DEFAULT '{}',
  "placeId"              INT                NOT NULL,
  "mapLatitude"          DOUBLE PRECISION   NOT NULL,
  "mapLongitude"         DOUBLE PRECISION   NOT NULL,
  private                BOOL               NOT NULL DEFAULT FALSE,
  "imprintCache"         JSONB,
  "profileQuality"       INT                NOT NULL DEFAULT 0,
  "clientSettings"       JSONB,
  "serverSettings"       JSONB,
  "insertionTime"        TIMESTAMPTZ        NOT NULL DEFAULT now(),
  "maxParticipants"      INT                NOT NULL DEFAULT 0,
  "expectedParticipants" INT                NOT NULL DEFAULT 0,
  "eventTagId"           INT,
  "parentEventId"        INT,
  webpage                VARCHAR,
  "socialNetworks"       JSONB,
  annotation             VARCHAR            NOT NULL DEFAULT '',
  "ownerId"              INT                NOT NULL,
  CONSTRAINT "events_eventTagId_fkey" FOREIGN KEY ("eventTagId") REFERENCES tags (id),
  CONSTRAINT "events_parentEventId_fkey" FOREIGN KEY ("parentEventId") REFERENCES events (id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT "events_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT "events_mapPlaceId_fkey" FOREIGN KEY ("placeId") REFERENCES places (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE user_about_event
(
  "id"            SERIAL PRIMARY KEY NOT NULL,
  "userId"        INT                NOT NULL,
  "eventId"       INT                NOT NULL,
  "expectedVisit" BOOL               NOT NULL DEFAULT FALSE,
  "preRating"     INT DEFAULT -1     NOT NULL,
  "postRating"    INT DEFAULT -1     NOT NULL,
  "message"       VARCHAR,
  CONSTRAINT "user_about_event_userId_fkey" FOREIGN KEY ("userId") REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "user_about_event_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES events (id) ON DELETE CASCADE ON UPDATE CASCADE
);
------------------------------------------------------------------------------------------------------------------------
CREATE TYPE organizer_types AS ENUM ('natural person', 'legal person', 'association', 'organization');
CREATE TABLE organizers
(
  id                     SERIAL PRIMARY KEY NOT NULL,
  name                   VARCHAR            NOT NULL,
  address                VARCHAR,
  "identificationNumber" VARCHAR,
  "organizerType"        organizer_types    NOT NULL DEFAULT 'natural person',
  description            VARCHAR,
  contact                VARCHAR,
  "ownerId"              INT                NOT NULL,
  CONSTRAINT "organizers_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE organizer_in_event
(
  "organizerId" INT           NOT NULL,
  "eventId"     INT           NOT NULL,
  "orgFlag"     INT DEFAULT 0 NOT NULL,
  "type"        VARCHAR       NOT NULL DEFAULT 'main',
  PRIMARY KEY ("organizerId", "eventId"),
  CONSTRAINT "organizer_in_event_organizerId_fkey" FOREIGN KEY ("organizerId") REFERENCES organizers (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "organizer_in_event_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES events (id) ON DELETE CASCADE ON UPDATE CASCADE
);
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE place_in_event
(
  "placeId"   INT NOT NULL,
  "eventId"   INT NOT NULL,
  description VARCHAR,
  PRIMARY KEY ("placeId", "eventId"),
  CONSTRAINT "place_to_event_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES events (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "place_to_event_placeId_fkey" FOREIGN KEY ("placeId") REFERENCES places (id) ON DELETE CASCADE ON UPDATE CASCADE
);
------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE RULE "places_beforeDelete_preventDeleteUsedPlace_rule" AS ON DELETE TO places
  WHERE EXISTS(SELECT *
               FROM "place_in_event"
               WHERE "placeId" = OLD.id) DO INSTEAD NOTHING;
------------------------------------------------------------------------------------------------------------------------
-------- UPDATE map coordinated for event ---------------
CREATE OR REPLACE FUNCTION "places_afterUpdate_setEventMapPos_func"()
  RETURNS TRIGGER VOLATILE AS $$
BEGIN
  UPDATE events
  SET "mapLongitude" = NEW.longitude,
    "mapLatitude"    = NEW.latitude
  WHERE events."placeId" = NEW.id;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "places_afterUpdate_setEventMapPos_trig"
ON places CASCADE;
CREATE TRIGGER "places_afterUpdate_setEventMapPos_trig" AFTER UPDATE OF latitude, longitude
  ON places FOR EACH ROW
EXECUTE PROCEDURE "places_afterUpdate_setEventMapPos_func"();
-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION "events_beforeInsertUpdate_setEventMapPos_func"()
  RETURNS TRIGGER AS $$
DECLARE
  place places%ROWTYPE;
BEGIN
  SELECT
    id,
    latitude,
    longitude
  FROM places
  WHERE places.id = NEW."placeId"
  INTO place;
  NEW."mapLatitude" := place.latitude;
  NEW."mapLongitude" := place.longitude;
  RETURN NEW;
END;

$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS "events_beforeInsertUpdate_setEventMapPos_trig"
ON events CASCADE;
CREATE TRIGGER "events_beforeInsertUpdate_setEventMapPos_trig" BEFORE INSERT OR UPDATE OF "placeId"
  ON events
FOR EACH ROW EXECUTE PROCEDURE "events_beforeInsertUpdate_setEventMapPos_func"();
------------------------------------------------------------------------------------------------------------------------
-------- UPDATE representative price for event ---------------
CREATE OR REPLACE FUNCTION "events_beforeInsertUpdate_updatePrice_func"()
  RETURNS TRIGGER VOLATILE AS $$
BEGIN
  IF NOT NEW."costs" ? 'default'
  THEN
    NEW.price := 0;
  ELSE
    NEW.price := (NEW."costs" ->> 'default') :: NUMERIC;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS "events_beforeInsertUpdate_updatePrice_trig"
ON events CASCADE;
CREATE TRIGGER "events_beforeInsertUpdate_updatePrice_trig"
BEFORE INSERT OR UPDATE OF "costs"
  ON events FOR EACH ROW
EXECUTE PROCEDURE "events_beforeInsertUpdate_updatePrice_func"();
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE organizer_in_user
(
  "userId"        INT         NOT NULL,
  "organizerId"   INT         NOT NULL,
  role            VARCHAR,
  "insertionTime" TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY ("userId", "organizerId"),
  CONSTRAINT "organizer_in_user_organizerId_fkey" FOREIGN KEY ("organizerId") REFERENCES organizers (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT "organizer_in_user_userId_fkey" FOREIGN KEY ("userId") REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE
);
------------------------------------------------------------------------------------------------------------------------
CREATE TABLE points_of_origin
(
  id          SERIAL PRIMARY KEY                                             NOT NULL,
  "userId"    INTEGER                                                        NOT NULL,
  description VARCHAR,
  latitude    DOUBLE PRECISION                                               NOT NULL,
  longitude   DOUBLE PRECISION                                               NOT NULL,
  importance  DOUBLE PRECISION DEFAULT 1                                     NOT NULL,
  CONSTRAINT "points_of_origin_userId_fkey" FOREIGN KEY ("userId") REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE
);
COMMIT TRANSACTION;