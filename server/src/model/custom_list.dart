part of model;

class CustomList extends ModelList<CustomEntity> {
  String type;

  CustomList(this.type);
  @override
  ModelList<CustomEntity> copyType() => new CustomList(type);

  @override
  CustomEntity entityFactory() => new CustomEntity();
}
//###############################################################################
class CustomEntity extends Jsonable {
  final Map<String, dynamic> map = {};

  dynamic operator [](String key) => map[key];

  void operator []=(String key, dynamic value) {
    map[key] = value;
  }

  void fromMap(Map<String, dynamic> json) {
    map.addAll(json);
    if (json["id"] != null) {
      id = json["id"];
    } else {
      id = json.hashCode;
    }
  }

  Map<String, dynamic> toFullMap() {
    return {}..addAll(map);
  }

  @override
  Map<String, dynamic> toSafeMap() => null;
}
