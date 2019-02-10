part of eventModule;

void _bindFacebookEvents() {
  libs.route(CONTROLLER_FACEBOOK_EVENTS, () => new FacebookEventsRC(),
      method: "POST", template: {"token": "string", "tokenType": "string"});
  libs.route(CONTROLLER_FACEBOOK_CHECK_EVENTS, () => new FacebookCheckEventsRC(),
      method: "POST",
      template: {
        "facebook_ids": ["int"]
      },
      permission: Permissions.SHOW_EVENT);
}

class FacebookEventsRC extends libs.RequestContext {
  static const eventListColumns = const ["id", "name", "from", "to", "mapLongitude", "mapLatitude", "clientSettings"];

//  Future validate(){
//
//  }

  @override
  Future execute() async {
    Uri uri = new Uri.https("graph.facebook.com", "/v2.7/me/events", {
      "access_token": data["token"] as String,
      "fields": "name,place,start_time,end_time,id,description,attending{id,name}",
      "since": (new DateTime.now().millisecondsSinceEpoch ~/ 1000).toString()
    });
    http.Response response = await http.get(uri);
    Map<String, dynamic> fbJson;
    try {
      fbJson = convert.JSON.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      envelope.error("cannot parse JSON " + response.body, DATA_NOT_VALID_JSON);
      return null;
    }
    List<Map<String, dynamic>> facebookEvents = fbJson["data"] as List<Map<String, dynamic>>;
    List<int> eventIds = [];
    for (Map<String, dynamic> event in facebookEvents) {
      eventIds.add(event["id"]);
    }
    RootFilter filter = new CustomFilter("facebook_ids", "events",
        matcher: (Event event) => eventIds.contains(event.serverSettings["facebook_id"]),
        sqlTemplate: "@table.\"socialNetworks\"->'facebook_id' IN (${eventIds.join(",")}",
        validateTemplate: ["List<int>"],
        data: [eventIds]).upgrade();
    Events foundEvents = await connection.events.load(filter, eventListColumns);

    for (Map<String, dynamic> facebookEvent in facebookEvents) {
      for (Event event in foundEvents.list) {
        if (facebookEvent["id"] == event.serverSettings["facebook_id"]) {
          facebookEvent["gimme_id"] = event.id;
          break;
        }
      }
    }
    envelope.withList(facebookEvents);
  }
}

class FacebookCheckEventsRC extends libs.RequestContext {
  static const eventListColumns = const ["id", "name", "from", "to", "mapLongitude", "mapLatitude", "clientSettings"];
  List<String> eventIds;

  Future validate() {
    eventIds = (data["facebook_ids"] as List<int>).map((int id) => id.toString()).toList();
    return null;
  }

  Future execute() async {
    RootFilter filter = new CustomFilter(
        "facebook_ids",
        "events",
        matcher: (Event event) => eventIds.contains(event.socialNetworks["facebook_id"]),
        sqlTemplate: "@table.\"socialNetworks\"->>'facebook_id' IN ('${eventIds.join("','")}'")
        .upgrade();
    Events foundEvents = await connection.events.load(filter, eventListColumns);
    envelope.withList(foundEvents.toEventDetailList());
  }
}
