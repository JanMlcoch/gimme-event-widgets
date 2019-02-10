part of model;

class Routes{
  static List pastRoutes = [];
  String _route;
  String _baseRoute;
  String get route => _route;
  List<Function> onRouteChanged = [];

  Routes(){
    model.user.onUserChanged.add((){
      if(!model.user.isLogged && LOGGED_ROUTES.contains(_route)){
        route = ROUTE_RECOMMENDED_EVENTS;
      }
    });
  }

  static String getBaseRouteFromRoute(String route){
    String routeWithoutAttrs = route.toString().split("?")[0];
    if (routeWithoutAttrs.contains("-")) {
      List split = routeWithoutAttrs.split("-");
      routeWithoutAttrs = split[0];
    }
    return routeWithoutAttrs;
  }

  void setActualRoute(){
    String hash = window.location.hash;
    String hashKey = hash.replaceFirst("#", "");
    route = hashKey;
  }

  /// routeWithoutAttrs is route without attrs (after question mark) but can
  /// contains id (after dash)
  String get routeWithoutAttrs => _route.toString().split("?")[0];

  /// base route is route without id and attrs, it determine subpages
  String get baseRoute => _baseRoute;

  ///  return value after dash, before attrs part
  String get valueAfterDash {
    if(routeWithoutAttrs.contains("-")){
      return routeWithoutAttrs.split("-")[1];
    }
    return "";
  }

  /// return only attrs of route (after question mark)
  String get routeAttrs {
    if (_route.length > 0) {
      return _route.toString().substring(routeWithoutAttrs.length + 1);
    }
    return "";
  }

  Map<String, String> get attrs {
    if (routeAttrs == null || routeAttrs == "") {
      return {};
    }
    Map<String, String> attrs = {};
    for (String attr in routeAttrs.split("&")) {
      List<String> parts = attr.split("=");
      String key = parts[0];
      String value = parts[1];
      attrs[key] = value;
    }
    return attrs;
  }

  void set route(Object val) {
    if (_route == val) {
      return;
    }
    int id;
    String routeWithoutAttrs = val.toString().split("?")[0];
    String attrs = val.toString().substring(routeWithoutAttrs.length);
    if (routeWithoutAttrs.contains("-")) {
      List split = routeWithoutAttrs.split("-");
      try {
        id = int.parse(split[1]);
      } catch (exception) {
        id = null;
      }
      routeWithoutAttrs = split[0];
    }
    if (!ROUTES.contains(routeWithoutAttrs)) {
      return;
    }
    if (LOGGED_ROUTES.contains(routeWithoutAttrs) && !model.user.isLogged) {
      return;
    }
    pastRoutes.add(_route);
    if (id != null) {
      _route = "$routeWithoutAttrs-$id$attrs";
    } else {
      _route = "$val";
    }
    if (routeWithoutAttrs.contains("-")) {
      _baseRoute = routeWithoutAttrs.split("-")[0];
    } else {
      _baseRoute = routeWithoutAttrs;
    }
    window.location.hash = "${routeWithoutAttrs == ROUTE_RECOMMENDED_EVENTS ? "" : "#"}$_route";
    onRouteChanged.forEach((Function f) {
      f();
    });
  }

}








const String ROUTE_RECOMMENDED_EVENTS = "";
const String ROUTE_LOGIN = "login";
const String ROUTE_SIGN_UP = "sign_up";
const String ROUTE_USER_SETTINGS = "user_settings";
const String ROUTE_FORGOTTEN_PASSWORD = "forgotten_password";
const String ROUTE_RESET_PASSWORD = "reset_password";
const String ROUTE_CONFIRM_USER = "confirm_user";
const String ROUTE_TEST_MANAGER = "test_manager";
const String ROUTE_PLANNED_EVENTS = "planned_events";
const String ROUTE_ADD_EVENT = "add_event";
const String ROUTE_EVENT_DETAIL = "event_detail";
const List<String> CENTRAL_ROUTES = const[
  ROUTE_USER_SETTINGS,
  ROUTE_FORGOTTEN_PASSWORD,
  ROUTE_RESET_PASSWORD,
  ROUTE_CONFIRM_USER,
  ROUTE_TEST_MANAGER,
  ROUTE_PLANNED_EVENTS
];
const List<String> LEFT_PANEL_ROUTES = const[
  ROUTE_RECOMMENDED_EVENTS,
  ROUTE_ADD_EVENT,
  ROUTE_EVENT_DETAIL
];


const List<String> LOGGED_ROUTES = const[ROUTE_ADD_EVENT, ROUTE_USER_SETTINGS];
bool onceDone = false;

const List ROUTES = const[
  ROUTE_RECOMMENDED_EVENTS,
  ROUTE_LOGIN,
  ROUTE_SIGN_UP,
  ROUTE_USER_SETTINGS,
  ROUTE_ADD_EVENT,
  ROUTE_EVENT_DETAIL,
  ROUTE_FORGOTTEN_PASSWORD,
  ROUTE_RESET_PASSWORD,
  ROUTE_CONFIRM_USER,
  ROUTE_TEST_MANAGER,
  ROUTE_PLANNED_EVENTS
];