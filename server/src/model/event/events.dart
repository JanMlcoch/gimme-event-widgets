part of model;

class Events extends ModelList<Event> {
  String type = "events";

  List<Event> get list => _list;

  @override
  Event entityFactory() => new Event();

  List<int> getEventsIdList() {
    List<int> eventIds = [];
    for (Event event in _list) {
      eventIds.add(event.id);
    }
    return eventIds;
  }

  ///Sorts events by ids regarding given [idList]
  Events getSortedAsEventsIdList(List<int> idList) {
    if (idList == null) {
      return this;
    } else {
      List<Event> eventList = _list.toList();
      eventList.sort((Event event1, Event event2) {
        return idList.indexOf(event1.id).compareTo(idList.indexOf(event2.id));
      });
      return new Events()..addAll(eventList);
    }
  }

  List<Map<String, dynamic>> toEventDetailList() {
    List<Map<String, dynamic>> out = [];
    for (Event e in _list) {
      out.add(e.toEventDetailMap());
    }
    return out;
  }

  List<Map<String, dynamic>> toEventListList() {
    return list.map((Event event) => event.toEventListMap()).toList();
  }

  @override
  Events copyType() => new Events();
}
