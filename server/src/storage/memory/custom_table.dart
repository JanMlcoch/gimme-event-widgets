part of storage.memory;

class CustomMemoryTable extends MemoryTableCode<CustomEntity> {
  final String _tableName;

  CustomMemoryTable(this._tableName);

  CustomList _getModelList(Connection connection) {
//    switch (_tableName) {
//      case "events":
//        return connection.model.events;
//      case "tags":
//        return connection.model.tags;
//    }
    return null;
  }
}
