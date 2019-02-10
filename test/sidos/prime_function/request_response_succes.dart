part of akcnik.tests.sidos.prime;

void requestResponseSuccessTests() {
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
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of update Imprint 1", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.updateImprintEnvelope(1, [1], message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of update Imprint 2", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.updateImprintEnvelope(2, [2], message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of update Imprint 3", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.updateImprintEnvelope(3, [1, 2], message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of update Imprint 3", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.updateImprintEnvelope(3, [1, 2], message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of update Patttern", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.updatePatternEnvelope(1, message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of update Pattern of nonexistent user", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.updatePatternEnvelope(111101, message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of attend", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.attendEnvelope(1, 2, message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of reupdate Imprint 1", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.updateImprintEnvelope(1, [1], message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of reupdate Patttern", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.updatePatternEnvelope(1, message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of reattend", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.attendEnvelope(1, 2, message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of attending nonexistent event", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.attendEnvelope(1, 84, message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of attending by nonexistent user", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.attendEnvelope(85, 1, message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of attending nonexistent event by nonexistent user", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.attendEnvelope(85, 76, message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of sort events for user - small number of events (request-response)", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.sortEventsForUser(1, [1, 2], message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of loading hard cache", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.loadHardCache(message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of creating hard cache", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.createHardCache(message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of creating hard log", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.createHardLog(message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Test of loading hard cache when hard cache file does not exist", () async {
    String message = getRandomString();
    // Creates dir/, dir/subdir/, and dir/subdir/file.txt in the system
    // temp directory.
    File file = new File('${projectDir.path}/sidos/brain/hard_cache/file.txt');
    if (file.existsSync()) {
      file.deleteSync(recursive: true);
    }
    outcomingEnvelope = new SidosSocketEnvelope.loadHardCache(message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });

  test("Final test of communication", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.testEnvelope(message: message);
    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.success, equals(true));
  });
}
