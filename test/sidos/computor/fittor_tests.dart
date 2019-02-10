part of akcnik.test.sidos.computor;

void fittorTests() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  test("Test of fit", () async {
    Cachor.wipe();
    UserPattern pattern = Patternificator.instance.createUserPatternFromImprints([]);
    Imprint imprint = Imprintificator.instance.createImprint([6], new GPS.withValues(5.65,5.48), baseCost: 0.0);
    double fitIndex = Fittor.instance.fitIndex(pattern, imprint).value;
    expect(fitIndex is double, equals(true));
  });
}
