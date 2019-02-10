library akcnik.tests.server_libs;

import "package:test/test.dart";
import "dart:convert";
import "dart:async";
//import "package:unittest/vm_config.dart";
//import "../lib/common/database_test.dart" as common;
//import "../server/main.dart" as server;
import "../../server_libs/server/library.dart" as server_lib;
//import "../server_libs/sidos/database_test.dart" as sidos;
//import "../server_libs/data_types/database_test.dart";
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_route/shelf_route.dart' as shelf_router;
//import "../server_libs/data_types/database_test.dart" as common;
//import "../../server/src/model/library.dart" as model_lib;
import "../common.dart";
import 'package:akcnik/envelope.dart' as envelope;

part "server_libs_tests.dart";
part "server_libs_execution_tests.dart";
//part "imprint_tests.dart";

void main() {
  serverLibsTest();
  serverLibsExecutionTest();
}
