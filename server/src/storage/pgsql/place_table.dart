part of storage.pgsql;

class PlacePgsqlTable extends PgsqlTableCode<Place> {
  static final query_lib.PlaceSqlCompiler _queries = new query_lib.PlaceSqlCompiler();

  @override
  query_lib.SqlCompiler get queries => _queries;

  Map<String, dynamic> _toDatabaseJson(Map<String, dynamic> json) => json;

  Map<String, dynamic> _fromDatabaseJson(Map<dynamic, dynamic> json) {
    if (json is Map<String, dynamic>) return json;
    return null;
  }

  Places _rowsToModelList(List<pgsql.Row> rows) {
    Places places = new Places();
    rows.forEach((pgsql.Row row) {
      Place place = new Place();
      place.fromMap(_fromDatabaseJson(row.toMap()));
      places.add(place);
    });
    return places;
  }

}
