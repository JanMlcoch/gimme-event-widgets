part of model;

class Tag {
  int id;
  bool active = false;
  String tagName;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["id"] = id;
    map["tagName"] = tagName;
    return map;
  }

  void fromMap(Map map) {
    id = map["id"];
    tagName = map["name"];
  }
}