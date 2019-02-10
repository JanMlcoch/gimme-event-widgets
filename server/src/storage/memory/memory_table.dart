part of storage.memory;

abstract class MemoryTableCode<T extends common.Jsonable> extends BaseTableCode<T> {
  ModelList<T> getModelList(Connection connection) {
    if (connection == null) throw new ArgumentError("missing connection");
    if (connection.model == null) throw new ArgumentError("missing connection model");
    return _getModelList(connection);
  }

  Future<T> saveModel(Connection connection, Map<String, dynamic> entityMap) async {
    ModelList modelList = getModelList(connection);
    entityMap["id"] = modelList.nextId();
    dynamic entity = modelList.entityFactory()
      ..fromMap(entityMap);
    modelList.add(entity);
    return entity;
  }

  Future<T> updateModel(Connection connection, Map<String, dynamic> entityMap, List<String> columns) async {
    common.Jsonable oldEntity = getModelList(connection).getById(entityMap["id"]);
    Map<String, dynamic> oldMap = oldEntity.toFullMap();
    for (String column in columns) {
      oldMap[column] = entityMap[column];
    }
    oldEntity.fromMap(oldMap);
    return oldEntity;
  }

  Future<ModelList<T>> load(Connection connection, filter_module.RootFilter filter, List<String> columns,
      {int limit: 50, bool fullColumns: false}) async {
    if (filter == null) {
      ModelList modelList = getModelList(connection);
      if (limit == -1 || limit >= modelList.length) return getModelList(connection);
      return modelList.copyType().addAll(modelList.list.sublist(0, limit));
    }
    return filter.filter(getModelList(connection), limit: limit);
  }

  ModelList<T> _getModelList(Connection connection);

  Future<Set<int>> missing(Connection connection, Iterable<int> ids, filter_module.RootFilter filter) {
    return new Future.value(ids.where((int id) => filter.filter(getModelList(connection)).getById(id) == null).toSet());
  }

  Future<bool> anyoneExists(Connection connection, filter_module.RootFilter filter) {
    if (filter == null) filter = filter_module.RootFilter.pass;
    return new Future.value(filter.any(getModelList(connection)));
  }

  Future<Map<String, dynamic>> deleteModel(Connection connection, Map<String, dynamic> model) {
    return new Future.value(getModelList(connection).remove(model["id"]));
  }

//###################################################################################################################
  T addToModel(Connection connection, T model) {
    ModelList<T> modelList = getModelList(connection);
    modelList.add(model);
    return model;
  }

  ModelList<T> addAllToModel(Connection connection, ModelList<T> newModelList) {
    ModelList<T> modelList = getModelList(connection);
    modelList.addAll(newModelList.list);
    return modelList;
  }
}
