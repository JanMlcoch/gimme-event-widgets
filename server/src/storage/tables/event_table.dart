part of storage.tables;

class EventTable extends TableBase<Event> {
  static EventMemoryTable _memoryTable = new EventMemoryTable();
  static EventPgsqlTable _pgsqlTable = new EventPgsqlTable();

  MemoryTableCode get memoryTable => _memoryTable;

  PgsqlTableCode get pgsqlTable => _pgsqlTable;
  Events modelListFactory() => new Events();
  EventTable(Connection connection) : super(connection);
}
