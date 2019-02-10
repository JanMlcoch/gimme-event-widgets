import 'dart:async';
import 'dart:io';
import '../server_libs/io_helper.dart';
import 'package:postgresql/postgresql.dart' as pgsql;

Future main(List<String> args) async {
  String projectDir = getProjectDirectoryName();
  Directory migrationDir = new Directory("$projectDir/migration");
  File sqlFile = new File("${migrationDir.path}/reset_sequences.sql");
  String queryBuilderQuery = await sqlFile.readAsString();
  pgsql.Connection connection =
  await pgsql.connect(args.first, applicationName: "Migrate", connectionTimeout: new Duration(seconds: 30));
  if (connection.state != pgsql.ConnectionState.idle) {
//    print(connection.state.toString());
    throw new StateError("Could not connect to database");
  }

  String query = "BEGIN TRANSACTION;\n";
  List<pgsql.Row> rows = await connection.query(queryBuilderQuery).toList();
  for (pgsql.Row row in rows) {
    query += row[0] + "\n";
  }
  query += "COMMIT TRANSACTION;";
  print(query);
  connection.close();
}
