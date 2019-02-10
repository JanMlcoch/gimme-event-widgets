part of filter_module.common;

class PassFilter extends RootFilter {
  PassFilter() : super.fromFilters([]);

  ModelList filter(ModelList modelList, {int limit: -1}) => modelList;

  bool any(ModelList modelList) => modelList.length > 0;

  String getSqlConstraint(String filterType) => null;

  List<Map<String, dynamic>> toList() => [
    {"type": "pass"}
  ];

  RootFilter concat(RootFilter filter) => filter;
}
