part of akcnik.server.authenticator;

/// Common password authenticator. It reads login and password from request and put
/// correct user into request context. I'm not sure, if request body is still accessible or not.
class PasswordAuthenticator extends auth.AbstractAuthenticator {
  PasswordAuthenticator({bool sessionCreationAllowed: true, bool sessionUpdateAllowed: true})
      : super(sessionCreationAllowed, sessionUpdateAllowed);

  @override
  Future<Option<auth.AuthenticatedContext<PrincipalUser>>> authenticate(shelf.Request request) async {
    dynamic data = request.context[server.DATA_CONTEXT_KEY];
    Map<String, dynamic> json;
    if (data is Map<String, dynamic>) {
      json = data;
    } else {
      return new None<auth.AuthenticatedContext<PrincipalUser>>();
    }
    if (json.containsKey("login") && json.containsKey("password")) {
      String login = json["login"];
      String password = json["password"];
      server_model.User user = await storage_lib.storage.connectHandler(
          (storage_lib.Connection connection) => connection.users.getUserByLoginOrEmailAndPassword(login, password));
      if (user != null) {
        return new Some<auth.AuthenticatedContext<PrincipalUser>>(createContext(new PrincipalUser(user.login, user)));
      }
    }
    return new None<auth.AuthenticatedContext<PrincipalUser>>();
  }
}
