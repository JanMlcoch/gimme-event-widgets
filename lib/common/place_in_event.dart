part of common;

abstract class PlaceInEventBase {
  int id;
  int placeId;
  String description = "";

  void fromMap(Map json) {
    id = json["id"];
    description = json["description"];
    placeId = json["placeId"];
  }

  Map toSafeMap() {
    Map out = {};
    out["placeId"] = placeId;
    out["description"] = description;
    return out;
  }

  Map toFullMap(){
    return toSafeMap()..["id"] = id;
  }

}
