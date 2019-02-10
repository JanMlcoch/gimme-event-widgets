part of common;

abstract class OrganizerBase implements Jsonable {
  int id;
  String name;
  String address;
  String identificationNumber;
  String type;
  String description;
  String contact;
  int ownerId;

  void fromMap(Map json) {
    id = json["id"];
    name = json["name"];
    address = json["address"];
    identificationNumber = json["identificationNumber"];
    type = json["type"];
    description = json["description"];
    contact = json["contact"];
    ownerId = json["ownerId"];
  }

  @override
  Map<String, dynamic> toSafeMap() => null;

  Map<String, dynamic> toFullMap() {
    Map<String, dynamic> out = {};
    out["id"] = id;
    out["name"] = name;
    out["address"] = address;
    out["identificationNumber"] = identificationNumber;
    out["type"] = type;
    out["description"] = description;
    out["contact"] = contact;
    out["ownerId"] = ownerId;
    return out;
  }
}
