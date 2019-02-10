part of filter_module.entity;

abstract class EventFilter extends FilterBase<Event> {
  String filterType = "events";

  EventFilter(String filterName, List<String> validateTemplate, List data) : super(filterName, validateTemplate, data);
}

//##############################################################################
class SubNameEventFilter extends EventFilter {
  String _subName;

  SubNameEventFilter(List data) : super("event_subname", const ["string"], data);

  void fromList(List<dynamic> jsonArray) {
    _subName = jsonArray.first;
  }

  String get sqlConstraint => "$filterType.\"name\" LIKE ${safeConvert("%$_subName%")}";

  bool match(Event event) => event.name.contains(_subName);
}

//##############################################################################
class FromToEventFilter extends EventFilter {
  DateTime _from;
  DateTime _to;

  FromToEventFilter(List data) : super("event_in_interval", const ["int", "int"], data);

  void fromList(List data) {
    _from = new DateTime.fromMillisecondsSinceEpoch(data.first as int);
    _to = new DateTime.fromMillisecondsSinceEpoch(data[1] as int);
  }

  String get sqlConstraint =>
      "($filterType.from, $filterType.to) OVERLAPS (${_from.toIso8601String()}, ${_to.toIso8601String()})";

  bool match(Event event) => event.from.isBefore(_to) && !event.to.isBefore(_from);
}

//##############################################################################
class FutureEventFilter extends EventFilter {
  DateTime _today;

  FutureEventFilter() : super("event_in_future", null, null);

  void fromList(List<dynamic> jsonArray) {
    _today = new DateTime.now();
  }

  String get sqlConstraint => "$filterType.to > now()";

  bool match(Event event) => event.to.isAfter(_today);
}

//##############################################################################
//class IdEventFilter extends FilterBase {
//  int _id;
//
//  IdEventFilter() : super("event_id", "events", const ["int"]);
//
//  void fromList(List<dynamic> jsonArray) {
//    _id = jsonArray.first;
//  }
//
//  String get sqlConstraint => "$filterType.id = $_id)";
//  bool match(Event event) => _id == event.id;
//}

//##############################################################################
class PriceIntervalFilter extends EventFilter {
  double _lower;
  double _upper;

  PriceIntervalFilter(List data) : super("price_interval", const ["num", "num", "string"], data);

  void fromList(List data) {
    String currency = data[2];
    double rate = CurrencyRater.getInstance().getRateToUnited(currency);
    _lower = (data.first as num).toDouble() / rate;
    _upper = (data[1] as num).toDouble() / rate;
  }

  bool match(Event event) {
    double price = event.representativePrice;
    return price >= _lower && price <= _upper;
  }

  @override
  String get sqlConstraint => "$filterType.\"price\" BETWEEN $_lower AND $_upper";
}
