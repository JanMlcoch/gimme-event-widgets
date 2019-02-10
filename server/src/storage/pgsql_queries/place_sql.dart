part of storage.pgsql.query;

class PlaceSqlCompiler extends IdKeyCompiler {
  static const String _table = "places";
  static const List<String> fullColumns = const [
    "id",
    "name",
    "latitude",
    "longitude",
    "city",
    "description",
    "ownerId"
  ];
  static const List<String> insertColumns = const ["name", "latitude", "longitude", "city", "description", "ownerId"];
  //############################################################################
  //final String _insertQuery = _precompileInsertQuery();

  PlaceSqlCompiler() : super(_table, insertColumns, fullColumns);

  //############################################################################

//  @override
//  String _replaceSpecialColumns(String query, Iterable<String> columns) => query;
  @override
  String _replaceSpecialColumns(String query, Iterable<String> columns) {
    if (columns.contains("eventId")) {
      query = query
          .replaceFirst("SELECT", "SELECT DISTINCT ON ($_table.id)")
          .replaceFirst("$_table.\"eventId\"", "events.id AS \"eventId\"")
          .replaceFirst("FROM $_table", "FROM $_table LEFT OUTER JOIN events ON places.\"id\" = events.\"placeId\"");
    }
    return query;
  }
}
