part of filter_module.access;

class AccessManager {
  final User user;
  final String permission;

  AccessManager(this.permission, this.user);

  RootFilter get events => createAccessFilter(TABLE_EVENTS);

  RootFilter get places => createAccessFilter(TABLE_PLACES);

  RootFilter get organizers => createAccessFilter(TABLE_ORGANIZERS);

  RootFilter get users => createAccessFilter(TABLE_USERS);

  RootFilter eventsByIds(Iterable<int> ids) => _addByIdsFilter(events, ids, TABLE_EVENTS);

  RootFilter placesByIds(Iterable<int> ids) => _addByIdsFilter(places, ids, TABLE_PLACES);

  RootFilter organizersByIds(Iterable<int> ids) => _addByIdsFilter(organizers, ids, TABLE_ORGANIZERS);

  RootFilter usersByIds(Iterable<int> ids) => _addByIdsFilter(users, ids, TABLE_USERS);

  //##########################################################################################################
  RootFilter createAccessFilter(String table) => AccessProvider._instance
      ._createAccessFilter(permission, user == null ? "anonym" : user.permissions[permission], user, table);

  RootFilter _addByIdsFilter(RootFilter accessFilter, Iterable<int> ids, String table) {
    EnvelopeHolder message = new EnvelopeHolder();
    FilterBase filter = entity_filters.IdListAnyFilter.byTable(table, [ids]);
    RootFilter idsFilter = filter.upgrade(message: message);
    if (!message.empty) {
      throw new ArgumentError(message.envelope.message);
    }
    return accessFilter.concat(idsFilter);
  }
}
