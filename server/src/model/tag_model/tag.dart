part of model;

class Tag implements Jsonable {
  int id;
  String _name;
  int type;
  int parentSynonymId;
  String lowerCaseName;

  String get name => _name;

  void set name(String val) {
    _name = val;
    lowerCaseName = val.toLowerCase();
  }

  void fromMap(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    type = json["type"];
    parentSynonymId = json["parentSynonymId"];
  }

  Map<String, dynamic> toSafeMap() => null;

  Map<String, dynamic> toFullMap() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["type"] = type;
    if (parentSynonymId != null) json["parentSynonymId"] = parentSynonymId;
    return json;
  }

  Map toListMap() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    return json;
  }
}
