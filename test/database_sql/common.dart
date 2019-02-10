part of akcnik.tests.database_sql;

class TestEventSqlCompiler extends queries_lib.IdKeyCompiler {
  static const String _table = "test_events";
  static const List<String> insertColumns = const [
    "name",
    "from",
    "to",
    "language",
    "clientSettings",
    "serverSettings",
    "description",
    "maxParticipants",
    "expectedParticipants",
    "webpage",
    "socialNetworks"
  ];
  static const List<String> returnColumns = const [
    "id",
    "name",
    "from",
    "to",
    "language",
    "price",
    "clientSettings",
    "description",
    "maxParticipants",
    "expectedParticipants",
//    "guestRateSum",
//    "guestRateCount",
    "webpage",
    "socialNetworks"
  ];

  TestEventSqlCompiler() : super(_table, insertColumns, returnColumns);
}
