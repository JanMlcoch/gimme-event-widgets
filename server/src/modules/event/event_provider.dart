part of eventModule;

void _bindEventProviders() {
  libs.route(CONTROLLER_FILTER_EVENTS, () => new FilterEventsRC(),
      method: "POST",
      allowAnonymous: true,
      template: {
        "?sortBy": "string",
        "?desc": "bool",
        "filters": "filters",
        "?localLat": "double",
        "?localLon": "double"
      },
      permission: Permissions.SHOW_EVENT);
  libs.route(CONTROLLER_DETAIL_EVENT, () => new DetailEventRC(),
      method: "POST", template: {"?userId": "int", "id": "int"}, allowAnonymous: true);
}

class DetailEventRC extends libs.RequestContext {
  static const List<String> eventColumns = const [
    "id",
    "name",
    "from",
    "to",
    "placeId",
    "tagIds",
    "language",
    "description",
    "price",
    "costs",
    "mapLongitude",
    "mapLatitude",
    "eventTagId",
    "parentEventId",
    "private",
    "profileQuality",
    "clientSettings",
    "insertionTime",
    "maxParticipants",
    "expectedParticipants",
    "webpage",
    "socialNetworks",
    "annotation"
  ];
  static const List<String> placeColumns = const ["id", "name", "latitude", "longitude", "city", "description"];

  Future<dynamic> execute() async {
    Set<int> eventsIds = new Set.from([data["id"]]);
    Events events;
    try {
      events = await connection.events.load(access.eventsByIds(eventsIds), eventColumns);
    } catch (e) {
      return envelope.error("DetailEvents: " + e.toString(), COULD_NOT_CONNECT_TO_DATABASE);
    }
    if(events.isEmpty){
      return envelope.withMap({"events": [], "places": [], "organizers": []});
    }
    Set<int> placeIds = new Set();
    Set<int> organizerIds = new Set();
    events.list.forEach((Event event) {
      placeIds.add(event.placeId);
      event.places.forEach((PlaceInEvent placeInEvent) {
        placeIds.add(placeInEvent.placeId);
      });
      event.organizers.forEach((OrganizerInEvent organizerInEvent) {
        organizerIds.add(organizerInEvent.organizerId);
      });
    });
    Places places;
//    Organizers organizers;
    try {
      places = await connection.places.load(access.placesByIds(placeIds), placeColumns);
    } catch (e) {
      envelope.error("DetailEvents: " + e.toString(), COULD_NOT_CONNECT_TO_DATABASE);
      return null;
    }
    List<int> eventIds = events.getEventsIdList();
    //todo: some smart message
    List<int> sortedEventIds = user == null
        ? eventIds
        : await gateway_to_sidos.sortEvents(eventIds, user.id,
            message: "sort for ... detaiLEvent ? Really? (Events Ids are $eventIds");
//    List<int> sortedEventIds = eventIds;
    events = events.getSortedAsEventsIdList(sortedEventIds);
//    try {
//      organizers = await connection.organizers.load(access.organizersByIds(organizerIds), PURPOSE_EVENT_FULL);
//    } catch (e) {
//      envelope.error(COULD_NOT_CONNECT_TO_DATABASE);
//      return null;
//    }
//    print("${data["userId"] != null}");
    //todo: use filters to optimize
    CustomList userInEventList =
        await connection.customs(USER_ABOUT_EVENT_TABLE_NAME).load(null, null, fullColumns: true, limit: -1);
    double ratingSum = 0.0;
    int ratingCount = 0;
    for (CustomEntity userInEvent in userInEventList.list) {
//        print("Looking through lieks");
      if (data["userId"] != null && userInEvent["userId"] == data["userId"] && userInEvent["eventId"] == data["id"]) {
        events.list.first.relevantRating = userInEvent["preRating"];
      }
      if(userInEvent["eventId"] == data["id"]){
        ratingCount++;
        ratingSum += userInEvent["preRating"];
      }
    }
    events.list.first.averageRating = ratingSum / ratingCount;

    envelope.withMap({"events": events.toEventDetailList(), "places": places.toFullList(), "organizers": []});
  }
}

class FilterEventsRC extends libs.RequestContext {
  static const eventListColumns = const ["id", "name", "from", "to", "mapLongitude", "mapLatitude", "clientSettings"];

  Map<String, dynamic> out = {};

  Future<dynamic> execute() async {
    RootFilter eventFilter = constructFilter();
    if (eventFilter == null) return null;
    Events events;
    try {
      events = await connection.events.load(eventFilter.concat(access.events), eventListColumns);
    } catch (e) {
      envelope.error("FilterEvents: " + e.toString(), COULD_NOT_CONNECT_TO_DATABASE);
      return null;
    }

    List<int> eventIds = events.getEventsIdList();

//    List<int> sortedEventIds = user == null
//        ? eventIds
//        : await gateway_to_sidos.sortEvents(eventIds, user.id,
//            localLatitude: data["localLat"],
//            localLongitude: data["localLon"],
//            message: "Asking for sort of Events being filtered");
//    List<int> sortedEventIds = eventIds;
    events = events.getSortedAsEventsIdList(eventIds);
    out["events"] = events.toEventListList();
//
//    Set<int> placeIds = new Set();
//    Set<int> organizerIds = new Set();
//    events.list.toList(growable: false).forEach((Event event) {
////      if (event.places.isEmpty) {
////        libs.Logger.log("event without place ${event.id}", user);
////        events.list.remove(event);
////        return;
////      }
//      if (event.placeId != null) {
//        placeIds.add(event.placeId);
//      }
//      event.places.forEach((PlaceInEvent placeInEvent) {
//        placeIds.add(placeInEvent.placeId);
//      });
//      event.organizers.forEach((OrganizerInEvent organizerInEvent) {
//        organizerIds.add(organizerInEvent.organizerId);
//      });
//    });
//    Places places = await (connection.places as PlacePgsqlTable).load(access.placesByIds(placeIds), PURPOSE_EVENT_LIST);
//    out["places"] = places.toFullList();
//    out["organizers"] = [];

    envelope.withMap(out);
    return null;
  }
}
