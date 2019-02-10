part of filter_module.base;

abstract class FilterBase<T extends Jsonable> {
  final List<String> _validateTemplate;
  final String filterName;

  String get filterType;
  bool invalid = false;
  String invalidMessage;

  bool match(T entity);

  String get sqlConstraint;

  FilterBase(this.filterName, this._validateTemplate, List data) {
    _dataValidator(data);
    if (!invalid) fromList(data);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"name": filterName, "type": filterType};
    if (invalid) map["invalid"] = invalidMessage;
    return map;
  }

//  String getSqlConstraint(String filterType) {
//    if (filterType != filterType) return null;
//    return sqlConstraint;
//  }

  void fromList(List data);

  void _dataValidator(List data) {
    if (_validateTemplate == null && data == null) return;
    if (_validateTemplate.length != data.length) {
      invalid = true;
      invalidMessage = "data array $data should contains ${_validateTemplate.length} items";
      return;
    }
    for (int i = 0; i < _validateTemplate.length; i++) {
      bool correctType = true;
      switch (_validateTemplate[i]) {
        case "string":
          if (data[i] is! String) correctType = false;
          break;
        case "num":
          if (data[i] is! num) correctType = false;
          break;
        case "int":
          if (data[i] is! int) correctType = false;
          break;
        case "double":
          if (data[i] is! double) correctType = false;
          break;
        case "bool":
          if (data[i] is! bool) correctType = false;
          break;
        case "User":
          if (data[i] is! User) correctType = false;
          break;
        case "List<int>":
          if (data[i] is! List<int>) {
            correctType = false;
            break;
          }
          if ((data[i] as List).any((dynamic item) => item is! int)) correctType = false;
          break;
        case "Iterable<int>":
          if (data[i] is! Iterable<int>) {
            correctType = false;
            break;
          }
          if ((data[i] as Iterable).any((dynamic item) => item is! int)) correctType = false;
          break;
        default:
          invalid = true;
          invalidMessage = "Unknown type '${_validateTemplate[i]}' in filter validator";
          return;
      }
      if (!correctType) {
        invalid = true;
        invalidMessage = "$i-th item from $data should be ${_validateTemplate[i]}";
        return;
      }
    }
    return;
  }

  RootFilter upgrade({EnvelopeHolder message}) {
    if (invalid) {
      message?.error('Filter $filterName have source data in incorrect format: $invalidMessage', BAD_FILTER);
      return RootFilter.nope;
    }
    return new RootFilter.fromFilters([this]);
  }
}
