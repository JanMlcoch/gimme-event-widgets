library akcnik.tests.common;

import 'package:akcnik/json_helper.dart';
import "package:test/test.dart";
import "dart:convert";
import "dart:async";
import "../server_libs/server/library.dart" as server_lib;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_route/shelf_route.dart' as shelf_route;
import "../server/src/model/library.dart" as model_lib;
import 'package:crypto/crypto.dart' as crypto;
import 'dart:io';
import '../server/main.dart' as runner;
//import 'dart:math' as math;
import 'package:akcnik/envelope.dart';

part 'response_helpers.dart';

Future runServer(int port) => runner.main(["-dtest", "-p$port"]);

model_lib.ModelRoot constructModel({List<Map<String, dynamic>> usersJson: null,
List<Map<String, dynamic>> eventsJson: null,
List<Map<String, dynamic>> placesJson: null,
List<Map<String, dynamic>> tagsJson: null,
List<Map<String, dynamic>> organizersJson: null}) {
  model_lib.ModelRoot model = new model_lib.ModelRoot();
  if (usersJson != null) {
    for (Map<String, dynamic> userJson in usersJson) {
      model.users.add(new model_lib.User()..fromMap(userJson));
    }
  }
  if (placesJson != null) {
    for (Map<String, dynamic> placeJson in placesJson) {
      model.places.add(new model_lib.Place()..fromMap(placeJson));
    }
  }
  if (organizersJson != null) {
    for (Map organizerJson in organizersJson) {
      model.organizers.add(new model_lib.Organizer()..fromMap(organizerJson));
    }
  }
  if (tagsJson != null) {
    for (Map<String, dynamic> tagJson in tagsJson) {
      model.tags.add(new model_lib.Tag()..fromMap(tagJson));
    }
  }
  if (eventsJson != null) {
    for (Map eventJson in eventsJson) {
      model.events.add(new model_lib.Event()..fromMap(eventJson));
      model.events.list.forEach((model_lib.Event event) {
        //print(event.costs.getRepresentativePrice());
        event.representativePrice = event.costs.getRepresentativePrice();
      });
    }
  }
  return model;
}

class PathProvider {
  static int _testPathCounter = 0;
  final String path;
  Uri uri;
  PathProvider() : path = _getUniqueTestPath() {
    uri = getUri();
  }

  Uri getUri([Map<String, String> query]) {
    return new Uri.http("localhost", path, query);
  }

  static String _getUniqueTestPath() {
    return "/api/test/${crypto.md5.convert([_testPathCounter++])}";
  }
}

//class StringProvider{
//  static int _counter = 0;
//  final String message;
//  StringProvider():message=crypto.md5.convert([_counter++]);
//}
int _randomStringCounter = 0;

String getRandomString() => crypto.md5.convert([_randomStringCounter++]).toString();

String routerContainsPath(shelf_route.Router router, String path) {
//  print(router.fullPaths);
  Iterable<shelf_route.PathInfo> filtered =
  router.fullPaths.where((shelf_route.PathInfo pathInfo) => pathInfo.path == path);
  expect(filtered.length, 1, reason: "Missing route $path");
  if (filtered.length == 0) return null;
  return filtered.first.method;
}

Directory get projectDir {
  Directory projectDir = Directory.current;
  while (projectDir.parent != null && !projectDir.path.endsWith("akcnik")) {
    projectDir = projectDir.parent;
  }
  return projectDir;
}

typedef Future ContextToFuture(server_lib.RequestContext context);

class TestRequestContext extends server_lib.RequestContext {
//  final bool strictMode = false;
  final ContextToFuture onBeforeValidateFunction;
  final ContextToFuture validateFunction;
  final ContextToFuture executeFunction;
  @override
  TestRequestContext({Future<dynamic> onBefore(server_lib.RequestContext request): null,
  Future<dynamic> validate(server_lib.RequestContext request): null,
  Future<dynamic> execute(server_lib.RequestContext request): null})
      : this.onBeforeValidateFunction = onBefore,
        this.validateFunction = validate,
        this.executeFunction = execute,
        super();
  Future onBeforeValidation() {
    if (onBeforeValidateFunction == null) return null;
    return onBeforeValidateFunction(this);
  }

  Future validate() {
    if (validateFunction == null) return null;
    return validateFunction(this);
  }

  Future execute() {
    if (executeFunction == null) {
      envelope.success("Test successful", TEST_SUCCESS);
      return null;
    }
    return executeFunction(this);
  }
}
