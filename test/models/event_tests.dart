part of akcnik.tests.models;

void eventTests() {
  model_lib.Event event;
  group("Event", () {
    group("JSON", () {
      test("FromTo", () {
        Map eventJson = {
          "id": 0,
          "name": "Chlastacka",
          "imprintCache": "",
          "serverSettings": {},
          "clientSettings": {},
          "mapLatitude": -96.5662,
          "mapLongitude": 12.25641,
          "insertionTime": DateTime.parse("2015-11-29T10:34:23.000Z").millisecondsSinceEpoch,
          "places": [
            {"eventId": 0, "description": "nadrazi", "placeId": 5}
          ],
          "from": DateTime.parse("2015-11-29T11:53:50.000").millisecondsSinceEpoch,
          "to": DateTime.parse("2015-11-30T14:53:50.000").millisecondsSinceEpoch,
          "organizers": [
            {"eventId": 0, "description": "main org", "orgFlag": 5, "organizerId": 8}
          ],
          "insertedById": 2,
          "tags": [{"id":2, "name": "kolo", "type": 2}],
          "language": "en",
          "description": "Common event",
          "representativePrice": 256.2,
          "costs": [
            {"price": 25, "currency": "CZK", "flag": 2, "description": "common price"}
          ],
          "annotation": "",
          "private": true,
          "webpage": "http://www.gimmeevent.com",
          "socialNetworks":{},
          "profileQuality": 25,
          "parentEventId": 2,
          "guestRate": 2.5,
          "ownerId":652,
          "placeId":25,
          "relevantRating": null
        };
        event = new model_lib.Event();
        event.fromMap(eventJson);
        expect(event.toFullMap(), equals(eventJson));
      });
    });
  });
}
