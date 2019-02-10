library tag_filter.test;

import "dart:html";
import "dart:async";
import "dart:convert";

import "package:akcnik/constants/constants.dart";

part "test.dart";
part "widgetoid.dart";
part "inputed_tag_widgetoid.dart";

void main() {
  getOptions("", "", "").then((Object response) {
    print(response);
  });
  tests();
}

Future<Object> getOptions(String names, String substring, String origin) {
  Completer completer = new Completer();
  HttpRequest
      .request("http://localhost$CONTROLLER_TAG_FILTER_GET_OPTIONS",
          method: "POST",
          sendData: JSON.encode(
              {"tagNames": names, "origin": origin, "substring": substring}))
      .then((HttpRequest req) {
    completer.complete(req.response);
  });

  return completer.future;
}

String serializeNames(List<String> names) {
  String out = "";
  names.forEach((String name) {
    out = out + name + "\\\\\\";
  });
  return out;
}
