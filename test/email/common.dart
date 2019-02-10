library akcnik.tests.email.common;

import 'dart:async';

Future<String> getEmail(StreamController controller) {
  if (controller == null) return new Future.value("Missing StreamController");
  Completer<String> completer = new Completer<String>();
  controller.stream.listen((String email) => completer.complete(email));
  return completer.future;
}
