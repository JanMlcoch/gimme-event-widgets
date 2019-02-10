part of storage.pgsql.query;

class PlaceInEventSqlCompiler extends TwoKeyCompiler {
  static const String _table = "place_in_event";
  static const String primaryKey = "eventId";
  static const String secondaryKey = "placeId";
  static const List<String> fullColumns = const ["eventId", "placeId", "description"];
  static const List<String> insertColumns = const ["eventId", "placeId", "description"];
  //############################################################################

  PlaceInEventSqlCompiler() : super(_table, primaryKey, secondaryKey, insertColumns, fullColumns);
  //############################################################################

  String constructMultipleDeleteInsertQuery(dynamic primaryKeyValue, Iterable<Map<String, dynamic>> jsonList) {
    for (Map<String, dynamic> json in jsonList) {
      json[primaryKey] = primaryKeyValue;
    }
    return _multipleDeleteQueryByPrimary.replaceFirst("@$_primaryKey", primaryKeyValue.toString()) +
        constructMultipleInsertQuery(jsonList);
  }

  @override
  String _replaceSpecialColumns(String query, List<String> columns) => query;
}
