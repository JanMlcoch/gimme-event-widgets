part of view_model;

class MapModel extends MapWrap {
  String lastMode = "event";
  StreamSubscription _addPlaceClickSubscription;
  List<Function> onNewPlaceRequested = [];
  g_m.LatLng newPlaceLatLng;
  String newPlaceName = "";

  MapModel() {
    pathByType = const{
      "event": "images/icons/geicon_experiment1.png",
      "place": "images/icons/geicon_pastelgreen.png",
      "search": "images/icons/geicon.png",
    };
  }

  @override
  void _boundsChanged(g_m.LatLngBounds bounds) {
    currentBounds = bounds;
    if (mode == "place") {
      _requestNewPlaces();
    }
  }

  Future _requestNewPlaces() async {
    if (mode != "place") return;
    if (_newPlacesRequestedStream != null) {
      _newPlacesRequestedStream.cancel();
    }
    _newPlacesRequestedStream = new Future.delayed(const Duration(seconds: 1)).asStream().listen((_) {
      if (mode == "place") {
        switchToAddPlaceMode();
      }
      _newPlacesRequestedStream = null;
    });
  }

  Future init() async {
    await model.map.init();
    await initMap();
    createSearchBox();
    _repaintMarkers();
    model.eventsModel.onChange.add(() {
      onChange.forEach((Function f) => f());
      recenter();
    });
    onLeftPanelWidthChanged.add(recenter);
    baseEvents.onChange.add(_repaintMarkers);
  }

  void createSearchBox() {
    searchInput = new InputElement()
      ..className = "gmapSearchInput";
    var searchBox = new g_m_p.SearchBox(searchInput);
    map.controls[g_m.ControlPosition.TOP_RIGHT].push(searchInput);
    map.onBoundsChanged.listen((_) {
      searchBox.bounds = map.bounds;
      _boundsChanged(map.bounds);
    });
    searchBox.onPlacesChanged.listen((_) {
      if (searchBox.places.isEmpty) return;
      foundPlaces = searchBox.places;
      switchToSearchMode();
    });
    searchInput.style.display = "none";
  }


  void _repaintMarkers() {
    if (map == null) return;
    Map<String, List<ClientEvent>> latLonMap = {};

    for (ClientEvent event in baseEvents.list) {
      if (!latLonMap.containsKey(event.latLonKey)) {
        latLonMap[event.latLonKey] = [];
      }
      latLonMap[event.latLonKey].add(event);
    }
    Map<ClientPlace, List<ClientEvent>> structure = {};

    latLonMap.forEach((k, List<ClientEvent> events) {
      ClientEvent first = events.first;
      ClientPlace place = allPlaces.byLatLonKeys[first.latLonKey];
      structure[place] = events;
    });

    structure.forEach((ClientPlace place, List<ClientEvent> events) {
      var position = new g_m.LatLng(events.first.mapPlace.latitude, events.first.mapPlace.longitude);
      if (events.length == 1) {
        _doMarker(position, events.first.name, () {
          offerDetailForEvent(events.first);
        });
      } else {
        _doMarker(position, place.name, () {
          filterPlace = place;
        });
      }
    });
  }

  void destroy() {
    super.destroy();
    if (_addPlaceClickSubscription != null) {
      _addPlaceClickSubscription.cancel();
    }
  }

  void _repaintPlaceMarkers(ClientPlaces places) {
    for (var place in places.list) {
      _doMarker(new g_m.LatLng(place.latitude, place.longitude), place.name, () {
        switchToMode(lastMode);
        model.createEvent.addMapPlace(place);
      });
    }
  }

  Future switchToAddPlaceMode() async {
    searchInput.style.display = "";
    lastMode = mode;
    mode = "place";
    var placesInView = await model.map.getPlacesInView(map.bounds);
    _clearMarkers();
    _repaintPlaceMarkers(placesInView);
    if (_addPlaceClickSubscription != null) {
      _addPlaceClickSubscription.cancel();
    }
    _addPlaceClickSubscription = map.onClick.listen((g_m.MouseEvent event) {
      newPlaceLatLng = event.latLng;


      HttpRequest.getString(
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${newPlaceLatLng.lat},${newPlaceLatLng.lng}&sensor=true&language=en&key=AIzaSyDvgRz-1Pgmkrq0FVwpmkdd2ohuUbyVy6U")
          .then((String data) {
        Map result = JSON.decode(data);
        String formatted;
        if (result.containsKey("results")) {
          List results = result["results"];
          if (result.isNotEmpty) {
            formatted = results.first["formatted_address"];
          }
        }
        if (formatted != null) {
          newPlaceName = formatted;
        }
        onNewPlaceRequested.forEach((f) => f());
      }).catchError((e) {
        onNewPlaceRequested.forEach((f) => f());
      });
    });
  }

  void switchToEventsMode() {
    searchInput.style.display = "none";
    lastMode = mode;
    mode = "event";
    _clearMarkers();
    _repaintMarkers();
  }

  void switchToSearchMode() {
    if (mode == "search") return;
    searchInput.style.display = "";
    if (lastMode != "places") {
      _clearMarkers();
    }
    lastMode = mode;
    mode = "search";
    foundPlaces.forEach((g_m_p.PlaceResult place) {
      if (place.geometry == null) {
        print("Returned place contains no geometry");
        return;
      }
      _doMarker(place.geometry.location, place.name, () {
        switchToEventsMode();
      });
      map.bounds.extend(place.geometry.location);
    });
    map.fitBounds(map.bounds);
  }

  void switchToMode(String mode) {
    switch (mode) {
      case "event":
        switchToEventsMode();
        break;
      case "place":
        switchToAddPlaceMode();
        break;
      case "search":
        switchToSearchMode();
        break;
      default:
        throw "undefined mode $mode";
    }
  }


}