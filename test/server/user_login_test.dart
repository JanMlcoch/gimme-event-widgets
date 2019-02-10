library akcnik.test.user_login;

import "package:test/test.dart";
import "dart:convert";
import "../../server_libs/server/library.dart" as server_lib;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_route/shelf_route.dart' as shelf_route;
import "../../server/src/model/library.dart" as model_lib;
import "../common.dart";
import '../sample_data/library.dart' as sample;
import "../../server/src/storage/library.dart" as storage_lib;
import 'package:akcnik/envelope.dart' as envelope;

void init() {
  model_lib.ModelRoot model = sample.constructModel();
  storage_lib.loadMemoryStorage(model);
}

String extractToken(shelf.Response response) {
  return response.headers["authorization"];
}

Map<String, String> tokenHeader(String token) {
  return {"authorization": token};
}

void main() {
  init();
  group("initialization", () {
    test("storage is not null", () {
      expect(storage_lib.storage, isNotNull);
    });
  });
  group("User login", () {
    PathProvider loginPath = new PathProvider();
    PathProvider tokenPath = new PathProvider();
    PathProvider sessionPath = new PathProvider();
    PathProvider permissionPath = new PathProvider();
    shelf.Request request;
    shelf_route.Router router = server_lib.loadRouter();
    server_lib.route(loginPath.path, () => new TestRequestContext(),
        authenticateByPassword: true, method: "POST", template: {"login": "string", "password": "string"});
    server_lib.route(tokenPath.path, () => new TestRequestContext(),
        authenticateByToken: true, method: "POST", template: {"login": "string", "token": "string"});
    server_lib.route(
        sessionPath.path,
        () => new TestRequestContext(execute: (server_lib.RequestContext context) {
      context.envelope.success(context.data["message"], envelope.TEST_SUCCESS);
            }),
        method: "POST",
        template: {"message": "string"});
    server_lib.route(
        permissionPath.path,
        () => new TestRequestContext(execute: (server_lib.RequestContext context) {
      context.envelope.success(context.data["message"], envelope.TEST_SUCCESS);
            }),
        method: "POST",
        template: {"message": "string"},
        permission: "testPermission");
    group("password", () {
      test("without login", () async {
        String body = JSON.encode({"name": "Ahoj"});
        request = new shelf.Request("POST", loginPath.uri, body: body);
        expect(await getResponseMap(router.handler, request),
            failedEnvelope('Missing "login" parameter of "rootData"', envelope.DATA_IMPROPER_STRUCTURE));
      });
      test("without password", () async {
        String body = JSON.encode({"login": "Ahoj"});
        request = new shelf.Request("POST", loginPath.uri, body: body);
        expect(await getResponseMap(router.handler, request),
            failedEnvelope('Missing "password" parameter of "rootData"', envelope.DATA_IMPROPER_STRUCTURE));
      });
      test("wrong login", () async {
        String body = JSON.encode({"login": "Ahoj", "password": "cosi"});
        request = new shelf.Request("POST", loginPath.uri, body: body);
        String message = await requestError(router.handler, request);
        expect(message, "Status 401: Unauthorized");
      });
      test("wrong password", () {
        String body = JSON.encode({"login": "ringael", "password": "cosi"});
        request = new shelf.Request("POST", loginPath.uri, body: body);
        expect(requestError(router.handler, request), completion("Status 401: Unauthorized"));
      });
      test("correct password", () async {
        String body = JSON.encode({"login": "ringael", "password": "heslo"});
        request = new shelf.Request("POST", loginPath.uri, body: body);
        shelf.Response response = await router.handler(request);
        expect(extractToken(response), isNotNull);
      });
    });
    group("token", () {
      test("wrong login", () {
        String body = JSON.encode({"login": "Ahoj", "token": "cosi"});
        request = new shelf.Request("POST", tokenPath.uri, body: body);
        expect(requestError(router.handler, request), completion("Status 401: Unauthorized"));
      });
      test("wrong token", () {
        String body = JSON.encode({"login": "ringael", "token": "cosi"});
        request = new shelf.Request("POST", tokenPath.uri, body: body);
        expect(requestError(router.handler, request), completion("Status 401: Unauthorized"));
      });
      test("correct token", () async {
        String body = JSON.encode({"login": "ringael", "token": "ringaelringaelringaelringaelringael"});
        request = new shelf.Request("POST", tokenPath.uri, body: body);
        shelf.Response response = await router.handler(request);
        expect(extractToken(response), isNotNull);
      });
      test("token is changed", () async {
        String body = JSON.encode({"login": "ringael", "token": "ringaelringaelringaelringaelringael"});
        request = new shelf.Request("POST", tokenPath.uri, body: body);
        expect(requestError(router.handler, request), completion(contains("Status 401: Unauthorized")));
      });
      test("generated token", () async {
        model_lib.User user = await storage_lib.storage.connectHandler((storage_lib.Connection connection) {
          return connection.users.getUserByLoginOrEmail("ringael");
        });
        expect(user, isNotNull);
        String token = user.authenticationToken;
        String body = JSON.encode({"login": "ringael", "token": token});
        request = new shelf.Request("POST", tokenPath.uri, body: body);
        shelf.Response response = await router.handler(request);
        expect(extractToken(response), isNotNull);
        expect(token, isNot(user.authenticationToken));
      });
    });
    group("session", () {
      String token;
      test("get token", () async {
        String body = JSON.encode({"login": "ringael", "password": "heslo"});
        request = new shelf.Request("POST", loginPath.uri, body: body);
        shelf.Response response = await router.handler(request);
        token = extractToken(response);
        expect(token, isNotNull);
//        print(token);
      });
      test("no token", () {
        String body = JSON.encode({"message": "Ahoj"});
        request = new shelf.Request("POST", sessionPath.uri, body: body);
        expect(requestError(router.handler, request), completion("Status 401: Unauthorized"));
      });
      test("wrong token", () {
        String body = JSON.encode({"message": "Ahoj"});
        request =
            new shelf.Request("POST", sessionPath.uri, body: body, headers: tokenHeader("ShelfAuthJwtSession cosi"));
        expect(
            requestError(router.handler, request),
            completion('Invalid argument(s): JWS tokens must be in form \'<header>.<payload>.<signature>\'.\n' +
                'Value: \'cosi\' is invalid'));
      });
      test("outdated token", () {
        String body = JSON.encode({"message": "Ahoj"});
        request = new shelf.Request("POST", sessionPath.uri,
            body: body,
            headers: tokenHeader('SShelfAuthJwtSession ' +
                'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.' +
                'eyJpYXQiOjE0NjM3NDc1OTcsImV4cCI6MTQ2Mzc0OTM5NywiaXNzIjoiZ2ltbWVldmVudC5jb20iLCJzdWIiOiJyaW5nYWVsIiwiYXVkIjpbbnVsbF0sInNpZCI6IjA3YWFlZjgwLWZlMTAtMTFlNS05NWIzLWMzOWE2YzQzNWY0ZSIsInRzZSI6MTQ2MzgzMzk5N30.' +
                'wmz9VpMoPVtQO02Gf70kiuSEhK278I_K8RRqfkY2y0Y'));
        expect(requestError(router.handler, request), completion("Status 401: Unauthorized"));
      });
      test("correct token", () async {
        String body = JSON.encode({"message": "Ahoj"});
        request = new shelf.Request("POST", sessionPath.uri, body: body, headers: tokenHeader(token));
        shelf.Response response = await router.handler(request);
        expect(extractToken(response), isNot(token));
        expect(response.readAsString(), completion(JSON.encode(passedEnvelope("Ahoj"))));
      });
    });
    group("permissions", () {
      String userToken;
      String adminToken;
      test("login Taliesin", () async {
        String body = JSON.encode({"login": "taliesin", "password": "aaa"});
        request = new shelf.Request("POST", loginPath.uri, body: body);
        shelf.Response response = await router.handler(request);
        userToken = extractToken(response);
        expect(userToken, isNotNull);
      });
      test("no permission", () async {
        String body = JSON.encode({"message": "Ahoj"});
        request = new shelf.Request("POST", permissionPath.uri, body: body, headers: tokenHeader(userToken));
        shelf.Response response = await router.handler(request);
        expect(response.statusCode, 403);
        expect(response.readAsString(),
            completion(JSON.encode(failedEnvelope("missing permission testPermission", envelope.MISSING_PERMISSIONS))));
      });
      test("login Ringael", () async {
        String body = JSON.encode({"login": "ringael", "password": "heslo"});
        request = new shelf.Request("POST", loginPath.uri, body: body);
        shelf.Response response = await router.handler(request);
        adminToken = extractToken(response);
        expect(userToken, isNotNull);
      });
      test("with permission", () async {
        String body = JSON.encode({"message": "Ahoj"});
        request = new shelf.Request("POST", permissionPath.uri, body: body, headers: tokenHeader(adminToken));
        shelf.Response response = await router.handler(request);
        expect(extractToken(response), isNot(adminToken));
        expect(response.readAsString(), completion(JSON.encode(passedEnvelope("Ahoj"))));
      });
    });
  });
}
