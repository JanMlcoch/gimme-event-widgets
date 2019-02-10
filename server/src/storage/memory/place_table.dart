part of storage.memory;

class PlaceMemoryTable extends MemoryTableCode<Place> {
  Places _getModelList(Connection connection) => connection.model.places;
}
