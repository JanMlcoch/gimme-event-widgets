part of storage.pgsql.query;

class OrganizerSqlCompiler extends IdKeyCompiler {
  static const String _table = "organizers";
  static const List<String> fullColumns = const [
    "id",
    "name",
    "address",
    "identificationNumber",
    "organizerType",
    "description",
    "contact"
  ];
  static const List<String> insertColumns = const [
    "name",
    "address",
    "identificationNumber",
    "organizerType",
    "description",
    "contact"
  ];
  //############################################################################

  OrganizerSqlCompiler() : super(_table, insertColumns, fullColumns);

//############################################################################

//  @override
//  String _replaceSpecialColumns(String query, Iterable<String> columns) => query;
}
