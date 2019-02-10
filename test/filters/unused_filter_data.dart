part of akcnik.tests.filter.unused_filter;

List<Map<String, dynamic>> eventsJson = [
  {"id": 1, "to": new DateTime.now().subtract(new Duration(days: 2)), "ownerId": 1, "placeId": 1},
  {"id": 2, "to": new DateTime.now().subtract(new Duration(days: 2)), "ownerId": 5, "placeId": 2},
  {"id": 3, "to": new DateTime.now().add(new Duration(days: 2)), "ownerId": 1, "placeId": 3},
  {"id": 4, "to": new DateTime.now().add(new Duration(days: 2)), "ownerId": 5, "placeId": 4},
  {
    "id": 5,
    "to": new DateTime.now().add(new Duration(days: 2)),
    "ownerId": 1,
    "placeId": 100,
    "places": [
      {"placeId": 5},
      {"placeId": 6},
      {"placeId": 7}
    ]
  },
  {
    "id": 6,
    "to": new DateTime.now().add(new Duration(days: 2)),
    "ownerId": 5,
    "placeId": 100,
    "places": [
      {"placeId": 8},
      {"placeId": 9},
      {"placeId": 10}
    ]
  },
  {
    "id": 1,
    "to": new DateTime.now().subtract(new Duration(days: 2)),
    "ownerId": 1,
    "placeId": 100,
    "places": [
      {"placeId": 11},
      {"placeId": 12}
    ]
  },
  {
    "id": 2,
    "to": new DateTime.now().subtract(new Duration(days: 2)),
    "ownerId": 5,
    "placeId": 100,
    "places": [
      {"placeId": 13},
      {"placeId": 14}
    ]
  }
];
List<Map<String, dynamic>> placesJson = [
  {"id": 1},
  {"id": 2},
  {"id": 3},
  {"id": 4},
  {"id": 5},
  {"id": 6},
  {"id": 7},
  {"id": 8},
  {"id": 9},
  {"id": 10},
  {"id": 11},
  {"id": 12},
  {"id": 13},
  {"id": 14},
  {"id": 100},
  {"id": 101}
];
List<Map<String, dynamic>> usersJson = [
  {"id": 1},
  {"id": 5}
];
