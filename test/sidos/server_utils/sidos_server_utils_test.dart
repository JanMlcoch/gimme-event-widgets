library akcnik.tests.sidos.server_utils;

import 'package:test/test.dart';
import 'dart:async';
import '../../../sidos/sidos_server_utils.dart';

import '../computor/sidos_computor_tests.dart';
import '../scheduler/sidos_scheduler_tests.dart';
import 'package:logging/logging.dart' as log;


int timeoutInSeconds = 1;

void main(){
  copyMain();
  copyMain2();
  group("Settings test", () {
    Timer timeout;
    setUp(() {
      // fail the test after Duration
      timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
    });
    tearDown(() {
      // if the test already ended, cancel the timeout
      timeout.cancel();
    });

    test("SIDOS server console chattiness test", () {
      expect(new log.Logger("sidos").level is log.Level, isTrue);
    });

    test("EUR_PER_KILOMETER test", () {
      expect(EUR_PER_KILOMETER is num, isTrue);
    });

    test("MILLISECONDS_PER_KILOMETER test", () {
      expect(MILLISECONDS_PER_KILOMETER is num, isTrue);
    });
  });
}
