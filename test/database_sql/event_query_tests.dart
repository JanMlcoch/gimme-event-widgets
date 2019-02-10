part of akcnik.tests.database_sql;

void eventQueryTest() {
  queries_lib.EventSqlCompiler eventCompiler;
  queries_lib.PlaceInEventSqlCompiler placeInEventCompiler;

  TestEventSqlCompiler testEventCompiler = new TestEventSqlCompiler();
  placeInEventCompiler = new queries_lib.PlaceInEventSqlCompiler();
  group("Event Query", () {
    group("init SqlCompilers", () {
      test("eventCompiler", () {
        eventCompiler = new queries_lib.EventSqlCompiler();
        expect(eventCompiler, isNotNull);
        expect(eventCompiler.ownTable, "events");
      });
      test("placeInEventCompiler", () {
        placeInEventCompiler = new queries_lib.PlaceInEventSqlCompiler();
        expect(placeInEventCompiler, isNotNull);
        expect(placeInEventCompiler.ownTable, "place_in_event");
      });
    });
    group("eventCompiler", () {
      Map<String, dynamic> eventJson = {
        "id": 5,
        "name": "testEvent",
        "from": "2016-12-24",
        "to": "2016-12-25",
        "clientSettings": {
          "public": true,
          "otherLanguages": ["de", "en", "pl"]
        },
        "language": "cz",
        "description": "Vánoční test event",
        "maxParticipants": 300,
        "expectedParticipants": 250,
        "webpage": "http://www.vanove.cz",
        "socialNetworks": {"facebook": "blavl", "google+": "není"}
      };
      final String targetQuery =
          'BEGIN TRANSACTION; INSERT INTO test_events ("name", "from", "to", "language", "clientSettings", "serverSettings", "description", "maxParticipants", "expectedParticipants", "webpage", "socialNetworks") VALUES (E\'testEvent\', E\'2016-12-24\', E\'2016-12-25\', E\'cz\', \'{"public":true,"otherLanguages":["de","en","pl"]}\', DEFAULT, E\'Vánoční test event\', 300, 250, E\'http://www.vanove.cz\', \'{"facebook":"blavl","google+":"není"}\'); ' +
              'SELECT test_events."id", test_events."name", test_events."from", test_events."to", test_events."language", test_events."price", test_events."clientSettings", test_events."description", test_events."maxParticipants", test_events."expectedParticipants", test_events."webpage", test_events."socialNetworks" FROM test_events WHERE "id" = (SELECT currval(\'test_events_id_seq\')); COMMIT TRANSACTION;';
      test("insertQuery", () {
        String query = testEventCompiler.constructInsertQuery(eventJson);
        expect(query, targetQuery);
      });
      test("insertMultipleQuery", () {
        String query = testEventCompiler.constructMultipleInsertQuery([eventJson]);
        expect(query, targetQuery);
      });
      test("updateQuery", () {
        String query = testEventCompiler.constructUpdateQuery(["name", "from", "maxParticipants"], eventJson);
        String targetQuery =
            'BEGIN TRANSACTION; UPDATE test_events SET "name" = E\'testEvent\', "from" = E\'2016-12-24\', "maxParticipants" = 300 WHERE "id" = 5;' +
                ' SELECT test_events."id", test_events."name", test_events."from", test_events."to", test_events."language", test_events."price", test_events."clientSettings", test_events."description", test_events."maxParticipants", test_events."expectedParticipants", test_events."webpage", test_events."socialNetworks" FROM test_events WHERE "id" = 5; COMMIT TRANSACTION;';
        expect(query, targetQuery);
      });
      test("deleteQuery", () {
        String query = testEventCompiler.constructDeleteQuery(eventJson);
        String targetQuery = 'DELETE FROM test_events WHERE "id" = 5 RETURNING test_events."id", test_events."name", test_events."from", test_events."to", test_events."language", test_events."price", test_events."clientSettings", test_events."description", test_events."maxParticipants", test_events."expectedParticipants", test_events."webpage", test_events."socialNetworks";';
        expect(query, targetQuery);
      });
      test("multipleDeleteQuery", () {
        String query = testEventCompiler.constructMultipleDeleteQuery([eventJson]);
        String targetQuery = 'DELETE FROM test_events WHERE "id" IN (5);';
        expect(query, targetQuery);
      });
    });
    group("placeInEventCompiler", () {
      Map<String, dynamic> placeInEventJson = {"placeId": 5, "eventId": 6, "description": "test", "mapFlag": true};
      final String targetQuery =
          'INSERT INTO place_in_event ("eventId", "placeId", "description") VALUES (6, 5, E\'test\') RETURNING "eventId", "placeId", "description";';
      test("insertQuery", () {
        String query = placeInEventCompiler.constructInsertQuery(placeInEventJson);
        expect(query, targetQuery);
      });
      test("insertMultipleQuery", () {
        String query = placeInEventCompiler.constructMultipleInsertQuery([placeInEventJson]);
        expect(query, targetQuery);
      });
      test("updateQuery", () {
        String query = placeInEventCompiler.constructUpdateQuery(["placeId", "description"], placeInEventJson);
        String targetQuery =
            'UPDATE place_in_event SET "placeId" = 5, "description" = E\'test\' WHERE "eventId" = 6 AND "placeId" = 5;';
        expect(query, targetQuery);
      });
      test("deleteQuery", () {
        String query = placeInEventCompiler.constructDeleteQuery(placeInEventJson);
        String targetQuery = 'DELETE FROM place_in_event WHERE "eventId" = 6 AND "placeId" = 5;';
        expect(query, targetQuery);
      });
      test("multipleDeleteQuery", () {
        String query = placeInEventCompiler.constructMultipleDeleteQuery([
          placeInEventJson,
          {"eventId": 6, "placeId": 8}
        ]);
        String targetQuery = 'DELETE FROM place_in_event WHERE "eventId" = 6 AND "placeId" IN (5, 8);';
        expect(query, targetQuery);
      });
      test("multipleDeleteInsertQuery", () {
        String query = placeInEventCompiler.constructMultipleDeleteInsertQuery(6, [placeInEventJson]);
        String targetQuery =
            'DELETE FROM place_in_event WHERE "eventId" = 6;INSERT INTO place_in_event ("eventId", "placeId", "description") VALUES (6, 5, E\'test\') RETURNING "eventId", "placeId", "description";';
        expect(query, targetQuery);
      });
      test("multipleDeleteInsertQuery complex", () {
        String query = placeInEventCompiler.constructMultipleDeleteInsertQuery(6, [
          placeInEventJson,
          {"placeId": 7}
        ]);
        String targetQuery =
            'DELETE FROM place_in_event WHERE "eventId" = 6;INSERT INTO place_in_event ("eventId", "placeId", "description") VALUES (6, 5, E\'test\'), (6, 7, DEFAULT) RETURNING "eventId", "placeId", "description";';
        expect(query, targetQuery);
      });
    });
  });
}
