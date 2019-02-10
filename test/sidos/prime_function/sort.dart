part of akcnik.tests.sidos.prime;

void sortTests() {
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

  test("Test of sort events for user - small number of events", () async {
    String message = getRandomString();
    outcomingEnvelope =
        new SidosSocketEnvelope.sortEventsForUser(1, [1, 2], message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(2));
  });

  test("Test of sort same events for user - small number of events", () async {
    String message = getRandomString();
    outcomingEnvelope =
    new SidosSocketEnvelope.sortEventsForUser(1, [1, 1], message: message);
    incomingEnvelope =
    await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(2));
  });

  test("Test of sort same nonexistent events for user - small number of events", () async {
    String message = getRandomString();
    outcomingEnvelope =
    new SidosSocketEnvelope.sortEventsForUser(1, [2252, 2252], message: message);
    incomingEnvelope =
    await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(2));
  });

  test("Test of sort not only same not only nonexistent events for user - small number of events", () async {
    String message = getRandomString();
    outcomingEnvelope =
    new SidosSocketEnvelope.sortEventsForUser(1, [1,1,2,3542,2252, 2252], message: message);
    incomingEnvelope =
    await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(6));
  });

  //should probably return some default-sorted data anyway - or/and make a warning?
  test("Test of sort events for nonexistent user - small number of events",
      () async {
    String message = getRandomString();
    outcomingEnvelope =
        new SidosSocketEnvelope.sortEventsForUser(65, [1, 2], message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(2));
  });

  test("Test of sort nonexistent events for user - small number of events",
      () async {
    String message = getRandomString();
    outcomingEnvelope =
        new SidosSocketEnvelope.sortEventsForUser(1, [1, 54], message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(2));
  });

  test("Test of sort only nonexistent events for user - small number of events",
      () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.sortEventsForUser(1, [75, 56],
        message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(2));
  });

  test(
      "Test of sort nonexistent events for nonexistent user - small number of events",
      () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.sortEventsForUser(65, [1, 54],
        message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(2));
  });

  test(
      "Test of sort only nonexistent events for nonexistent user - small number of events",
      () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.sortEventsForUser(65, [75, 54],
        message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(2));
  });

  test("Test of sort 0 events for user - small number of events", () async {
    String message = getRandomString();
    outcomingEnvelope =
        new SidosSocketEnvelope.sortEventsForUser(1, [], message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(0));
  });

  test("Test of sort null events for user - small number of events", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.sortEventsForUser(
        1, [null, null],
        message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(0));
  });

  test("Test of sort not only null events for user - small number of events",
      () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.sortEventsForUser(
        1, [null, null, 1, 2],
        message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(2));
  });

  test("Test of sort one event for user - small number of events", () async {
    String message = getRandomString();
    outcomingEnvelope =
        new SidosSocketEnvelope.sortEventsForUser(1, [1], message: message);
    incomingEnvelope =
        await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(1));
  });

  test("Test of sort overlimit number of events for user", () async {
    String message = getRandomString();
    outcomingEnvelope =
    new SidosSocketEnvelope.sortEventsForUser(1, [1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40], message: message);
    incomingEnvelope =
    await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(35));
  });

  test("Test of sort events with limit for user", () async {
    String message = getRandomString();
    outcomingEnvelope =
    new SidosSocketEnvelope.sortEventsForUser(1, [1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40], numberOfEventsDesired: 12, message: message);
    incomingEnvelope =
    await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    expect(incomingEnvelope.eventIds.length, equals(12));
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
