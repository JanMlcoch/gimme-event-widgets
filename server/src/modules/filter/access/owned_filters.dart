part of filter_module.access;


class OwnedEventFilter extends _AccessFilterBase<Event> {
  OwnedEventFilter(dynamic user) : super("owned_events", TABLE_EVENTS, user);

  bool match(Event entity) {
    return entity.ownerId == userId;
  }

  String get sqlConstraint => "$filterType.\"ownerId\" = $userId";
}

class OwnedPlaceFilter extends _AccessFilterBase<Place> {
  OwnedPlaceFilter(dynamic user) : super("owned_places", TABLE_PLACES, user);

  @override
  bool match(Place entity) {
    return entity.ownerId == userId;
  }

  @override
  String get sqlConstraint => "$filterType.\"ownerId\" = $userId";
}

class OwnedOrganizerFilter extends _AccessFilterBase<Organizer> {
  OwnedOrganizerFilter(dynamic user) : super("owned_organizers", TABLE_ORGANIZERS, user);

  @override
  bool match(Organizer entity) {
    return entity.ownerId == userId;
  }

  @override
  String get sqlConstraint => "$filterType.\"ownerId\" = $userId";
}

class OwnedUserFilter extends _AccessFilterBase<User> {
  OwnedUserFilter(dynamic user) : super("owned_users", TABLE_USERS, user);

  @override
  bool match(User entity) {
    return entity.id == userId;
  }

  @override
  String get sqlConstraint => "$filterType.id = $userId";
}
