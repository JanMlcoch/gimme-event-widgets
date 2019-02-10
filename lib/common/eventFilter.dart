part of common;

typedef bool FilterFunction(EventBase event, dynamic param);

class FilterHelper {
  static Map<int, EventFilter> filters = {
    1: new EventFilter("TagFilter", (EventBase event, String tag) => event.tags.contains(tag)),
    2: new EventFilter("PartNameFilter", (EventBase event, String name) => event.name.contains(name)),
    3: new EventFilter("PlaceFilter", (EventBase event, String place) => event.place.contains(place)),
    4: new EventFilter("DateFromFilter", (EventBase event, DateTime from) => event.from.compareTo(from) >= 0),
    5: new EventFilter("DateToFilter", (EventBase event, DateTime to) => event.to.compareTo(to) <= 0),
    6: new EventFilter("PriceFromFilter", (EventBase event, num from) => event.priceToCZK() >= from),
    7: new EventFilter("priceToFilter", (EventBase event, num to) => event.priceToCZK() <= to),
    8: new EventFilter("eventTagFilter", (EventBase event, String tag) => event.eventTag.contains(tag)),
  };
  static Map<int, EventFilter> getFilters() {
    return filters;
  }
}

class EventFilter {
  String name;
  FilterFunction filter;
//  String paramType;
  EventFilter(this.name, this.filter);
}
