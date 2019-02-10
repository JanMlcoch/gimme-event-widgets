import 'dart:async';
import 'common.dart';
import "package:test/test.dart";
import "package:postgresql/postgresql.dart" as pgsql;
import '../../server/src/modules/filter/entity/library.dart' as entity_filter;
import '../../server/src/modules/filter/common/library.dart' as common_filter;
import '../../server/src/storage/library.dart' as storage_lib;
import '../../server/src/model/library.dart' as model_lib;

Future main() async {
  bool skip = await skipDatabase();
  entity_filter.CustomFilter rawFilter;
  common_filter.RootFilter filter;
  common_filter.RootFilter compareFilter;
  storage_lib.DataStorage storage = await storage_lib.loadStorage(pgsqlUri: "devel");
  group("customSqlFilter",(){
    group("init filter",(){
      test("basic filter",(){
        expect(
            new Future(() => new entity_filter.CustomFilter("test5Filter", "events", sqlTemplate: '@table."id" = 5')),
            completes);
      });
      test("filter with data", () {
        rawFilter = new entity_filter.CustomFilter(
            "test5Filter", "events", sqlTemplate: '@table."id" = 5', validateTemplate: ["int"], data: [5]);
        expect(rawFilter.invalid, isFalse);
      });
      test("failed filter", () {
        rawFilter = new entity_filter.CustomFilter(
            "test5Filter", "events", sqlTemplate: '@table."id" = 5', validateTemplate: ["int"], data: ["5"]);
        expect(rawFilter.invalid, isTrue);
        expect(rawFilter.invalidMessage, "0-th item from [5] should be int");
      });
      test("upgraded filter", () {
        filter = new entity_filter.CustomFilter(
            "test5Filter", "events", sqlTemplate: '@table."id" = 5', validateTemplate: ["int"], data: [5]).upgrade();
        expect(filter, isNot(common_filter.RootFilter.nope));
      });
      test("failed upgraded filter", () {
        filter = new entity_filter.CustomFilter(
            "test5Filter", "events", sqlTemplate: '@table."id" = 5', validateTemplate: ["int"], data: ["5"]).upgrade();
        expect(filter, equals(common_filter.RootFilter.nope));
      });
    });
    group("filtering",(){
      storage_lib.Connection connection;
      test("ID filter",()async{
        connection = await storage.getConnection(noMemory: true);
        try {
          compareFilter = new entity_filter.IdListEventFilter([[150]]).upgrade();
          filter =
              new entity_filter.CustomFilter("test150Filter", "events", sqlTemplate: '@table."id" = 150').upgrade();
          model_lib.Events eventsFromCustom = await connection.events.load(filter, ["id", "name", "from", "to"]);
          model_lib.Events eventsFromCompare = await connection.events.load(
              compareFilter, ["id", "name", "from", "to"]);
          expect(eventsFromCustom.length, 1);
          expect(eventsFromCustom.toFullList(), equals(eventsFromCompare.toFullList()));
        } finally {
          connection.close();
        }
      });
      group("unused own places filter",(){
        String constraint;
        setUp((){
          filter = new entity_filter.CustomFilter("testOwnUnusedFilter", "places", sqlTemplate: '''@table."id" IN (select distinct @table."id"
          from @table left outer join events on @table."id" = events."placeId" and events."ownerId" != 1
          where @table."ownerId"=1 and not @table."deleted"
          and (events."to"<NOW() or events."ownerId" is null or events IS NULL))''',
              validateTemplate: ["int"],
              data: [1]).upgrade();
          constraint = """places."id" IN (select distinct places."id"
          from places left outer join events on places."id" = events."placeId" and events."ownerId" != 1
          where places."ownerId"=1 and not places."deleted"
          and (events."to"<NOW() or events."ownerId" is null or events IS NULL))""";
        });
        test("same constraint",(){
          expect(filter.getSqlConstraint("places"),constraint);
        });
        test("filtering",()async{
          connection = await storage.getConnection(noMemory: true);
          try {
            model_lib.Places placesFromCustom = await connection.places.load(
                filter, ["id", "latitude", "longitude", "name", "description", "city"], limit: -1);

            expect(placesFromCustom.length, greaterThan(0));
            model_lib.Places placesFromCompare = new model_lib.Places();

            List<pgsql.Row> rows = await connection.connection.query("""
              select places."id", places."latitude", places."longitude", places."name",
              places."description", places."city"
              from places
              where $constraint
              order by places."id" desc
                  """).toList();
            for (pgsql.Row row in rows) {
              placesFromCompare.add(new model_lib.Place()..fromMap(row.toMap() as Map<String, dynamic>));
            }
            expect(placesFromCustom.toFullList(), unorderedEquals(placesFromCompare.toFullList()));
          } finally {
            connection.close();
          }
        });
      });
    },skip: skip);
  });
}
