part of filter_module.entity;

abstract class IdAnyFilter<T extends Jsonable> extends FilterBase<T> {
  int _id;
  final String filterType;

  IdAnyFilter(String filterName, String filterType, this._id)
      :filterType=filterType,
        super(filterName, null, null);

  void fromList(List jsonArray) {}

  bool match(entity) => _id == entity.id;

  String get sqlConstraint => "$filterType.id = $_id";
}

class IdEventFilter extends IdAnyFilter<Event> {
  IdEventFilter(int id) : super("event_id", TABLE_EVENTS, id);
}

class IdPlaceFilter extends IdAnyFilter<Place> {
  IdPlaceFilter(int id) : super("place_id", TABLE_PLACES, id);
}

class IdOrganizerFilter extends IdAnyFilter<Organizer> {
  IdOrganizerFilter(int id) : super("organizer_id", TABLE_ORGANIZERS, id);
}

class IdUserFilter extends IdAnyFilter<User> {
  IdUserFilter(int id) : super("user_id", TABLE_USERS, id);
}
