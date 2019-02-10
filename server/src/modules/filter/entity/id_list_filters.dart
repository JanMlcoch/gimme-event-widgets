part of filter_module.entity;

abstract class IdListAnyFilter<T extends Jsonable> extends FilterBase<T> {
  Iterable<int> _ids;
  final String filterType;

  IdListAnyFilter(String filterName, String filterType, List data)
      : filterType=filterType,
        super(filterName, const ["Iterable<int>"], data);

  void fromList(List data) {
    if (data.first is Iterable<int>) {
      _ids = data.first as Iterable<int>;
    }
  }

  bool match(T entity) => _ids.contains(entity.id);

  String get sqlConstraint => "$filterType.id IN (" + _ids.join(", ") + ")";

  static FilterBase byTable(String table, List data) {
    switch (table) {
      case TABLE_EVENTS:
        return new IdListEventFilter(data);
      case TABLE_PLACES:
        return new IdListPlaceFilter(data);
      case TABLE_ORGANIZERS:
        return new IdListOrganizerFilter(data);
      case TABLE_USERS:
        return new IdListUserFilter(data);
}
return null;
}
}

class IdListEventFilter extends IdListAnyFilter<Event> {
  IdListEventFilter(List data) : super("event_id_list", TABLE_EVENTS, data);
}

class IdListPlaceFilter extends IdListAnyFilter<Place> {
  IdListPlaceFilter(List data) : super("place_id_list", TABLE_PLACES, data);
}

class IdListOrganizerFilter extends IdListAnyFilter<Organizer> {
  IdListOrganizerFilter(List data) : super("organizer_id_list", TABLE_ORGANIZERS, data);
}

class IdListUserFilter extends IdListAnyFilter<User> {
  IdListUserFilter(List data) : super("user_id_list", TABLE_USERS, data);
}