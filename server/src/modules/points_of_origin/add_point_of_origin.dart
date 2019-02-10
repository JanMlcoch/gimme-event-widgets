part of pointsOfOriginModule;

void _bindPointOfOriginAddor() {
  var editDataTemplate = {
    "?userId": "int",
    "newPointOfOrigin": {"description": "string", "latitude": "double", "longitude": "double"}
  };
  libs.route(CONTROLLER_ADD_POINT_OF_ORIGIN, () => new AddPointOfOriginRC(),
      method: "POST",
      template: editDataTemplate,
      permission: Permissions.EDIT_USER);
}

class AddPointOfOriginRC extends libs.RequestContext {
  User targetUser;

  Future validate() async {
    Users targetUsers =
    await connection.users.load(
        new entity_filters.IdUserFilter(data["userId"]).upgrade(), ["id", "login"], limit: 1);
    targetUser = targetUsers.first;
    if (targetUser == null) {
      return envelope.error("User with id=${data["userId"]} does not exists", USER_NOT_FOUND);
    }
    if (!access.users.any(targetUsers)) {
      return envelope.error(
          "User ${user.login} cannot modify user ${targetUser.login}", USER_CANNOT_EDIT_ANOTHER_USER);
    }
    return null;
  }

  @override
  Future execute() async {
    Map<String, dynamic> dataMap = {
      "userId": data["userId"],
      "description": data["newPointOfOrigin"]["description"],
      "latitude": data["newPointOfOrigin"]["latitude"],
      "longitude": data["newPointOfOrigin"]["longitude"]
    };
    print("$dataMap");
    connection.customs(POINTS_OF_ORIGIN_TABLE_NAME).saveModel(dataMap);
    envelope.withMap({"pointsOfOrigin": await GetPointsOfOriginRC.getPointsOfOrigin(targetUser, connection)});
  }
}
