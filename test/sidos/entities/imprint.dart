part of akcnik.tests.sidos.task_completer;

void imprintTests() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

//  GPS prague = new GPS.withValues(50.0797, 14.4826);

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

  Imprint imprint1 = new Imprint()..points = {1: link11, 2: link12}..place = new GPS.withValues(13.0,48.0)..baseCost = 0.0..visitLength = 3000000;
  Imprint imprint2 = new Imprint()..points = {1: link21, 2: link22}..place = new GPS.withValues(16.0,52.0)..baseCost = 7.2..visitLength = 25000000;
  Imprint jsonedImprint1 = new Imprint()..fromMap(imprint1.toFullMap());

  test("Test of to/from map consistency", () {
    expect(jsonedImprint1.toFullMap(), equals(imprint1.toFullMap()));
  });

  test("Test of sum output type", () {
    expect(Imprint.sum([imprint1, imprint2]).points.isNotEmpty && Imprint.sum([imprint1, imprint2]) is Imprint , equals(true));
  });

  test("Test of sum stacionarity", () {
    Map summedImprint = Imprint.sum([imprint1]).toFullMap();
    summedImprint = roundJsonObject(summedImprint);
    expect(summedImprint["points"], equals(imprint1.toFullMap()["points"]));
  });

}
