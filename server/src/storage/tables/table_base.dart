part of storage.tables;

abstract class TableBase<T extends common.Jsonable> {
  final Connection connection;

  TableBase(this.connection);

  MemoryTableCode get memoryTable;

  PgsqlTableCode get pgsqlTable;

  Future<ModelList<T>> load(filter_module.RootFilter filter, List<String> columns,
      {bool fullColumns: false, int limit: 50}) {
    if (connection.connection != null) {
      return pgsqlTable.load(connection, filter, columns, fullColumns: fullColumns, limit: limit);
    }
    if (connection.model != null) {
      return memoryTable.load(connection, filter, columns, fullColumns: fullColumns, limit: limit);
    }
    throwFakedConnectionError();
    return new Future.value(null);
  }

  Future<Set<int>> missing(Iterable<int> ids, filter_module.RootFilter filter) {
    if (connection.connection != null) {
      return pgsqlTable.missing(connection, ids, filter);
    }
    if (connection.model != null) {
      return memoryTable.missing(connection, ids, filter);
    }
    throwFakedConnectionError();
    return new Future.value(ids);
  }

  Future<T> saveModel(Map<String, dynamic> model) {
    if (connection.connection != null) {
      return pgsqlTable.saveModel(connection, model);
    }
    if (connection.model != null) {
      return memoryTable.saveModel(connection, model);
    }
    throwFakedConnectionError();
    return null;
  }

  Future<T> updateModel(Map<String, dynamic> model, [List<String> columns]) {
    if (columns == null) {
      columns = model.keys.where((String key) => key != "id").toList();
    }
    if (connection.connection != null) {
      return pgsqlTable.updateModel(connection, model, columns);
    }
    if (connection.model != null) {
      return memoryTable.updateModel(connection, model, columns);
    }
    throwFakedConnectionError();
    return null;
  }

  Future<bool> anyoneExists(filter_module.RootFilter filter) {
    if (connection.connection != null) {
      return pgsqlTable.anyoneExists(connection, filter);
    }
    if (connection.model != null) {
      return memoryTable.anyoneExists(connection, filter);
    }
    throwFakedConnectionError();
    return null;
  }

  Future<Map<String, dynamic>> deleteModel(Map<String, dynamic> map) {
    if(connection.connection !=null){
      return pgsqlTable.deleteModel(connection, map);
    }
    if(connection.model!=null){
      return memoryTable.deleteModel(connection,map);
    }
    throwFakedConnectionError();
    return null;
  }

//###################################################################
  ModelList<T> modelListFactory();

  void throwFakedConnectionError() {
    throw new StateError("Faked connection: get proper connection to database \n" +
        "-- final bool needConnection = true; in RequestContext");
  }

//  Future<ModelList> initFromDatabase() async {
//    if (connection.model == null || connection.connection == null)
//      throw new StateError(
//          "Cannot load model from database: " + "${connection.model == null ? "model" : "database"} is missing");
//    return await pgsqlTable
//        .load(connection, null, null, limit: -1, fullColumns: true)
//        .then((ModelList modelList) => memoryTable.addAllToModel(connection, modelList));
//  }
}

class OrganizerTable extends TableBase<Organizer> {
  static OrganizerMemoryTable _memoryTable = new OrganizerMemoryTable();
  static OrganizerPgsqlTable _pgsqlTable = new OrganizerPgsqlTable();

  MemoryTableCode get memoryTable => _memoryTable;

  PgsqlTableCode get pgsqlTable => _pgsqlTable;

  Organizers modelListFactory() => new Organizers();

  OrganizerTable(Connection connection) : super(connection);
}
