part of view_model;

class CentralModel{
  String forgottenPasswordEmailInputValue;
  UserSettingsModel userSettingsModel;
  List<Function> onChange=[];

  bool get inUserSettings => model.routes.baseRoute == ROUTE_USER_SETTINGS;

  bool get inForgottenPassword => model.routes.baseRoute == ROUTE_FORGOTTEN_PASSWORD;

  bool get inResetPassword => model.routes.baseRoute == ROUTE_RESET_PASSWORD;

  bool get inConfirmUser => model.routes.baseRoute == ROUTE_CONFIRM_USER;

  bool get inTestManager => model.routes.baseRoute == ROUTE_TEST_MANAGER;

  bool get isPlannedEvents => model.routes.baseRoute == ROUTE_PLANNED_EVENTS;

  CentralModel(){
    model.routes.onRouteChanged.add((){
      if(CENTRAL_ROUTES.contains(model.routes.baseRoute)){
        onChange.forEach((Function f)=>f());
      }
    });
    userSettingsModel = new UserSettingsModel(this);
  }

  Model get rootModel => model;
  ClientUser get user => model.user;

  String getTokenFromHash() {
    if (model.routes.attrs.containsKey("token")) {
      return model.routes.attrs["token"];
    } else {
      throw("No token found");
    }
  }

  Future confirmUser(String token) async {
    model.user.confirmUser(token);
  }

  Future resetPassword(String newPassword, String token) async{
    return model.user.resetPassword(newPassword, token);

  }

  void goToRecommendedEvents(){
    layoutModel.navbarModel.goToRecommendedEvents();
  }
}