part of akcnik.tests.sidos.prime;

void sugarTests() {
  SidosSocketEnvelope outcomingEnvelope;
  SidosSocketEnvelope incomingEnvelope;

  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  test("Test of communication", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.testEnvelope(message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.message,
        equals(message + "+ checked by sidos server"));
  });

  test("test of positive sort sugar", () async {
    List<int> sortedIds = await sortEvents([1,2], 1);
    expect(sortedIds.length,
        equals(2));
  });

  test("test of sugar sort all for existing user", () async {
    List<int> sortedIds = await sortEvents(null, 1);
    expect(sortedIds.length is int,
        equals(true));
  });

  test("test of sugar sort all for non-existing user", () async {
    List<int> sortedIds = await sortEvents(null, 78);
    expect(sortedIds.length is int,
        equals(true));
  });

  test("Final test of communication", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.testEnvelope(message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.message,
        equals(message + "+ checked by sidos server"));
  });
}
