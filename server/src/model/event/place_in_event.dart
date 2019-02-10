part of model;

class PlaceInEvent extends PlaceInEventBase {
  Event event;

  Map toFullMap() {
    Map out = super.toSafeMap();
    out["eventId"] = event.id;
    return out;
  }
}
