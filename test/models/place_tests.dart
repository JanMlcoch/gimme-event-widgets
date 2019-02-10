part of akcnik.tests.models;

void placeTests() {
  group("place", () {
    model_lib.Place place;
    test("fromMap full", () {
      Map<String, dynamic> placeJson = {
        "id": 5,
        "name": "Louka U Louky",
        "description": "velká louka",
        "latitude": 52.5,
        "longitude": 14.6,
        "deprecated": null,
        "city": null,
        "ownerId":25,
      };
      place = new model_lib.Place()..fromMap(placeJson);
      expect(place.toFullMap(), equals(placeJson));
    });
    test("fromMap empty", () {
      place = new model_lib.Place()..fromMap({});
      expect(
          place.toFullMap(),
          equals({
            "longitude": 0.0,
            "latitude": 0.0,
            "name": null,
            "id": 0,
            "deprecated": null,
            "description": null,
            "city": null,
            "ownerId":null
          }));
    });
  });
}
