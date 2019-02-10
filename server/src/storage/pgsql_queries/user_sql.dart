part of storage.pgsql.query;

class UserSqlCompiler extends IdKeyCompiler {
  static const String _table = "users";
  static const List<String> fullColumns = const [
    "id",
    "login",
    "proven",
    "role",
    "permissions",
    "password",
    "preferenceTagIds",
    "firstName",
    "surname",
    "middleNames",
    "birthDate",
    "maleGender",
    "residenceLatitude",
    "residenceLongitude",
    "residenceTown",
    "clientSettings",
    "serverSettings",
    "calendarSettings",
    "notificationSettings",
    "imprintCache",
    "profileQuality",
    "email",
    "authenticationToken",
    "insertionTime",
    "language"
  ];
  static const List<String> insertColumns = const [
    "login",
    "password",
    "proven",
    "role",
    "preferenceTagIds",
    "firstName",
    "surname",
    "middleNames",
    "birthDate",
    "maleGender",
    "residenceLatitude",
    "residenceLongitude",
    "residenceTown",
    "clientSettings",
    "serverSettings",
    "calendarSettings",
    "notificationSettings",
    "email",
    "language"
  ];
  static const List<String> updateDetailColumns = const [
    "password",
    "preferenceTags",
    "firstName",
    "surname",
    "middleNames",
    "birthDate",
    "maleGender",
    "residenceLatitude",
    "residenceLongitude",
    "residenceTown",
    "clientSettings",
    "serverSettings",
    "calendarSettings",
    "notificationSettings",
    "email",
    "language"
  ];
  static const List<String> updateSupportColumns = const ["proven", "profileQuality", "authentificationToken"];
  //############################################################################
  UserSqlCompiler() : super(_table, insertColumns, fullColumns);

  //############################################################################

  String _replaceSpecialColumns(String query, Iterable<String> columns) {
    if (columns.contains("permissions")) {
      String columnName = "permissions";
      query = query
          .replaceFirst("$_table.\"$columnName\"", "user_roles.\"$columnName\"")
          .replaceFirst("FROM $_table", "FROM $_table JOIN user_roles ON $_table.role = user_roles.role");
    }
    return query;
  }

  String getLoginOrEmailConstraint(String login) {
    String safeLogin = safeConvert(login);
    return "WHERE (login=$safeLogin OR email=$safeLogin)";
  }
}
