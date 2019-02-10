part of storage.pgsql.query;

abstract class IdKeyCompiler extends SqlCompiler {
  final List<String> _insertColumns;
  final List<String> _fullColumns;
  static const String primaryKey = "id";
  final String _insertQueryCont;
  final String _deleteQuery;
  final String _multipleDeleteQuery;
  final String _updateQuery;
  final String _multipleExistsQuery;

  IdKeyCompiler(String table, List<String> insertColumns, List<String> fullColumns)
      : _insertColumns = insertColumns,
        _fullColumns = fullColumns,
        _multipleExistsQuery = _precompileMultipleExistsQuery(table),
        _multipleDeleteQuery = _precompileMultipleDeleteQuery(table),
        _deleteQuery = _precompileDeleteQuery(table, fullColumns),
        _insertQueryCont = _precompileInsertQueryCont(table, insertColumns, fullColumns),
        _updateQuery = _precompileUpdateQuery(table, fullColumns),
        super(table);

  String _replaceSpecialColumns(String query, Iterable<String> columns) => query;

  //############################################################################

  static String _precompileInsertQueryCont(String table, List<String> columns, List<String> returnColumns) {
    return "BEGIN TRANSACTION; INSERT INTO $table (" +
        columns.map((String column) => "\"$column\"").join(", ") +
        ") VALUES /* values */; " +
        _precompileSelectQuery(table, returnColumns)
            .replaceFirst("/* WHERE$table */", "WHERE \"$primaryKey\" = (SELECT currval('${table}_id_seq'))")
            .replaceAll(new RegExp(r' \/\* [a-zA-Z_]* \*\/'), "") +
        " COMMIT TRANSACTION;";
  }

  static String _precompileDeleteQuery(String table, fullColumns) {
    return "DELETE FROM $table WHERE \"$primaryKey\" = @$primaryKey RETURNING " +
        fullColumns.map((String key) => "$table.\"$key\"").join(", ") +
        ";";
  }

  static String _precompileMultipleDeleteQuery(String table) {
    return "DELETE FROM $table WHERE \"$primaryKey\" IN (@$primaryKey);";
  }

  static String _precompileUpdateQuery(String table, List<String> returnColumns) {
    return "BEGIN TRANSACTION; UPDATE $table SET /* values */ WHERE \"$primaryKey\" = @$primaryKey; " +
        _precompileSelectQuery(table, returnColumns)
            .replaceFirst("/* WHERE$table */", "WHERE \"$primaryKey\" = @$primaryKey")
            .replaceAll(new RegExp(r' \/\* [a-zA-Z_]* \*\/'), "") +
        " COMMIT TRANSACTION;";
  }

  static String _precompileSelectQuery(String table, List<String> columns) {
    return "SELECT " +
        columns.map((String key) => "$table.\"$key\"").join(", ") +
        " FROM $table " +
        "/* WHERE$table */ /* otherWHERE */ /* LIMIT */;";
  }

//  static String _precompileExistsQuery(String table) {
//    return "SELECT exists(SELECT 1 FROM $table WHERE \"$_primaryKey\" = @$_primaryKey);";
//  }

  static String _precompileMultipleExistsQuery(String table) {
    return "SELECT $primaryKey FROM $table WHERE \"$primaryKey\" IN (@$primaryKey);";
  }

  //############################################################################
  String constructUpdateQuery(List<String> columns, Map<String, dynamic> json) {
    String sets = columns.map((String column) => "\"$column\" = ${safeConvert(json[column])}").join(", ");
    String query =
    _updateQuery.replaceFirst("/* values */", sets).replaceAll("@$primaryKey", json[primaryKey].toString());
    return _replaceSpecialColumns(query, _fullColumns);
  }

  String constructInsertQuery(Map<String, dynamic> json) {
    Iterable columns = _insertColumns.map((String column) => safeConvert(json[column], nullToDefault: true));
    String value = "(" + columns.join(", ") + ")";
    String query = _insertQueryCont.replaceFirst("/* values */", value);
    return _replaceSpecialColumns(query, _fullColumns);
  }

  String constructMultipleInsertQuery(List<Map<String, dynamic>> jsonList) {
    List<String> values = [];
    for (Map<String, dynamic> json in jsonList) {
      String value =
          "(" + _insertColumns.map((String column) => safeConvert(json[column], nullToDefault: true)).join(", ") + ")";
      values.add(value);
    }
    return _insertQueryCont.replaceFirst("/* values */", values.join(", "));
  }

  String constructDeleteQuery(Map<String, dynamic> json) {
    return _deleteQuery.replaceFirst("@$primaryKey", json["id"].toString());
  }

  String constructMultipleDeleteQuery(List<Map<String, dynamic>> jsonList) {
    List<int> ids = [];
    for (Map<String, dynamic> json in jsonList) {
      ids.add(json["id"]);
    }
    return _multipleDeleteQuery.replaceFirst("@$primaryKey", ids.join(", "));
  }

//  String constructExistsQuery(int id) {
//    return _existsQuery.replaceFirst("@$_primaryKey", id.toString());
//  }

  String constructMultipleExistsQuery(Iterable<int> ids) {
    return _multipleExistsQuery.replaceFirst("@$primaryKey", ids.join(","));
  }

  String constructSelectQuery(Iterable<String> columns, {bool useFullColumns: false}) {
    if (useFullColumns) columns = _fullColumns;
    if (columns == null) throw new ArgumentError.notNull("columns");
    String query = _precompileSelectQuery(_thisTable, columns);
    return _replaceSpecialColumns(query, columns);
  }
}
