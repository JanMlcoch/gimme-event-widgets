part of eventModule;

void _bindGetEditableEvents() {
  libs.route(CONTROLLER_EDITABLE_EVENTS, () => new EditableEventsRC(),
      method: "POST", template: {"?filters": "filters"}, permission: Permissions.EDIT_EVENT);
}

class EditableEventsRC extends libs.RequestContext {
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
    "annotation",
    "ownerId"
  ];
  static const List<String> placeColumns = const ["id", "name", "latitude", "longitude", "city", "description"];
  static const List<String> organizerColumns = const [
    "id",
    "name",
    "address",
    "identificationNumber",
    "organizerType",
    "description",
    "contact"
  ];

  Future<dynamic> execute() async {
    RootFilter filter = constructFilter();
    Events events;
    try {
      events = await connection.events
          .load(filter.concat(access.events), eventColumns, limit: 150);
    } catch (e) {
      return envelope.error("GetEditableEvents: " + e.toString(), COULD_NOT_CONNECT_TO_DATABASE);
    }
    if(events.isEmpty){
      envelope.withMap(
          {"events": [], "places": [], "organizers": []});
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
//      organizers = await connection.organizers.load(access.organizersByIds(organizerIds), organizerColumns);
    } catch (e) {
      envelope.error("GetEditableEvents: " + e.toString(), COULD_NOT_CONNECT_TO_DATABASE);
      return null;
    }
    envelope.withMap(
        {"events": events.toEventDetailList(), "places": places.toFullList(), "organizers": []});
  }
}
