part of filter_module.access;

abstract class AccessLevel {
  RootFilter createAccessFilter(String permission, User user, String table, EnvelopeHolder message);
}

class AnonymousAccessLevel extends AccessLevel {
  final String level = "anonym";

  @override
  RootFilter createAccessFilter(String permission, User user, String table, EnvelopeHolder message) {
    switch (permission) {
      case Permissions.SHOW_EVENT:
        switch (table) {
          case TABLE_EVENTS:
            return new entity_filters.FutureEventFilter().upgrade(message: message);
          case TABLE_PLACES:
            return RootFilter.pass;
          case TABLE_EVENTS:
            return RootFilter.pass;
        }
        break;
    }
    message?.error("level \"$level\" not defined \"$permission\", returning Nope", MISSING_PERMISSIONS);
    return RootFilter.nope;
  }
}

class OwnAccessLevel extends AccessLevel {
  final String level = "own";

  @override
  RootFilter createAccessFilter(String permission, User user, String table, EnvelopeHolder message) {
    RootFilter filter;
    switch (table) {
      case TABLE_EVENTS:
        filter = _eventAccess(permission, user, message);
        break;
      case TABLE_PLACES:
        filter = _placeAccess(permission, user, message);
        break;
      case TABLE_ORGANIZERS:
        filter = _organizerAccess(permission, user, message);
        break;
      case TABLE_USERS:
        filter = _userAccess(permission, user, message);
        break;
    }
    if (filter != null) return filter;
    message?.error("level \"$level\" not defined for \"$permission\", returning Nope", MISSING_PERMISSIONS);
    return RootFilter.nope;
  }

  RootFilter _eventAccess(String permission, User user, EnvelopeHolder message) {
    switch (permission) {
      case Permissions.EDIT_EVENT:
      case Permissions.COMMENT_EVENT:
      case Permissions.DELETE_EVENT:
        return new OwnedEventFilter(user).upgrade(message: message);
    }
    return null;
  }

  RootFilter _placeAccess(String permission, User user, EnvelopeHolder message) {
    switch (permission) {
      case Permissions.EDIT_EVENT:
      case Permissions.COMMENT_EVENT:
      case Permissions.DELETE_EVENT:
        return RootFilter.pass;
      case Permissions.EDIT_PLACE:
      case Permissions.DELETE_PLACE:
        return new OwnedPlaceFilter(user).upgrade(message: message);
    }
    return null;
  }

  RootFilter _organizerAccess(String permission, User user, EnvelopeHolder message) {
    switch (permission) {
      case Permissions.EDIT_ORGANIZER:
      case Permissions.DELETE_ORGANIZER:
        return new OwnedOrganizerFilter(user).upgrade(message: message);
    }
    return null;
  }

  RootFilter _userAccess(String permission, User user, EnvelopeHolder message) {
    switch (permission) {
      case Permissions.SHOW_USER:
      case Permissions.EDIT_USER:
        return new OwnedUserFilter(user).upgrade(message: message);
    }
    return null;
  }
}
