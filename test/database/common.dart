library akcnik.tests.database.common;

import 'dart:async';
import "package:postgresql/postgresql.dart" as pgsql;
import "dart:io" as io;

const bool DATABASE_ON = true;

Future<pgsql.Connection> getConnection([String address = testAddress]) async {
  pgsql.Connection connection = await pgsql.connect(address);
  new Timer(new Duration(seconds: 4), () {
    if (connection.state != pgsql.ConnectionState.closed) {
      throw new StateError("Connection to database is not closed");
    }
  });
  return connection;
}

const String testAddress = 'postgresql://akcnik:sidos@akcnik.vserver.cz:5432/akcnik_migration';
//const String testAddress = 'postgresql://akcnik:sidos@akcnik.vserver.cz:5432/akcnik_test';
//const String testAddress = 'postgresql://akcnik:sidos@akcnik.vserver.cz:5432/akcnik';
//const String testAddress = 'postgresql://akcnik.thilisar.cz:brMO4i5mblfVcm@sql3.pipni.cz:5432/akcnik.thilisar.cz';

Future<dynamic> connectHandler(inner(pgsql.Connection connection), [String address = testAddress]) async {
  pgsql.Connection connection = await pgsql.connect(address);
  if (connection == null) return "Connect error";
  dynamic result;
  try {
    result = await inner(connection);
  } finally {
    connection.close();
  }
  return result;
}

Future<bool> skipDatabase() async {
  if(!DATABASE_ON) return true;
//  skipDatabase = true;
    try {
      (await getConnection()).close();
    } on pgsql.PostgresqlException {
      return true;
    } on io.SocketException {
      return true;
    }
  return false;
}
