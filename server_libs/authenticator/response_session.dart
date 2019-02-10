part of akcnik.server.authenticator;

shelf.Middleware _responseSessionMiddleware = (shelf.Handler innerHandler) {
  return (shelf.Request request) async {
    shelf.Response response = await innerHandler(request);
    auth.AuthenticatedContext<PrincipalUser> context = auth.getAuthenticatedContext(request).getOrElse(() => null);
    if (context == null) return response;
    return _sessionHandler.handle(context, request, response);
  };
};
