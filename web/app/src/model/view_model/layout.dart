part of view_model;


class LayoutModel {
  bool _isLeftVisible = true;
  bool _isCentralVisible = false;

//  bool _isLeftVisibleLast = true;
//  bool _isNavbarVisibleLast = true;
//  bool _isCentralVisibleLast = false;
  CentralModel centralModel;
  LeftPanelModel leftPanelModel;
  NavbarModel navbarModel;
  int _leftPanelWidth;
  List<Function> onChange = [];
  List<Function> onLeftPanelWidthChanged = [];

  bool get isCentralVisible => _isCentralVisible;

  bool get isLeftVisible => _isLeftVisible;

  LayoutModel() {
    _repaintLayoutWidgets();
    centralModel = new CentralModel();
    leftPanelModel = new LeftPanelModel();
    navbarModel = new NavbarModel();
//    _resolveVisibilityByRoute();
//    model.routes.onRouteChanged.add(_resolveVisibilityByRoute);
    model.routes.onRouteChanged.add(_repaintLayoutWidgets);
  }

  int get leftPanelWidth => _leftPanelWidth;

  set leftPanelWidth(int value) {
    onLeftPanelWidthChanged.forEach((Function f) => f());
    _leftPanelWidth = value;
  }

  void _repaintLayoutWidgets() {
    String baseRoute = model.routes.baseRoute;
    _isLeftVisible = baseRoute == ROUTE_EVENT_DETAIL ||
        baseRoute == ROUTE_RECOMMENDED_EVENTS ||
        baseRoute == ROUTE_ADD_EVENT;
    _isCentralVisible = baseRoute == ROUTE_CONFIRM_USER ||
        baseRoute == ROUTE_FORGOTTEN_PASSWORD ||
        baseRoute == ROUTE_USER_SETTINGS ||
        baseRoute == ROUTE_TEST_MANAGER ||
        baseRoute == ROUTE_RESET_PASSWORD ||
        baseRoute == ROUTE_PLANNED_EVENTS;
    onChange.forEach((Function f) => f());
  }


//  void _resolveVisibilityByRoute() {
//    String baseRoute = model.routes.baseRoute;
//    _isLeftVisible =
//        baseRoute == ROUTE_EVENT_DETAIL ||
//            baseRoute == ROUTE_RECOMMENDED_EVENTS ||
//            baseRoute == ROUTE_ADD_EVENT;
//    _isCentralVisible =
//        baseRoute == ROUTE_CONFIRM_USER ||
//            baseRoute == ROUTE_FORGOTTEN_PASSWORD ||
//            baseRoute == ROUTE_USER_SETTINGS ||
//            baseRoute == ROUTE_TEST_MANAGER ||
//            baseRoute == ROUTE_RESET_PASSWORD;
//
//    if (_isLeftVisible != _isLeftVisibleLast || _isCentralVisible != _isCentralVisibleLast ||
//        _isNavbarVisible != _isNavbarVisibleLast) {
//      _isLeftVisibleLast = _isLeftVisible;
//      _isCentralVisibleLast = _isCentralVisible;
//      _isNavbarVisibleLast = _isNavbarVisible;
//      onChange.forEach((Function f) => f());
//    }
//  }
}