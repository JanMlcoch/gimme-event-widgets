part of storage.pgsql;

class CustomPgsqlTable extends PgsqlTableCode<CustomEntity> {
  final String _tableName;
  final query_lib.CustomSqlCompiler _query;
  final query_lib.CustomAnyKeySqlCompiler _anyKeyQuery;

  CustomPgsqlTable(String table)
      : _tableName = table,
        _query = query_lib.CustomSqlCompiler.haveTable(table) ? new query_lib.CustomSqlCompiler(table) : null,
        _anyKeyQuery =
        query_lib.CustomAnyKeySqlCompiler.haveTable(table) ? new query_lib.CustomAnyKeySqlCompiler(table) : null;

  @override
  Map<String, dynamic> _fromDatabaseJson(Map<dynamic, dynamic> json) {
    if (json is Map<String, dynamic>) return json;
    return null;
  }

  @override
  ModelList _rowsToModelList(List<pgsql.Row> rows) {
    CustomList customs = new CustomList(_tableName);
    rows.forEach((pgsql.Row row) {
      CustomEntity entity = new CustomEntity();
      Map<String, dynamic> rowMap = row.toMap() as Map<String, dynamic>;
      entity.fromMap(rowMap);
      customs.add(entity);
    });
    return customs;
  }

  @override
  Map<String, dynamic> _toDatabaseJson(Map<String, dynamic> json) => json;

  @override
  query_lib.SqlCompiler get queries => _query == null ? _anyKeyQuery : _query;
}
