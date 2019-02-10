part of view_model;

abstract class MapWrap {
  Map pathByType;
  g_m.GMap map;
  List<Function> onChange = [];
  List<g_m.Marker> markers = [];
  g_m.LatLng preparedCenter;
  String mode = "event";
  StreamSubscription _newPlacesRequestedStream;
  InputElement searchInput;
  g_m.LatLngBounds currentBounds;
  List<g_m_p.PlaceResult> foundPlaces;
  List<Function> onMessage = [];
  ClientEvents get baseEvents => model.eventsModel.baseEvents;
  List<Function> get onLeftPanelWidthChanged => layoutModel.onLeftPanelWidthChanged;
  double get initLatitude => model.map.initLatitude;
  double get initLongitude => model.map.initLongitude;
  double get latitude {
    if (layoutModel.leftPanelModel.isEventDetail) {
      return model.eventsModel.eventToShowDetail.mapPlace.latitude;
    } else if (layoutModel.leftPanelModel.isPlaceFilterActive) {
      return layoutModel.leftPanelModel.filterPlace.latitude;
    } else {
      return model.map.initLatitude;
    }
  }
  double get longitude {
    if (layoutModel.leftPanelModel.isEventDetail) {
      return model.eventsModel.eventToShowDetail.mapPlace.longitude;
    } else if (layoutModel.leftPanelModel.isPlaceFilterActive) {
      return layoutModel.leftPanelModel.filterPlace.longitude;
    } else {
      return model.map.initLongitude;
    }
  }
  int get leftPanelWidth => layoutModel.leftPanelWidth;
  ClientPlaces get allPlaces => model.placesModel.placeRepository;
  String message;
  set filterPlace(ClientPlace place) {
    layoutModel.leftPanelModel.filterPlace = place;
  }

  void sendMessage(String message){
    this.message = message;
    // map widget
    onMessage.forEach((f)=>f());
  }

  void offerDetailForEvent(ClientEvent event) {
    model.routes.route = "$ROUTE_EVENT_DETAIL-${event.id}";
  }
  StreamSubscription get newPlacesRequestedStream => _newPlacesRequestedStream;

  set newPlacesRequestedStream(StreamSubscription value) => _newPlacesRequestedStream = value;

  Future initMap() async{
    await new Future.delayed(const Duration(milliseconds: 200));
    final mapOptions = new g_m.MapOptions()
      ..zoom = 13
      ..minZoom = 4
      ..disableDefaultUI = false
      ..backgroundColor = "white"
      ..center = preparedCenter != null ? preparedCenter : new g_m.LatLng(initLatitude, initLongitude)
      ..mapTypeId = g_m.MapTypeId.ROADMAP
    ;
    map = new g_m.GMap(querySelector("#appMap"), mapOptions);
  }

  void _clearMarkers() {
    markers.forEach((marker) {
      marker.map = null;
    });
    markers = [];
  }

  void _boundsChanged(g_m.LatLngBounds bounds);

  g_m.Marker _doMarker(g_m.LatLng position, String name, Function onClick) {
    g_m.Marker marker = new g_m.Marker(new g_m.MarkerOptions()
      ..position = position
      ..map = map
      ..title = name
      ..icon = pathByType[mode]
    );
    g_m.event.addListener(marker, "click", ([_, __]) {
      onClick();
    });
    markers.add(marker);
    return marker;
  }

  void recenter() {
    if (map == null) return;
    panToEventPlace(new g_m.LatLng(latitude, longitude));
    new Future.delayed(const Duration(milliseconds: 10)).then((_) {
      double right = map.bounds.northEast.lng;
      double left = map.bounds.southWest.lng;
      int windowWidth = window.innerWidth;
      double lng;
      if ((right - left) > 180) {
        lng = longitude - (((360 + left - right) * (leftPanelWidth / windowWidth)) / 2);
      } else {
        lng = longitude - (((right - left) * (leftPanelWidth / windowWidth)) / 2);
      }
      panToEventPlace(new g_m.LatLng(latitude, lng));
    });
  }

  void destroy() {
    onChange.remove(recenter);
    onLeftPanelWidthChanged.remove(recenter);
  }

  void panToEventPlace(g_m.LatLng coordinates) {
    if (map == null) {
      preparedCenter = coordinates;
    } else {
      map.panTo(coordinates);
    }
  }


}