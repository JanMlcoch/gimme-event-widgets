part of storage;

class DataStorage {
  log.Logger logger = new log.Logger("akcnik.storage");
  PgsqlDriver _pgsqlDriver;
  MemoryDriver _memoryDriver;
  static Connection fakedConnection = new Connection(null, null);
  bool isInitialized = false;

  bool testing = false;

  DataStorage(ModelRoot model, String pgsqlDatabase) {
    if (model != null) {
      _memoryDriver = new MemoryDriver(model);
    }
    if (pgsqlDatabase != null) {
      _pgsqlDriver = new PgsqlDriver(pgsqlDatabase);
    }
  }

  Future<DataStorage> init() {
    if (_pgsqlDriver != null) {
      return _pgsqlDriver.init().then((_) {
        logger.info("DataStorage with database PGSQL pool inited");
        isInitialized = true;
        return this;
      }).catchError((e) {
        _pgsqlDriver.killPool();
        _pgsqlDriver = null;
        logger.severe(e.toString());
      });
    }
//    print("DataStorage without PGSQL inited");
    isInitialized = true;
    return new Future.value(this);
  }

  Future<Connection> getConnection({bool noMemory: false, bool onlyMemory: false}) {
    return new Connection(noMemory ? null : _memoryDriver, onlyMemory ? null : _pgsqlDriver).init();
  }

  Future killStorage() {
    if (_pgsqlDriver != null) {
      PgsqlDriver pgsqlDriver = _pgsqlDriver;
      _pgsqlDriver = null;
      return pgsqlDriver.killPool();
    }
    if (_memoryDriver != null) {
      _memoryDriver.replaceModel(null);
      _memoryDriver = null;
    }
    return new Future.value(true);
  }

  Connection get memory => new Connection(_memoryDriver, null);

  Future<dynamic> connectHandler(Future<dynamic> handler(Connection connection)) async {
    Connection connection = await getConnection();
    var result = await handler(connection);
    connection.close();
    return result;
  }

  Future<DataStorage> initMemoryFromDb() async {
    Connection connection = await getConnection();
    if (connection.connection == null) {
      throw new Exception("missing connection");
//      _memoryDriver.replaceModel(sample.constructModel());
    } else {
      await connection.tags.initFromDatabase();
    }
    connection.close();
    ModelRoot model = memory.model;
    logger.info("loading from ${connection.connection != null ? "DATABASE" : "SAMPLE"}: " +
        "EVENTS=${model.events.length} " +
        "PLACES=${model.places.length} " +
        "USERS=${model.users.length} " +
        "TAGS=${model.tags.length} " +
        "ORGANIZERS=${model.organizers.length}");
    return this;
  }

  //###################################################################
  Future testRun() async {
    const List<String> eventColumns = const [
      "id",
      "name",
      "from",
      "to",
      "placeId",
      "tags",
      "language",
      "description",
      "price",
      "costs",
      "mapLongitude",
      "mapLatitude",
      "eventTagId",
      "parentEventId",
      "private",
      "profileQuality",
      "clientSettings",
      "insertionTime",
      "maxParticipants",
      "expectedParticipants",
      "webpage",
      "socialNetworks",
      "annotation"
    ];
    Connection connection = await getConnection();
//    dynamic idSet = new Set<int>()..addAll([38, 59]);
    EnvelopeHolder message = new EnvelopeHolder();
    filter_module.RootFilter filter = new filter_module.RootFilter.construct([
      {
        "name": "distance",
        "data": [50.0755381, 14.4378005, 30]
      },
      {
        "name": "price_interval",
        "data": [50, 250, "CZK"]
      },
    ], message);
    if (!message.isSuccess) {
      print(message.toMap());
    }
    Events events = await connection.events.load(filter, eventColumns);
//    List<Map<String,dynamic>> events = await session.events.loadByIds(idSet,purpose);
    print("storage Events: " + JSON.encode(events.toFullList()));
    connection.close();
  }
}
