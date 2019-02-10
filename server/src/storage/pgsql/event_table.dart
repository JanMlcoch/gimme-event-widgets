part of storage.pgsql;

class EventPgsqlTable extends PgsqlTableCode<Event> {
  static query_lib.EventSqlCompiler _queries = new query_lib.EventSqlCompiler();

  query_lib.SqlCompiler get queries => _queries;
  static query_lib.PlaceInEventSqlCompiler _placesQueries = new query_lib.PlaceInEventSqlCompiler();
//  static database_sql.EventSqlCompiler _organizerQueries = new database_sql.EventSqlCompiler();

  @override
  Future<Event> saveModel(Connection connection, Map<String, dynamic> entityMap) async {
    entityMap = _toDatabaseJson(entityMap);
    String query = _queries.constructInsertQuery(entityMap);
    query = _enhanceSaveQuery(query);
    List<Map<String, dynamic>> placeInEventJsonList = [];
    if (entityMap.containsKey("places"))
      placeInEventJsonList =
          (entityMap["places"] as List).map((Map<String, dynamic> placeMap) => toPlaceInEventDatabaseJson(placeMap)).toList();
//        model.places.map((PlaceInEvent placeInEvent) => toPlaceInEventDatabaseJson(placeInEvent.toFullMap())).toList();
    Event entity = (await _executeQueryWithProcessor(connection, query)).first;
    if (placeInEventJsonList.length > 0) {
      String placeInEventQuery = _queries.constructMultipleInsertQuery(placeInEventJsonList);
      List<pgsql.Row> placeInEventRows = await _executeQuery(connection, placeInEventQuery);
      entity.places = _rowsToPlaceInEventList(placeInEventRows);
    }
    return entity;
  }

  Future<Event> updateModel(Connection connection, Map<String, dynamic> entityMap, List<String> columns) async {
    entityMap = _toDatabaseJson(entityMap);
    if (columns.contains("places")) {
      List<Map<String, dynamic>> placeInEventJsonList =
      (entityMap["places"] as List).map((Map<String, dynamic> placeMap) => toPlaceInEventDatabaseJson(placeMap));
      String placeQuery = _placesQueries.constructMultipleDeleteInsertQuery(
          entityMap["id"], placeInEventJsonList);
      columns.remove("places");
      await _executeQueryWithProcessor(connection, placeQuery);
    }
    String query = _queries.constructUpdateQuery(columns, entityMap);
    query = _enhanceSaveQuery(query);
    return (await _executeQueryWithProcessor(connection, query)).first;
  }

  Events _rowsToModelList(List<pgsql.Row> rows) {
    Events events = new Events();
    rows.forEach((pgsql.Row row) {
      Event event = new Event();
      Map<String, dynamic> entityJson = _fromDatabaseJson(row.toMap());
      event.fromMap(entityJson);
      events.add(event);
    });
    return events;
  }

  Map<String, dynamic> _toDatabaseJson(Map<String, dynamic> json) {
    if(json.containsKey("from")){
      json["from"] = new DateTime.fromMillisecondsSinceEpoch(json["from"]).toIso8601String();
    }
    if(json.containsKey("to")){
      json["to"] = new DateTime.fromMillisecondsSinceEpoch(json["to"]).toIso8601String();
    }
    if (json["tags"] is List) {
      json["tagIds"] =
          (json["tags"] as List<Map<String, dynamic>>).map((Map<String, dynamic> tag) => tag["id"]).toList();
      json.remove("tags");
    }
//    json["clientSettings"] = JSON.encode(json["clientSettings"]);
//    json["costsJson"] = JSON.encode(json["costsJson"]);
    return json;
  }

  Map<String, dynamic> _fromDatabaseJson(Map json) {
    if (json["places"] == null) {
      json["places"] = [];
    }
    if (json is Map<String, dynamic>) return json;
    return null;
  }

  Map<String, dynamic> toPlaceInEventDatabaseJson(Map<String, dynamic> json) {
    return json;
  }

  List<PlaceInEvent> _rowsToPlaceInEventList(List<pgsql.Row> rows) {
    List<PlaceInEvent> list = [];
    for (pgsql.Row row in rows) {
      PlaceInEvent placeInEvent = new PlaceInEvent();
      placeInEvent.fromMap(row.toMap());
      list.add(placeInEvent);
    }
    return list;
  }
}
