part of model;

class QuickPlaceModel {
  String _value = "";
  bool isDownloading = false;

  String get value => _value;
  List<ClientPlace> filteredPlaces = [];
  ClientPlaces places;
  List<Function> onActivePlaceChanged = [];
  List<Function> onFilteredPlacesChanged = [];
  List<Function> onDownloadComplete = [];
  List<Function> onValueChanged = [];
  List<Function> onFilteredEventsChanged = [];
  List<Function> onCreatePlaceRequested = [];

  int _activeFilteredPlaceIndex = 0;

  int get activeFilteredPlaceIndex => _activeFilteredPlaceIndex;

  void set activeFilteredPlaceIndex(int val) {
    int length = filteredPlaces.length;
    if (length == 0) {
      _activeFilteredPlaceIndex = 0;
    } else if (val > length - 1) {
      _activeFilteredPlaceIndex = 0;
    } else if (val < 0) {
      _activeFilteredPlaceIndex = length - 1;
    } else {
      _activeFilteredPlaceIndex = val;
    }
    onActivePlaceChanged.forEach((Function f) => f());
  }

  void set value(String value) {
    _value = value;
    if (value.length > 1) {
      isDownloading = true;
      places.getPlacesBySubstring(value).then((ClientPlaces places) {
        filteredPlaces.clear();
        filteredPlaces.addAll(places.list);
        onFilteredEventsChanged.forEach((Function f) => f());
        isDownloading = false;
        onDownloadComplete.forEach((Function f) => f());
      });
    } else {
      filteredPlaces.clear();
      onFilteredEventsChanged.forEach((Function f) => f());
    }
    if (filteredPlaces.isNotEmpty) {
      filteredPlaces = [];
      onFilteredPlacesChanged.forEach((Function f) => f());
    }
    onValueChanged.forEach((Function f) => f());
  }

  QuickPlaceModel() {
    places = new ClientPlaces();
    onFilteredEventsChanged.add(() {
      activeFilteredPlaceIndex = _activeFilteredPlaceIndex;
    });
  }

  void reset() {
    _value = "";
    filteredPlaces.clear();
    _activeFilteredPlaceIndex = 0;
  }

  List<Map> getFilteredPlacesJson() {
    List<Map> out = [];
    for(ClientPlace place in filteredPlaces){
      out.add(place.toFullMap());
    }
    return out;
  }

  void createPlace() {
    onCreatePlaceRequested.forEach((Function f) => f());
  }

  void fromEvent(ClientEvent event) {
    places.list.clear();
    places.list.add(event.mapPlace);
  }
}