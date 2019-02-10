import '../../server/src/modules/filter/entity/library.dart';
import 'package:test/test.dart';
import '../../server/src/modules/filter/common/library.dart';
import '../../server/src/model/library.dart';
import 'package:akcnik/common/library.dart' as common_model;

TestModelList data = new TestModelList();
int entityCount = 40;

void main() {
  CustomFilter filter;
  RootFilter upgraded;
  for (int i = 0; i < entityCount; i++) {
    data.add(new TestEntity()..fromNumber(i));
  }
//  group("failed create",(){
//    test()
//  });
  group("failed data", () {
    setUp(() {});
    test("no value", () {
      filter = new CustomFilter("testFilter", "tests", validateTemplate: ["string"], data: []);
      expect(filter.invalid, true);
      expect(filter.invalidMessage, "data array [] should contains 1 items");
    });
    test("more values", () {
      filter = new CustomFilter("testFilter", "tests", validateTemplate: ["string"], data: ["cosi", "cosi"]);
      expect(filter.invalid, true);
      expect(filter.invalidMessage, "data array [cosi, cosi] should contains 1 items");
    });
    test("int value", () {
      filter = new CustomFilter("testFilter", "tests", validateTemplate: ["string"], data: [2]);
      expect(filter.invalid, true);
      expect(filter.invalidMessage, "0-th item from [2] should be string");
    });
  });
  group("Memory", () {
    setUp(() {
      filter = new CustomFilter("testFilter", "tests", matcher: (TestEntity entity) => entity.even == true);
    });
    test("init filter", () {
      expect(filter.toMap(), equals({"name": "testFilter", "type": "tests"}));
    });
    test("filter upgraded", () {
      expect(data.length, entityCount);
      upgraded = filter.upgrade();
      expect(upgraded
          .filter(data)
          .length, 20);
    });
    test("filter in rootFilter", () {
      upgraded = new RootFilter.fromFilters([filter]);
      expect(upgraded
          .filter(data)
          .length, 20);
    });
  });
  group("Pgsql", () {
    setUp(() {
      filter = new CustomFilter("testFilter", "tests",
          sqlTemplate: "@table.name = @0", validateTemplate: ["string"], data: ["cosi"]);
    });
    test("fromList one", () {
      expect(filter.sqlConstraint, "tests.name = E'cosi'");
    });
  });
}

class TestEntity extends common_model.Jsonable {
  bool even;

  void fromNumber(int number) {
    id = number;
    even = number % 2 == 1;
  }

  @override
  void fromMap(Map<String, dynamic> json) => null;

  @override
  Map<String, dynamic> toFullMap() => null;

  @override
  Map<String, dynamic> toSafeMap() => null;
}

class TestModelList extends ModelList<TestEntity> {
  String type = "tests";

  @override
  ModelList<TestEntity> copyType() => new TestModelList();

  @override
  TestEntity entityFactory() => new TestEntity();
}
