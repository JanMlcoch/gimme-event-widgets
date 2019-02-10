SELECT
  events."id",
  events."name",
  events."from",
  events."to",
  events."language",
  events."description",
  events."maxParticipants",
  events."expectedParticipants",
  events."guestRateSum",
  events."guestRateCount",
  events."webpage",
  events."socialNetworks",
  array_agg(place_in_event."id")          AS "placesid",
  array_agg(place_in_event."placeId")     AS "placesplaceId",
  array_agg(place_in_event."description") AS "placesdescription"
FROM events
  JOIN place_in_event
    ON (place_in_event."eventId" = events.id /* placeInEventWHEREplaceholder */) /* eventsWHEREplaceholder */
GROUP BY events."id", events."name", events."from", events."to", events."language", events."description",
  events."maxParticipants", events."expectedParticipants", events."guestRateSum", events."guestRateCount",
  events."webpage", events."socialNetworks"
LIMIT 20;

SELECT
  events."id",
  events."name",
  events."from",
  events."to",
  (SELECT json_agg(t) FROM (
     SELECT place_in_event."placeId",
       place_in_event."mapFlag",
       place_in_event.description
     FROM place_in_event) t) AS places
FROM events
/*JOIN place_in_event
  ON (place_in_event."eventId" = events.id /* placeInEventWHEREplaceholder */)*/ /* eventsWHEREplaceholder */
LIMIT 200;