part of storage.memory;

class EventMemoryTable extends MemoryTableCode<Event> {
  Events _getModelList(Connection connection) => connection.model.events;
}
