part of akcnik.test.sidos.computor;

void imprintificatorTests() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  test("Test of imrpint creation", () async {
    Imprint imprint = Imprintificator.instance.createImprint([1, 2], new GPS.withValues(45.6, 18.6), baseCost: 0.0);
    expect(imprint is Imprint, equals(true));
  });
}
