part of userModule;

void _bindEditUser() {
  libs.route(CONTROLLER_EDIT_USER, () => new EditUserRequestContext(),
      method: "POST",
      template: {
        "?name": "string",
        "?surname": "string",
        "?city": "string",
        "?address": "string",
        "?clientSettings": {
          "?facebook_id":"int",
          "?google_id":"int",
          "?haveImage":"bool",
          "?currency":"string",
          "?mailer":{
            "firstDate":"int",
            "frequency":"int",
            "isMonth":"bool",
            "minAmount":"int",
            "maxAmount":"int"
          }
        },
        "id": "int",
        "?language": "string",
        "?tags": ["int"]
      },
      permission: Permissions.EDIT_USER);
}

class EditUserRequestContext extends libs.RequestContext {
  String email;
  static const List<String> allowedColumns = const [
    "language",
    "tags",
    "firstName",
    "surname",
    "residenceTown",
    "clientSettings",
    "currency"
  ];

  @override
  Future validate() {
    email = data["email"];
    if (email != null && !validator.isEmail(email)) {
      envelope.error(INCORRECT_EMAIL);
      return null;
    }
    int userId = data["id"];
    Users allowedUsers = access.users.filter(new Users()..add(new User()..fromMap({"id": userId})));
    if (allowedUsers.length == 0) {
      envelope.error("User ID=${user.id} cannot edit user ID=$userId", USER_CANNOT_EDIT_ANOTHER_USER);
      return null;
    }
    if (data.containsKey("clientSettings")) {
      if (!_clientSettingValidation(data["clientSettings"])) return null;
    }

    return null;
  }

  @override
  Future execute() async {
    Map<String, dynamic> processedMap = _prepareDataForUser(data);
    List<String> changedColumns = processedMap.keys.toList();
    processedMap["id"] = data["id"];
    User modifiedUser = await connection.users.updateModel(processedMap, changedColumns);
    if (modifiedUser == null) {
      envelope.error(DATABASE_ERROR);
      new log.Logger("akcnik.server.context.edit_user").severe("user ${user.login} edit failed");
      return null;
    }
    if (data.containsKey("imageData") &&
        data["imageData"] != null &&
        data["imageData"].startsWith("data:image/png;base64,")) {
      _saveImage(data["id"], data["imageData"]);
    }
    new log.Logger("akcnik.server.context.edit_user").fine("user ${user.login} updated");
    envelope.withMap(user.toSafeMap());
    return null;
  }

  void _saveImage(int id, String body) {
    String prefix = "data:image/png;base64,";
    String bStr = body.substring(prefix.length);
    List<int> bytes = convert.BASE64.decode(bStr); // using CryptoUtils from Dart SDK

    new io.File('web/app/images/user_images/user_avatar_$id.png')
      ..createSync()
      ..writeAsBytesSync(bytes);
  }

//  Define here all user data what can be edited
  Map<String, dynamic> _prepareDataForUser(Map map) {
    Map<String, dynamic> resultMap = {};
    for (String key in map.keys) {
      if (allowedColumns.contains(key) && map[key] != null) {
        resultMap[key] = map[key];
      }
    }
    return resultMap;
  }

  bool _clientSettingValidation(dynamic map) {
    if (map is Map<String, dynamic>) {
      if (map == null) {
        envelope.error("ClientSetting cannot be null", DATA_IMPROPER_STRUCTURE);
        return false;
      }
      if (map["mailer"] != null) {}
      return true;
    }
    return false;
  }
}
