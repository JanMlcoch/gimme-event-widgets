part of common;

abstract class PlaceBase implements Jsonable {
  int id = 0;
  double latitude = 0.0;
  double longitude = 0.0;
  String name;
  String description = "";
  bool deprecated = false;
  String city;
  int ownerId;
  int eventId; // arbitrary event which use this place

  Map<String, dynamic> toFullMap() {
    Map<String, dynamic> out = {};
    out["id"] = id;
    out["latitude"] = latitude;
    out["longitude"] = longitude;
    out["name"] = name;
    out["description"] = description;
    out["deprecated"] = deprecated;
    out["city"] = city;
    out["ownerId"] = ownerId;
    if(eventId!=null){
      out["eventId"]=eventId;
    }
    return out;
  }

  void fromMap(Map<String, dynamic> json) {
    if (json["id"] != null) {
      id = json["id"];
    }
    if (json["latitude"] != null) {
      latitude = json["latitude"];
    }
    if (json["longitude"] != null) {
      longitude = json["longitude"];
    }
    name = json["name"];
    description = json["description"];
    deprecated = json["deprecated"];
    city = json["city"];
    ownerId = json["ownerId"];
    eventId= json["eventId"];
  }
}
