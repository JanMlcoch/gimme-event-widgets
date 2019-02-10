part of model;

class ClientUser extends UserBase {
  static const String FACEBOOK_TOKEN = "facebookToken";
  static const String GOOGLE_TOKEN = "googleToken";
  static const String ONE_TIME_TOKEN = "oneTimeToken";
  Registration registration;
  List onUserChanged = [];
  String _currency = "EUR";
  String facebookToken;
  PointsOfOrigin pointsOfOrigin;
  PointOfOrigin selectedPointOfOrigin;
  List<Function> onPointsOfOriginLoaded = [];
  ClientAboutEvent clientAboutEvent;

  bool get isLogged => id != null;

  set isLogged(bool val) {
    if (!val) id = null;
    _fireUserChanged();
  }

  void set currency(String val) {
    _currency = val;
    _updateExchangeRate();
  }

  String get currency => _currency;
  double _exchangeRateToEur = 1.0;

  double get exchangeRateToEur => _exchangeRateToEur;

  ClientUser() {
    registration = new Registration();
    pointsOfOrigin = new PointsOfOrigin();
    clientAboutEvent = new ClientAboutEvent();
  }

  Future _updateExchangeRate() async {
    Map data = {"request": GET_EXCHANGE_RATE, "currencyFrom": _currency, "currencyTo": "EUR"};
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_GET_EXCHANGE_RATE, data: data);
    _exchangeRateToEur = envelope.map["exchangeRateToEur"];
  }

  void _fireUserChanged() {
    for (Function f in onUserChanged) {
      f();
    }
  }

  void fromMap(Map<String, dynamic> json) {
    loadPointsOfOrigin(json["id"]);
    loadUserAboutEvents(json["id"]);
    super.fromMap(json);
    _currency = json["currency"];
    _exchangeRateToEur = json["exchangeRateToEur"];
    _fireUserChanged();
  }

  Map<String, dynamic> toFullMap() {
    Map<String, dynamic> out = super.toFullMap();
    out["currency"] = _currency;
    out["exchangeRateToEur"] = _exchangeRateToEur;
    return out;
  }

  Map toBaseEditJson() {
    Map out = toFullMap();
    out.remove("password");
    out.remove("email");
    return out;
  }

  Map toLoginJson() {
    return {"login": login, "password": password};
  }

  Future<bool> checkLoginStatus() async {
    envelope_lib.Envelope envelope = new envelope_lib.Envelope.error(envelope_lib.INTERNAL_SERVER_ERROR);
    try {
      envelope = await Gateway.instance.get(CONTROLLER_USER);
    } catch (e) {}
    if (envelope.isSuccess) {
      if (envelope.message == envelope_lib.USER_NOT_LOGGED) {
        model.user.isLogged = false;
        return false;
      }
      model.user.fromMap(envelope.map);
      return true;
    }
//    else {
//      throw new Exception("error in user data");
//    }
    return false;
  }

  Future loadPointsOfOrigin(int userId) async{
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_GET_POINTS_OF_ORIGIN, data: {"userId": userId});
    if (envelope.isSuccess){
      pointsOfOrigin.fromMap(envelope.map);
      if(pointsOfOrigin.points.isNotEmpty){
//        TODO: Implement main point of origin
        selectedPointOfOrigin = pointsOfOrigin.points.last;
        _fireUserChanged();
        onPointsOfOriginLoaded.forEach((Function f) => f());
      }
      return OK;
    }else{
      return envelope.message;
    }
  }

  Future loadUserAboutEvents(int userId) async{
    List filters = [{"name": "event_in_future", "data": []}];
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_PLANNED_EVENT, data: {"filters": filters});
    if (envelope.isSuccess){
      clientAboutEvent.fromMap(envelope.map);
      return OK;
    }else{
      return envelope.message;
    }
  }

  Future<bool> submitCredentials(String login, String password) async {
    if (this != model.user) throw new ArgumentError("Only CentralUser can call submitCredentials()");
    this.login = login;
    this.password = password;
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_LOGIN, data: toLoginJson());
    if (envelope.isSuccess) {
      dynamic user = envelope.map["user"];
      if(user is Map<String, dynamic>){
        fromMap(user);
      }
    }
    return envelope.isSuccess;
  }

  void logout() {
    id = null;
    onUserChanged.forEach((Function f) => f());
    model.routes.route = ROUTE_RECOMMENDED_EVENTS;
    Gateway.instance.logout();
//    envelope_lib.Envelope envelope = await Gateway.instance.get(CONTROLLER_LOGOUT);
//    if(envelope.isSuccess){
//    }else{
//      throw new Exception("Log out failed");
//    }
  }

  Future<envelope_lib.Envelope> create() async {
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_CREATE_USER, data: toFullMap());
    if (envelope.isSuccess) {
      id = envelope.map["id"];
      onUserChanged.forEach((Function f) => f());
      return envelope;
    }
    return envelope;
  }

  Future<envelope_lib.Envelope> saveChanges() async {
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_EDIT_USER, data: toBaseEditJson());
    return envelope;
  }

  Future<Map> getResidencesForAutocomplete(String subString) async {
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_GOOGLE_PLACE_API, data: {"subString": subString});
    return JSON.decode(envelope.map["found"]);
  }

  Future<dynamic> changePassword(Map passwordData) async {
    dynamic data = await Gateway.instance.post(CONTROLLER_CHANGE_PASSWORD, data: passwordData);
    return data;
  }

  void fireChange() {
    onUserChanged.forEach((Function f) => f());
  }

  String get imgSrc {
    String defaultImage = 'images/user_images/user_avatar_default.png';
    if (model.user.imageData != "" && model.user.imageData != null) {
      return model.user.imageData;
    }
    if(!clientSettings.containsKey("haveImage")){
      return defaultImage;
    }
    if (clientSettings["haveImage"]) {
      if (window.localStorage.containsKey("userSettingsImageHash")) {
        return 'images/user_images/user_avatar_${model.user.id}.png#${window.localStorage["userSettingsImageHash"]}';
      }
      return 'images/user_images/user_avatar_${model.user.id}.png';
    } else {
      return defaultImage;
    }
  }

  Future<bool> loginByToken(String token, String tokenType) async {
    Map requestData = {"token": token, "tokenType": tokenType};
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_TOKEN_LOGIN, data: requestData);
    if (envelope.isSuccess) {
      if (envelope.map["user"] != null) {
        dynamic user = envelope.map["user"];
        if(user is Map<String, dynamic>){
          model.user.fromMap(user);
        }
        if (tokenType == "facebookToken") {
          facebookToken = token;
        }
        return true;
      }
    }
    return false;
  }
  Future<bool> connectSocial(String token, {bool facebook: false, bool google: false}) async {
    String controller;
    if (facebook) {
      controller = CONTROLLER_FACEBOOK_CONNECT_USER;
    } else if (google) {
      controller = CONTROLLER_GOOGLE_CONNECT_USER;
    } else {
      throw new ArgumentError("social network have to be specified");
    }
    envelope_lib.Envelope envelope = await Gateway.instance.post(controller, data: {"token":token});
    if (envelope.isSuccess) {
      if (envelope.map["user"] != null) {
        dynamic user = envelope.map["user"];
        if(user is Map<String, dynamic>){
          model.user.fromMap(user);
        }
        if (facebook) {
          facebookToken = token;
        }
        return true;
      }
    }
    return false;
  }

  Future confirmUser(String token) async {
    Map requestData = {"token": token};
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_CONFIRM_USER, data: requestData);
    if (envelope.isSuccess) {
      if (envelope.map["user"] != null) {
        dynamic user = envelope.map["user"];
        if(user is Map<String, dynamic>){
          model.user.fromMap(user);
        }
      }
    }
  }

  Future resetPassword(String newPassword, String token) async {
    Map requestData = {"newPassword": newPassword, "token": token};
    return await Gateway.instance.post(CONTROLLER_RESET_PASSWORD, data: requestData);
  }

  Future<envelope_lib.Envelope> createFromSocial(String token, {bool facebook: false, bool google: false}) async {
    String controller;
    if (facebook) {
      controller = CONTROLLER_CREATE_USER_FROM_FACEBOOK;
    } else if (google) {
      controller = CONTROLLER_CREATE_USER_FROM_GOOGLE;
    } else {
      throw new ArgumentError("social network have to be specified");
    }
    envelope_lib.Envelope envelope = await Gateway.instance.post(controller, data: {"token": token});
    if (envelope.isSuccess) {
      id = envelope.map["id"];
      onUserChanged.forEach((Function f) => f());
      return envelope;
    }
    return envelope;
  }

  bool canEditAnyEvent() {
    if(permissions!=null){
      if(permissions.containsKey("edit-event")){
        return permissions["edit-event"] == "any";
      }
      return false;
    }else{
      return false;
    }
  }
}

