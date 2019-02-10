part of model;

class EventsModel {
  ClientEvent _eventToShowDetail;
  /// base collection of user specific events obtained on initial
  ClientEvents baseEvents;
  List<Function> onChange = [];

  static const List BG_COLORS = const [
    "rgb(26, 188, 156)",
    "rgb(46, 204, 113)",
    "rgb(52, 152, 219)",
    "rgb(155, 89, 182)",
    "rgb(52, 73, 94)",
    "rgb(241, 196, 15)",
    "rgb(230, 126, 34)",
    "rgb(231, 76, 60)",
    "rgb(149, 165, 166)"
  ];

  EventsModel() {
    baseEvents = new ClientEvents(model.placesModel.placeRepository, model.organizersModel.organizersRepository);
//    if(model.routes.baseRoute==ROUTE_EVENT_DETAIL){
//      _offerDetailById(_getEventId());
//    }
  }

  ClientEvent get eventToShowDetail => _eventToShowDetail;

  void createBaseEvents(List eventsData) {
    baseEvents.fromList(eventsData);
  }

  Future offerDetailForEvent() async {
    ClientEvent offered = new ClientEvent(model.placesModel.placeRepository, model.organizersModel.organizersRepository);
    int eventId;
    if(model.routes.baseRoute == ROUTE_EVENT_DETAIL){
      eventId = int.parse(model.routes.valueAfterDash);
    }else{
      throw new Exception("Trying to get event detail on wrong route (${model.routes.route}");
    }
    offered.id = eventId;
    if (eventToShowDetail == offered) return null;
    await offered.getEventDetail(offered.id);
    _eventToShowDetail = offered;
    onChange.forEach((Function f) => f());
    return offered;
  }

  Future postRating(int rating) async{
    Map <String, dynamic> dataToPost = {"userId": model.user.id, "eventId": _eventToShowDetail.id, "rating": rating};
    return await Gateway.instance.post(CONTROLLER_RATE_EVENT, data: dataToPost);
  }

  void clearEventToShowDetail() {
    _eventToShowDetail = null;
  }

  void addEventToBase(ClientEvent event) {
    baseEvents.list.add(event);
  }

  /// use for initialization of detail
//  void _offerDetailById(int id) {
//    ClientEvent detail = new ClientEvent(model.placesModel.placeRepository, model.organizersModel.organizersRepository);
//    detail.id = id;
//    offerDetailForEvent(detail);
//  }

  Future<ClientEvents> getOwnEditableEvents() async{
    ClientEvents myEvents = new ClientEvents(model.placesModel.placeRepository, model.organizersModel.organizersRepository);
    return myEvents.getMyEditableEvents();
  }

  Future<ClientEvents> getEditableEvents() async{
    ClientEvents myEvents = new ClientEvents(model.placesModel.placeRepository, model.organizersModel.organizersRepository);
    return myEvents.getEditableEvents();
  }

}