part of akcnik.tests.sidos.task_completer;

void task1req2() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  test("Test of rescheduling singleTask with single 2 requirements", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req1], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([true, true]));
  });

  test("Test of rescheduling singleTask with single 2 requirements consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req1], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1);
    List<bool> toExpect = TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req)
      ..addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    expect(toExpect, equals([false, false, false, false]));
  });

  test("Test of rescheduling singleTask with single 2 requirements - reversed order of requirements", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req1, req], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([true, true]));
  });

  test("Test of rescheduling singleTask with single 2 requirements consistency - reversed order of requirements", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req1, req], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1);
    List<bool> toExpect = TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req)
      ..addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    expect(toExpect, equals([false, false, false, false]));
  });

  test("Test of singleTask with single 2 requirements - only one requirement met", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req1], 2);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([true, false]));
  });

  test("Test of singleTask with single 2 requirements - only one requirement met consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req1], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    List<bool> toExpect = TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    expect(toExpect, equals([false, false, true, true]));
  });


  test("Test of singleTask with single 2 requirements - only one requirement met - reversed order of requirements", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req1, req], 2);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([true, false]));
  });

  test("Test of singleTask with single 2 requirements - only one requirement met consistency - reversed order of requirements", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req1, req], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    List<bool> toExpect = TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    expect(toExpect, equals([false, false, true, true]));
  });

  test("Test of singleTask with single 2 requirements - some other req met", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    Requirement req2 = new Requirement.baseCost(2);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req1, req], 2);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2), equals([false, false]));
  });

  test("Test of singleTask with single 2 requirements - some other req met - consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    Requirement req2 = new Requirement.baseCost(2);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req1, req], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2);
    List<bool> toExpect = TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    expect(toExpect, equals([true, false, true, true]));
  });
}