class ClientAboutEvent {
  ClientPlaces placesRepository;
  ClientOrganizers organizersRepository;
  RecommedationsFeedback recommedationsFeedback;
  PlannedEventsModel plannedEvents;

  ClientAboutEvent() {
    placesRepository = model.placesModel.placeRepository;
    organizersRepository = model.organizersModel.organizersRepository;
    plannedEvents = new PlannedEventsModel(this);
    recommedationsFeedback = new RecommedationsFeedback(this);
  }

  void fromMap(Map json) {
    plannedEvents.fromMap(json["events"]);
  }

  void saveChanges() {

  }
}

class PlannedEventsModel{
  ClientAboutEvent clientAboutEvent;
  List<ClientEvent> _plannedEvents = [];
  bool loaded = false;
  List<Function> onDataLoaded = [];

  List<ClientEvent> get plannedEvents => _plannedEvents;
  List<ClientEvent> get futurePlannedEvents{
    return _plannedEvents.where((ClientEvent event) => event.to.isAfter(new DateTime.now())).toList();
  }
  ClientPlaces get placesRepository => clientAboutEvent.placesRepository;
  ClientOrganizers get organizersRepository => clientAboutEvent.organizersRepository;

  PlannedEventsModel(this.clientAboutEvent);

  void fromMap(List events) {
    _plannedEvents.clear();
    for (Map event in events) {
      ClientEvent clientEvent = new ClientEvent(placesRepository, organizersRepository)
        ..fromMap(event);
      _plannedEvents.add(clientEvent);
    }
    loaded = true;
    onDataLoaded.forEach((Function f) => f());
  }

