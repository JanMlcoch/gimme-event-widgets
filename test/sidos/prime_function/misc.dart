part of akcnik.tests.sidos.prime;

void miscTests() {
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

  //todo: money conservation "hotfix" (giving default value) makes this test to fail
  test("Test of hard caching consistency", () async {
    String message = getRandomString();
    outcomingEnvelope =
        new SidosSocketEnvelope.createHardCache(message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);

    String originalCacheString =
        await new File('${projectDir.path}/sidos/computor/cachor/hard_cache/file.txt')
            .readAsString();

    outcomingEnvelope = new SidosSocketEnvelope.loadHardCache(message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    outcomingEnvelope =
        new SidosSocketEnvelope.createHardCache(message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);

    String resultCacheString =
        await new File('${projectDir.path}/sidos/computor/cachor/hard_cache/file.txt')
            .readAsString();
    Map resultMap = JSON.decode(resultCacheString);
    Map originalMap = JSON.decode(originalCacheString);
    expect(resultMap, equals(originalMap));
  }, skip: true);

  test("Final test of communication", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.testEnvelope(message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.message,
        equals(message + "+ checked by sidos server"));
  });
}
