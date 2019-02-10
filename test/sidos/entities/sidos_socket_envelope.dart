part of akcnik.tests.sidos.task_completer;

void sidosSocketEnvelopeTests() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });
  String msg = " asd54df. =´dfs 54šč";

  SidosSocketEnvelope testEnvelope = new SidosSocketEnvelope.testEnvelope(message: msg);
  SidosSocketEnvelope updateImprintEnvelope = new SidosSocketEnvelope.updateImprintEnvelope(0, [0], message: msg);
  SidosSocketEnvelope updateImprintEnvelopeWithMoreEventIds =
      new SidosSocketEnvelope.updateImprintEnvelope(0, [0, 1, 2], message: msg);
  SidosSocketEnvelope updatePatternEnvelope = new SidosSocketEnvelope.updatePatternEnvelope(0, message: msg);
  SidosSocketEnvelope attendEnvelope = new SidosSocketEnvelope.attendEnvelope(0, 0, message: msg);
  SidosSocketEnvelope sortEventsForUser = new SidosSocketEnvelope.sortEventsForUser(0, [0], message: msg);
  SidosSocketEnvelope createHardLog = new SidosSocketEnvelope.createHardLog(message: msg);
  SidosSocketEnvelope createHardCache = new SidosSocketEnvelope.createHardCache(message: msg);
  SidosSocketEnvelope loadHardCache = new SidosSocketEnvelope.loadHardCache(message: msg);
  SidosSocketEnvelope requestAdditionalInfoEventTags =
      new SidosSocketEnvelope.requestAdditionalInfoEventTags(0, message: msg);
  SidosSocketEnvelope requestSpecificAdditionalInfoEvent =
      new SidosSocketEnvelope.requestSpecificAdditionalInfoEvent(0, ["baseCost"], message: msg);
  SidosSocketEnvelope requestUserPointsOfOriginAdditionalInfo =
      new SidosSocketEnvelope.requestUserPointsOfOriginAdditionalInfo(0, message: msg);
  SidosSocketEnvelope additionalEventTags = new SidosSocketEnvelope.additionalEventTags(0, [0], message: msg);
