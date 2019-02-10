part of akcnik.tests.database;

void databaseReset({skip: false}) {
  group("Database initiation", () {
    test("database migration", () {
      expect(
          migration.main(["-fpv", "-dmigration"]),
          completion(isTrue));
    });
    test("database migration with test data", () {
      expect(
          migration.main(["-fv", "-dmigration"]),
          completion(isTrue));
    });
  }, skip: skip);
}
