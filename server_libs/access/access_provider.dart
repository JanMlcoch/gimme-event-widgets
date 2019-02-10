part of filter_module.access;

class AccessProvider {
  static AccessProvider _instance = new AccessProvider();
  AnonymousAccessLevel _anonymousLevel = new AnonymousAccessLevel();
  OwnAccessLevel _ownLevel = new OwnAccessLevel();

  static RootFilter createAccessFilter(String permission, String level, User user, String table,
      {EnvelopeHolder message: null}) =>
      _instance._createAccessFilter(permission, level, user, table, message: message);

  RootFilter _createAccessFilter(String permission, String level, User user, String table,
      {EnvelopeHolder message: null}) {
    if (permission == null) return RootFilter.pass;
    if (user == null) return _instance._anonymousLevel.createAccessFilter(permission, user, table, message);
    if (level == null) {
      message?.error("level=null for $permission from ${user.permissions}", MISSING_PERMISSIONS);
      return RootFilter.nope;
    }
    if (level == "any") return RootFilter.pass;

    //---------------------------------------------------
    RootFilter filter = RootFilter.pass;
    List<String> levels = level.split("-");
    if (levels.contains("none")) return RootFilter.nope;
    if (levels.contains("own")) {
      filter = filter.concat(_instance._ownLevel.createAccessFilter(permission, user, table, message));
    }
    if (levels.contains("future") && table == TABLE_EVENTS) {
      filter = filter.concat(new entity_filters.FutureEventFilter().upgrade());
    }
    if (levels.contains("unused") && table == TABLE_PLACES) {
      filter = filter.concat(new UnusedPlaceFilter(user).upgrade());
    }
    if (levels.contains("geo")) {
      throw new UnimplementedError("geo level $permission");
    }
    return filter;
  }
}
