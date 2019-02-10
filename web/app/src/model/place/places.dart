part of model;

class ClientPlaces {
  List<ClientPlace> list = [];
  List onNewPlaces = [];
  Map byLatLonKeys ={};

  Future<ClientPlaces> getPlacesBySubstring(String substring) async {
    envelope_lib.Envelope result = await Gateway.instance.post(CONTROLLER_AUTOCOMPLETE_PLACES,
        data: {"substring":substring});
    if(result.isSuccess){
      fromList(result.list);
    }
    return this;
  }

  List<Map> toList(){
    List<Map> out = [];
    for(ClientPlace place in list){
      out.add(place.toFullMap());
    }
    return out;
  }

  void addList(List<Map<String, dynamic>> places) {
    for (Map<String, dynamic> place in places) {
      ClientPlace newPlace = new ClientPlace()..fromMap(place);
      list.add(newPlace);
      byLatLonKeys[newPlace.latLonKey] = newPlace;
    }
    onNewPlaces.forEach((Function f) => f());
  }

  void fromList(List<Map<String, dynamic>> places) {
    list.clear();
    if (places == null) {
      throw new Exception("Places data cannot be null");
    }
    for (Map<String, dynamic> place in places) {
      ClientPlace newPlace = new ClientPlace()..fromMap(place);
      list.add(newPlace);
      newPlace.parent=this;
      byLatLonKeys[newPlace.latLonKey] = newPlace;
    }
    onNewPlaces.forEach((Function f) => f());
  }

  ClientPlace getPlaceById(int id) {
    ClientPlace toReturn;
    for (ClientPlace place in list) {
      if (place.id == id) {
        toReturn = place;
        break;
      }
    }
    return toReturn;
  }

  Future<ClientPlace> create(String name, double lat, double lng, String description) async {
    ClientPlace place = new ClientPlace();
    place
      ..name = name
      ..description = description
      ..latitude = lat
      ..longitude = lng;

    await place.create();
    list.add(place);
    byLatLonKeys[place.latLonKey] = place;
    return place;
  }

  bool contains(String name) {
    for (ClientPlace place in list) {
      if (place.name == name) {
        return true;
      }
    }
    return false;
  }

  void addPlace(ClientPlace place) {
    if (list.contains(place)) return;
    list.add(place);
    byLatLonKeys[place.latLonKey] = place;
    onNewPlaces.forEach((Function f) => f());
  }

  Future<ClientPlaces> getMyPlaces() async {
    envelope_lib.Envelope result = await Gateway.instance.post(CONTROLLER_EDITABLE_PLACES,
        data: {});
    if(result.isSuccess){
      fromList(result.list);
    }
    return this;
  }

  void removePlace(ClientPlace clientPlace) {
    list.remove(clientPlace);
    onNewPlaces.forEach((Function f) => f());
  }
}

class ClientPlace extends PlaceBase {
  ClientEvent event;
  String get latLonKey =>"$latitude,$longitude";
  ClientPlaces parent;
  Gps gpsCont;
  List<Function> onPlaceSaved = [];

  Future<ClientPlace> create() async {
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_CREATE_PLACE,
        data: toSaveMap());
    fromMap(envelope.map);
    onPlaceSaved.forEach((f)=>f());
    return this;
  }

  Map toViewMap() {
    Map out = {};
    out["name"] = name;
    out["description"] = description;
    out["id"] = id;
    out["placeId"] = id;
    out["mapFlag"] = "";
    return out;
  }

  Map toSaveMap() {
    Map out = {};
    out["name"] = name;
    out["description"] = description;
    out["latitude"] = gpsCont.lat;
    out["longitude"] = gpsCont.lng;
    return out;
  }

  Future<bool> sendDelete() async {
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_DELETE_PLACE,
        data: {"id":id});
    if(envelope.isSuccess){
      if(parent!=null){
        parent.removePlace(this);
      }
      return true;
    }else{
      return false;
    }
  }


  bool parseGPS(String value) {
    gpsCont = new Gps.fromString(value);
    if(gpsCont.valid){
      latitude = gpsCont.lat;
      longitude = gpsCont.lng;
      return true;
    }else{
      return false;
    }
  }


  Future<ClientPlace> persist() async{
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_EDIT_PLACE,
        data: toFullMap());
    if(!envelope.isSuccess){
      print("place persist error");
    }else{
      fromMap(envelope.map);
    }
    onPlaceSaved.forEach((f)=>f());
    return this;
  }

  String formattedGps() {
    if(gpsCont!=null){
      return gpsCont.format();
    }else{
      return latLonKey;
    }
  }

  @override
  Map<String, dynamic> toSafeMap() => null;
}

class ClientPlaceInEvent extends PlaceInEventBase {
  ClientPlace place;
  ClientPlaces repository;
  ClientEvent event;

  ClientPlaceInEvent(this.repository);

  Map toViewJson() {
    Map out = super.toSafeMap();
    out["name"] = place.name;
    out["description"] =
    description != "" && description != null ? description : lang.manageEvent.placesLangs.noDescription;
    out["id"] = id;
    out["placeId"] = place.id;
    out["_place"] = place.toFullMap();
    return out;
  }

  Map toSafeMap() {
    Map out = super.toSafeMap();
    out["name"] = place.name;
    out["eventId"] = event.id;
    out["description"] = description;
    out["id"] = id;
    out["placeId"] = place.id;
    out["_place"] = place.toFullMap();
    return out;
  }

  void fromMap(Map json) {
    super.fromMap(json);
    place = repository.getPlaceById(json["placeId"]);
    if (place == null) {
      throw new Exception("place ${json["placeId"]} is not in repository");
    }
  }
}