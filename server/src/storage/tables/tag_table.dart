part of storage.tables;

class TagTable extends TableBase<Tag> {
  static CustomMemoryTable _memoryTable = new CustomMemoryTable(TAGS_TABLE_NAME);
  static CustomPgsqlTable _pgsqlTable = new CustomPgsqlTable(TAGS_TABLE_NAME);

  PgsqlTableCode get pgsqlTable => _pgsqlTable;

  MemoryTableCode get memoryTable => _memoryTable;

  ModelList<Tag> modelListFactory() => new Tags();
  TagTable(Connection connection) : super(connection);

  Tag factory() => new Tag();

  Tags loadByIds(Iterable<int> ids) {
    if (connection.model != null)
      return new Tags()
        ..addAll(connection.model.tags.list.where((Tag tag) => ids.contains(tag.id)));
    throwFakedConnectionError();
    return null;
  }

  Future<Tags> initFromDatabase() async {
    if (connection.model == null || connection.connection == null)
      throw new StateError(
          "Cannot load model from database: " + "${connection.model == null ? "model" : "database"} is missing");

    CustomList modelList = await pgsqlTable.load(connection, null, null, limit: -1, fullColumns: true);
    List<Tag> tagList = modelList.list.map((CustomEntity entity) =>
    new Tag()
      ..fromMap(entity.map)).toList();
    Tags tags = new Tags()
      ..addAll(tagList);
    connection.model.tags.addAll(tags.list);
    return tags;
//    return memoryTable.addAllToModel(connection, tags);
  }
}
