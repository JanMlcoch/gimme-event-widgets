part of storage.pgsql;

abstract class PgsqlTableCode<T extends Jsonable> extends BaseTableCode<T> {
  query_lib.SqlCompiler get queries;

  Future<T> saveModel(Connection connection, Map<String, dynamic> entityMap) async {
    entityMap = _toDatabaseJson(entityMap);
    String query = queries.constructInsertQuery(entityMap);
    query = _enhanceSaveQuery(query);
//    print("FUCKING QUERY IS: $query");
    return (await _executeQueryWithProcessor(connection, query)).first;
  }

  Future<T> updateModel(Connection connection, Map<String, dynamic> entityMap, List<String> columns) async {
    entityMap = _toDatabaseJson(entityMap);
    String query = queries.constructUpdateQuery(columns, entityMap);
    query = _enhanceSaveQuery(query);
//    print("FUCKING QUERY IS: $query");
    return (await _executeQueryWithProcessor(connection, query)).first;
  }

  Future<ModelList<T>> load(Connection connection, filter_module.RootFilter filter, List<String> columns,
      {int limit: 50, bool fullColumns: false}) async {
    //if(filter==filter_module.RootFilter.nope) return _rowsToModelList([]);
    String query = queries.constructSelectQuery(columns, useFullColumns: fullColumns);
    if (query == null) return new Future.error("Missing purpose for query");
    query = _multiEnhanceQuery(query, filter, limit);

    return _executeQueryWithProcessor(connection, query);
  }

  Future<Set<int>> missing(Connection connection, Iterable<int> ids, filter_module.RootFilter filter) async {
    String query = queries.constructMultipleExistsQuery(ids);
    List<pgsql.Row> rows = await _executeQuery(connection, query);
    Set<int> rowsIds = rows.map((pgsql.Row row) => row[0] as int).toSet();
    return ids.toSet().difference(rowsIds);
  }

  Future<bool> anyoneExists(Connection connection, filter_module.RootFilter filter) {
    String query = queries.anyoneExistsQuery;
    query = _cleanQuery(_enhanceQueryByConstraints(query, filter));
    return _executeQuery(connection, query).then((List<pgsql.Row> rows) => rows.length > 0 && rows.first[0] == true);
  }

  Future<Map<String, dynamic>> deleteModel(Connection connection, Map<String, dynamic> map) {
    String query = queries.constructDeleteQuery(map);
    query = _cleanQuery(query);
    return _executeQuery(connection, query).then((List<pgsql.Row> rows) {
      if (rows.length == 0) return null;
      return _fromDatabaseJson(rows.first.toMap());
    });
  }

  //####################################################################################################################

  Map<String, dynamic> _fromDatabaseJson(Map<dynamic, dynamic> json);

  Map<String, dynamic> _toDatabaseJson(Map<String, dynamic> json);

  ModelList _rowsToModelList(List<pgsql.Row> rows);


  String _multiEnhanceQuery(String query, filter_module.RootFilter filter, int limit) =>
      _cleanQuery(_enhanceQueryByLimit(_enhanceQueryByConstraints(query, filter), limit));

  String _enhanceSaveQuery(String query) => _cleanQuery(query);

  String _enhanceQueryByConstraints(String query, filter_module.RootFilter filter) {
    if (filter == null || filter == filter_module.RootFilter.pass) return query;
    Map<String, bool> whereFound = {};
    return query.replaceAllMapped(new RegExp(r'\/\* ([a-z0-9_]+)?(WHERE|AND|WHEREAND)([a-z_]+) \*\/'), (Match match) {
      String conjunction = match.group(2);
      String constraint = filter.getSqlConstraint(match.group(3));
      if (conjunction == "AND") return "$conjunction $constraint";
      if (conjunction == "WHEREAND") {
        conjunction = whereFound[match.group(1)] == true ? "AND" : "WHERE";
      }
      whereFound[match.group(1)] = true;
      return "$conjunction $constraint";
    });
  }

  String _enhanceQueryByLimit(String query, int limit) {
    if (limit < 0) return query;
    return query.replaceFirst("/* LIMIT */", "LIMIT $limit");
  }

  String _cleanQuery(String query) {
    return query.replaceAll(new RegExp(r' \/\* \w+ \*\/'), "");
  }

  Future<List<pgsql.Row>> _executeQuery(Connection connection, String query) async {
    storage.logger.info(query);
    if (connection == null || connection.connection == null) throw new ArgumentError("missing connection");
    return connection.connection.query(query).toList();
  }

  Future<ModelList> _executeQueryWithProcessor(Connection connection, String query) async {
    storage.logger.info(query);
    if (connection == null || connection.connection == null) throw new ArgumentError("missing connection");
    List<pgsql.Row> rows = await connection.connection.query(query).toList();
    return _rowsToModelList(rows);
  }

}
