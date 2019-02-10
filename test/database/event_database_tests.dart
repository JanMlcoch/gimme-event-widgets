part of akcnik.tests.database;

void eventDatabaseTest({skip: false}) {
  group("EventDatabase", () {
    group("Invalid inserts", () {
      test("NULL into not null", () async {
        await connectHandler((pgsql.Connection connection) async {
          String query = """INSERT INTO events (name,\"from\",\"tagIds\",\"costs\")
          VALUES ('City run v Ostrava','2016-06-23','[1,6]','{"student":100}');""";
          try {
            await connection.execute(query);
            fail("should throw error");
          } catch (e) {
            print(e.toString());
            expect(e.toString(), 'ERROR 23502 null value in column "to" violates not-null constraint');
          }
        });
      });
      test("invalid date", () async {
        await connectHandler((pgsql.Connection connection) async {
          String query = """INSERT INTO events (name,\"from\",\"to\",\"tagIds\",\"costs\")
          VALUES ('City run v Ostrava','2016-06-23','wrongdate','[1,6]','{"student":100}');""";
          try {
            await connection.execute(query);
            fail("should throw error");
          } catch (e) {
            expect(e.toString(), 'ERROR 22007 invalid input syntax for type timestamp with time zone: "wrongdate"');
          }
        });
      });
      test("invalid bool", () async {
        await connectHandler((pgsql.Connection connection) async {
          String query = """INSERT INTO events (name,\"from\",\"to\",\"tagIds\",\"costs\",\"private\")
          VALUES ('City run v Ostrava','2016-06-23','2016-06-23','[1,6]','{"student":100}','fasle');""";
          try {
            await connection.execute(query);
            fail("should throw error");
          } catch (e) {
            expect(e.toString(), 'ERROR 22P02 invalid input syntax for type boolean: "fasle"');
          }
        });
      });
      test("invalid JSON", () async {
        await connectHandler((pgsql.Connection connection) async {
          String query = """INSERT INTO events (name,\"from\",\"to\",\"tagIds\",\"costs\")
            VALUES ('City run v Ostrava','2016-06-23','2016-06-23','[1,6]','{"studen00}');""";
          try {
            await connection.execute(query);
            fail("should throw error");
          } catch (e) {
            expect(e.toString(), 'ERROR 22P02 invalid input syntax for type json');
          }
        });
      });
    });
    group("Add event", () {
      test("Add event", () async {
        await connectHandler((pgsql.Connection connection) async {
          String query = """INSERT INTO events (name,\"from\",\"to\",\"tagIds\",\"costs\",\"placeId\",\"ownerId\")
            VALUES ('City run v Zábřeh','2016-06-23','2016-06-23','[1,6]','{"student":100}',100,2);""";
          return connection.execute(query);
        });
        expect(true, true);
      });
    });
  }, skip: skip);
}
