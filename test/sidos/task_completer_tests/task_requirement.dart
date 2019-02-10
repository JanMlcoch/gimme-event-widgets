part of akcnik.tests.sidos.task_completer;

void task1req1() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  test("Test of rescheduling singleTask with single requirement", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task,[req], 2);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([true, true]));
  });

  test("Test of rescheduling singleTask with single requirement consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task,[req], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([false, false]));
  });

  test("Test of not finding a requirement", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task,[req], 2);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1), equals([false, false]));
  });

  test("Test of not finding a requirement consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task,[req], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1);
    List<List<bool>> toExpect = [TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1),TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req)];
    expect(toExpect, equals([[false, false],[true,true]]));
  });
}
