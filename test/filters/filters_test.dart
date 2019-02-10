library akcnik.tests.filter;

import "package:test/test.dart";
import "dart:convert";
import "../../server/src/model/library.dart" as model_lib;
import "../../server/src/modules/event/library.dart";
import "../../server/src/modules/place/library.dart";
import "../../server/src/modules/filter/common/library.dart";
import "../../server_libs/server/library.dart" as server_lib;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_route/shelf_route.dart' as shelf_route show Router;
import '../sample_data/library.dart' as sample;
import "../common.dart";
import "../../server/src/storage/library.dart" as storage_lib;
import 'package:akcnik/envelope.dart';
import '../../server_libs/access/library.dart';

//part "sample_data.dart";
part "event_filter_tests.dart";
part "place_filter_tests.dart";
part 'access_filter_tests.dart';

void main() {
  eventFilterTest();
  placeFilterTest();
  accessFilterTest();
}
