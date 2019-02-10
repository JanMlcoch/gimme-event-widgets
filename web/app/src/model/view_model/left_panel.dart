part of view_model;

class LeftPanelModel {
  EventsModel eventsModel;

  ClientPlace _filterPlace;
  ClientEvents filteredEventsByPlace;
  List<Function> onChange = [];

  bool _isEdit=false;
  /// base collection of user specific events obtained on initial
  ClientEvents get baseEvents => eventsModel.baseEvents;

  String get userLanguage => model.user.language;

  set leftPanelWidth(int val) {
    layoutModel.leftPanelWidth = val;
  }

  List<Function> get onNewPlaceRequested=>mapModel.onNewPlaceRequested;
  g_m.LatLng get newPlaceLatLng=>mapModel.newPlaceLatLng;
  String get newPlaceName=>mapModel.newPlaceName;

  LeftPanelModel() {
    eventsModel = model.eventsModel;
    checkEventEdit();
    model.routes.onRouteChanged.add(() {
      checkEventEdit();
      onChange.forEach((Function f) => f());
    });
  }

  void checkEventEdit() {
    if(model.routes.baseRoute!=ROUTE_ADD_EVENT){
      return;
    }
    int eventId;
    bool clone = false;
    ClientEvent event;
    String subRoute = model.routes.valueAfterDash;
    if (subRoute != "") {
      if(subRoute.contains("clone")){
        clone = true;
        subRoute = subRoute.replaceAll("clone","");
      }
      eventId = int.parse(subRoute, onError: (_) => null);
    }

    Future getEventDetail() async {
      await event.getEventDetail();
      event.downloadImage(event.id).then((ClientEvent e){
        model.createEvent.setImageData(e.imageData);
      });
      model.createEvent.event = event;
      model.createEvent.quickPlaceInBaseManage.fromEvent(event);
      model.createEvent.smartSelectModel.fromEvent(event);
      if(clone){
        model.createEvent.event.id=null;
      }
      _isEdit = true;
      onChange.forEach((Function f) => f());
    }

    if (eventId != null) {
      event = new ClientEvent(model.placesModel.placeRepository, model.organizersModel.organizersRepository);
      event.id = eventId;
      getEventDetail();
    }else{
      _isEdit = false;
    }
  }

  ManageEventModel get createEvent => model.createEvent;

  ClientPlace get filterPlace => _filterPlace;

  bool get isPlaceFilterActive => filterPlace != null;

//  bool get isEventDetail => eventToShowDetail != null;
  bool get isEventDetail => model.routes.baseRoute == ROUTE_EVENT_DETAIL;

  bool get isManageEvent => model.routes.baseRoute == ROUTE_ADD_EVENT;

  set filterPlace(ClientPlace place) {
    _filterPlace = place;
    eventsModel.clearEventToShowDetail();
    filteredEventsByPlace =
    new ClientEvents(model.placesModel.placeRepository, model.organizersModel.organizersRepository);
    for (ClientEvent event in baseEvents.list) {
      if (event.mapLatitude == place.latitude && event.mapLongitude == place.longitude) {
        filteredEventsByPlace.addEvent(event);
      }
    }
    onChange.forEach((Function f) => f());
  }


  void backToBaseEvents() {
    if(Routes.getBaseRouteFromRoute(Routes.pastRoutes.last) == ROUTE_USER_SETTINGS){
      model.routes.route = Routes.pastRoutes.last;
    }else{
      eventsModel.clearEventToShowDetail();
      _filterPlace = null;
      layoutModel.navbarModel.goToRecommendedEvents();
    }
  }

  void addEventToBase(ClientEvent event) {
    baseEvents.list.add(event);
  }

  void addPlaceToCentralRepository(ClientPlace place) {
    model.placesModel.addPlace(place);
  }

  void navigateToEventDetail(int id) {
    model.routes.route = "$ROUTE_EVENT_DETAIL-$id";
  }

  void resetCreateEventModel() {
    model.createEvent.reset();
  }

  bool isEdit() {
    return _isEdit;
  }

  void selectPlaceMode() {
    mapModel.switchToAddPlaceMode();
  }

  void selectEventMode() {
    mapModel.switchToEventsMode();
  }

  void sendMapMessage(String message) {
    mapModel.sendMessage(message);
  }

  Future addPlaceToCreatingEvent(ClientPlace place) async{
    await place.create();
    model.placesModel.addPlace(place);
    model.createEvent.addMapPlace(place);
  }
}