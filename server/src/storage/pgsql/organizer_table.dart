part of storage.pgsql;

class OrganizerPgsqlTable extends PgsqlTableCode<Organizer> {
  static final query_lib.OrganizerSqlCompiler _queries = new query_lib.OrganizerSqlCompiler();

  @override
  query_lib.SqlCompiler get queries => _queries;

  @override
  Map<String, dynamic> _fromDatabaseJson(Map<dynamic, dynamic> json) {
    if (json is Map<String, dynamic>) return json;
    Map<String, dynamic> transformed = {};
    json.forEach((dynamic key, dynamic value) {
      transformed[key.toString()] = value;
    });
    return transformed;
  }

  Map<String, dynamic> _toDatabaseJson(Map<String, dynamic> json) => json;

  @override
  ModelList _rowsToModelList(List<pgsql.Row> rows) {
    Organizers organizers = new Organizers();
    rows.forEach((pgsql.Row row) {
      Organizer organizer = new Organizer();
      organizer.fromMap(_fromDatabaseJson(row.toMap()));
      organizers.add(organizer);
    });
    return organizers;
  }
}
