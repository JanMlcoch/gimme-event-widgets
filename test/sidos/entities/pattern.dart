part of akcnik.tests.sidos.task_completer;

void patternTests() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  GPS prague = new GPS.withValues(50.0797, 14.4826);

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
  ImprintPoint link21 = new ImprintPoint()
    ..probability = 0.5
    ..zeroVariance = 0.1
    ..valueVariance = 0.2
    ..value = 0.4;
  ImprintPoint link22 = new ImprintPoint()
    ..probability = 0.9
    ..zeroVariance = 0.3
    ..valueVariance = 0.1
    ..value = 0.9;

  UserPattern pattern = new UserPattern()
    ..eventCount = 2.0
    ..moneyConservation = 1.5
    ..pointsOfOrigin = [prague]
    ..timeConservation = 1.7
    ..travelReluctance = 2.5
    ..points = {1: link11, 2: link12};

  UserPattern pattern2 = new UserPattern()
    ..eventCount = 3.0
    ..moneyConservation = 5.5
    ..pointsOfOrigin = [prague]
    ..timeConservation = 1.1
    ..travelReluctance = 2.7
    ..points = {1: link21, 2: link22};

  UserPattern jsonedPattern = new UserPattern()..fromMap(pattern.toFullMap());

  test("Test of to/from map consistency", () {
    expect(jsonedPattern.toFullMap(), equals(pattern.toFullMap()));
  });

  test("Test of sum output type", () {
    UserPattern sum = UserPattern.sum([pattern, pattern2]);
    expect(sum.points.isNotEmpty && sum is UserPattern,
        equals(true));
  });

  test("Test of sum stacionarity", () {
    Map summedPattern = UserPattern.sum([pattern]).toFullMap();
    summedPattern = roundJsonObject(summedPattern);
    expect(summedPattern["points"], equals(pattern.toFullMap()["points"]));
  });
}