//  SidosSocketEnvelope additionalEventInfo;

  test("Test of to/from map consistency", () {
    SidosSocketEnvelope testEnvelopeJsoned = new SidosSocketEnvelope()..fromMap(testEnvelope.toFullMap());
    SidosSocketEnvelope updateImprintEnvelopeJsoned = new SidosSocketEnvelope()
      ..fromMap(updateImprintEnvelope.toFullMap());
    SidosSocketEnvelope updateImprintEnvelopeWithMoreEventIdsJsoned = new SidosSocketEnvelope()
      ..fromMap(updateImprintEnvelopeWithMoreEventIds.toFullMap());
    SidosSocketEnvelope updatePatternEnvelopeJsoned = new SidosSocketEnvelope()
      ..fromMap(updatePatternEnvelope.toFullMap());
    SidosSocketEnvelope attendEnvelopeJsoned = new SidosSocketEnvelope()..fromMap(attendEnvelope.toFullMap());
    SidosSocketEnvelope sortEventsForUserJsoned = new SidosSocketEnvelope()..fromMap(sortEventsForUser.toFullMap());
    SidosSocketEnvelope createHardLogJsoned = new SidosSocketEnvelope()..fromMap(createHardLog.toFullMap());
    SidosSocketEnvelope createHardCacheJsoned = new SidosSocketEnvelope()..fromMap(createHardCache.toFullMap());
    SidosSocketEnvelope loadHardCacheJsoned = new SidosSocketEnvelope()..fromMap(loadHardCache.toFullMap());
    SidosSocketEnvelope requestAdditionalInfoEventTagsJsoned = new SidosSocketEnvelope()
      ..fromMap(requestAdditionalInfoEventTags.toFullMap());
    SidosSocketEnvelope requestSpecificAdditionalInfoEventJsoned = new SidosSocketEnvelope()
      ..fromMap(requestSpecificAdditionalInfoEvent.toFullMap());
    SidosSocketEnvelope requestUserPointsOfOriginAdditionalInfoJsoned = new SidosSocketEnvelope()
      ..fromMap(requestUserPointsOfOriginAdditionalInfo.toFullMap());
    SidosSocketEnvelope additionalEventTagsJsoned = new SidosSocketEnvelope()..fromMap(additionalEventTags.toFullMap());
    List<Map<String, dynamic>> toBeExpected = [
      testEnvelope.toFullPurgedMap(),
      updateImprintEnvelope.toFullPurgedMap(),
      updateImprintEnvelopeWithMoreEventIds.toFullPurgedMap(),
      updatePatternEnvelope.toFullPurgedMap(),
      attendEnvelope.toFullPurgedMap(),
      sortEventsForUser.toFullPurgedMap(),
      createHardLog.toFullPurgedMap(),
      createHardCache.toFullPurgedMap(),
      loadHardCache.toFullPurgedMap(),
      requestAdditionalInfoEventTags.toFullPurgedMap(),
      requestSpecificAdditionalInfoEvent.toFullPurgedMap(),
      requestUserPointsOfOriginAdditionalInfo.toFullPurgedMap(),
      additionalEventTags.toFullPurgedMap()
    ];
    List<Map<String, dynamic>> toExpect = [
      testEnvelopeJsoned.toFullPurgedMap(),
      updateImprintEnvelopeJsoned.toFullPurgedMap(),
      updateImprintEnvelopeWithMoreEventIdsJsoned.toFullPurgedMap(),
      updatePatternEnvelopeJsoned.toFullPurgedMap(),
      attendEnvelopeJsoned.toFullPurgedMap(),
      sortEventsForUserJsoned.toFullPurgedMap(),
      createHardLogJsoned.toFullPurgedMap(),
      createHardCacheJsoned.toFullPurgedMap(),
      loadHardCacheJsoned.toFullPurgedMap(),
      requestAdditionalInfoEventTagsJsoned.toFullPurgedMap(),
      requestSpecificAdditionalInfoEventJsoned.toFullPurgedMap(),
      requestUserPointsOfOriginAdditionalInfoJsoned.toFullPurgedMap(),
      additionalEventTagsJsoned.toFullPurgedMap()
    ];
    expect(toExpect, equals(toBeExpected));
  });

  test("Test of toPurgedMap consistency", () {
    SidosSocketEnvelope testEnvelopeJsoned = new SidosSocketEnvelope()..fromMap(testEnvelope.toFullPurgedMap());
    SidosSocketEnvelope updateImprintEnvelopeJsoned = new SidosSocketEnvelope()
      ..fromMap(updateImprintEnvelope.toFullPurgedMap());
    SidosSocketEnvelope updatePatternEnvelopeJsoned = new SidosSocketEnvelope()
      ..fromMap(updatePatternEnvelope.toFullPurgedMap());
    SidosSocketEnvelope attendEnvelopeJsoned = new SidosSocketEnvelope()..fromMap(attendEnvelope.toFullPurgedMap());
    SidosSocketEnvelope sortEventsForUserJsoned = new SidosSocketEnvelope()
      ..fromMap(sortEventsForUser.toFullPurgedMap());
    SidosSocketEnvelope createHardLogJsoned = new SidosSocketEnvelope()..fromMap(createHardLog.toFullPurgedMap());
    SidosSocketEnvelope createHardCacheJsoned = new SidosSocketEnvelope()..fromMap(createHardCache.toFullPurgedMap());
    SidosSocketEnvelope loadHardCacheJsoned = new SidosSocketEnvelope()..fromMap(loadHardCache.toFullPurgedMap());
    SidosSocketEnvelope requestAdditionalInfoEventTagsJsoned = new SidosSocketEnvelope()
      ..fromMap(requestAdditionalInfoEventTags.toFullPurgedMap());
    SidosSocketEnvelope requestSpecificAdditionalInfoEventJsoned = new SidosSocketEnvelope()
      ..fromMap(requestSpecificAdditionalInfoEvent.toFullPurgedMap());
    SidosSocketEnvelope requestUserPointsOfOriginAdditionalInfoJsoned = new SidosSocketEnvelope()
      ..fromMap(requestUserPointsOfOriginAdditionalInfo.toFullPurgedMap());
    SidosSocketEnvelope additionalEventTagsJsoned = new SidosSocketEnvelope()
      ..fromMap(additionalEventTags.toFullPurgedMap());
    List<Map<String, dynamic>> toBeExpected = [
      testEnvelope.toFullMap(),
      updateImprintEnvelope.toFullMap(),
      updatePatternEnvelope.toFullMap(),
      attendEnvelope.toFullMap(),
      sortEventsForUser.toFullMap(),
      createHardLog.toFullMap(),
      createHardCache.toFullMap(),
      loadHardCache.toFullMap(),
      requestAdditionalInfoEventTags.toFullMap(),
      requestSpecificAdditionalInfoEvent.toFullMap(),
      requestUserPointsOfOriginAdditionalInfo.toFullMap(),
      additionalEventTags.toFullMap()
    ];
    List<Map<String, dynamic>> toExpect = [
      testEnvelopeJsoned.toFullMap(),
      updateImprintEnvelopeJsoned.toFullMap(),
      updatePatternEnvelopeJsoned.toFullMap(),
      attendEnvelopeJsoned.toFullMap(),
      sortEventsForUserJsoned.toFullMap(),
      createHardLogJsoned.toFullMap(),
      createHardCacheJsoned.toFullMap(),
      loadHardCacheJsoned.toFullMap(),
      requestAdditionalInfoEventTagsJsoned.toFullMap(),
      requestSpecificAdditionalInfoEventJsoned.toFullMap(),
      requestUserPointsOfOriginAdditionalInfoJsoned.toFullMap(),
      additionalEventTagsJsoned.toFullMap()
    ];
    expect(toExpect, equals(toBeExpected));
  });

  test("Test of validate not being too strict", () {
    List<bool> toExpect = [
      testEnvelope.validate(),
      updateImprintEnvelope.validate(),
      updatePatternEnvelope.validate(),
      attendEnvelope.validate(),
      sortEventsForUser.validate(),
      createHardLog.validate(),
      createHardCache.validate(),
      loadHardCache.validate(),
    ];
    bool isAllValid = toExpect.reduce((a, b) => a && b);
    expect(isAllValid, equals(true));
  });
}
