part of common;

abstract class UserBase implements Jsonable {
  static const String LOGIN_DUPLICATE = "loginDuplicate";
  static const String EMAIL_DUPLICATE = "emailDuplicate";
  String login;
  String password;
  int id;
  String language = "";
  String firstName = "";
  String surname = "";
  String email = "";
  String imageData = "";
  String residenceTown = "";
  Map permissions;
  Map clientSettings = {"haveImage": false};

  void fromMap(Map<String, dynamic> map) {
    login = map["login"];
    password = map["password"];
    id = map["id"];
    language = map["language"];
    firstName = map["firstName"];
    surname = map["surname"];
    email = map["email"];
    if(map.containsKey("permissions")){
      permissions = map["permissions"];
    }
    if (map["residenceTown"] != null) {
      residenceTown = map["residenceTown"];
    }
    if (map.containsKey("clientSettings") && map["clientSettings"] != null) {
      Map cs = map["clientSettings"];
      clientSettings = cs;
    }
    if (map["imageData"] != null) {
      imageData = map["imageData"];
    }
  }

  Map<String, dynamic> toFullMap() {
    Map<String, dynamic> out = {};
    out["login"] = login;
    out["password"] = password;
    out["id"] = id;
    out["language"] = language;
    out["firstName"] = firstName;
    out["email"] = email;
    out["residenceTown"] = residenceTown;
    out["surname"] = surname;
    out["clientSettings"] = clientSettings;
    out["imageData"] = imageData;
    out["permissions"] = permissions;
    return out;
  }

  Map<String, dynamic> toSafeMap() {
    Map<String, dynamic> out = {};
    out["login"] = login;
    out["id"] = id;
    out["language"] = language;
    out["firstName"] = firstName;
    out["email"] = email;
    out["residenceTown"] = residenceTown;
    out["surname"] = surname;
    out["clientSettings"] = clientSettings;
    out["imageData"] = imageData;
    return out;
  }
}
