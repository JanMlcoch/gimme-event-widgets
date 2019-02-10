part of akcnik.server.authenticator;

auth.SessionHandler<PrincipalUser> _sessionHandler;

shelf.Middleware getAuthenticator({bool byPassword, bool byToken, bool anonymous: false, String method}) {
  if (_sessionHandler == null) {
    _sessionHandler = new auth.JwtSessionHandler(
        "gimmeevent.com", "189bad58f0c08090bbdb14e00e621e123fe3844a1650a6fb663ca8227bfe0ff3", lookupUser);
  }
  if (byPassword && method != "POST")
    throw new ArgumentError("Password authenticator is allowed only with POST requests");
  if (byToken && method != "POST") throw new ArgumentError("Token authenticator is allowed only with POST requests");
  if (anonymous && byPassword || anonymous && byToken)
    throw new ArgumentError("With and without authenticator cannot be specified at the same time");
  List<auth.AbstractAuthenticator> authenticators = new List<auth.AbstractAuthenticator>();
  if (byPassword || byToken) {
    if (byPassword) {
      authenticators.add(new PasswordAuthenticator());
    }
    if (byToken) {
      authenticators.add(new TokenAuthenticator());
      authenticators.add(new FacebookAuthenticator());
      authenticators.add(new GoogleAuthenticator());
    }

    /// authenticator without sessionHandler - jwtToken is added in _responseSessionMiddleware
    shelf.Middleware authenticator = auth.authenticate(authenticators, allowHttp: true, allowAnonymousAccess: false);
    return new shelf.Pipeline().addMiddleware(authenticator).addMiddleware(_responseSessionMiddleware).middleware;
  }
  return auth.authenticate([], sessionHandler: _sessionHandler, allowHttp: true, allowAnonymousAccess: anonymous);
}

server_model.User getUserFromSession(shelf.Request request) {
  auth.AuthenticatedContext<PrincipalUser> mySession = auth.getAuthenticatedContext(request).getOrElse(() => null);
  ;
  if (mySession == null) return null;
  return mySession.principal.user;
}
