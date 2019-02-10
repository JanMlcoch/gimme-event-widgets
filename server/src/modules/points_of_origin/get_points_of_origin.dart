part of pointsOfOriginModule;

void _bindPointOfOriginProvider() {
  libs.route(CONTROLLER_GET_POINTS_OF_ORIGIN, () => new GetPointsOfOriginRC(),
      method: "POST", template: {"?userId": "int"}, permission: Permissions.SHOW_USER);
}

class GetPointsOfOriginRC extends libs.RequestContext {
  User targetUser;

  Future validate() async {
    if (data.containsKey("userId")) {
      Users targetUsers = await connection.users
          .load(new entity_filters.IdUserFilter(data["userId"]).upgrade(), ["id", "login"], limit: 1);
      if (targetUsers.first == null) {
        return envelope.error("User with id=${data["userId"]} does not exists", USER_NOT_FOUND);
      }
      if (!access.users.any(targetUsers)) {
        return envelope.error(
            "User ${user.login} cannot modify user ${targetUsers.first.login}", USER_CANNOT_EDIT_ANOTHER_USER);
      }
      targetUser = targetUsers.first;
    } else {
      targetUser = user;
    }
    return null;
  }

  @override
  Future execute() async {
    envelope.withMap({"pointsOfOrigin": await getPointsOfOrigin(targetUser, connection)});
  }

  static Future<List> getPointsOfOrigin(User targetUser, storage_lib.Connection connection) async {
    entity_filters.CustomFilter ownFilter = new entity_filters.CustomFilter("own", POINTS_OF_ORIGIN_TABLE_NAME,
        sqlTemplate: "$POINTS_OF_ORIGIN_TABLE_NAME.\"userId\" = ${targetUser.id}");
    ModelList pointsOfOrigin = await connection
        .customs(POINTS_OF_ORIGIN_TABLE_NAME)
        .load(ownFilter.upgrade(), null, fullColumns: true, limit: -1);
    List<Map> pointList = [];
    for (CustomEntity pointOfOrigin in pointsOfOrigin.list) {
      Map pointOfOriginJson = {
        "id": pointOfOrigin["id"],
        "userId": pointOfOrigin["userId"],
        "description": pointOfOrigin["description"],
        "latitude": pointOfOrigin["latitude"],
        "longitude": pointOfOrigin["longitude"]
      };
      pointList.add(pointOfOriginJson);
    }
    return pointList;
  }
}
