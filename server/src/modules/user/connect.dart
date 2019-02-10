part of userModule;

void _bindConnectUser() {
  libs.route(CONTROLLER_FACEBOOK_CONNECT_USER, () => new ConnectFacebookUserRC(),
      method: "POST", template: {"token": "string"});
  libs.route(CONTROLLER_GOOGLE_CONNECT_USER, () => new ConnectGoogleUserRC(),
      method: "POST", template: {"token": "string"});
  libs.route(CONTROLLER_MERGE_USERS, () => new MergeUsersRC(),
      method: "POST",
      template: {"token": "string", "!tokenType": "string", "secondToken": "string"},
      authenticateByToken: true);
}

class ConnectFacebookUserRC extends libs.RequestContext {
  String token;
  User foundUser;
  Map<String, dynamic> facebookJson;
  Future validate() async {
    token = data["token"];
    http.Response response = await http
        .get(new Uri.https("graph.facebook.com", "/v2.6/me", {"access_token": token, "fields": "id,name,email"}));
    try {
      facebookJson = JSON.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      envelope.error("JSON is unparsable: " + response.body, DATA_NOT_VALID_JSON);
    }
    foundUser = await connection.users.getUserBySocialId(int.parse(facebookJson["id"]), facebook: true);
    if (foundUser != null && foundUser.id != user.id) {
      if (await mailer.sendMergeUserEmail(user, foundUser)) {
        envelope.warning(
            "FacebookUser ${facebookJson["name"]} is already connected to ${foundUser.login}", USER_ALREADY_CONNECTED);
      } else {
        envelope.error("Merge User Email cannot be sent", USER_ALREADY_CONNECTED);
      }
      return null;
    }
  }

  Future execute() async {
    User updatedUser = await connection.users.updateModel(
        {"id": user.id, "clientSettings": user.clientSettings..["facebook_id"] = int.parse(facebookJson["id"])}, null);
    if (updatedUser == null) {
      envelope.error(DATABASE_ERROR);
      return null;
    }
    envelope.withMap(updatedUser.toSafeMap());
    new log.Logger("akcnik.server.context.connect_to_facebook")
        .fine("user ${updatedUser?.login} connected to ${facebookJson["name"]}");
    return null;
  }
}

class ConnectGoogleUserRC extends libs.RequestContext {
  String token;
  User foundUser;
  Map<String, dynamic> googleJson;

  Future validate() async {
    token = data["token"];
    http.Response response =
        await http.get(new Uri.https("www.googleapis.com", "/oauth2/v3/userinfo", {"access_token": token}));
    try {
      googleJson = JSON.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      envelope.error("JSON is unparsable: " + response.body, DATA_NOT_VALID_JSON);
      return null;
    }
    if (googleJson["sub"] == null) {
      envelope.error("Wrong googleAPI body: " + response.body, EXTERNAL_REQUEST_FAILED);
    }
    foundUser = await connection.users.getUserBySocialId(int.parse(googleJson["sub"]), google: true);
    if (foundUser != null && foundUser.id != user.id) {
      if (await mailer.sendMergeUserEmail(user, foundUser)) {
        envelope.warning(
            "GoogleUser ${googleJson["name"]} is already connected to ${foundUser.login}", USER_ALREADY_CONNECTED);
      } else {
        envelope.error("Merge User Email cannot be sent", USER_ALREADY_CONNECTED);
      }
      return null;
    }
  }

  Future execute() async {
    User updatedUser = await connection.users.updateModel(
        {"id": user.id, "clientSettings": user.clientSettings..["google_id"] = int.parse(googleJson["sub"])}, null);
    if (updatedUser == null) {
      envelope.error(DATABASE_ERROR);
      return null;
    }
    envelope.withMap(updatedUser.toSafeMap());
    new log.Logger("akcnik.server.context.connect_to_google")
        .fine("user ${updatedUser?.login} connected to ${googleJson["name"]}");
    return null;
  }
}

class MergeUsersRC extends libs.RequestContext {
  User secondaryUser;

  @override
  Future validate() async {
    secondaryUser = await connection.users.getUserByTokenAndReset(data["secondToken"]);
    if (secondaryUser == null) {
      envelope.error("cannot find the secondary User", USER_NOT_FOUND);
      return null;
    }
  }

  @override
  Future execute() async {
    Map<String, dynamic> removedMap = await connection.users.deleteModel({"id": secondaryUser.id});
    if (removedMap == null) {
      envelope.error("Cannot remove user ${secondaryUser.login}", DATABASE_ERROR);
    }
    Map<String, dynamic> updateMap = secondaryUser.toFullMap();
    user.toFullMap().forEach((String key, dynamic value) {
      if (updateMap[key] != null) {
        if (value is List) {
          updateMap[key] = (updateMap[key] as List).toSet()
            ..addAll(value)
            ..toList();
          return;
        } else if (value is Map) {
          (updateMap[key] as Map).addAll(value);
          return;
        }
      }
      updateMap[key] = value;
    });
    User updatedUser = await connection.users.updateModel(updateMap, null);
    if (updatedUser == null) {
      envelope.error("updating by ${convert.JSON.encode(updateMap)} failed", DATABASE_ERROR);
      return null;
    }
    envelope.withMap(updatedUser.toSafeMap());
    new log.Logger("akcnik.server.context.merge_users")
        .fine("user ${updatedUser?.login} merged with ${secondaryUser.login}");
    return null;
  }
}
