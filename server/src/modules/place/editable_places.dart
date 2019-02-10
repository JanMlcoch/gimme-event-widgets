part of placeModule;

void _bindEditablePlaces() {
  libs.route(CONTROLLER_EDITABLE_PLACES, () => new EditablePlacesRC(),
      method: "POST", template: {"?filters": "filters"}, permission: Permissions.EDIT_PLACE);
}

class EditablePlacesRC extends libs.RequestContext {
  static const placeColumns = const ["id", "name", "latitude", "longitude", "city", "description", "eventId"];

  Future validate() {
    return null;
  }

  @override

  @override
  Future<dynamic> execute() async {
    common_filter.RootFilter filter = constructFilter();
    if (filter == null) return null;
    Places places = await connection.places.load(
        filter.concat(access.places), placeColumns,
        limit: -1);

    envelope.withList(places.toFullList());
    return null;
  }
}
