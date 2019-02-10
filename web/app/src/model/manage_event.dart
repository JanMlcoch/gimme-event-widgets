part of model;

class ManageEventModel {
  static const String BASE = "base";
  static const String EXTENDED = "extended";
  static const String PLACES = "places";
  static const String PAYMENT_ORGANIZERS = "paymentOrganizers";
  static const String SOCIAL = "social";
  static const String GALLERY = "gallery";
  static const String FACEBOOK = "facebook";
  List tabs = const [
    BASE,
    EXTENDED,
    PLACES,
    PAYMENT_ORGANIZERS,
    SOCIAL,
    GALLERY,
    FACEBOOK
  ];
  DateFormat dateTimeFormat;
  DateFormat timeFormat;
  DateFormat dateFormat;
  ClientEvent event;
  ClientCosts costs;

  QuickPlaceModel quickPlaceInBaseManage;
  CreatePlaceModel createPlace;
  List<ClientOrganizer> filteredOrganizers;
  SmartSelectModel smartSelectModel;

  List<Function> onValidityStateChanged = [];
  List<Function> onActiveTabChanged = [];
  List<Function> onPlacesChanged = [];
  List<Function> onImageChanged = [];
  List<Function> onReset = [];

  String _fromTime = "10:00";
  String _fromDate;
  String _toTime = "12:00";
  String _toDate;

  String get fromTime => _fromTime;

  String get fromDate => _fromDate;

  String get toTime => _toTime;

  String get toDate => _toDate;

  String _activeTab = BASE;

  String get activeTab => _activeTab;

  void set activeTab(String val) {
    if (!tabs.contains(val)) {
      throw new Exception("invalid tab id in create event");
    }
    _activeTab = val;
    onActiveTabChanged.forEach((Function f) => f());
  }

  ManageEventModel() {
    // spaghetti alert
    event = new ClientEvent(model.placesModel.placeRepository, model.organizersModel.organizersRepository);
    event.language = model.user.language;
    smartSelectModel = new SmartSelectModel();
    smartSelectModel.onChosenChanged.add(() {
      event.tags = smartSelectModel.chosenTags;
    });
    if (lang != null) {
      makeFormats();
    } else {
      _onLangLoaded.add(makeFormats);
    }
    quickPlaceInBaseManage = new QuickPlaceModel();
    createPlace = new CreatePlaceModel();
    createPlace.onSavedAndUsed.add(() {
      // CreatePlace model subscribed first.
      throw new Exception("not implemented");
//      addPlace(createPlace.createdPlace, event.places.isEmpty);
    });
    costs = new ClientCosts();
    costs.addCost(model.user.currency);

  }
  void makeFormats() {
    dateTimeFormat = new DateFormat(
        lang.datePicker.dartDateFormat + " " + lang.datePicker.timeFormat);
    dateFormat = new DateFormat(lang.datePicker.dartDateFormat);
    timeFormat = new DateFormat(lang.datePicker.timeFormat);
  }

  ClientOrganizer getOrganizerById(int id) {
    for (ClientOrganizer o in filteredOrganizers) {
      if (o.id == id) return o;
    }
    return null;
  }

  List getFilteredOrganizersViewJson() {
    List out = [];
    for (ClientOrganizer o in filteredOrganizers) {
      out.add({"description": o.description, "name": o.name, "id": o.id});
    }
    return out;
  }

  Future<List<ClientOrganizer>> getOrganizersBySubstring(String substring) async {
    List organizers = [];
    List response = (await Gateway.instance.post(
        CONTROLLER_AUTOCOMPLETE_ORGANIZER,
        data: {"substring": substring})).list;
    for (Map m in response) {
      organizers.add(new ClientOrganizer()
        ..fromMap(m));
    }
    return organizers;
  }

  void setFromTime(String value) {
    _fromTime = value;
    bool isInt = true;
    int time = int.parse(value, onError: (_) {
      isInt = false;
      return 0;
    });
    if (isInt) {
      if (time < 25) {
        _fromTime = "$time:00";
      }
    }
    setFromDate(_fromDate);
  }

  void setToTime(String value) {
    _toTime = value;
    bool isInt = true;
    int time = int.parse(value, onError: (_) {
      isInt = false;
      return 0;
    });
    if (isInt) {
      if (time < 25) {
        _toTime = "$time:00";
      }
    }
    setToDate(_toDate);
  }

  void setFromDate(String value) {
    if (value == null) return;
    _fromDate = value;
    DateFormat useFormat;
    if (_fromTime == null || _fromTime == "") {
      useFormat = dateFormat;
    }else{
      useFormat = dateTimeFormat;
      value += " $_fromTime";
    }
    try {
      DateTime dateTry = useFormat.parse(value);
      event.from = dateTry;
    } catch (e) {
      event.from = null;
    }
  }

  void setToDate(String value) {
    if (value == null || value == "") return;
    _toDate = value;
    DateFormat useFormat;
    if (_toTime == null || _toTime == "") {
      useFormat = dateFormat;
    }else{
      useFormat = dateTimeFormat;
      value += " $_toTime";
    }
    try {
      DateTime dateTry = useFormat.parse(value);
      event.to = dateTry;
    } catch (e) {
      event.to = null;
    }
  }

  void setImageData(String value){
    event.imageData = value;
    onImageChanged.forEach((Function f) => f());
  }

  void addMapPlace(ClientPlace place){
    place.event = event;
    event.mapPlace = place;
    event.placeId = place.id;
    onPlacesChanged.forEach((Function f) => f());
  }

  void removePlace(ClientPlaceInEvent mapPlace) {
    event.places.remove(mapPlace);
    quickPlaceInBaseManage.filteredPlaces.add(mapPlace.place);
    onPlacesChanged.forEach((Function f) => f());
    quickPlaceInBaseManage.onFilteredPlacesChanged.forEach((Function f) => f());
  }

  void setName(String value) {
    event.name = value;
  }

  void setAnnotation(String value) {
    event.annotation = value;
  }

  void reset() {
    event.destroy();
    event = new ClientEvent(model.placesModel.placeRepository, model.organizersModel.organizersRepository);
    smartSelectModel.reset();
    quickPlaceInBaseManage.reset();
    createPlace.reset();
    onReset.forEach((Function f) => f());
  }

  void removeMapPlace() {
    event.mapPlace = null;
    event.placeId = null;
    onPlacesChanged.forEach((Function f)=>f());
  }
}
