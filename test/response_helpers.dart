part of akcnik.tests.common;


Future<Envelope> getResponse(Function innerRoute, shelf.Request request) async {
  //Completer completer = new Completer<Map>();
  shelf.Response response;
  //request = await _store.loadSession(request);
  response = await innerRoute(request);
  return envelopeFromResponse(response);
}

Future<Map> getResponseMap(Function innerRoute, shelf.Request request) {
  return getResponse(innerRoute, request).then((Envelope envelope) => envelope.toMap());
}

Future<Envelope> envelopeFromResponse(shelf.Response response) async {
  String string = await response.readAsString();
  try {
    return new Envelope.fromMap(decodeJsonMap(string));
  } on FormatException {
    return new Envelope.error(string, TEST_ERROR);
  }
}

Future<String> requestError(shelf.Handler innerRoute, shelf.Request request) async {
  try {
    shelf.Response response = await innerRoute(request);
    return envelopeFromResponse(response).then((Envelope envelope) => JSON.encode(envelope.toMap()));
  } on Exception catch (e) {
    return e.toString();
  } on Error catch (e) {
    return e.toString();
  }
}

String getErrorMessage(void inner(), [Matcher error]) {
  try {
    inner();
    fail("function did not throw error");
  } on TypeError catch (e) {
    if (error != null) {
      expect(e, error);
    }
    return e.toString();
  } catch (e) {
    if (error != null) {
      expect(e, error);
    }
    return e.message;
  }
  return null;
}

Future<String> getAsyncErrorMessage(void inner(), [Matcher error]) async {
  try {
    await inner();
    fail("function did not throw error");
  } on TypeError catch (e) {
    if (error != null) {
      expect(e, error);
    }
    return e.toString();
  } catch (e) {
    if (error != null) {
      expect(e, error);
    }
    return e.message;
  }
  return null;
}

Map<String, dynamic> failedEnvelope(String message, [String category = null]) {
  if (category == null) category = TEST_ERROR;
  return new Envelope.error(message, category).toMap();
}

Map<String, dynamic> warnedEnvelope(String message, [String category = null]) {
  if (category == null) category = TEST_WARNING;
  return new Envelope.warning(message, category).toMap();
}

Map<String, dynamic> passedEnvelope(String message, [String category = null]) {
  if (category == null) category = TEST_SUCCESS;
  return new Envelope.success(message, category).toMap();
}
//Map<String,dynamic> envelopeWithMap(Map<String,dynamic> map){
//  Envelope envelope = new Envelope();
//  return (envelope..map=map).toMap();
//}
//Map<String,dynamic> envelopeWithList(List<dynamic> list){
//  Envelope envelope = new Envelope();
//  return (envelope..list=list).toMap();
//}
Map<String, dynamic> getMapFromEnvelope(Envelope envelope) {
  expect(envelope.isSuccess, true, reason: "envelope contains error: ${envelope.message}");
  expect(envelope.map, isMap);
  return envelope.map;
}

List<dynamic> getListFromEnvelope(Envelope envelope) {
  expect(envelope.isSuccess, true, reason: "envelope contains error: ${envelope.message}");
  expect(envelope.map, isList);
  return envelope.list;
}