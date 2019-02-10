library akcnik.tests.client_server_api.common;

import 'dart:async';
import 'package:akcnik/envelope.dart' as envelope_lib;
import 'package:akcnik/constants/constants.dart';
import 'package:akcnik/json_helper.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

part 'gateway.dart';

const Map<String, String> _userCredentials = const {
  "velkypasa": "velkypasa", // admin
  "fkrtky": "fkrtky", // unproven
  "gratzky": "gratzky" // user
};

Future<envelope_lib.Envelope> login([String login = "fkrtky"]) {
  if (!_userCredentials.containsKey(login)) throw new ArgumentError("missing credentials for user $login");
  return Gateway.instance.post(CONTROLLER_LOGIN, data: {"login": login, "password": _userCredentials[login]});
}

void logout() => Gateway.instance.logout();

void sendAndCompareMap(Future<envelope_lib.Envelope> response, Map<String, dynamic> target) {
  expect(response.then((envelope_lib.Envelope envelope) => envelope.toMap()), completion(target));
}
