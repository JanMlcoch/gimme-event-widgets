part of storage.pgsql;

class PgsqlDriver {
  final String databaseName;
  final pg_pool.Pool _pool;
  static const Map<String, String> _databaseUrls = const {
    "test": 'postgres://akcnik:sidos@akcnik.vserver.cz:5432/akcnik_test',
    "devel": 'postgres://akcnik:sidos@akcnik.vserver.cz:5432/akcnik',
    "migration": 'postgresql://akcnik:sidos@akcnik.vserver.cz:5432/akcnik_migration',
    "production": 'postgres://akcnik:sidos@akcnik.vserver.cz:5432/akcnik_production',
    "pipni_production": 'postgres://akcnik.thilisar.cz:brMO4i5mblfVcm@sql3.pipni.cz:5432/akcnik.thilisar.cz'
  };

  PgsqlDriver(String databaseName)
      : this.databaseName = databaseName,
        _pool = new pg_pool.Pool(_databaseUrls[databaseName],
            poolName: "akcnikDatabasePool",
            minConnections: 5,
            maxConnections: 25,
            leakDetectionThreshold: new Duration(seconds: 5));
  Future init() {
    if (!_databaseUrls.containsKey(databaseName))
      throw new ArgumentError.value(databaseName, "databaseName", "correct values are ${_databaseUrls.keys}");
    return pgsql
        .connect(_databaseUrls[databaseName], connectionTimeout: new Duration(seconds: 20))
        .then((pgsql.Connection tryConnection) {
      tryConnection.close();
      return _pool.start().then((_) {
        _pool.messages.listen((pgsql.Message message) {
          print(message.message);
        });
      });
    });
  }

  Future<pgsql.Connection> getConnection() async {
    if (_pool.state == pg_pool.PoolState.starting) {
      await untilPoolReady();
    }
    pgsql.Connection pgsqlConnection = await _pool.connect();
    return pgsqlConnection;
  }

  Future untilPoolReady() {
    return Future.doWhile(() {
      if (_pool.state == pg_pool.PoolState.starting) {
        return new Future.delayed(new Duration(milliseconds: 100), () => true);
      }
      return false;
    });
  }

  Future killPool() {
    return _pool.stop();
  }
}
