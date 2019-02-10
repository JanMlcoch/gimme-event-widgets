part of model;

class ClientEvent extends EventBase {
  bool _detailRequested = false;
  String imageData = "";
  List<Tag> tags = [];
  ClientCosts costs;
  ClientPlaces placesRepository;
  ClientOrganizers organizersRepository;
  List<ClientOrganizerInEvent> organizers = [];
  ClientEvents parent;
  int relevantRating;

  List<Function> onChange = [];

//  Places are used only when there are more than one place
  List<ClientPlaceInEvent> places = [];

//  Every event has to have set mapPlace!
  ClientPlace mapPlace;

  String get latLonKey => "$mapLatitude,$mapLongitude";

  String get currency => "CZK";

  String get src => 'images/events_images/event_avatar_$id.png';

  ClientEvent(this.placesRepository, this.organizersRepository) {
    costs = new ClientCosts();
    if (placesRepository == null) {
      throw new Exception("places repositroy must be set");
    }
    if (organizersRepository == null) {
      throw new Exception("organizers repository must be set");
    }
  }

  List getOrganizersViewJson() {
    List out = [];
    for (ClientOrganizerInEvent o in organizers) {
      out.add(o.toViewJson());
    }
    return out;
  }

  @override
  void fromMap(Map json) {
    super.fromMap(json);
    imageData = json["imageData"];
    if (json["costs"] is List) {
      costs.fromList(json["costs"]);
    }

    organizers.clear();
    if (json.containsKey("organizers")) {
      for (Map organizer in json["organizers"]) {
        organizers.add(new ClientOrganizerInEvent()
          ..fromMap(organizer)
          ..event = this);
      }
    }

    places.clear();
    if (json.containsKey("places")) {
      for (Map place in json["places"]) {
        places.add(new ClientPlaceInEvent(placesRepository)
          ..fromMap(place)
          ..event = this);
      }
    }
    if (json.containsKey("placeId")) {
      mapPlace = placesRepository.getPlaceById(json["placeId"]);
    } else {
      if (!placesRepository.byLatLonKeys.containsKey(latLonKey)) {
        placesRepository.byLatLonKeys[latLonKey] = new ClientPlace()
          ..latitude = mapLatitude
          ..longitude = mapLongitude;
      }
      mapPlace = placesRepository.byLatLonKeys[latLonKey];
    }

    if (json.containsKey("tags")) {
      for (Map tag in json["tags"]) {
        tags.add(new Tag()..fromMap(tag));
      }
    }
    relevantRating = json["relevantRating"];
  }

  @override
  Map toCreateMap() {
    Map out = super.toCreateMap();
    List placesOut = [];
    for (ClientPlaceInEvent place in places) {
      placesOut.add(place.toSafeMap());
    }
    out["places"] = placesOut;
    List organizersOut = [];
    for (ClientOrganizerInEvent organizer in organizers) {
      organizersOut.add(organizer.toFullMap());
    }
    out["organizers"] = organizersOut;
    out["tagIds"] = [];
    if (tags != null) {
      for (Tag tag in tags) {
        out["tagIds"].add(tag.id);
      }
    }
    if (imageData != null) {
      out["imageData"] = imageData;
    }
    out["costs"] = costs.toList();
    return out;
  }

  @override
  Map<String, dynamic> toFullMap() {
    Map<String, dynamic> json = super.toFullMap();
    List organizersOut = [];
    for (ClientOrganizerInEvent organizer in organizers) {
      organizersOut.add(organizer.toFullMap());
    }
    json["organizers"] = organizersOut;
    List placesOut = [];
    for (ClientPlaceInEvent place in places) {
      placesOut.add(place.toSafeMap());
    }
    json["places"] = placesOut;
    json["imageData"] = imageData;
    json["costs"] = costs.toList();
    json["tagIds"] = [];
    if (tags != null) {
      for (Tag tag in tags) {
        json["tagIds"].add(tag.id);
      }
    }
    json["relevantRating"] = relevantRating;
    return json;
  }

  Future<String> submitEvent() async {
    if (imageData == null || imageData == "") {
      clientSettings[EventBase.DONT_HAVE_AVATAR] = true;
    }
    envelope_lib.Envelope envelope;
    if (id == null) {
      envelope = await Gateway.instance.post(CONTROLLER_CREATE_EVENT, data: toCreateMap());
    } else {
      envelope = await Gateway.instance.post(CONTROLLER_EDIT_EVENT, data: toEditMap());
    }
    try {
      if (!envelope.isSuccess) {
        return envelope.message;
      }
      fromMap(envelope.map);
      if (!model.eventsModel.baseEvents.list.contains(this)) {
        model.eventsModel.addEventToBase(this);
      }
      onChange.forEach((f) => f());
      return OK;
    } catch (e) {
      throw new Exception(e);
    }
  }

  Map toEditMap() {
    Map out = toCreateMap();
    out["id"] = id;
    return out;
  }

  Future getEventDetail([int eventId]) async {
    if (eventId == null) {
      eventId = id;
    }
    if (_detailRequested) return;
    _detailRequested = true;
    Map<String, dynamic> data = model?.user?.id == null ? {"id": eventId} : {"id": eventId, "userId": model?.user?.id};
    envelope_lib.Envelope result =
    await Gateway.instance.post(CONTROLLER_DETAIL_EVENT, data: data);
    if (!result.isSuccess) {
      throw result.message;
    }
    dynamic placesInData = result.map["places"];
    if (placesInData is List<Map<String, dynamic>>) {
      placesRepository.addList(placesInData);
    }
    organizersRepository.fromList(result.map["organizers"]);
    relevantRating = result.map["relevantRating"];
    fromMap(result.map["events"].first);
  }

  List<Map> getPlacesViewJson() {
    List<Map> out = [];
    for (ClientPlaceInEvent place in places) {
      out.add(place.toViewJson());
    }
    return out;
  }

  Map getMapPlaceViewJson() {
    if (mapPlace == null) return null;
    return mapPlace.toViewMap();
  }

  List getAdmissionsJson() {
    return costs.toList();
  }

  void destroy() {
    costs.destroy();
  }

  Future<bool> delete() async {
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_DELETE_EVENT, data: {"id": id});
    if (!envelope.isSuccess) {
      return false;
    } else {
      if (parent != null) {
        parent.removeEvent(this);
      }
      return true;
    }
  }

  //model.createEvent.setImageData(canvas.toDataUrl());
  Future<ClientEvent> downloadImage([int asyncPassId]) async {
    int originalId = id;
    if (asyncPassId != null) {
      id = asyncPassId;
    }
    ImageElement image = new ImageElement(src: src);
    id = originalId;
    Completer completer = new Completer();
    image.onError.listen((_) {
      imageData = null;
      completer.complete(this);
    });
    image.onLoad.listen((_) {
      try {
        CanvasElement canvas = new CanvasElement(width: image.naturalWidth, height: image.naturalHeight);
        canvas.context2D.drawImage(image, 0, 0);
        imageData = canvas.toDataUrl();
      } catch (e) {
        imageData = null;
      }
      completer.complete(this);
    });
    return completer.future;
  }

  bool isInPast() {
    return !to.isAfter(new DateTime.now());
  }
}

class MapPlace {
  double latitude;
  double longitude;
  String name;
  String city;

  MapPlace(this.latitude, this.longitude, this.name, {this.city: ""});
}
