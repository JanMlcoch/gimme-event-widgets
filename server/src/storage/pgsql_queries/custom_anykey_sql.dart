part of storage.pgsql.query;

class CustomAnyKeySqlCompiler extends AnyKeyCompiler {
  final String _table;
  static const Map<String, String> primaryKeys = const {
    "user_roles":"role"
  };
  static const Map<String, List<String>> fullColumnsMap = const {
    "user_roles":const[
      "role",
      "permissions"
    ]
  };
  static const Map<String, List<String>> insertColumnsMap = const {
    "user_roles":const[
      "role",
      "permissions"
    ]
  };

  CustomAnyKeySqlCompiler(String table)
      : _table = table,
        super(table, insertColumnsMap[table], fullColumnsMap[table],
          primaryKeys.containsKey(table) ? primaryKeys[table] : "id");

  @override
  String _replaceSpecialColumns(String query, Iterable<String> columns) => query;

  static bool haveTable(String table) {
    return fullColumnsMap.containsKey(table) && primaryKeys.containsKey(table);
  }
}
