part of akcnik.tests.sidos.prime;

void requestResponseSchedulingTests() {
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

  test("Test of scheduling Tests", () async {
    String message = getRandomString();
    String message2 = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.testEnvelope(message: message);
    SidosSocketEnvelope outcomingEnvelope2 =
        new SidosSocketEnvelope.testEnvelope(message: message2 + "2");
    Future future1 = GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    Future future2 =
        GatewayToSidos.instance.demandFromSidos(outcomingEnvelope2);
    SidosSocketEnvelope incomingEnvelope2 = await future2;
    incomingEnvelope = await future1;
    expect(
        [incomingEnvelope.message, incomingEnvelope2.message],
        equals([
          message + "+ checked by sidos server",
          message2 + "2" + "+ checked by sidos server"
        ]));
  });

  test("Test of scheduling various Tasks", () async {
    String message = getRandomString();
    outcomingEnvelope = new SidosSocketEnvelope.testEnvelope(message: message);
    SidosSocketEnvelope outcomingEnvelope3 =
        new SidosSocketEnvelope.updateImprintEnvelope(1, [1],
            message: message + "3");
    SidosSocketEnvelope outcomingEnvelope4 =
        new SidosSocketEnvelope.updateImprintEnvelope(1, [1],
            message: message + "4");
    SidosSocketEnvelope outcomingEnvelope5 =
        new SidosSocketEnvelope.attendEnvelope(1, 2, message: message + "5");
    SidosSocketEnvelope outcomingEnvelope6 =
        new SidosSocketEnvelope.updatePatternEnvelope(1,
            message: message + "6");
    SidosSocketEnvelope outcomingEnvelope7 =
        new SidosSocketEnvelope.attendEnvelope(1, 1, message: message + "7");
    SidosSocketEnvelope outcomingEnvelope8 =
        new SidosSocketEnvelope.updatePatternEnvelope(2,
            message: message + "8");
    SidosSocketEnvelope outcomingEnvelope9 =
        new SidosSocketEnvelope.testEnvelope(message: message + "9");
    Future future1 = GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
    Future future3 =
        GatewayToSidos.instance.demandFromSidos(outcomingEnvelope3);
    Future future4 =
        GatewayToSidos.instance.demandFromSidos(outcomingEnvelope4);
    Future future5 =
        GatewayToSidos.instance.demandFromSidos(outcomingEnvelope5);
    Future future6 =
        GatewayToSidos.instance.demandFromSidos(outcomingEnvelope6);
    Future future7 =
        GatewayToSidos.instance.demandFromSidos(outcomingEnvelope7);
    Future future8 =
        GatewayToSidos.instance.demandFromSidos(outcomingEnvelope8);
    Future future9 =
        GatewayToSidos.instance.demandFromSidos(outcomingEnvelope9);
    incomingEnvelope = await future1;
//    print("Futura1 awaitnuta");
    SidosSocketEnvelope incomingEnvelope3 = await future3;
//    print("Futura3 awaitnuta");
    SidosSocketEnvelope incomingEnvelope4 = await future4;
//    print("Futura4 awaitnuta");
    SidosSocketEnvelope incomingEnvelope5 = await future5;
//    print("Futura5 awaitnuta");
    SidosSocketEnvelope incomingEnvelope6 = await future6;
//    print("Futura6 awaitnuta");
    SidosSocketEnvelope incomingEnvelope7 = await future7;
//    print("Futura7 awaitnuta");
    SidosSocketEnvelope incomingEnvelope8 = await future8;
//    print("Futura8 awaitnuta");
    SidosSocketEnvelope incomingEnvelope9 = await future9;
//    print("Futura9 awaitnuta");
    expect(
        [
          incomingEnvelope.message,
          incomingEnvelope3.message,
          incomingEnvelope4.message,
          incomingEnvelope5.message,
          incomingEnvelope6.message,
          incomingEnvelope7.message,
          incomingEnvelope8.message,
          incomingEnvelope9.message
        ],
        equals([
          message + "+ checked by sidos server",
          message + "3",
          message + "4",
          message + "5",
          message + "6",
          message + "7",
          message + "8",
          message + "9" + "+ checked by sidos server"
        ]));
  });

  test("Test of scheduling multiple same tasks", () async {
    List<String> messages = new List.generate(6, (_) => getRandomString());
    List<SidosSocketEnvelope> outcomingEnvelopes = messages
        .map((String message) =>
            new SidosSocketEnvelope.updatePatternEnvelope(1, message: message))
        .toList();
    List<Future<SidosSocketEnvelope>> futures = outcomingEnvelopes
        .map((SidosSocketEnvelope envelope) =>
            GatewayToSidos.instance.demandFromSidos(envelope))
        .toList();
//    List<SidosSocketEnvelope> incomingEnvelopes = [];
//    for (Future<SidosSocketEnvelope> future in futures) {
//      SidosSocketEnvelope envelope = await future;
//      print("awaited ${envelope.akcnikId}");
//      incomingEnvelopes.add(await future);
//    }
    List<SidosSocketEnvelope> incomingEnvelopes = await Future.wait(futures);
    expect(
        incomingEnvelopes
            .map((SidosSocketEnvelope envelope) => envelope.message)
            .toList(),
        messages);
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
