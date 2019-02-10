part of view_model;

class UserSettingsModel{
  ClientPlaces myPlaces;
  ClientEvents myEvents;
  static const String EVENTS = "events";
  static const String CALENDAR = "calendar";
  static const String PERSONAL = "personal";
  static const String PLACES = "places";
  static const String SOCIAL = "social";
  static const List routes = const[
   "",EVENTS,CALENDAR,PERSONAL,PLACES,SOCIAL
  ];

  List<Function> onChange = [];
  CentralModel centralModel;


  String get subRoute=>model.routes.valueAfterDash;
  bool get inBase => subRoute=="";
  bool get inEvents => subRoute==EVENTS;
  bool get inCalendar => subRoute==CALENDAR;
  bool get inPersonal => subRoute==PERSONAL;
  bool get inPlaces => subRoute==PLACES;
  bool get inSocial => subRoute==SOCIAL;

  UserSettingsModel(this.centralModel){
    centralModel.onChange.add((){
      if(centralModel.inUserSettings){
        onChange.forEach((f)=>f());
      }
    });
  }

  Future<ClientPlaces> downloadMyPlaces() async{
    myPlaces = new ClientPlaces();
    return await myPlaces.getMyPlaces();
  }

  void setRoute(String route) {
    if(!routes.contains(route)){
      throw new Exception("Bad user settings subroute $route");
    }
    model.routes.route = "$ROUTE_USER_SETTINGS-$route";
  }

  Future<ClientEvents> downloadMyEvents() async {
    return await model.eventsModel.getOwnEditableEvents();
  }


  void goToEventDetail(int id) {
    model.routes.route = "$ROUTE_EVENT_DETAIL-$id";
  }

  void goToEditEvent(ClientEvent event) {
    model.routes.route = "$ROUTE_ADD_EVENT-${event.id}";
  }

  void goToCloneEvent(ClientEvent event) {
    model.routes.route = "$ROUTE_ADD_EVENT-clone${event.id}";
  }

  bool canEditAnyEvent() {
    return model.user.canEditAnyEvent();
  }

  Future<ClientEvents> downloadAllEvents() async {
    return await model.eventsModel.getEditableEvents();
  }
}