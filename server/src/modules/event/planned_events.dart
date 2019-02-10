part of eventModule;

void _bindPlannedEvents() {
  libs.route(CONTROLLER_PLANNED_EVENT, () => new PlannedEventsRC(), method: "POST");
}

class PlannedEventsRC extends libs.RequestContext {
  Event event;

  Future validate() async {
    //todo: validate
    return null;
  }

  @override
  Future execute() async {
    /* non-validated filter - no data from request are loaded */
    var filter = new CustomFilter("plannedEvents", USER_ABOUT_EVENT_TABLE_NAME,
        sqlTemplate: "@table.\"userId\" = ${user.id} AND @table.\"expectedVisit\" = TRUE");
    CustomList userAboutEventList =
    await connection.customs(USER_ABOUT_EVENT_TABLE_NAME).load(filter.upgrade(), ["eventId"]);

    var ids = [];
    for (var map in userAboutEventList.list) {
      ids.add(map["eventId"]);
    }
    var rootFilter = new IdListEventFilter([ids]).upgrade();
    Events events = await connection.events.load(rootFilter, null, fullColumns: true);
    envelope.withMap({"events": events.toEventDetailList()});
    return null;
  }
}
