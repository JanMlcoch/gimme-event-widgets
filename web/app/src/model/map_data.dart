part of model;

class MapData {
  double initLatitude;
  double initLongitude;
  int distanceFilterValue;
  List onChange = [];
  List<Function> onLeftPanelWidthChanged = [];

  /// width is needed for centering map
  int _leftPanelWidth = 0;

  int get leftPanelWidth => _leftPanelWidth;

  void set leftPanelWidth(int value) {
    _leftPanelWidth = value;
    onLeftPanelWidthChanged.forEach((Function f) => f());
  }

  MapData({SmartSelectModel inputtedSsTagState, int distanceFilterValue: 5}) {
    this.distanceFilterValue = distanceFilterValue;
  }

  Future init() async {
    await getInitPosition();
    await getEvents(filters: [{"name": "event_in_future", "data": []},
    {"name": "distance", "data": [initLatitude.toDouble(), initLongitude.toDouble(), distanceFilterValue]}
    ]);
  }

  Future getEvents({List filters: const[]}) async {
    envelope_lib.Envelope envelope = await Gateway.instance.post(
        CONTROLLER_FILTER_EVENTS, data: {"filters":filters, "localLat": initLatitude, "localLon": initLongitude});
    model.eventsModel.createBaseEvents(envelope.map["events"]);
  }

  Future getInitPosition() async {
    String jsonString;
    try {
      jsonString = await HttpRequest.getString("http://ip-api.com/json");
    } catch (_) {
      jsonString = '{"lat": 0,"lon": 0}';
      print(lang.apiCallError);
    }

    initLatitude = JSON.decode(jsonString)["lat"].toDouble();
    initLongitude = JSON.decode(jsonString)["lon"].toDouble();
    onChange.forEach((f) => f());
  }

  Future<ClientPlaces> getPlacesInView(g_m.LatLngBounds bounds) async {
    envelope_lib.Envelope envelope = await Gateway.instance.post(
        CONTROLLER_FILTER_PLACES,
        data: {
          "filters": [{"name":"gps_window", "data":[
            bounds.northEast.lat,
            bounds.southWest.lat,
            bounds.southWest.lng,
            bounds.northEast.lng
          ]}
          ]
        });
    dynamic placesData = envelope.map["places"];
    ClientPlaces places;
    if(placesData is List<Map<String, dynamic>>){
      places = new ClientPlaces()..fromList(placesData);
    }else{
      throw "Places from response must be list";
    }
    return places;
  }
}
