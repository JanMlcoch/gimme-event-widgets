part of akcnik.tests.server_libs;

void serverLibsTest() {
  shelf_router.Router router;
  shelf.Request request;
  //Function innerRoute;
  group("create route", () {
    setUp(() {
      /// before every test - because "router" will change itself after router.fullPaths call
      router = server_lib.loadRouter();
    });
    test("loadRouter", () {
      expect(router, isNotNull);
    });
    test("bare route", () {
      String path = new PathProvider().path;
      server_lib.route(path, () => new TestRequestContext());
      expect(routerContainsPath(router, path), "GET");
    });
    test("parameter route", () {
      String path = new PathProvider().path;
      server_lib.route(path, () => new TestRequestContext(), template: {"name": "string"});
      expect(routerContainsPath(router, path), "GET");
    });
    group("GET", () {
      test("bare", () {
        String path = new PathProvider().path;
        server_lib.route(path, () => new TestRequestContext(), method: "GET");
        expect(routerContainsPath(router, path), "GET");
      });
      test("Map template", () {
        String path = new PathProvider().path;
        server_lib.route(path, () => new TestRequestContext(), method: "GET", template: {"name": "string"});
        expect(routerContainsPath(router, path), "GET");
      });
    });
    group("POST", () {
      test("Map template", () {
        String path = new PathProvider().path;
        server_lib.route(path, () => new TestRequestContext(), method: "POST", template: {"name": "string"});
        expect(routerContainsPath(router, path), "POST");
      });
    });
  });
  group("template validation", () {
    setUp(() {
      /// before every test - because "router" will change itself after router.fullPaths call
      router = server_lib.loadRouter();
    });
    group("GET", () {
      test("with strange type", () {
        String path = new PathProvider().path;
        String message = getErrorMessage(() {
          server_lib.route(path, () => new TestRequestContext(), method: "GET", template: {"name": "wrong"});
        }, isArgumentError);
        expect(message, "wrong is unknown class");
      });
      test("with int as key", () {
        String path = new PathProvider().path;
        String message = getErrorMessage(() {
          server_lib.route(path, () => new TestRequestContext(), method: "GET", template: {
            "map": {1: 2}
          });
        });
        expect(message, startsWith("type 'int' is not a subtype of type 'String'"));
      });
      test("deep template - success", () async {
        String path = new PathProvider().path;
        server_lib.route(path, () => new TestRequestContext(), method: "GET", template: {
          "userID": "int",
          "arr": [
            {"name": "string", "value": "double", "more": "Map"}
          ]
        });
        expect(routerContainsPath(server_lib.getRouter, path), "GET");
      });
      test("deep template - fail", () {
        String path = new PathProvider().path;
        String message = getErrorMessage(() {
          server_lib.route(path, () => new TestRequestContext(), method: "GET", template: {
            "userID": "int",
            "arr": [
              {"name": "string", "value": "doubl", "more": "Map"}
            ]
          });
        }, isArgumentError);
        expect(message, "doubl is unknown class");
      });
    });
  });
  group("validation by template", () {
    setUp(() {
      /// before every test - because "router" will change itself after router.fullPaths call
      router = server_lib.loadRouter();
    });
    group("GET", () {
      test("with string", () async {
        String path = new PathProvider().path;
        server_lib.route(path, () => new TestRequestContext(),
            method: "GET", template: {"name": "string"}, allowAnonymous: true);
        request = new shelf.Request("GET", Uri.parse("http://localhost$path?name=Ahoj"));
        envelope.Envelope res = await getResponse(router.handler, request);
        expect(res.toMap(), passedEnvelope("Test successful"));
      });
      test("with many - success", () async {
        String path = new PathProvider().path;
        server_lib.route(path, () => new TestRequestContext(),
            allowAnonymous: true, method: "GET", template: {"name": "string", "pass": "string", "number": "string"});
        request = new shelf.Request("GET", Uri.parse("http://localhost$path?name=Ahoj&pass=aaa&number=1"));
        envelope.Envelope res = await getResponse(router.handler, request);
        expect(res.toMap(), passedEnvelope("Test successful"));
      });
      test("with many - fail", () async {
        String path = new PathProvider().path;
        server_lib.route(path, () => new TestRequestContext(),
            allowAnonymous: true, method: "GET", template: {"name": "string", "pass": "string", "number": "int"});
        request = new shelf.Request("GET", Uri.parse("http://localhost$path?name=Ahoj&pass=aaa&number=1"));
        envelope.Envelope res = await getResponse(router.handler, request);
        expect(
            res.toMap(), failedEnvelope('"number" should be int instead of String', envelope.DATA_IMPROPER_STRUCTURE));
      });
    });
    group("POST", () {
      PathProvider pp = new PathProvider();
      test("with string", () {
        server_lib.route(pp.path, () => new TestRequestContext(),
            allowAnonymous: true, method: "POST", template: {"name": "string"});
        String body = JSON.encode({"name": "Ahoj"});
        request = new shelf.Request("POST", pp.uri, body: body);
        expect(getResponseMap(router.handler, request), completion(passedEnvelope("Test successful")));
      });
      test("with wrong key", () {
        server_lib.route(pp.path, () => new TestRequestContext(),
            allowAnonymous: true, method: "POST", template: {"name": "string"});
        String body = JSON.encode({"message": "Ahoj"});
        request = new shelf.Request("POST", pp.uri, body: body);
        expect(
            getResponseMap(router.handler, request),
            completion(failedEnvelope('Missing "name" parameter of "rootData"', envelope.DATA_IMPROPER_STRUCTURE)));
      });
      test("with wrong type", () {
        server_lib.route(pp.path, () => new TestRequestContext(),
            allowAnonymous: true, method: "POST", template: {"name": "string"});
        String body = JSON.encode({"name": 1});
        request = new shelf.Request("POST", pp.uri, body: body);
        expect(
            getResponseMap(router.handler, request),
            completion(failedEnvelope('"name" should be string instead of int', envelope.DATA_IMPROPER_STRUCTURE)));
      });
      group("deep template", () {
        PathProvider pp = new PathProvider();
        setUp(() {
          server_lib.route(pp.path, () => new TestRequestContext(), allowAnonymous: true, method: "POST", template: {
            "userID": "int",
            "arr": [
              {"name": "string", "value": "double"}
            ]
          });
        });
        test("empty arr - success", () {
          String body = JSON.encode({"userID": 1, "arr": []});
          request = new shelf.Request("POST", pp.uri, body: body);
          expect(getResponseMap(router.handler, request), completion(passedEnvelope("Test successful")));
        });
        test("wrong type - fail", () {
          String body = JSON.encode({"userID": "ahoj", "arr": []});
          request = new shelf.Request("POST", pp.uri, body: body);
          expect(getResponseMap(router.handler, request),
              completion(failedEnvelope('"userID" should be int instead of String', envelope.DATA_IMPROPER_STRUCTURE)));
        });
        test("full arr - fail", () {
          String body = JSON.encode({
            "userID": 1,
            "arr": [
              {"name": "Les", "value": 1},
              {"name": "Pole", "value": 1.25}
            ]
          });
          request = new shelf.Request("POST", pp.uri, body: body);
          expect(getResponseMap(router.handler, request),
              completion(failedEnvelope('"value" should be double instead of int', envelope.DATA_IMPROPER_STRUCTURE)));
        });
        test("full arr - success", () {
          String body = JSON.encode({
            "userID": 1,
            "arr": [
              {"name": "Les", "value": 1.00},
              {"name": "Pole", "value": 1.25}
            ]
          });
          request = new shelf.Request("POST", pp.uri, body: body);
          expect(getResponseMap(router.handler, request), completion(passedEnvelope('Test successful')));
        });
      });
    });
    group("optional parameters in POST", () {
      PathProvider pp = new PathProvider();
      test("strict non-null int", () {
        server_lib.route(pp.path, () => new TestRequestContext(),
            allowAnonymous: true, method: "POST", template: {"age": "int"});
        String body = JSON.encode({"age": null});
        request = new shelf.Request("POST", pp.uri, body: body);
        expect(getResponseMap(server_lib.getRouter.handler, request),
            completion(failedEnvelope('"age" should be int instead of Null', envelope.DATA_IMPROPER_STRUCTURE)));
      });
      test("optional int", () {
        server_lib.route(pp.path, () => new TestRequestContext(),
            allowAnonymous: true, method: "POST", template: {"age": "?int"});
        String body = JSON.encode({"age": null});
        request = new shelf.Request("POST", pp.uri, body: body);
        expect(getResponseMap(server_lib.getRouter.handler, request), completion(passedEnvelope('Test successful')));
      });
      test("optional int with string", () {
        server_lib.route(pp.path, () => new TestRequestContext(),
            allowAnonymous: true, method: "POST", template: {"age": "?int"});
        String body = JSON.encode({"age": "nine"});
        request = new shelf.Request("POST", pp.uri, body: body);
        expect(getResponseMap(server_lib.getRouter.handler, request),
            completion(failedEnvelope('"age" should be int instead of String', envelope.DATA_IMPROPER_STRUCTURE)));
      });
      test("optional key", () {
        server_lib.route(pp.path, () => new TestRequestContext(),
            allowAnonymous: true, method: "POST", template: {"?age": "int"});
        String body = JSON.encode({});
        request = new shelf.Request("POST", pp.uri, body: body);
        expect(getResponseMap(server_lib.getRouter.handler, request), completion(passedEnvelope('Test successful')));
      });
      test("optional key with wrong type", () {
        server_lib.route(pp.path, () => new TestRequestContext(),
            allowAnonymous: true, method: "POST", template: {"?age": "int"});
        String body = JSON.encode({"age": "nine"});
        request = new shelf.Request("POST", pp.uri, body: body);
        expect(getResponseMap(server_lib.getRouter.handler, request),
            completion(failedEnvelope('"age" should be int instead of String', envelope.DATA_IMPROPER_STRUCTURE)));
      });
      test("optional key with null = fail", () {
        server_lib.route(pp.path, () => new TestRequestContext(),
            allowAnonymous: true, method: "POST", template: {"?age": "int"});
        String body = JSON.encode({"age": null});
        request = new shelf.Request("POST", pp.uri, body: body);
        expect(getResponseMap(server_lib.getRouter.handler, request),
            completion(failedEnvelope('"age" should be int instead of Null', envelope.DATA_IMPROPER_STRUCTURE)));
      });
    });
  });
}
