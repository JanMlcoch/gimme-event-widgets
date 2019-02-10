part of akcnik.tests.sidos.task_completer;

void weirdTasks() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  test("Test of null Task", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    List<Function> task;
    TaskCompleter.instance.addTask(task, [req], 2);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([true, true]));
  });

  test("Test of null Task - consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    List<Function> task;
    TaskCompleter.instance.addTask(task, [req], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([false, false]));
  });
}
