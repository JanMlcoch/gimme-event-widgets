part of akcnik.tests.sidos.task_completer;

void task2Req1() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  test("Test of 2 Task with 2 single requirements - rescheduling", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    List<Function> task1 = [(){print("Task of type 2 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req], 2);
    TaskCompleter.instance.addTask(task1, [req1], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    expect(toExpect, equals([true, true, true, true]));
  });

  test("Test of 2 Task with 2 single requirements - rescheduling - consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    List<Function> task1 = [(){print("Task of type 2 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req], 2);
    TaskCompleter.instance.addTask(task1, [req1], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    expect(toExpect, equals([true, true, false, false, true, true, false, false, false, false]));
  });

  test("Test of 2 Task with 2 single same requirements - rescheduling + consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    List<Function> task1 = [(){print("Task of type 2 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req], 2);
    TaskCompleter.instance.addTask(task1, [req], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    expect(toExpect, equals([true, true, false, false]));
  });

  test("Test of 2 Task with 2 single equivalent requirements - rescheduling + consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req0 = new Requirement.baseCost(0);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    List<Function> task1 = [(){print("Task of type 2 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req], 2);
    TaskCompleter.instance.addTask(task1, [req0], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req0));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req0));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    expect(toExpect, equals([true, true, false, false, false, false, false, false, false, false]));
  });

  test("Test of 2 equivalent Task with 2 single requirements - rescheduling + consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 2 was rescheduled");}];
    List<Function> task1 = [(){print("Task of type 2 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req], 2);
    TaskCompleter.instance.addTask(task1, [req1], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    expect(toExpect, equals([true, true, false, false, true, true, false, false, false, false]));
  });

  test("Test of 2 same Task with 2 single requirements - rescheduling + consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 2 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req], 2);
    TaskCompleter.instance.addTask(task, [req1], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    expect(toExpect, equals([true, true, false, false, true, true, false, false, false, false]));
  });
}

