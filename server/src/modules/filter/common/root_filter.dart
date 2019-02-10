part of filter_module.common;

class RootFilter {
  static RootFilter nope = new NopeFilter();
  static RootFilter pass = new PassFilter();
  List<FilterBase> _filters = [];

  RootFilter.fromFilters(this._filters);

  factory RootFilter.construct(List jsonArray, EnvelopeHolder message) {
    assert(message != null);
    if (jsonArray == null || jsonArray.isEmpty) return pass;
    for (dynamic json in jsonArray) {
      if (json is! Map) {
        message.error('$json should be Map', BAD_FILTER);
        return nope;
      }
      if (!json.containsKey("name")) {
        message.error('$json should contains "name"', BAD_FILTER);
        return nope;
      }
      if (!json.containsKey("data")) {
        message.error('$json should contains "data"', BAD_FILTER);
        return nope;
      }
      if (json["data"] is! List) {
        message.error('$json[data] should be List', BAD_FILTER);
        return nope;
      }
      if (json["name"] is! String) {
        message.error('$json[name] should be String', BAD_FILTER);
        return nope;
      }
    }
    List<FilterBase> filters = [];
    for (Map filterJson in jsonArray) {
      FilterBase filter;
      filter = filterFactory(filterJson["name"], filterJson["data"]);
      if (filter == null) {
        message.error('unknown filter type: "${filterJson["name"]}"', BAD_FILTER);
        return nope;
      }
      if (filter.invalid) {
        message.error(
            'Filter ${filter.filterName} have source data in incorrect format: ${filter.invalidMessage}', BAD_FILTER);
        return nope;
      }
      filters.add(filter);
    }
    return new RootFilter.fromFilters(filters);
  }

//  String _getFilterTypeByModelList(ModelList modelList) {
//    if (modelList is Events) return "events";
//    if (modelList is Users) return "users";
//    if (modelList is Places) return "places";
//    if (modelList is Organizers) return "organizers";
//    throw new StateError("unknown ModelList in rootFilter");
//    return "";
//  }

  ModelList filter(ModelList modelList, {int limit: -1}) {
    if (_filters.length == 0) return modelList;
    List<FilterBase> filters = _reduce(modelList.type);
    if (filters == null) return modelList;
    ModelList modelListCopy = modelList.copyType();
    if (limit == -1) {
      for (dynamic entity in modelList.list) {
        if (filters.every((FilterBase filter) => filter.match(entity))) {
          modelListCopy.add(entity);
        }
      }
      return modelListCopy;
    }
    for (dynamic entity in modelList.list) {
      if (filters.every((FilterBase filter) => filter.match(entity))) {
        modelListCopy.add(entity);
        if (modelListCopy.length >= limit) {
          return modelListCopy;
        }
      }
    }
    return modelListCopy;
    //print(list.toString()+" - "+toJson().toString());
  }

  bool any(ModelList modelList) {
    if (_filters.length == 0) return modelList.length > 0;
    List<FilterBase> filters = _reduce(modelList.type);
    if (filters == null) return modelList.length > 0;
    return modelList.list.any((dynamic entity) => filters.every((FilterBase filter) => filter.match(entity)));
  }

  String getSqlConstraint(String filterType) {
    if (_filters.length == 0) return null;
    List<FilterBase> filters = _reduce(filterType);
    if (_filters.length == 0) return null;
    List<String> constrainParts = [];
    for (FilterBase filter in filters) {
      String constrainPart = filter.sqlConstraint;
      if (constrainPart != null) {
        constrainParts.add(constrainPart);
      }
    }
    if (constrainParts.length == 0) return null;
    if (constrainParts.length == 1) return constrainParts.first;

    return constrainParts.join(" AND ");
  }

  List<FilterBase> _reduce(String filterType) {
    if (_filters.length == 0) return null;
//    print(_filters.map((FilterBase filter)=>filter.toJson()).toString());
    List<FilterBase> reducedFilters = [];
    for (FilterBase filter in _filters) {
      if (filterType == filter.filterType) {
        reducedFilters.add(filter);
      }
    }
    //if (reducedFilters.length == 0) print(toJson().toString()+" filtered by $filterType reduced to 0");
    if (reducedFilters.length == 0) return null;
    //print(toJson().toString()+" filtered by $filterType reduced to "+reducedFilter.toJson().toString());
    return reducedFilters;
  }

  //bool _match(dynamic entity) => _filters.every((FilterBase filter) => filter._match(entity));

  List<Map<String, dynamic>> toList() {
    return _filters.map((FilterBase filter) => filter.toMap()).toList();
  }

  RootFilter concat(RootFilter filter) {
    if (filter == nope) return filter;
    if (filter == pass) return this;
    return new RootFilter.fromFilters(new List.from(_filters)..addAll(filter._filters));
  }
}
