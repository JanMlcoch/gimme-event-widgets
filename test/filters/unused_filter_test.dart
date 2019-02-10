library akcnik.tests.filter.unused_filter;

import "../../server/src/storage/library.dart" as storage_lib;
import "../common.dart";
import 'package:test/test.dart';
import '../../server/src/modules/filter/access/library.dart' as access_filter;
import '../../server/src/modules/filter/common/library.dart' as common_filter;
import '../../server/src/modules/filter/entity/library.dart' as entity_filter;
import '../../server/src/model/library.dart';

part 'unused_filter_data.dart';

void main() {
  ModelRoot model = constructModel(eventsJson: eventsJson, placesJson: placesJson, usersJson: usersJson);
  storage_lib.loadMemoryStorage(model);
  access_filter.UnusedPlaceFilter unusedFilter;
  common_filter.RootFilter filter;
  Places filtered;
  test("init", () {
    expect(model.events.length, 6);
    expect(model.places.length, 16);
    expect(model.users.length, 2);
  });
  group("create", () {
    test("without params", () {
      unusedFilter = new access_filter.UnusedPlaceFilter(null);
      expect(unusedFilter.invalid, isTrue);
      expect(unusedFilter.invalidMessage, "data null should be User or int");
    });
    test("with string param", () {
      unusedFilter = new access_filter.UnusedPlaceFilter("string");
      expect(unusedFilter.invalid, isTrue);
      expect(unusedFilter.invalidMessage, "data string should be User or int");
    });
    test("with int param", () {
      unusedFilter = new access_filter.UnusedPlaceFilter(5);
      expect(unusedFilter.invalid, isFalse);
    });
  });
  group("memory", () {
    setUp(() {
      filter = new access_filter.UnusedPlaceFilter(5).upgrade();
    });
    test("get place 101", () {
      filter = new entity_filter.IdPlaceFilter(7).upgrade();
      filtered = filter.filter(model.places);
      expect(filtered.length, 1);
      expect(filtered.first.id, 7);
    });
    test("Place 101 is unused", () {
      filter = filter.concat(new entity_filter.IdPlaceFilter(101).upgrade());
      filtered = filter.filter(model.places);
      expect(filtered.length, 1);
      expect(filtered.first.id, 101);
    });
    test("all unused", () {
      filtered = filter.filter(model.places);
      List<int> passed = [1, 2, 4, 8, 9, 10, 11, 12, 13, 14, 101];
      expect(filtered.length, passed.length);
      for (int id in passed) {
        expect(filtered
            .getById(id)
            .id, id);
      }
    });
  });
}
