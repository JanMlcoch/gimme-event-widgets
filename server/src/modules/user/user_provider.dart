part of userModule;

void _bindUserProvide() {
  libs.route(CONTROLLER_USER, () => new UserRequestContext(), method: "GET", allowAnonymous: true);
  // TODO: security hole
  libs.route(CONTROLLER_FIND_USER, () => new FindUserRC(), method: "POST", template: {"find": "string"});
  libs.route(CONTROLLER_FORGOTTEN_PASSWORD, () => new ForgottenPassword(),
      method: "POST", template: {"login": "string"}, allowAnonymous: true);
  libs.route(CONTROLLER_RESET_PASSWORD, () => new ResetPassword(),
      method: "POST",
      authenticateByToken: true,
      template: {"newPassword": "string", "token": "string", "!tokenType": "string"});
  libs.route(CONTROLLER_CONFIRM_USER, () => new ConfirmUser(),
      method: "POST", authenticateByToken: true, template: {"token": "string", "!tokenType": "string"});
  libs.route(CONTROLLER_CHANGE_PASSWORD, () => new ChangePasswordRequestContext(),
      method: "POST",
      authenticateByPassword: true,
      template: {"password": "string", "newPassword": "string", "login": "string"});
  libs.route(CONTROLLER_GOOGLE_PLACE_API, () => new PlaceApiRequestContext(),
      method: "POST",
      template: {"subString": "string"});
}

class ChangePasswordRequestContext extends libs.RequestContext {
//  @override
//  Future validate() {
//    if (user == null) {
//      envelope.error=USER_NOT_LOGGED;
//    }
//    return null;
//  }

  @override
  Future execute() async {
    User updatedUser = await connection.users.changePassword(user.id, data["newPassword"]);
    if (updatedUser != null) {
      envelope.success(REQUEST_SUCCESS);
    } else {
      envelope.error(RESET_PASSWORD_ERROR);
    }
    return null;
  }
}

class PlaceApiRequestContext extends libs.RequestContext {
//  @override
//  Future validate() {
//    if (user == null) {
//      envelope.error=USER_NOT_LOGGED;
//    }
//    return null;
//  }

  @override
  Future execute() async {
    String subString = data["subString"];
    String apiUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$subString&types=(cities)&key=AIzaSyDvgRz-1Pgmkrq0FVwpmkdd2ohuUbyVy6U";
    String jsonPlace;
    jsonPlace = await http.read(apiUrl);
    if (jsonPlace != null) {
      envelope.withMap({"found": jsonPlace});
    } else {
      envelope.error("to je ale divná chyba");
    }
    return null;
  }
}

class UserRequestContext extends libs.RequestContext {
  @override
  Future execute() {
    if (user != null) {
      envelope.withMap(user.toSafeMap());
    } else {
      envelope.success(USER_NOT_LOGGED);
    }
    return null;
  }
}

class FindUserRC extends libs.RequestContext {
  @override
  Future execute() async {
    String toFind = data["find"];
    User foundUser = await connection.users.getUserByLoginOrEmail(toFind);
    if (foundUser != null) {
      envelope.withMap(foundUser.toSafeMap());
    } else {
      envelope.error(USER_NOT_FOUND);
    }
    return null;
  }
}

class ForgottenPassword extends libs.RequestContext {

  @override
  Future validate() {
    if (user != null) {
      envelope.error("User ${user.login} is logged", USER_LOGGED);
    }
    return null;
  }

  @override
  Future execute() async {
    String loginOrEmail = data["login"];
    User user = await connection.users.getUserByLoginOrEmail(loginOrEmail);
    if (user == null) {
      envelope.error(USER_NOT_FOUND);
      return null;
    }
    mailer.sendResetPasswordEmail(user);
    envelope.success(RESET_PASSWORD_EMAIL_SENT);
    return null;
  }
}

class ResetPassword extends libs.RequestContext {

  @override
  Future execute() async {
    String newPassword = data["newPassword"];
    User updatedUser = await connection.users.changePassword(user.id, newPassword);
    if (updatedUser != null) {
      envelope.withMap(updatedUser.toSafeMap());
      return null;
    } else {
      envelope.error(RESET_PASSWORD_ERROR);
      return null;
    }
  }
}

class ConfirmUser extends libs.RequestContext {
  @override
  Future execute() async {
    User updatedUser = await connection.users.updateModel({"id": user.id, "proven": true, "role": "user"}, null);
    envelope.withMap({"login": true, "message": "login successfull", "user": updatedUser.toSafeMap()});
    return null;
  }
}
