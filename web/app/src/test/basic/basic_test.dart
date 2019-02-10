library akcnik.web.test.basic;

import 'dart:async';
import 'package:matcher/matcher.dart';
import '../test_helpers.dart';

void main() {
  group("Basic");
  test("true=true", () {
    expect(true, isTrue);
  });
  test("false=true", () {
    expect(false, isTrue);
  });
  test("delayed await", () async {
    expect(await new Future.delayed(new Duration(milliseconds: 500), () => "test"), "test");
  });
}
