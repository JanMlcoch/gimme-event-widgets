part of akcnik.server.authenticator;

/// Token authenticator for GET requests - URL with token should be only send by email
/// works like password authenticator, but token will be change immediately after successful login
class TokenAuthenticator extends auth.AbstractAuthenticator {
  TokenAuthenticator({bool sessionCreationAllowed: true, bool sessionUpdateAllowed: true})
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
    if (json["tokenType"] != null && json["tokenType"] != "oneTimeToken") {
      return new None<auth.AuthenticatedContext<PrincipalUser>>();
    }
    if (request.method != "POST") throw new ArgumentError("Token authenticator is allowed only with POST requests");
    String token = json["token"];

    server_model.User user = await storage_lib.storage
        .connectHandler((storage_lib.Connection connection) => connection.users.getUserByTokenAndReset(token));
    if (user != null) {
      return new Some<auth.AuthenticatedContext<PrincipalUser>>(createContext(new PrincipalUser(user.login, user)));
    }
    return new None<auth.AuthenticatedContext<PrincipalUser>>();
  }
}
