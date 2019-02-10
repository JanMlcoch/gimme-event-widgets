part of filter_module.entity;

class CustomFilter extends FilterBase<Jsonable> {
  final Function _matcher;
  final String _sqlConstraint;
  final String filterType;

  /**
   * Universal filter for any table and any selector.
   * use @table and @0, @1, ... to prevent SQL injection
   * */
  CustomFilter(String filterName, String filterType,
      {bool matcher(dynamic entity), String sqlTemplate: "", List<String> validateTemplate, List data})
      : _matcher = matcher,
        filterType=filterType,
        _sqlConstraint = data != null
            ? sqlSubstitute(sqlTemplate.replaceAll("@table", filterType), dataToMap(data))
            : sqlTemplate.replaceAll("@table", filterType),
        super(filterName, validateTemplate, data);

  @override
  void fromList(List jsonArray) {}

  @override
  bool match(entity) => _matcher(entity);

  @override
  String get sqlConstraint => _sqlConstraint;

  static Map<String, dynamic> dataToMap(List<dynamic> data) {
    Map<String, dynamic> map = {};
    for (int i = 0; i < data.length; i++) {
      map[i.toString()] = data[i];
    }
    return map;
  }
}
