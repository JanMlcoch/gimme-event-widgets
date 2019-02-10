library akcnik.tests.memory;

import "package:test/test.dart";
//import "dart:convert";
//import "../../server_libs/server/library.dart" as server_lib;
//import 'package:shelf/shelf.dart' as shelf;
//import 'package:shelf_route/shelf_route.dart' as shelf_route;
//import "../common.dart";
import "../../server/src/storage/library.dart" as storage_lib;
import 'dart:async';
import '../../server/src/modules/filter/common/library.dart';
import 'common.dart';


Future main() async {
  init();
  storage_lib.Connection connection = await storage_lib.storage.getConnection(onlyMemory: true);
  group("init", () {
    test("testRun", () {
      expect(storage_lib.storage.testRun(), completes);
    });
  });
  group("functions", () {
    group("Users", () {
      test("missing", () async {
        Set<int> ids = await connection.users.missing([1, 2, 56], RootFilter.pass);
        expect(ids, [56].toSet());
      });
    });
  });
}
