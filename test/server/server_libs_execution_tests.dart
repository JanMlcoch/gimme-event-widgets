part of akcnik.tests.server_libs;

class RouteExecutionHelper {
  static PathProvider pp = new PathProvider();
  static shelf_router.Router createRouterWithTestRoute(server_lib.ContextProvider contextProvider,
      {String method: "GET"}) {
    shelf_router.Router router = server_lib.loadRouter();
    server_lib.route(pp.path, contextProvider, allowAnonymous: true, method: method);
//    print(path + " "+router.fullPaths.toString() +" "+ uri.toString());
    return router;
  }
}

void serverLibsExecutionTest() {
  shelf.Request request;
  PathProvider pp = RouteExecutionHelper.pp;
  group("request execution", () {
    //Uri requestUri = RouteExecutionHelper.uri;
    group("out stream closing", () {
      test("one respond", () {
        shelf_router.Router router = RouteExecutionHelper.createRouterWithTestRoute(() => new TestRequestContext(
            execute: (server_lib.RequestContext context) async => context.envelope.success('Test successful',envelope.TEST_SUCCESS)));
        request = new shelf.Request("GET", pp.uri);
        expect(getResponseMap(router.handler, request), completion(passedEnvelope('Test successful')));
      });
      test("two responds", () {
        shelf_router.Router router = RouteExecutionHelper
            .createRouterWithTestRoute(() => new TestRequestContext(execute: (server_lib.RequestContext context) {
                  context.envelope.success(envelope.TEST_SUCCESS);
                  context.envelope.error(envelope.TEST_ERROR);
                  return null;
                }));
        request = new shelf.Request("GET", pp.uri);
        expect(getResponseMap(router.handler, request), completion(failedEnvelope(envelope.ENVELOPE_ALREADY_FILLED)));
      });
      test("futured responds", () {
        shelf_router.Router router = RouteExecutionHelper.createRouterWithTestRoute(() => new TestRequestContext(
            execute: (server_lib.RequestContext context) =>
                new Future.delayed(new Duration(milliseconds: 100)).then((_) {
                  context.envelope.success("Test successful",envelope.TEST_SUCCESS);
                })));
        request = new shelf.Request("GET", pp.uri);
        expect(getResponseMap(router.handler, request), completion(passedEnvelope('Test successful')));
      });
      test("no responds", () {
        shelf_router.Router router = RouteExecutionHelper.createRouterWithTestRoute(
            () => new TestRequestContext(execute: (server_lib.RequestContext context) => null));
        request = new shelf.Request("GET", pp.uri);
        expect(getResponseMap(router.handler, request), completion(failedEnvelope(envelope.REQUEST_NOT_CLOSED)));
      });
    });
    group("full process path", () {
      test("end on onBeforeValidation", () {
        shelf_router.Router router = RouteExecutionHelper.createRouterWithTestRoute(() => new TestRequestContext(
            onBefore: (server_lib.RequestContext context) async =>
                context.envelope.success("ending on onBeforeValidation",envelope.TEST_SUCCESS),
            validate: (server_lib.RequestContext context) {
              throw new StateError("Failed test");
            }));
        request = new shelf.Request("GET", pp.uri);
        expect(getResponseMap(router.handler, request), completion(passedEnvelope('ending on onBeforeValidation')));
      });
      test("end on validation", () {
        shelf_router.Router router = RouteExecutionHelper.createRouterWithTestRoute(() => new TestRequestContext(
            validate: (server_lib.RequestContext context) async => context.envelope.success("ending on validation",envelope.TEST_SUCCESS),
            execute: (server_lib.RequestContext context) {
              throw new StateError("Failed test");
            }));
        request = new shelf.Request("GET", pp.uri);
        expect(getResponseMap(router.handler, request), completion(passedEnvelope('ending on validation')));
      });
      test("end on validation after delayed onBeforeValidation", () {
        shelf_router.Router router = RouteExecutionHelper.createRouterWithTestRoute(() => new TestRequestContext(
            onBefore: (_) => new Future.delayed(new Duration(milliseconds: 100)),
            validate: (server_lib.RequestContext context) async => context.envelope.success("ending on validation",envelope.TEST_SUCCESS),
            execute: (server_lib.RequestContext context) {
              throw new StateError("Failed test");
            }));
        request = new shelf.Request("GET", pp.uri);
        expect(getResponseMap(router.handler, request), completion(passedEnvelope('ending on validation')));
      });
    });
    group("trasfering", () {
      server_lib.ContextProvider innerProvider;
      server_lib.ContextProvider provider = () => new TestRequestContext(execute: (server_lib.RequestContext context) {
            return context.transfer(innerProvider);
          });
      test("not reaching transfer", () {
        shelf_router.Router router = RouteExecutionHelper.createRouterWithTestRoute(() => new TestRequestContext(
            validate: (server_lib.RequestContext context) async => context.envelope.success("ending on validation",envelope.TEST_SUCCESS),
            execute: (server_lib.RequestContext context) => context.transfer(innerProvider)));
        request = new shelf.Request("GET", pp.uri);
        expect(getResponseMap(router.handler, request), completion(passedEnvelope('ending on validation')));
      });
      test("data transfer", () {
        innerProvider = () => new TestRequestContext(
            execute: (server_lib.RequestContext context) async => context.envelope.withMap(context.data));
        shelf_router.Router router = RouteExecutionHelper.createRouterWithTestRoute(provider);
        request = new shelf.Request("GET", pp.getUri({"name": "nobody"}));
        expect(getResponseMap(router.handler, request),
            completion(new envelope.Envelope.withMap({'name': 'nobody'}).toMap()));
      });
      test("data transfer POST", () {
        innerProvider = () => new TestRequestContext(
            execute: (server_lib.RequestContext context) async => context.envelope.withMap(context.data));
        shelf_router.Router router = RouteExecutionHelper.createRouterWithTestRoute(provider, method: "POST");
        request = new shelf.Request("POST", pp.uri, body: JSON.encode({"name": "nobody"}));
        expect(getResponseMap(router.handler, request),
            completion(new envelope.Envelope.withMap({'name': 'nobody'}).toMap()));
      });
      test("method transfer POST", () {
        innerProvider = () => new TestRequestContext(
            execute: (server_lib.RequestContext context) async => context.envelope.success(context.method,envelope.TEST_SUCCESS));
        shelf_router.Router router = RouteExecutionHelper.createRouterWithTestRoute(provider, method: "POST");
        request = new shelf.Request("POST", pp.uri, body: JSON.encode({"name": "nobody"}));
        expect(getResponseMap(router.handler, request), completion(passedEnvelope('POST')));
      });
    });
  });
}
