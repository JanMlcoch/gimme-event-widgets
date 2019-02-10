part of storage.pgsql.query;

abstract class TwoKeyCompiler extends SqlCompiler {
  final List<String> _insertColumns;
  final List<String> _fullColumns;
  final List<String> _primaryKeys;
  final String _primaryKey;
  final String _insertQueryCont;
  final String _deleteQuery;
  final String _multipleDeleteQuery;
  final String _updateQuery;
  final String _multipleExistsQuery;
  final String _multipleDeleteQueryByPrimary;

  TwoKeyCompiler(String table, String primaryKey, String secondaryKey, List<String> insertColumns,
      List<String> fullColumns)
      : _insertColumns = insertColumns,
        _fullColumns = fullColumns,
        _primaryKey = primaryKey,
        _primaryKeys = [primaryKey, secondaryKey],
        _multipleExistsQuery = _precompileMultipleExistsQuery(table, primaryKey, secondaryKey),
        _multipleDeleteQuery = _precompileMultipleDeleteQuery(table, primaryKey, secondaryKey),
        _deleteQuery = _precompileDeleteQuery(table, primaryKey, secondaryKey),
        _insertQueryCont = _precompileInsertQueryCont(table, insertColumns, fullColumns),
        _updateQuery = _precompileUpdateQuery(table, primaryKey, secondaryKey),
        _multipleDeleteQueryByPrimary =
        _precompileMultipleDeleteQueryByPrimary(table, primaryKey, secondaryKey, insertColumns),
        super(table);

  String _replaceSpecialColumns(String query, List<String> columns);

//#################################################################################################

  static String _precompileInsertQueryCont(String table, List<String> columns, List<String> returnColumns) {
    return "INSERT INTO $table (" +
        columns.map((String column) => "\"$column\"").join(", ") +
        ") VALUES /* values */ RETURNING " +
        returnColumns.map((String column) => "\"$column\"").join(", ") +
        ";";
  }

  static String _precompileMultipleDeleteQueryByPrimary(
      String table, String primaryKey, String secondaryKey, List<String> insertColumns) {
    return "DELETE FROM $table WHERE \"$primaryKey\" = @$primaryKey;";
  }

  static String _precompileDeleteQuery(String table, String primaryKey, String secondaryKey) {
    return "DELETE FROM $table " + "WHERE \"$primaryKey\" = @$primaryKey " + "AND \"$secondaryKey\" = @$secondaryKey;";
  }

  static String _precompileMultipleDeleteQuery(String table, String primaryKey, String secondaryKey) {
    return "DELETE FROM $table " +
        "WHERE \"$primaryKey\" = @$primaryKey " +
        "AND \"$secondaryKey\" IN (@$secondaryKey);";
  }

  static String _precompileUpdateQuery(String table, String primaryKey, String secondaryKey) {
    return "UPDATE $table SET /* values */ " +
        "WHERE \"$primaryKey\" = @$primaryKey " +
        "AND \"$secondaryKey\" = @$secondaryKey;";
  }

//  static String _precompileExistsQuery(String table, String primaryKey, String secondaryKey) {
//    return "SELECT exists(SELECT 1 FROM $table " +
//        "WHERE \"$primaryKey\" = @$primaryKey " +
//        "AND \"$secondaryKey\" = @$secondaryKey);";
//  }

  static String _precompileMultipleExistsQuery(String table, String primaryKey, String secondaryKey) {
    return "SELECT \"$secondaryKey\" FROM $table" +
        "WHERE \"$primaryKey\" = @$primaryKey " +
        "AND \"$secondaryKey\" IN (@$secondaryKey);";
  }

  //############################################################################
  String constructUpdateQuery(List<String> columns, Map<String, dynamic> json) {
    String sets = columns.map((String column) => "\"$column\" = ${safeConvert(json[column])}").join(", ");
    String query = _updateQuery.replaceFirst("/* values */", sets);
    return sqlSubstitute(query, json, keys: _primaryKeys);
  }

  String constructInsertQuery(Map<String, dynamic> json) {
    String value =
        "(" + _insertColumns.map((String column) => safeConvert(json[column], nullToDefault: true)).join(", ") + ")";
    return _insertQueryCont.replaceFirst("/* values */", value);
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
    return sqlSubstitute(_deleteQuery, json, keys: _primaryKeys);
  }

  String constructMultipleDeleteQuery(List<Map<String, dynamic>> jsonList) {
    String query = _multipleDeleteQuery;
    for (String key in _primaryKeys) {
      Set<int> ids = new Set();
      for (Map<String, dynamic> json in jsonList) {
        ids.add(json[key]);
      }
      query = query.replaceFirst("@$key", ids.join(", "));
    }
    return query;
  }

//  String constructExistsQuery(int primaryId, int secondaryId) {
//    return _existsQuery
//        .replaceFirst("@$_primaryKey", primaryId.toString())
//        .replaceFirst("@$_secondaryKey", secondaryId.toString());
//  }

  String constructMultipleExistsQuery(Iterable<int> secondaryIds) {
    throw new StateError("constructMultipleExistsQuery() is not implemented for TwoKeyCompiler");
  }

  String constructTwoKeyMultipleExistsQuery(int primaryId, Iterable<int> secondaryIds) {
    return _multipleExistsQuery
        .replaceFirst("@$_primaryKey", primaryId.toString())
        .replaceFirst("@id", secondaryIds.join(","));
  }

  String constructSelectQuery(Iterable<String> columns, {bool useFullColumns: false}) {
    if (useFullColumns) columns = _fullColumns;
    if (columns == null) throw new ArgumentError.notNull("columns");
    String query = "SELECT " +
        columns.map((String key) => "$_thisTable.\"$key\"").join(", ") +
        " FROM $_thisTable " +
        " /* WHERE$_thisTable */ /* otherWHERE */ /* LIMIT */";
    return _replaceSpecialColumns(query, columns);
  }
}
