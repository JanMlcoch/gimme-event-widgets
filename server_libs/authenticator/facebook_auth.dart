part of akcnik.server.authenticator;

class FacebookAuthenticator extends auth.AbstractAuthenticator {
  FacebookAuthenticator({bool sessionCreationAllowed: true, bool sessionUpdateAllowed: true})
      : super(sessionCreationAllowed, sessionUpdateAllowed);

  @override
  Future<Option<auth.AuthenticatedContext>> authenticate(shelf.Request request) async {
    dynamic data = request.context[server.DATA_CONTEXT_KEY];
    Map<String, dynamic> json;
    if (data is Map<String, dynamic>) {
      json = data;
    } else {
      return new None<auth.AuthenticatedContext<PrincipalUser>>();
    }
    if (json["tokenType"] != "facebookToken" || !json.containsKey("token")) {
      return new None<auth.AuthenticatedContext<PrincipalUser>>();
    }
    http.Response response = await http.get(new Uri.https("graph.facebook.com", "/v2.6/me", {
      "access_token": (json["token"] as String),
//        "fields":"id,name,email,first_name,last_name,locale,friends{id,name}"
      "fields": "id"
    }));
    Map<String, dynamic> fbJson;
    try {
      fbJson = JSON.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return new None<auth.AuthenticatedContext<PrincipalUser>>();
    }
    server_model.User user = await storage_lib.storage.connectHandler((storage_lib.Connection connection) =>
        connection.users.getUserBySocialId(int.parse(fbJson["id"]), facebook: true));
    if (user != null) {
      return new Some<auth.AuthenticatedContext<PrincipalUser>>(createContext(new PrincipalUser(user.login, user)));
    }
    return new None<auth.AuthenticatedContext<PrincipalUser>>();
  }
}
