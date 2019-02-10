part of akcnik.tests.sidos.task_completer;

void weirdRequirements() {
  Timer timeout;
  setUp(() {
    // fail the test after Duration
    timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
  });
  tearDown(() {
    // if the test already ended, cancel the timeout
    timeout.cancel();
  });

  test("Test of null Requirements", () {
    TaskCompleter.instance.clearCompleter();
    List<Function> task;
    TaskCompleter.instance.addTask(task, null, 2);
    expect(true, equals(true));
  });

  test("Test of Task with only null requirement", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req;
    List<Function> task = [
          () {
        print("Task of type 1 was rescheduled");
      }
    ];
    ;
    TaskCompleter.instance.addTask(task, [req], 2);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([true, true]));
  });

  test("Test of Task with only null requirement - consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req;
    List<Function> task = [
          () {
        print("Task of type 1 was rescheduled");
      }
    ];
    ;
    TaskCompleter.instance.addTask(task, [req], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([false, false]));
  });

  test("Test of Task with only null requirements", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req;
    List<Function> task = [
          () {
        print("Task of type 1 was rescheduled");
      }
    ];
    ;
    TaskCompleter.instance.addTask(task, [req, null], 2);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([true, true]));
  });

  test("Test of Task with only null requirements - consistency", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req;
    List<Function> task = [
          () {
        print("Task of type 1 was rescheduled");
      }
    ];
    ;
    TaskCompleter.instance.addTask(task, [req, null], 2);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req);
    expect(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req), equals([false, false]));
  });

  test("Test of Task with not only null requirements", () {
    TaskCompleter.instance.clearCompleter();
    Requirement req0;
    Requirement req1 = new Requirement.baseCost(1);
    Requirement req2 = new Requirement.baseCost(2);
    List<Function> task = [
          () {
        print("Task of type 1 was rescheduled");
      }
    ];
    ;
    TaskCompleter.instance.addTask(task, [req0, req1, req2], 2);
    List<bool> toExpect = [];
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
//    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
//    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req0));
//    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req0));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
//    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req0));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req1));
    toExpect.addAll(TaskCompleter.instance.testIfSomeRequirementHasBeenMet(req2));
    expect(
        toExpect,
        equals([
          true,
          false,
//          false,
//          false,
//          true,
//          false,
//          false,
//          false,
          false,
          false,
          true,
          true,
//          false,
//          false,
          false,
          false,
          false,
          false
        ]));
  });
}
