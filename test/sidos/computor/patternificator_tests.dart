part of akcnik.test.sidos.computor;

void patternificatorTests() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  Imprint newImprint = Imprintificator.instance.createImprint([],new GPS.withValues(5.4,5.6));
  Imprint newImprint2 = Imprintificator.instance.createImprint([],new GPS.withValues(1.4,5.6));

  test("Test of pattern creation without imprints", () async {
    UserPattern pattern = Patternificator.instance.createUserPatternFromImprints([]);
    expect(pattern is UserPattern, equals(true));
  });

  test("Test of pattern creation", () async {
    UserPattern pattern = Patternificator.instance.createUserPatternFromImprints([newImprint]);
    expect(pattern is UserPattern, equals(true));
  });

  test("Test of pattern creation with weights", () async {
    UserPattern pattern =
    Patternificator.instance.createUserPatternFromImprints([newImprint, newImprint2], weights: [0.5, 0.7]);
    expect(pattern is UserPattern, equals(true));
  });

  test("Test of pattern creation with points of origin", () async {
    UserPattern pattern = Patternificator.instance.createUserPatternFromImprints([newImprint, newImprint2],
        pointsOfOrigin: [new GPS.withValues(5.2, 6.2), new GPS.withValues(6.5, 8.7)]);
    expect(pattern is UserPattern, equals(true));
  });
}
