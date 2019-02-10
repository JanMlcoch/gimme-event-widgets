library akcnik.web.facebook.helpers;

import 'dart:async';
import "dart:js" as js;
import 'package:akcnik/envelope.dart' as envelope_lib;
import 'dart:convert';
import 'package:akcnik/json_helper.dart';

Future loadFacebookSDK() {
  Completer completer = new Completer();
  js.context.callMethod("loadFacebookSDK", [() {
    completer.complete();
  }
  ]);
  return completer.future;
}

Future<envelope_lib.Envelope> checkFacebookStatus() async {
  Completer completer = new Completer();
  js.context["FB"]
      .callMethod('getLoginStatus', [(response) => completer.complete(new js.JsObject.fromBrowserObject(response))]);
  js.JsObject response = await completer.future;
  if (response["status"] == 'connected') {
    String token = response["authResponse"]["accessToken"];
    return new envelope_lib.DataEnvelope.withMap({"status": response["status"], "token": token});
  }
  return new envelope_lib.Envelope.error(response["status"], envelope_lib.EXTERNAL_REQUEST_FAILED);
}

Future<envelope_lib.Envelope> facebookLogin({List<String> scope: const []}) async {
  Completer completer = new Completer();
  Map<String, dynamic> options = {};
  if (scope.length > 0) {
    options["scope"] = scope.join(",");
  }
  js.context["FB"].callMethod('login',
      [(response) => completer.complete(new js.JsObject.fromBrowserObject(response)), new js.JsObject.jsify(options)]);
  js.JsObject response = await completer.future;
  if (response["status"] == 'connected') {
    String token = response["authResponse"]["accessToken"];
    return new envelope_lib.DataEnvelope.withMap({"status": response["status"], "token": token});
  }
  return new envelope_lib.Envelope.error(response["status"], envelope_lib.EXTERNAL_REQUEST_FAILED);
}

Future<envelope_lib.Envelope> facebookApi(String url, String token, Map<String, dynamic> sourceOptions) async {
  Map<String, String> options = {"token":token};
  if (sourceOptions != null) {
    sourceOptions.forEach((String key, dynamic value) {
      options[key] = value.toString();
    });
  }
  Completer completer = new Completer();
  js.context["FB"].callMethod('api',
      [
        url,
            (response) => completer.complete(new js.JsObject.fromBrowserObject(response)),
        new js.JsObject.jsify(options)
      ]);
  js.JsObject response = await completer.future;
  dynamic data = response["data"];
  if (data != null) {
    if (data is js.JsArray) {
      return new envelope_lib.Envelope.withList(decodeJsonMapList(
          js.context['JSON'].callMethod(
              'stringify',
              [data]
          )
      ));
    } else if (data is js.JsObject) {
      var dartMap = JSON.decode(
          js.context['JSON'].callMethod(
              'stringify',
              [data]
          )
      );
      if(dartMap is Map<String,dynamic>) {
        return new envelope_lib.Envelope.withMap(dartMap);
      }
      return new envelope_lib.Envelope.error("data is unknown type", envelope_lib.DATA_NOT_VALID_JSON);
    } else {
      return new envelope_lib.Envelope.error("data is unknown type", envelope_lib.DATA_NOT_VALID_JSON);
    }
  }
  return new envelope_lib.Envelope.error(response["status"], envelope_lib.EXTERNAL_REQUEST_FAILED);
}


