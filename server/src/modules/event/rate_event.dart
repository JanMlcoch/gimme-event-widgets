part of eventModule;

void _bindEventRator() {
  var editDataTemplate = {"eventId": "int", "?rating": "?int", "?attend": "?boolean"};
  libs.route(CONTROLLER_RATE_EVENT, () => new RateEventRC(), method: "POST", template: editDataTemplate);
}

class RateEventRC extends libs.RequestContext {
  Event event;

  Future validate() async {
    //todo: validate
    return null;
  }

  @override
  Future execute() async {
    Map<String, dynamic> dataMap = {"userId": user.id, "eventId": data["eventId"]};
    if (data.containsKey("attend")) {
      dataMap["expectedVisit"] = data["attend"];
    }
    if (data.containsKey("rating")) {
      dataMap["preRating"] = data["rating"];
    }

    var filter = new CustomFilter("addRatingFromUserToEvent", USER_ABOUT_EVENT_TABLE_NAME,
        sqlTemplate: "@table.\"userId\" = @0 AND @table.\"eventId\" = @1",
        validateTemplate: ["int", "int"],
        data: [user.id, data["eventId"]]);
    CustomList userAboutEventList =
    await connection.customs(USER_ABOUT_EVENT_TABLE_NAME).load(filter.upgrade(), ["id"], limit: 1);



    if (!userAboutEventList.isEmpty) {
      dataMap.addAll({"id": userAboutEventList.first["id"]});
      await connection.customs(USER_ABOUT_EVENT_TABLE_NAME).updateModel(dataMap);
    } else {
      await connection.customs(USER_ABOUT_EVENT_TABLE_NAME).saveModel(dataMap);
    }
    // TODO: proxy to sidos
//    gateway_to_sidos.eventAttended(data["userId"], data["eventId"]);
    envelope.withMap({});
    return null;
  }
}
