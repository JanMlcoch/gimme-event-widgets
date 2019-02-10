part of common;

abstract class Jsonable {
  int id;

//  Map<String,dynamic> toMap();
  Map<String, dynamic> toFullMap();

  Map<String, dynamic> toSafeMap();

  void fromMap(Map<String, dynamic> json);
}