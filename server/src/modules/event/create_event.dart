part of eventModule;


void _bindEventCreator() {
  var createDataTemplate = {
    "name": "string",
    "places": [
      {"placeId": "int", "!mapFlag": true, "description": "string"}
    ],
    "placeId": "int",
    "from": "int",
    "to": "int",
    "organizers": [
      {"organizerId": "int"}
    ],
    "?imageData": "string",
    "tagIds": ["int"],
    "language": "string",
    "annotation": "string",
    "description": "?string",
    "socialNetworks": "map",
    "costs": [
      {"price": "num", "description": "string", "flag": "int", "currency": "string"}
    ],
    "private": "boolean",
    "parentEventId": "?int",
    "clientSettings": {}
  };
  libs.route(CONTROLLER_CREATE_EVENT, () => new CreateEventRC(),
      method: "POST", template: createDataTemplate, permission: Permissions.CREATE_EVENT);
}

class CreateEventRC extends libs.RequestContext {
  CreateEventRC():super();

  Future validate() async {
    Set<int> ids;
    int parentEventId = data["parentEventId"];
    if (parentEventId != null) {
      ids = await connection.events.missing([parentEventId], access.events);
      if (ids.length > 0) {
        return envelope.error("Parent event ID=${ids.first} not found", EVENT_NOT_FOUND);
      }
    }

    Iterable<int> organizerIds = (data["organizers"] as List).map((Map organizer) => organizer["organizerId"]);

    if (organizerIds.isNotEmpty) {
      ids = await connection.organizers.missing(organizerIds, access.organizers);
      if (ids.length > 0) {
        return envelope.error("Organizers with ID=[${ids.join(", ")}] not found", ORGANIZER_NOT_FOUND);
      }
    }

    List<int> placeIds = (data["places"] as List).map((Map place) => place["placeId"] as int).toList()
      ..add(data["placeId"]);
    ids = await connection.places.missing(placeIds, access.places);
    if (ids.length > 0) {
      return envelope.error("Places with ID=[${ids.join(", ")}] not found", PLACE_NOT_FOUND);
    }
    // todo validate Datetime

    return null;
  }

  @override
  Future execute() async {
    Event event;

    data["insertedById"] = user.id;
    if (data["imageData"] == null || data["imageData"] == "") {
      Map settings = data["clientSettings"];
      settings[EventBase.DONT_HAVE_AVATAR] = true;
      data["clientSettings"] = settings;
    }
    data["ownerId"] = user.id;
    event = await connection.events.saveModel(data);
    if (event != null) {
      if (data["imageData"] != null && data["imageData"] != "") {
        _saveImage(event, data["imageData"]);
      }
      envelope.withMap(event.toEventDetailMap());
      new log.Logger("akcnik.server.context.event").info(
          "event ${convert.JSON.encode(event.toFullMap())} by ${user?.login}");
    } else {
      envelope.error(ERROR_IN_EVENT_CREATION);
    }
    try {
      createEventFile(event);
    } catch (e) {
      print(e);
    }
    return null;
  }
}


