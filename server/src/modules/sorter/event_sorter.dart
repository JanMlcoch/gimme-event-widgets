part of sorter_module;

class EventSorter extends SorterBase {
  EventSorter build(String name, bool ascending) {
    _ascending = ascending;
    switch (name) {
      case "name":
        _comparator = (Event event1, Event event2) => event1.name.compareTo(event2.name);
        break;
      case "price":
        _comparator = (Event event1, Event event2) => event1.representativePrice.compareTo(event2.representativePrice);
        break;
      case "startDate":
        _comparator = (Event event1, Event event2) => event1.from.compareTo(event2.from);
        break;
      case "profileQuality":
        _comparator = (Event event1, Event event2) => event1.profileQuality.compareTo(event2.profileQuality);
        break;
      default:
        return null;
    }
    return this;
  }
}
