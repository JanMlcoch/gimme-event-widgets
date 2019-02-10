import 'package:test/test.dart';
import 'common.dart';
import '../common.dart';
import 'package:akcnik/constants/constants.dart';
import 'package:akcnik/envelope.dart' as envelope_lib;
import 'dart:async';

Future main() async {
  await runServer(25689);
  Gateway.instance.port = 25689;
  group("password login", () {
    test("empty data", () {
      expect(Gateway.instance.post(CONTROLLER_LOGIN),
          throwsA(envelope_lib.DATA_IMPROPER_STRUCTURE));
    });
    test("missing password", () {
      expect(Gateway.instance.post(CONTROLLER_LOGIN, data: {"login": "unknownUserTest"}),
          throwsA(envelope_lib.DATA_IMPROPER_STRUCTURE));
    });
    test("unknown login", () {
      sendAndCompareMap(Gateway.instance.post(CONTROLLER_LOGIN, data: {"login": "unknownUserTest", "password": "pass"}),
          warnedEnvelope(envelope_lib.USER_NOT_LOGGED));
    });
    test("wrong password", () {
      sendAndCompareMap(Gateway.instance.post(CONTROLLER_LOGIN, data: {"login": "fkrtky", "password": "pass"}),
          warnedEnvelope(envelope_lib.USER_NOT_LOGGED));
    });
    test("correct password", () async {
      envelope_lib.Envelope result = await Gateway.instance.post(
          CONTROLLER_LOGIN, data: {"login": "fkrtky", "password": "fkrtky"});
      expect(result.map, contains("login"));
      expect(result.map["user"]["login"], "fkrtky");
      logout();
    });
    group("login function", () {
      test("wrong login", () {
        expect(() {
          login("unknownUserTest");
        }, throwsArgumentError);
      });
      test("correct login", () async {
        envelope_lib.Envelope result = await login("fkrtky");
        expect(result.map, contains("login"));
        expect(result.map["user"]["login"], "fkrtky");
        logout();
      });
    });
  });
}
