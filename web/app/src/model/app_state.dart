part of model;

class AppState{
  bool isSignUpDialog = false;
  bool isSignIn = false;

  bool get inAddEvent => model.routes.baseRoute == ROUTE_ADD_EVENT;

  bool get inUserSettings => model.routes.baseRoute == ROUTE_USER_SETTINGS;

  bool get inSignIn => model.routes.baseRoute == ROUTE_LOGIN;

  bool get inSignUp => model.routes.baseRoute == ROUTE_SIGN_UP;

  bool get inMap => model.routes.baseRoute == ROUTE_RECOMMENDED_EVENTS;

  bool get inForgottenPassword => model.routes.baseRoute == ROUTE_FORGOTTEN_PASSWORD;

  bool get inResetPassword => model.routes.baseRoute == ROUTE_RESET_PASSWORD;

  bool get inConfirmUser => model.routes.baseRoute == ROUTE_CONFIRM_USER;
  List<Function> onAppStateChanged=[];

  AppState(){
    if(model.routes.baseRoute==ROUTE_SIGN_UP){
      isSignUpDialog = true;
    }else if(model.routes.baseRoute==ROUTE_LOGIN){
      isSignUpDialog = true;
      isSignIn = true;
    }
  }





  void goToAddEvent() {
    model.routes.route = ROUTE_ADD_EVENT;
    _stateChanged();
  }

  void goToUserSettings() {
    model.routes.route = ROUTE_USER_SETTINGS;
    _stateChanged();
  }


  void _stateChanged(){
    for(Function f in onAppStateChanged){
      f();
    }
  }

  void goToSignIn() {
    model.routes.route = ROUTE_LOGIN;
    _stateChanged();
  }

  void goToSignUp() {
    model.routes.route = ROUTE_SIGN_UP;
    _stateChanged();
  }

  void goToForgottenPassword(){
    model.routes.route = ROUTE_FORGOTTEN_PASSWORD;
    _stateChanged();
  }

  void goToResetPassword(){
    model.routes.route = ROUTE_RESET_PASSWORD;
    _stateChanged();
  }

  void goToConfirmUser(){
    model.routes.route = ROUTE_CONFIRM_USER;
    _stateChanged();
  }

  void goToMap() {
    model.eventsModel.clearEventToShowDetail();
    _stateChanged();
  }

  void goToTestManager() {
    model.routes.route = ROUTE_TEST_MANAGER;
    _stateChanged();
  }

  void goToGeneric(hashUrl) {
    model.routes.route = hashUrl;
    _stateChanged();
  }
}