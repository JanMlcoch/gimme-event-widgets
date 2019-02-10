part of placeModule;

void _bindEditAndDelete() {
  libs.route(CONTROLLER_EDIT_PLACE, () => new EditPlacesRC(),
      method: "POST",
      template: {"latitude": "double", "longitude": "double", "name": "string", "description": "string", "id": "int"},
      permission: Permissions.EDIT_PLACE);
  libs.route(CONTROLLER_DELETE_PLACE, () => new DeletePlacesRC(),
      method: "POST",
      template: {"id": "int"},
      permission: Permissions.DELETE_PLACE);
}

class EditPlacesRC extends libs.RequestContext {

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
    Place place = await connection.places.updateModel(data, [
      "latitude",
      "longitude",
      "description",
      "name"
    ]);
    envelope.withMap(place.toFullMap());
    return null;
  }
}

class DeletePlacesRC extends libs.RequestContext {

  Future validate() async {
    return null;
  }

  @override
  Future<dynamic> execute() async {
    Place place = await connection.places.updateModel({
      "deleted":true,
      "id": data["id"]
    }, [
      "deleted"
    ]);
    envelope.withMap(place.toFullMap());
    return null;
  }
}
