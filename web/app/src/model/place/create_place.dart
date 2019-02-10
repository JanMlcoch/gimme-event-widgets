part of model;

class CreatePlaceModel {
  double lat;
  double lon;
  String _gps = "";
  String description = "";
  String _name = "";

  QuickPlaceModel quickPlace;
  ClientPlace createdPlace;

  List<Function> onSavedAndUsed = [];
  List<Function> onSimilarsChanged = [];

  String get name => _name;

  void set name(String val) {
    _name = val;
    ClientPlaces places = new ClientPlaces();
    places.getPlacesBySubstring(val);
  }

  String get gps => _gps;

  void set gps(String val) {
    _gps = val;
    getSimilars().then((bool good) {
      if (good) {
        onSimilarsChanged.forEach((Function f) => f());
      }
    });
  }

  Future<bool> getSimilars() async {
//    await Gateway.instance.post(CONTROLLER_GET_NEARBY_PLACES,
//        data: {"lat":lat, "lon": lon});

    // TODO: similars doesnt work
//    print(JSON.encode(result["places"]));
    return false;
//    fromJson(result["events"].first);
  }

  CreatePlaceModel() {
    quickPlace = new QuickPlaceModel();
  }

  void reset() {
    quickPlace.reset();
    description = "";
  }

  bool validateGps() {
    Gps gpsCont= new Gps.fromString(gps);
    if(gpsCont.valid){
      lat=gpsCont.lat;
      lon=gpsCont.lng;
      return true;
    }else{
      return false;
    }
  }

  Future saveAndUse(String description) async {
    ClientPlace place = new ClientPlace();
    place
      ..name = name
      ..description = description
      ..latitude = lat
      ..longitude = lon;
    await place.create();
    createdPlace = place;
    // spaghetti alert
    model.placesModel.addPlace(place);
    onSavedAndUsed.forEach((Function f) => f());
  }
}