part of placeModule;

void _bindCreatePlace() {
  libs.route(CONTROLLER_CREATE_PLACE, () => new CreatePlacesRC(),
      method: "POST",
      template: {"latitude": "double", "longitude": "double", "name": "string", "description": "string"},
      permission: Permissions.CREATE_PLACE);
}

class CreatePlacesRC extends libs.RequestContext {
  Future validate() async {
    // locate proximity place and send it instead
    if (data["latitude"] > 90) {
      return envelope.error("Latitude have to be smaller than 90°", INCORRECT_REQUEST_ARGUMENTS);
    }
    if (data["latitude"] < -90) {
      return envelope.error("Latitude have to be larger than -90°", INCORRECT_REQUEST_ARGUMENTS);
    }
    if (data["longitude"] > 90) {
      return envelope.error("Longitude have to be smaller than 90°", INCORRECT_REQUEST_ARGUMENTS);
    }
    if (data["longitude"] < -90) {
      return envelope.error("Lontitude have to be larger than -90°", INCORRECT_REQUEST_ARGUMENTS);
    }
    return null;
  }

  @override
  Future<dynamic> execute() async {
    common_filter.RootFilter nameFilter = new entity_filter.SubNamePlaceFilter([data["name"]]).upgrade();
    common_filter.RootFilter filter = new entity_filter.GpsWindowPlaceFilter([
      data["latitude"] + 400,
      data["latitude"] - 400,
      data["longitude"] - 800,
      data["longitude"] + 800
    ]).upgrade().concat(nameFilter);

    Places foundPlaces = await connection.places.load(filter, null, fullColumns: true, limit: 1);
    if (foundPlaces.length > 0) {
      envelope.withMap(foundPlaces.first.toFullMap());
      return null;
    }
    data["ownerId"] = user.id;
    data["city"] = await Place.getCity(data["latitude"], data["longitude"]);
    // TODO: review
    connection.model = null;
    Place place = await connection.places.saveModel(data);
    if (place == null) {
      envelope.error(ERROR_IN_PLACE_CREATION);
      return null;
    }
    new log.Logger("akcnik.server.context.place").info("create place data ${convert.JSON.encode(data)}");
    envelope.withMap(place.toFullMap());
    return null;
  }
}
