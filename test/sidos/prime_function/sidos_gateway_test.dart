library akcnik.tests.sidos.prime;

import 'package:test/test.dart';
import '../../../sidos/sidos_entities/library.dart';
import 'dart:async';
import 'dart:convert';
import '../../../sidos/gateway_to_sidos/main.dart';
import 'dart:io';
import '../common.dart' as sidos_common;
import '../../common.dart';
import 'package:akcnik/log_helper.dart' as log_helper;

part 'match_and_complete.dart';
part 'request_response_simple.dart';
part 'request_response_succes.dart';
part 'request_response_scheduling.dart';
part 'sort.dart';
part 'sugar.dart';
part 'misc.dart';

int timeoutInSeconds = 5;

Future main() async {
  log_helper.rootLoggerPrint(all: true);
  await sidos_common.startServer();
  group("Simple Request-response tests", () {
    requestResponseSimpleTests();
  });
  group("Success Request-response tests", () {
    requestResponseSuccessTests();
  });
  group("Request-response scheduling tests", () {
    requestResponseSchedulingTests();
  });
  group("Sort tests", () {
    sortTests();
  });
  group("Sugar tests",(){
    sugarTests();
  });
  group("Miscellaneous tests", () {
    miscTests();
  });
  group("Temporary imprint tests", () {

    SidosSocketEnvelope outcomingEnvelope;
    SidosSocketEnvelope incomingEnvelope;

    Timer timeout;
    setUp(() {
      // fail the test after Duration
      timeout = new Timer(new Duration(seconds: 5), () => fail("timed out"));
    });
    tearDown(() {
      // if the test already ended, cancel the timeout
      timeout.cancel();
    });
    test("Temporary Test of update Imprint 1", () async {
      String message = getRandomString();
      print(message);
      outcomingEnvelope = new SidosSocketEnvelope.updateImprintEnvelope(1, [1], message: message);
      incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
      expect(incomingEnvelope.message, equalsAndComplete(message, new Completer()));
    });
  });
}
