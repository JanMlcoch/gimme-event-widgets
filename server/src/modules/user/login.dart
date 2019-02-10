part of userModule;

void _bindUserLogin() {
  libs.route(CONTROLLER_LOGIN, () => new LoginRequestContext(),
      method: "POST", template: {"login": "string", "password": "string"}, authenticateByPassword: true);
  libs.route(CONTROLLER_TOKEN_LOGIN, () => new LoginRequestContext(),
      method: "POST", template: {"token": "string", "tokenType": "string"}, authenticateByToken: true);
//  libs.route(CONTROLLER_LOGOUT, () => new LogoutRequestContext(), method: "GET");
}

class LoginRequestContext extends libs.RequestContext {
  @override
  Future execute() async {
    envelope.withMap({"login": true, "message": "login successfull", "user": user.toSafeMap()});
  }
}

//class LogoutRequestContext extends libs.RequestContext {
//  @override
//  Future execute() {
//    envelope.withMap({"logout": true, "message": "logout successfull"});
//    new log.Logger("akcnik.server.context").info("user ${user?.login} logged out");
//    //close();
//    return null;
//  }
//}
