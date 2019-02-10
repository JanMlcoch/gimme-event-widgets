part of filter_module.common;

class NopeFilter extends RootFilter {
  NopeFilter() : super.fromFilters([]);

  ModelList filter(ModelList modelList, {int limit: -1}) => modelList.copyType();

  bool any(ModelList modelList) => false;
  String getSqlConstraint(String filterType) => "TRUE = FALSE";

  List<Map<String, dynamic>> toList() => [
    {"type": "nope"}
  ];

  RootFilter concat(RootFilter filter) => this;
}
