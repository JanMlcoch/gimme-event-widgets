library akcnik.web.gateway;

import 'dart:html';
import 'dart:async';
import "dart:convert";
import "package:akcnik/constants/constants.dart";
import "package:akcnik/envelope.dart" as envelope_lib;
import 'package:akcnik/json_helper.dart';

part 'gateway_offline.dart';

class Gateway {
  static Gateway _instance;
  static bool offline = false;
  String userToken;

  static Gateway get instance {
    if (_instance == null) {
      if (offline) {
        _instance = new GatewayOffline();
      } else {
        _instance = new Gateway();
      }
    }
    return _instance;
  }

  Gateway() {
    if (window.localStorage.containsKey("userToken")) {
      userToken = window.localStorage["userToken"];
      if (userToken == "null") userToken = null;
    }
  }

  Future<envelope_lib.Envelope> _send(String url, {Map data: const {}, String method: "GET"}) async {
    Map<String, String> headers = {};

    if (userToken != null) {
      headers["authorization"] = userToken;
    }

    envelope_lib.Envelope out;
    HttpRequest request = await HttpRequest
        .request(url, method: method, sendData: JSON.encode(data), requestHeaders: headers)
        .catchError((dynamic e) {
      if (e.target.status == 401) {
        out = new envelope_lib.Envelope.warning(envelope_lib.USER_NOT_LOGGED);
        logout();
      } else {
        throw "$CONNECTION_ERROR - ${e.target.status.toString()}";
      }
    });
    if (out != null) {
      return out;
    }

    userToken = request.getResponseHeader("authorization");
    window.localStorage["userToken"] = userToken;
    String responseText = request.responseText;
    try {
      return new envelope_lib.Envelope.fromMap(decodeJsonMap(responseText));
    } catch (e) {
      throw responseText;
    }
  }

  Future<envelope_lib.Envelope> post(String url, {Map data: const {}}) async {
    return _send(url, data: data, method: "POST");
  }

  Future<envelope_lib.Envelope> get(String url) async {
    return _send(url, method: "GET");
  }

  void logout() {
    window.localStorage.remove("userToken");
    userToken = null;
  }
}
