part of storage.pgsql.query;

class CustomSqlCompiler extends IdKeyCompiler {
  final String _table;
  //todo: shouldn't here be also column list for [USER_ROLES_TABLE_NAME]
  static const Map<String, List<String>> fullColumnsMap = const {
    TAGS_TABLE_NAME: const ["id", "name", "type", "relations"],
    USER_ABOUT_EVENT_TABLE_NAME: const ["id", "userId", "eventId", "expectedVisit", "preRating", "postRating", "message"],
    POINTS_OF_ORIGIN_TABLE_NAME: const ["id", "userId", "description", "latitude", "longitude", "importance"]
  };
  static const Map<String, List<String>> insertColumnsMap = const {
    TAGS_TABLE_NAME: const ["name", "type", "relas"],
    USER_ABOUT_EVENT_TABLE_NAME: const ["userId", "eventId", "expectedVisit", "preRating", "postRating", "message"],
    POINTS_OF_ORIGIN_TABLE_NAME: const ["userId", "description", "latitude", "longitude", "importance"]
  };

  CustomSqlCompiler(String table)
      : _table = table,
        super(table, insertColumnsMap[table], fullColumnsMap[table]);

  @override
  String _replaceSpecialColumns(String query, Iterable<String> columns) {
//    if (columns.contains("places")) {
//      String columnName = "places";
//      List<String> placeInEventColumns = PlaceInEventSqlCompiler.fullColumns;
//      query.replaceFirst(
//          "$_table.\"$columnName\"",
//          "(SELECT json_agg(t) FROM (SELECT " +
//              placeInEventColumns.map((String column) => "place_in_event.\"$column\"").join(",") +
//              " FROM place_in_event WHERE place_in_event.\"eventId\" = $_table.\"id\" /* WHEREplace_in_event */) t) AS $columnName");
//    }
    return query;
  }

  static bool haveTable(String table) {
    return fullColumnsMap.containsKey(table);
  }
}
