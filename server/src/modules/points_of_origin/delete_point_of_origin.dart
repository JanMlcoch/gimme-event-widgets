part of pointsOfOriginModule;

void _bindPointOfOriginDestroyer() {
  libs.route(CONTROLLER_DELETE_POINT_OF_ORIGIN, () => new DeletePointOfOriginRC(),
      method: "POST", template: {"pointOfOriginId": "int"}, permission: Permissions.EDIT_USER);
}

class DeletePointOfOriginRC extends libs.RequestContext {
  User targetUser;
  CustomEntity point;

  Future validate() async {
    entity_filters.CustomFilter pointFilter = new entity_filters.CustomFilter("owner", POINTS_OF_ORIGIN_TABLE_NAME,
        sqlTemplate: "@table.\"id\" = @0",
        validateTemplate: ["int"],
        data: [data["pointOfOriginId"]]);
    ModelList pointsOfOrigin = await connection
        .customs(POINTS_OF_ORIGIN_TABLE_NAME)
        .load(pointFilter.upgrade(), null, fullColumns: true, limit: 1);
    point = pointsOfOrigin.first;
    if (point == null) {
      return envelope.error("PointOfOrigin id=${data["pointOfOriginId"]} not found", PLACE_NOT_FOUND);
    }
    Users targetUsers = await connection.users
        .load(new entity_filters.IdUserFilter(point["userId"]).upgrade(), ["id", "login"], limit: 1);
    targetUser = targetUsers.first;
    if (targetUser == null) {
      return envelope.error("User with id=${point["userId"]} does not exists", USER_NOT_FOUND);
    }
    if (!access.users.any(targetUsers)) {
      return envelope.error("User ${user.login} cannot modify user ${targetUser.login}", USER_CANNOT_EDIT_ANOTHER_USER);
    }
    return null;
  }

  @override
  Future execute() async {
    connection.customs(POINTS_OF_ORIGIN_TABLE_NAME).deleteModel(point.map);

    envelope.withMap({"pointsOfOrigin": await GetPointsOfOriginRC.getPointsOfOrigin(targetUser, connection)});
  }
}
