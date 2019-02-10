part of akcnik.tests.sidos.task_completer;

void imprintPointTests() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  ImprintPoint link11 = new ImprintPoint()
    ..probability = 0.8
    ..zeroVariance = 0.1
    ..valueVariance = 0.1
    ..value = 1.0;
  ImprintPoint link12 = new ImprintPoint()
    ..probability = 0.3
    ..zeroVariance = 0.1
    ..valueVariance = 0.3
    ..value = 0.5;
//  ImprintPoint link21 = new ImprintPoint()
//    ..probability = 0.5
//    ..zeroVariance = 0.1
//    ..valueVariance = 0.2
//    ..value = 0.4;
//  ImprintPoint link22 = new ImprintPoint()
//    ..probability = 0.9
//    ..zeroVariance = 0.3
//    ..valueVariance = 0.1
//    ..value = 0.9;

  ImprintPoint jsonedLink11 = new ImprintPoint()..fromMap(link11.toFullMap());

  test("Test of to/from map consistency", () {
    expect(jsonedLink11.toFullMap(), equals(link11.toFullMap()));
  });

  test("Test of sum output type", () {
    ImprintPoint sum = ImprintPoint.sum([link11, link11]);
    expect(sum is ImprintPoint, equals(true));
  });

  test("Test of sum commutation", () {
    ImprintPoint sum = ImprintPoint.sum([link11, link12]);
    ImprintPoint sumCommuted = ImprintPoint.sum([link12, link11]);
    expect(sumCommuted.toFullMap(), equals(sum.toFullMap()));
  });

  test("Test of sum stacionarity", () {
    Map summedImprintPoint = ImprintPoint.sum([link11]).toFullMap();
    summedImprintPoint = roundJsonObject(summedImprintPoint);
    expect(summedImprintPoint, equals(link11.toFullMap()));
  });
}
