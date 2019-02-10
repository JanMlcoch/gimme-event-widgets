part of akcnik.tests.sidos.task_completer;

void task1sameReq2() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  test("Test of rescheduling singleTask with 2 same requirements", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req], 2);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([true, true]));
  });

  test("Test of rescheduling singleTask with 2 same requirements - consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([false, false]));
  });

  test("Test of rescheduling singleTask with not only 2 same requirements (2-1)", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req, req1], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    expect(toExpect, equals([true, false, true, true]));
  });

  test("Test of rescheduling singleTask with not only 2 same requirements (1-2)", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req, req1], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    expect(toExpect, equals([true, false, true, true]));
  });

  test("Test of rescheduling singleTask with not only 2 same requirements (1-2-1)", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    Requirement req2 = new Requirement.baseCost(2);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req, req1, req2], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    expect(toExpect, equals([true, false, true, false, true, true]));
  });

  test("Test of rescheduling singleTask with 2x2 same requirements (2-2)", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req, req1, req1], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    expect(toExpect, equals([true, false, true, true]));
  });

  test("Test of singleTask with not only 2 same requirements - meeting same requirements consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req, req1], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    expect(toExpect, equals([false, false]));
  });

  test("Test of singleTask with not only 2 same requirements - meeting non-same requirement consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req, req1], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    expect(toExpect, equals([false, false]));
  });
}

