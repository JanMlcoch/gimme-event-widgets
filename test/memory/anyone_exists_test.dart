import 'package:test/test.dart';
import 'common.dart';
import "../../server/src/storage/library.dart" as storage_lib;
import '../../server/src/modules/filter/common/library.dart' as filter_module;
import '../../server/src/modules/filter/entity/library.dart' as entity_filters;
import 'dart:async';

Future main() async {
  init();
  storage_lib.Connection connection = await storage_lib.storage.getConnection(onlyMemory: true);
  group("init data", () {
    test("testRun", () {
      expect(storage_lib.storage.testRun(), completes);
    });
  });
  group("Events", () {
    test("empty filter", () {
      expect(connection.events.anyoneExists(null), completion(isTrue));
    });
    test("pass filter", () {
      expect(connection.events.anyoneExists(filter_module.RootFilter.pass), completion(isTrue));
    });
    test("nope filter", () {
      expect(connection.events.anyoneExists(filter_module.RootFilter.nope), completion(isFalse));
    });
    test("festival subname => true", () {
      expect(connection.events.anyoneExists(new entity_filters.SubNameEventFilter(["festival"]).upgrade()),
          completion(isTrue));
    });
    test("fesfival subname => false", () {
      expect(connection.events.anyoneExists(new entity_filters.SubNameEventFilter(["fesfival"]).upgrade()),
          completion(isFalse));
    });
    test("<2015-12-25, 2015-12-29>", () {
      expect(
          connection.events.anyoneExists(new entity_filters.FromToEventFilter(
              [
                DateTime
                    .parse("2015-12-25")
                    .millisecondsSinceEpoch,
                DateTime
                    .parse("2015-12-29")
                    .millisecondsSinceEpoch
              ]).upgrade()),
          completion(isTrue));
    });
    test("<2015-08-25, 2015-09-29>", () {
      expect(
          connection.events.anyoneExists(new entity_filters.FromToEventFilter(
              [
                DateTime
                    .parse("2015-08-25")
                    .millisecondsSinceEpoch,
                DateTime
                    .parse("2015-09-29")
                    .millisecondsSinceEpoch
              ]).upgrade()),
          completion(isFalse));
    });
    test("<2015-06-06, 2015-06-21>", () {
      expect(
          connection.events.anyoneExists(new entity_filters.FromToEventFilter(
              [
                DateTime
                    .parse("2015-06-06")
                    .millisecondsSinceEpoch,
                DateTime
                    .parse("2015-06-21")
                    .millisecondsSinceEpoch
              ]).upgrade()),
          completion(isFalse));
    });
    test("<2015-07-21, 2015-08-21>", () {
      expect(
          connection.events.anyoneExists(new entity_filters.FromToEventFilter(
              [
                DateTime
                    .parse("2015-07-21")
                    .millisecondsSinceEpoch,
                DateTime
                    .parse("2015-08-21")
                    .millisecondsSinceEpoch
              ]).upgrade()),
          completion(isTrue));
    });
  });
}