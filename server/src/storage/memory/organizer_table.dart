part of storage.memory;

class OrganizerMemoryTable extends MemoryTableCode<Organizer> {
  Organizers _getModelList(Connection connection) => connection.model.organizers;
}
