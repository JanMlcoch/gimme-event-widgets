SELECT
  events.name,
  json_build_object('placeName',place.name,'latitude',place.latitude,'longitude',place.longitude) as places
FROM events
  JOIN place_in_event ON (place_in_event."eventId" = events.id)
  JOIN place ON (place.id = place_in_event."placeId")
WHERE events."from" > '2015-08-08';

SELECT
  "id",
  "name",
  "from",
  "to",
  "language",
  "description",
  "maxParticipants",
  "expectedParticipants",
  "guestRateSum",
  "guestRateCount",
  "webpage",
  "socialNetworks",
  (SELECT array_agg(place_in_event.id)
   FROM place_in_event
   WHERE place_in_event."eventId" = events.id) AS "places"
FROM events;

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