part of common;

abstract class OrganizerInEventBase {
  int id;
  int organizerId;
  int eventId;
  String description;
  int orgFlag;

  void fromMap(Map map) {
    organizerId = map["organizerId"];
    description = map["description"];
    eventId = map["eventId"];
    orgFlag = map["orgFlag"];
  }

  Map toFullMap() {
    return toSafeMap()..["id"] = id;
  }

  Map toSafeMap() {
    return {"organizerId": organizerId, "description": description, "eventId": eventId, "orgFlag": orgFlag};
  }
}
