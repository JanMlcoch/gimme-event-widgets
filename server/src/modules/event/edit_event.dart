part of eventModule;

void _bindEventEditor() {
  var editDataTemplate = {
    "id": "int",
    "?places": [
      {"placeId": "int", "mapFlag": "bool", "description": "string"}
    ],
    "?from": "int",
    "?to": "int",
    "?organizers": [
      {"organizerId": "int"}
    ],
    "?imageData": "string",
    "?tags": ["string"],
    "?language": "string",
    "?description": "string",
    "?costs": [
      {"price": "num", "description": "string", "flag": "int", "currency": "string"}
    ],
    "?private": "boolean",
    "?parentEventId": "?int",
  };
  libs.route(CONTROLLER_EDIT_EVENT, () => new EditEventRC(),
      method: "POST", template: editDataTemplate, permission: Permissions.EDIT_EVENT);
}

class EditEventRC extends libs.RequestContext {
  Event event;
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
  static const List<String> allowedColumns = const [
    "name",
    "from",
    "to",
    "placeId",
    "tags",
    "language",
    "description",
    "costs",
    "eventTagId",
    "parentEventId",
    "private",
    "clientSettings",
    "maxParticipants",
    "expectedParticipants",
    "webpage",
    "socialNetworks",
    "annotation"
  ];

  Future validate() async {
    Set<int> ids;
    if(data["id"] is! int)throw new Exception("id must be of type int");
    int id = data["id"];
    event = (await connection.events.load(access.eventsByIds([id]), eventColumns)).first;

    if (event == null) {
      return envelope.error("Event ID=${data["id"]} not found", EVENT_NOT_FOUND);
    }

    int parentEventId = data["parentEventId"];
    if (parentEventId != null) {
      ids = await connection.events.missing([parentEventId], access.events);
      if (ids.length > 0) {
        return envelope.error("Parent event ID=${ids.first} not found", EVENT_NOT_FOUND);
      }
    }
//    Iterable<int> organizerIds = (data["organizers"] as List).map((Map organizer) => organizer["organizerId"]);
//    ids = await connection.organizers.missing(organizerIds, access.organizers);
//    if (ids.length > 0) {
//      return envelope.error("Organizer with ID=[${ids.join(", ")}] not found", ORGANIZER_NOT_FOUND);
//    }
//    Iterable<int> placeIds = (data["places"] as List).map((Map place) => place["placeId"]);
//    ids = await connection.places.missing(placeIds, access.places);
//    if (ids.length > 0) {
//      return envelope.error("Place with ID=[${ids.join(", ")}] not found", PLACE_NOT_FOUND);
//    }
    DateTime startTime = event.from;
    DateTime endTime = event.to;
    if (data["from"] != null) {
      startTime = new DateTime.fromMillisecondsSinceEpoch(data["from"]);
    }
    if (data["to"] != null) {
      endTime = new DateTime.fromMillisecondsSinceEpoch(data["to"]);
    }
    if (startTime.isAfter(endTime)) {
      return envelope.error(
          "Event start time ${startTime.toIso8601String()} is after event end time ${endTime.toIso8601String()}");
    }

    return null;
  }

  @override
  Future execute() async {
    Map<String, dynamic> processedMap = _prepareDataForEvent(data);
    List<String> changedColumns = processedMap.keys.toList();
    processedMap["id"] = data["id"];
    Event modifiedEvent = await connection.events.updateModel(processedMap, changedColumns);
    if (modifiedEvent == null) {
      envelope.error(DATABASE_ERROR);
      return null;
    }
    envelope.withMap(event.toSafeMap());
    return null;
  }

  Map<String, dynamic> _prepareDataForEvent(Map map) {
    Map<String, dynamic> resultMap = {};
    for (String key in map.keys) {
      if (allowedColumns.contains(key) && map[key] != null) {
        resultMap[key] = map[key];
      }
    }
    return resultMap;
  }
}
