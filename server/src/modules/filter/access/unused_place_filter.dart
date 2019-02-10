part of filter_module.access;

class UnusedPlaceFilter extends _AccessFilterBase<Place> {
  DateTime _today;

  UnusedPlaceFilter(dynamic user) : super("unused_places", TABLE_PLACES, user) {
    _today = new DateTime.now();
  }

  @override
  bool match(Place place) {
    int id = place.id;
    List<Event> events = storage.memory.model.events.list;
    for (Event event in events) {
      if (event.placeId == id) {
        place.eventId = event.id;
        if (event.ownerId != userId && event.to.isAfter(_today)) {
//          print("Place $id discarded");
          return false;
        }
      }
      for (PlaceInEvent placeInEvent in event.places) {
        if (placeInEvent.placeId == id) {
          place.eventId = event.id;
          if (placeInEvent.event?.ownerId != userId && placeInEvent.event.to.isAfter(_today)) {
//            print("Place $id discarded by placeInEvent");
            return false;
          }
        }
      }
    }
//    print("Place $id passed");
    return true;
  }

  @override
//  String get sqlConstraint =>
//      '''places."id" IN (select distinct "places".id
//          FROM places LEFT OUTER JOIN events ON places."id" = events."placeId" AND events."ownerId" != $userId
//          WHERE NOT places."deleted"
//          AND (events."to"<NOW() OR events."ownerId" IS NULL OR events IS NULL))''';
  String get sqlConstraint =>
      '(events."to"<NOW() OR events."ownerId" IS NULL OR events IS NULL OR events."ownerId" = $userId)';
}
