part of storage;

class Connection {
  final MemoryDriver _memoryDriver;
  final PgsqlDriver _pgsqlDriver;
  pgsql.Connection connection;
  ModelRoot model;
  bool isClosed = false;

  Connection(this._memoryDriver, this._pgsqlDriver) {
    if (_memoryDriver != null) model = _memoryDriver.model;
  }

  Future<Connection> init() async {
    if (_pgsqlDriver == null) return this;
    connection = await _pgsqlDriver.getConnection();
    return this;
  }

  EventTable get events => new EventTable(this);

  PlaceTable get places => new PlaceTable(this);

  UserTable get users => new UserTable(this);

  TagTable get tags => new TagTable(this);

  OrganizerTable get organizers => new OrganizerTable(this);

  CustomTable customs(String table) => new CustomTable(this, table);

  void close() {
    if (connection != null) connection.close();
  }
}
