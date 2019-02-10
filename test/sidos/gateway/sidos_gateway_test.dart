library akcnik.test.sidos.gateway;

import 'package:test/test.dart';
//import '../../../sidos/sidos_entities/library.dart';
import 'dart:async';
//import '../../../sidos/gateway_to_sidos/main.dart';
//import '../../../sidos/gateway/gateway.dart';
//import '../../common.dart';

Future main() async {
  _init();
  int timeoutInSeconds = 1;
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

//  runZoned(() {
  test("Test of communication", () async {
    expect(true, equals(true));
  });
}

void _init(){
//  ProcessEnvelope processEnvelope;
//  ProcessEnvelope requestEnvelope;
//  GatewayToSidos.instance.initSocket();
//  Gateway.init(processEnvelope, requestEnvelope);
}