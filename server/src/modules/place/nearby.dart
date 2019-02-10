part of placeModule;

void _bindNearby() {
  libs.route(CONTROLLER_GET_NEARBY_PLACES, () => new NearbyRC(),
      method: "POST", template: {"lat": "double", "lon": "double"});
}

class NearbyRC extends libs.RequestContext {
  Future validate() {
    return null;
  }

  @override
  Future<dynamic> execute() {
    // TODO: get places nearby
    envelope.withList([]);
    return null;
  }
}
