part of akcnik.tests.sidos.task_completer;

void task2Req2() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  test("Test of 2 Tasks with 2 different tasks + consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    Requirement req2 = new Requirement.baseCost(2);
    Requirement req3 = new Requirement.baseCost(3);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    List<Function> task1 = [(){print("Task of type 2 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req1], 2);
    TaskCompleter.instance.addTask(task1, [req2, req3], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req3));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req3));
    expect(
        toExpect,
        equals([
          true,
          false,
          false,
          false,
          true,
          false,
          false,
          false,
          false,
          false,
          true,
          true,
          false,
          false,
          false,
          false,
          false,
          false,
          true,
          true,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false
        ]));
  });

  test("Test of 2 Tasks with 2 tasks - 2 of them equivalent (2-1-1) + consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req0 = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    Requirement req2 = new Requirement.baseCost(2);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    List<Function> task1 = [(){print("Task of type 2 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req1], 2);
    TaskCompleter.instance.addTask(task1, [req0, req2], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req0));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req0));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req0));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    expect(
        toExpect,
        equals([
          true,
          false,
          false,
          false,
          true,
          true,
          false,
          false,
          false,
          false,
          false,
          false,
          true,
          true,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false
        ]));
  });

  test("Test of 2 Tasks with 2 tasks - 2 of them equivalent (1-2-1) + consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req0 = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    Requirement req2 = new Requirement.baseCost(2);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    List<Function> task1 = [(){print("Task of type 2 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req1], 2);
    TaskCompleter.instance.addTask(task1, [req0, req2], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req0));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req0));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    expect(
        toExpect,
        equals([
          true,
          false,
          false,
          false,
          true,
          true,
          false,
          false,
          false,
          false,
          false,
          false,
          true,
          true,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false
        ]));
  });

  test("Test of 2 Tasks with 2 tasks - 2 of them equivalent (1-1-2) + consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req = new Requirement.baseCost(0);
    Requirement req0 = new Requirement.baseCost(0);
    Requirement req1 = new Requirement.baseCost(1);
    Requirement req2 = new Requirement.baseCost(2);
    List<Function> task = [(){print("Task of type 1 was rescheduled");}];
    List<Function> task1 = [(){print("Task of type 2 was rescheduled");}];
    TaskCompleter.instance.addTask(task, [req, req1], 2);
    TaskCompleter.instance.addTask(task1, [req0, req2], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req0));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    expect(
        toExpect,
        equals([
          true,
          false,
          false,
          false,
          true,
          false,
          false,
          false,
          false,
          false,
          true,
          true,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false
        ]));
  });
}
