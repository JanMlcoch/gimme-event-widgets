part of akcnik.server.authenticator;

class GoogleAuthenticator extends auth.AbstractAuthenticator {
  GoogleAuthenticator({bool sessionCreationAllowed: true, bool sessionUpdateAllowed: true})
      : super(sessionCreationAllowed, sessionUpdateAllowed);

  @override
  Future<Option<auth.AuthenticatedContext<PrincipalUser>>> authenticate(shelf.Request request) async {
    dynamic data = request.context[server.DATA_CONTEXT_KEY];
    Map<String, String> json;
    if (data is Map<String, String>) {
      json = data;
    } else {
      return new None<auth.AuthenticatedContext<PrincipalUser>>();
    }
    if (json["tokenType"] != "googleToken" || !json.containsKey("token")) {
      return new None<auth.AuthenticatedContext<PrincipalUser>>();
    }
    http.Response response =
        await http.get(new Uri.https("www.googleapis.com", "/oauth2/v3/tokeninfo", {"access_token": json["token"]}));
    Map<String, dynamic> gJson;
    try {
      gJson = JSON.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return new None<auth.AuthenticatedContext<PrincipalUser>>();
    }
    if (!(gJson["aud"] as String)
        .contains("635260593170-eefq1ock9bmm3je9f47058bn6b84q2dh.apps.googleusercontent.com")) {
      return new None<auth.AuthenticatedContext<PrincipalUser>>();
    }
    server_model.User user = await storage_lib.storage.connectHandler((storage_lib.Connection connection) =>
        connection.users.getUserBySocialId(int.parse(gJson["sub"]), google: true));

    if (user != null) {
      return new Some<auth.AuthenticatedContext<PrincipalUser>>(createContext(new PrincipalUser(user.login, user)));
    }
    return new None<auth.AuthenticatedContext<PrincipalUser>>();
  }
}
