part of akcnik.tests.sidos.task_completer;

void emptyCompleterTests() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  test("Test of empty Completer", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([false, false]));
  });

  test("Test of empty Completer invariance", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    Requirement req2 = new Requirement.baseCost(1);
    List<List<bool>> toExpect = [
      TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req),
      TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2)
    ];
    expect(toExpect, equals([[false, false],[false,false]]));
  });

}
