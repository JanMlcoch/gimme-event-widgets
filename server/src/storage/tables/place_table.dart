part of storage.tables;

class PlaceTable extends TableBase<Place> {
  static PlaceMemoryTable _memoryTable = new PlaceMemoryTable();
  static PlacePgsqlTable _pgsqlTable = new PlacePgsqlTable();

  MemoryTableCode get memoryTable => _memoryTable;

  PgsqlTableCode get pgsqlTable => _pgsqlTable;
  Places modelListFactory() => new Places();
  PlaceTable(Connection connection) : super(connection);
  Place factory() => new Place();
}
