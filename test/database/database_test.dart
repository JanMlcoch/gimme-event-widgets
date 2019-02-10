library akcnik.tests.database;

import "package:test/test.dart";
//import "dart:convert";
//import "../../lib/common/flags/library.dart" as flag_lib;
//import "../../server/src/model/library.dart" as model_lib;
//import "../../server/src/modules/event/library.dart";
//import "../../server/src/modules/place/library.dart";
//import "../../server/src/modules/filter/library.dart";
//import "../../server_libs/server/library.dart" as server_lib;
//import 'package:shelf/shelf.dart' as shelf;
//import "../common.dart";
////import "../../server/src/storage/library.dart" as storage_lib;
//import "../../server/src/storage/pgsql_queries/library.dart" as queries_lib;
import 'dart:async';
import "package:postgresql/postgresql.dart" as pgsql;
import "../../migration/migrate.dart" as migration;
import '../common.dart';
import 'common.dart';

part 'database_reset.dart';
part "event_database_tests.dart";

Future main() async {
  bool skip = await skipDatabase();
  await runServer(45869);
  databaseReset(skip: skip);
  eventDatabaseTest(skip: skip);
}
