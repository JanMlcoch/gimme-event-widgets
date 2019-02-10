library akcnik.tests.models;

import "package:test/test.dart";
//import "dart:convert";
import "../../lib/common/library.dart" as common_lib;
import "../../server/src/model/library.dart" as model_lib;
//import "../../server/src/modules/event/database_test.dart";
//import "../../server/src/modules/filter/database_test.dart";
//import "../../server_libs/server/database_test.dart" as server_lib;
//import 'package:shelf/shelf.dart' as shelf;
//import "../all_test.dart";

part "common.dart";
part "place_tests.dart";
part "cost_tests.dart";
part "event_tests.dart";

void main() {
  placeTests();
  costTests();
  eventTests();
}
