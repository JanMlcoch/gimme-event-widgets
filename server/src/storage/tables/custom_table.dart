part of storage.tables;

class CustomTable extends TableBase<CustomEntity> {
  final String _tableName;
  static Map<String, MemoryTableCode> _memoryTables = {};
  static Map<String, PgsqlTableCode> _pgsqlTables = {};

//  static EventMemoryTable _memoryTable = new EventMemoryTable();
//  static EventPgsqlTable _pgsqlTable = new EventPgsqlTable();

  CustomTable(Connection connection, this._tableName) :super(connection);

  Future<List> executeQuery(String query) {
    if (connection.connection == null) throw new ArgumentError("could not connect to database");
    return connection.connection.query(query).toList();
  }

  @override
  CustomList modelListFactory() => new CustomList(_tableName);

  @override
  MemoryTableCode get memoryTable {
    if (_memoryTables[_tableName] == null) {
      _memoryTables[_tableName] = new CustomMemoryTable(_tableName);
    }
    return _memoryTables[_tableName];
  }


  @override
  PgsqlTableCode get pgsqlTable {
    if (_pgsqlTables[_tableName] == null) {
      _pgsqlTables[_tableName] = new CustomPgsqlTable(_tableName);
    }
    return _pgsqlTables[_tableName];
  }

  Future<CustomList> load(filter_module.RootFilter filter, List<String> columns,
      {bool fullColumns: false, int limit: 50}) {
    if (connection.connection != null) {
      return pgsqlTable.load(connection, filter, columns, fullColumns: fullColumns, limit: limit);
    }
    throwFakedConnectionError();
    return new Future.value(null);
  }

  Object addToModel(Object model) {
    return model;
  }
}