  void addEventToPlanned(ClientEvent event) {
    _plannedEvents.add(event);
    saveChanges(event.id, true);
  }

  void removePlannedEvent(ClientEvent event) {
    _plannedEvents.remove(event);
    saveChanges(event.id, false);
  }

  bool isEventInPlanned(ClientEvent event) {
    return _plannedEvents.contains(event);
  }

  Future saveChanges(int eventId, bool attend){
    clientAboutEvent.saveChanges();
    Map <String, dynamic> dataToPost = {"eventId": eventId, "attend": attend};
    return Gateway.instance.post(CONTROLLER_RATE_EVENT, data: dataToPost);

  }
}

class RecommedationsFeedback{
  ClientAboutEvent clientAboutEvent;
  Map<ClientEvent, bool> _evaluations = {};

  RecommedationsFeedback(this.clientAboutEvent);

  void evaluateRecommedationAsGood(ClientEvent event){
    _evaluations[event] = true;
    saveChanges(event.id, 0);
  }

  void evaluateRecommedationAsBad(ClientEvent event){
    _evaluations[event] = false;
    saveChanges(event.id, 1);
  }

  bool isPositivelyEvaluated(ClientEvent event){
    if(!_evaluations.containsKey(event)){
      return false;
    }
    return _evaluations[event];
  }

  bool isNegativelyEvaluated(ClientEvent event){
    if(!_evaluations.containsKey(event)){
      return false;
    }
    return !_evaluations[event];
  }

  bool isEventEvaluated(ClientEvent event){
    return _evaluations.keys.contains(event);
  }

  Future saveChanges(int eventId, int evaluate){
//    Rating 0 = good recommedation, 1 = bad recommedation
    clientAboutEvent.saveChanges();
    Map <String, dynamic> dataToPost = {"eventId": eventId, "rating": evaluate};
    return Gateway.instance.post(CONTROLLER_RATE_EVENT, data: dataToPost);
  }
}

class PointsOfOriginLoadedEvent{

}