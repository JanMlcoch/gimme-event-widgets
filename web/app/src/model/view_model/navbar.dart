part of view_model;

class NavbarModel {
  bool _isSignUpDialog = false;
  bool _isSignIn = false;
  bool _isAddEvent = false;
  bool _isUserSettings = false;
  bool _isRecommendedEvents = false;
  bool _isPlannedEvents = false;
  List<Function> onChange = [];
  List<Function> onUserChange = [];

  bool get isSignIn => _isSignIn;
  bool get isSignUpDialog => _isSignUpDialog;
  bool get isAddEvent => _isAddEvent;
  bool get isUserSettings => _isUserSettings;
  bool get isRecommendedEvents => _isRecommendedEvents;
  bool get isPlannedEvents => _isPlannedEvents;

  ClientUser get user => model.user;

  NavbarModel() {
    _resolveRoute();
    model.user.onUserChanged.add(() {
      onUserChange.forEach((Function f) => f());
    });
    model.routes.onRouteChanged.add(() {
      _resolveRoute();
      onChange.forEach((Function f) => f());
    });
  }

  void _resolveRoute() {
    resetBooleans();
    if (model.routes.baseRoute == ROUTE_SIGN_UP) {
      _isSignUpDialog = true;
    } else if (model.routes.baseRoute == ROUTE_LOGIN) {
      _isSignUpDialog = true;
      _isSignIn = true;
    } else if (model.routes.baseRoute == ROUTE_RECOMMENDED_EVENTS) {
      _isRecommendedEvents = true;
    } else if (model.routes.baseRoute == ROUTE_ADD_EVENT) {
      _isAddEvent = true;
    } else if (model.routes.baseRoute == ROUTE_USER_SETTINGS) {
      _isUserSettings = true;
    } else if (model.routes.baseRoute == ROUTE_PLANNED_EVENTS) {
      _isPlannedEvents = true;
    }
  }

  void resetBooleans() {
    _isSignUpDialog = false;
    _isSignIn = false;
    _isAddEvent = false;
    _isUserSettings = false;
    _isRecommendedEvents = false;
    _isPlannedEvents = false;
  }

  void goToAddEvent() {
    model.routes.route = ROUTE_ADD_EVENT;
  }

  void goToUserSettings() {
    model.routes.route = ROUTE_USER_SETTINGS;
  }

  void goToSignIn() {
    model.routes.route = ROUTE_LOGIN;
  }

  void goToSignUp() {
    model.routes.route = ROUTE_SIGN_UP;
  }

  void goToForgottenPassword() {
    model.routes.route = ROUTE_FORGOTTEN_PASSWORD;
  }

  void goToResetPassword() {
    model.routes.route = ROUTE_RESET_PASSWORD;
  }

  void goToConfirmUser() {
    model.routes.route = ROUTE_CONFIRM_USER;
  }

//  void goToMap() {
//    model.eventsModel.backToBaseEvents();
//    _stateChanged();
//  }

  void goToRecommendedEvents() {
    model.routes.route = ROUTE_RECOMMENDED_EVENTS;
  }

  void goToPlannedEvents() {
    model.routes.route = ROUTE_PLANNED_EVENTS;
  }

  void closeSignUpDialog() {
    if (isSignIn || isSignUpDialog || isRecommendedEvents) {
      _isSignUpDialog = false;
      goToRecommendedEvents();
    }
  }
}
