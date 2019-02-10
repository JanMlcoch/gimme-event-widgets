part of model;

class OrganizerInEvent extends OrganizerInEventBase {
  Event event;

  Map toFullMap() {
    Map out = super.toSafeMap();
    out["eventId"] = event.id;
    out["organizerId"] = organizerId;
    return out;
  }

  @override
  void fromMap(Map json) {
    super.fromMap(json);
    organizerId = json["organizerId"];
  }
}
