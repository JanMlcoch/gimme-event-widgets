part of storage.pgsql.query;

class EventSqlCompiler extends IdKeyCompiler {
  static const String _table = "events";
  static const List<String> fullColumns = const [
    "id",
    "name",
    "from",
    "to",
    "placeId",
    "tagIds",
    "language",
    "description",
    "price",
    "costs",
    "mapLongitude",
    "mapLatitude",
    "eventTagId",
    "parentEventId",
    "private",
    "profileQuality",
//      "questAttends",
    "clientSettings",
    "serverSettings",
    "insertionTime",
    "maxParticipants",
    "expectedParticipants",
//      "guestRateSum",
//      "guestRateCount",
    "webpage",
    "socialNetworks",
    "annotation",
    "ownerId"
  ];
  static const List<String> insertColumns = const [
    "name",
    "from",
    "to",
    "tagIds",
    "placeId",
    "language",
    "clientSettings",
    "serverSettings",
    "annotation",
    "description",
    "maxParticipants",
    "expectedParticipants",
    "webpage",
    "socialNetworks",
    "ownerId"
  ];

  //############################################################################
  EventSqlCompiler() : super(_table, insertColumns, fullColumns);

  //############################################################################

  //############################################################################

  @override
  String _replaceSpecialColumns(String query, Iterable<String> columns) {
    if (columns.contains("places")) {
      String columnName = "places";
      List<String> placeInEventColumns = PlaceInEventSqlCompiler.fullColumns;
      query.replaceFirst(
          "$_table.\"$columnName\"",
          "(SELECT json_agg(t) FROM (SELECT " +
              placeInEventColumns.map((String column) => "place_in_event.\"$column\"").join(",") +
              " FROM place_in_event WHERE place_in_event.\"eventId\" = $_table.\"id\" /* WHEREplace_in_event */) t) AS $columnName");
    }
    return query;
  }
}
