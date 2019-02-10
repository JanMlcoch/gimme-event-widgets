part of storage.pgsql.query;

abstract class SqlCompiler {
  final String _thisTable;
  final String anyoneExistsQuery;

  SqlCompiler(String table)
      : _thisTable = table,
        anyoneExistsQuery = _precompileAnyoneExistsQuery(table);

  String get ownTable => _thisTable;

  //#################################################################################
  String constructInsertQuery(Map<String, dynamic> entityMap);

  String constructUpdateQuery(List<String> columns, Map<String, dynamic> entityMap);

  String constructSelectQuery(Iterable<String> columns, {bool useFullColumns: false});

  String constructMultipleExistsQuery(Iterable<int> ids);

  String constructDeleteQuery(Map<String, dynamic> map);

  static String _precompileAnyoneExistsQuery(String table) {
    return "SELECT exists(SELECT 1 FROM $table /* WHERE$table */);";
  }
}
