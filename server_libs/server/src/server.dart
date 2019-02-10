part of server_common;

Router _myRouter;
shelf.Middleware _middle;
const Map<String, String> defaultHeaders = const <String, String>{HttpHeaders.CONTENT_TYPE: "text/json"};

typedef RequestContext ContextProvider();

typedef dynamic InnerRoute(shelf.Request request);

void serve(int port) {
  shelf.Handler handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware(shelf_exception.exceptionHandler())
      .addHandler(_myRouter.handler);
  io.serve(handler, InternetAddress.ANY_IP_V4, port).then((HttpServer server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}

Router loadRouter() {
  _myRouter = router();
  return _myRouter;
}

Router get getRouter => _myRouter;

InnerRoute _createInnerRoute(String method, ContextProvider provider, Map<String, String> headers,
    {String permission: null}) {
  return (shelf.Request request) {
    StreamController innerController = new StreamController();
    model.User user = user_auth.getUserFromSession(request);
    if (user!= null && permission != null) {
      if(!user.havePermission(permission)){
        innerController.add(const Utf8Codec()
            .encode(JSON.encode(new Envelope.error("missing permission $permission", MISSING_PERMISSIONS).toMap())));
        innerController.close();
        return new shelf.Response.forbidden(innerController.stream, headers: headers);
      }
    }
    RequestContext context = provider();

    context
      ..method = method
      ..request = request
      ..user = user
      ..access = new AccessManager(permission, user)
      ..data = request.context[DATA_CONTEXT_KEY] as Map<String, dynamic>
      .._out = innerController;
    return context.process().then((_) {
      return new shelf.Response.ok(innerController.stream, headers: headers);
    });
  };
}

void route(String path, ContextProvider controller,
    {bool authenticateByPassword: false,
    bool authenticateByToken: false,
    bool allowAnonymous: false,
    String permission: null,
    String method: "GET",
    Map<String, String> headers: defaultHeaders,
    Map<String, dynamic> template: null}) {
//  if (permission != null && allowAnonymous)
//    throw new ArgumentError("Request for $permission permission and " + "allowAnonymous cannot be specified together");
  shelf.Middleware authenticator = user_auth.getAuthenticator(
      byPassword: authenticateByPassword, byToken: authenticateByToken, anonymous: allowAnonymous, method: method);
  shelf.Middleware middleware =
      new shelf.Pipeline().addMiddleware(getDataChecker(template)).addMiddleware(authenticator).middleware;
  shelf.Handler innerRoute = _createInnerRoute(method, controller, headers, permission: permission);
  _myRouter.add(path, [method], innerRoute, name: "$method $path", middleware: middleware);
}
