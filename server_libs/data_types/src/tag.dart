part of akcnik.common;

abstract class CommonTag {
  int id = -1;

  //String name="Anonym";
  int type = -1;
  int count = 0;
  static const int CORE = 5;
  static const int CONCRETE = 4;
  static const int COMPOSITE = 3;
  static const int COMMON = 2;
  static const int COMPARABLE = 1;

  Map<String, dynamic> toMap();

  bool fromMap(Map<String, dynamic> json);
}
