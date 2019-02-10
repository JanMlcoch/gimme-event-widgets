part of akcnik.test.sidos.computor;

void cachorTests() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  Imprint imprint = Imprintificator.instance.createImprint([4], new GPS.withValues(15.4, 45.1));

  test("Test of empty cachor consistency", () async {
    Map json = Cachor.instance.toFullMap();
    Cachor.instance.fromMap(json);
    Map json2 = Cachor.instance.toFullMap();
    Cachor.wipe();
    expect(json2, equals(json));
  });

  test("Test of non-empty cachor consistency", () async {
    Cachor.instance.attends[1] = [2, 5, 255];
    Cachor.instance.eventImprints[1] = imprint;
    Map json = Cachor.instance.toFullMap();
    Cachor.instance.fromMap(json);
    Map json2 = Cachor.instance.toFullMap();
    Cachor.wipe();
    expect(json2, equals(json));
  });

  test("Test of cachor with bad attends data robustness", () async {
    Cachor.instance.attends[1] = ([2, 5, null, 1.0] as List<int>);
    Cachor.instance.attends[null] = ([2, 5, null, 1.0] as List<int>);
    Map json = Cachor.instance.toFullMap();
    Cachor.instance.fromMap(json);
    Map json2 = Cachor.instance.toFullMap();
    Cachor.wipe();
    expect(json, equals(json2));
  });

  test("Test of cachor with bad eventImprints data consistency", () async {
    Cachor.instance.eventImprints[1] = new Imprint();
    Cachor.instance.eventImprints[2] = null;
    Cachor.instance.eventImprints[null] = new Imprint();

    Map json = Cachor.instance.toFullMap();
    Cachor.instance.fromMap(json);
    Map json2 = Cachor.instance.toFullMap();
    Cachor.wipe();
    expect(json2, equals(json));
  });

  test("Test of cachor with bad tagRelations data consistency", () async {
    Cachor.instance.tagRelations[1] =
        ({1: new ImprintPoint(), 2: null, 3.0: new ImprintPoint(), null: new ImprintPoint()} as Map<int, ImprintPoint>);
    Cachor.instance.tagRelations[null] =
        ({1: new ImprintPoint(), 2: null, 3.0: new ImprintPoint(), null: new ImprintPoint()} as Map<int, ImprintPoint>);
    Map json = Cachor.instance.toFullMap();
    Cachor.instance.fromMap(json);
    Map json2 = Cachor.instance.toFullMap();
    Cachor.wipe();
    expect(json2, equals(json));
  });

  test("Test of cachor with bad userEventFitIndices data consistency", () async {
    Cachor.wipe();
    Cachor.instance.userEventFitIndices[1] = ({
      1: new FitIndex(5.0),
      2: new FitIndex(5.0),
      3.0: new FitIndex(4.0),
      null: new FitIndex(8.5),
      6: null
    } as Map<int, FitIndex>);
    Cachor.instance.userEventFitIndices[null] = ({
      1: new FitIndex(5.0),
      2: new FitIndex(5.0),
      3.0: new FitIndex(4.0),
      null: new FitIndex(8.5),
      6: null
    } as Map<int, FitIndex>);
    Map json = Cachor.instance.toPurgedMap();
    Cachor.instance.fromMap(json);
    Map json2 = Cachor.instance.toPurgedMap();
    Cachor.wipe();
    expect(json2, equals(json));
  });

  test("Test of cachor with bad userPatterns data consistency", () async {
    Cachor.instance.userPatterns[1] = Patternificator.instance.createUserPatternFromImprints([]); //new UserPattern();
    Cachor.instance.userPatterns[2] = null;
    Cachor.instance.userPatterns[null] = Patternificator.instance.createUserPatternFromImprints([]);
    Map json = Cachor.instance.toPurgedMap();
    Cachor.instance.fromMap(json);
    Map json2 = Cachor.instance.toPurgedMap();
    Cachor.wipe();
    expect(json2, equals(json));
  });

  test("Test of cachor with bad userPointsOfOrigin data consistency", () async {
    Cachor.instance.userPointsOfOrigin[1] = [];
    Cachor.instance.userPointsOfOrigin[2] = [new GPS.withValues(5.0, 6.3)];
    Cachor.instance.userPointsOfOrigin[3] = [new GPS.withValues(null, null)];
    Cachor.instance.userPointsOfOrigin[4] = [new GPS.withValues(5.0, 6.3), new GPS.withValues(5.0, 6.3)];
    Cachor.instance.userPointsOfOrigin[5] = [null];
    Cachor.instance.userPointsOfOrigin[6] = null;
    Cachor.instance.userPointsOfOrigin[null] = [new GPS.withValues(5.0, 6.3)];
    Map json = Cachor.instance.toPurgedMap();
    Cachor.instance.fromMap(json);
    Map json2 = Cachor.instance.toPurgedMap();
    Cachor.wipe();
    expect(json2, equals(json));
  });

  test("Test of cachor with bad data consistency - all at once", () async {
    Cachor.wipe();
    Cachor.instance.attends[1] = ([2, 5, null, 1.0] as List<int>);
    Cachor.instance.attends[null] = ([2, 5, null, 1.0] as List<int>);
    Cachor.instance.eventImprints[1] = new Imprint();
    Cachor.instance.eventImprints[2] = null;
    Cachor.instance.eventImprints[null] = new Imprint();
    Cachor.instance.tagRelations[1] =
        ({1: new ImprintPoint(), 2: null, 3.0: new ImprintPoint(), null: new ImprintPoint()} as Map<int, ImprintPoint>);
    Cachor.instance.tagRelations[null] =
        ({1: new ImprintPoint(), 2: null, 3.0: new ImprintPoint(), null: new ImprintPoint()} as Map<int, ImprintPoint>);
    Cachor.instance.userEventFitIndices[1] = ({
      1: new FitIndex(5.0),
      2: new FitIndex(5.toDouble()),
      3.0: new FitIndex(4.0),
      null: new FitIndex(8.5),
      6: null,
      7: new FitIndex(null)
    } as Map<int, FitIndex>);
    Cachor.instance.userEventFitIndices[null] = ({
      1: new FitIndex(5.0),
      2: new FitIndex(5.toDouble()),
      3.0: new FitIndex(4.0),
      null: new FitIndex(8.5),
      6: null,
      7: new FitIndex(null)
    } as Map<int, FitIndex>);
    Cachor.instance.userPatterns[1] = Patternificator.instance.createUserPatternFromImprints([]);
    ;
    Cachor.instance.userPatterns[2] = null;
    Cachor.instance.userPatterns[null] = Patternificator.instance.createUserPatternFromImprints([]);
    ;
    Cachor.instance.userPointsOfOrigin[1] = [];
    Cachor.instance.userPointsOfOrigin[2] = [new GPS.withValues(5.0, 6.3)];
    Cachor.instance.userPointsOfOrigin[3] = [new GPS.withValues(null, null)];
    Cachor.instance.userPointsOfOrigin[4] = [new GPS.withValues(5.0, 6.3), new GPS.withValues(5.0, 6.3)];
    Cachor.instance.userPointsOfOrigin[5] = [null];
    Cachor.instance.userPointsOfOrigin[6] = null;
    Cachor.instance.userPointsOfOrigin[null] = [new GPS.withValues(5.0, 6.3)];
    Map json = Cachor.instance.toPurgedMap();
    Cachor.instance.fromMap(json);
    Map json2 = Cachor.instance.toPurgedMap();
    Cachor.wipe();
    expect(json2, equals(json));
  });

  test("Test of cachor wipe", () async {
    Cachor.wipe();
    Cachor.instance.userEventFitIndices[1] = {1: new FitIndex(1.0)};
    Cachor.wipe();
    Map json = Cachor.instance.toPurgedMap();
    Map expectedJson = {
      'eventImprints': {},
      'userPatterns': {},
      'userPointsOfOrigin': {},
      'userEventFitIndices': {},
      'attends': {}
    };
    expect(json, equals(expectedJson));
  });

  test("Test of cachor addFitIndexValue", () async {
    Cachor.wipe();
    Cachor.instance.addFitIndexValue(1, 1, 1.1);
    Cachor.instance.addFitIndexValue(1, 2, 1.2);
    Cachor.instance.addFitIndexValue(2, 1, 2.1);
    Cachor.instance.addFitIndexValue(2, 1, 2.1);
    Map json = Cachor.instance.toFullMap();
    Cachor.wipe();
    Map expectedJson = {
      'eventImprints': {},
      'userPatterns': {},
      'userPointsOfOrigin': {},
      'userEventFitIndices': {
        1.toString(): {1: 1.1, 2: 1.2},
        2.toString(): {1: 2.1}
      },
      'attends': {}
    };
    expect(json, equals(expectedJson));
  });
}
