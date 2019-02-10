library akcnik.tests.sidos.scheduler;

import 'package:test/test.dart';
import 'dart:async';
//import '../../../sidos/sidos_server_utils.dart';
import '../../../sidos/scheduler/library.dart';

List<int> processedTaskIds = [];
List<int> longTaskIds = [];
int timeoutInSeconds = 1;
const Duration waitTime = const Duration(milliseconds: 200);
const Duration longTaskDuration = /*const Duration(milliseconds: 5);*/ Duration.ZERO;

void main() {
  ProcessTask processTask = (Task task, int priority) async {
    print("Task of id ${task.id} started being processed");
    if (longTaskIds.contains(task.id)) {
      Future processLongTask = new Future.delayed(longTaskDuration).then((_) {
        print("long processed");
        processedTaskIds.add(task.id);
      });
      await processLongTask;
    } else {
      print("short processed");
      processedTaskIds.add(task.id);
    }
  };

  SendEnvelope sendEnvelope = (_, _nope) {
    return;
  };

  Scheduler.init(processTask, sendEnvelope);

  group("Scheduler tests", () {
    Timer timeout;
    setUp(() {
      // fail the test after Duration
      timeout = new Timer(new Duration(seconds: timeoutInSeconds), () => fail("timed out"));
      Scheduler.reset();
      Scheduler.instance;
      processedTaskIds.clear();
      longTaskIds.clear();
    });
    tearDown(() {
      // if the test already ended, cancel the timeout
      timeout.cancel();
    });

    test("Scheduler init", () {
      Scheduler.instance;
      expect(Scheduler.instance is Scheduler, equals(true));
    });

    test("Scheduler single task scheduling", () async {
      Task task = new Task();
      List<int> expectedProcessedTaskIds = [task.id];
      Scheduler.instance.addTask(task, 3);

      Future<List<int>> matchingFuture = new Future.delayed(waitTime).then((_) {
        return processedTaskIds;
      });
      expect(matchingFuture, completion(expectedProcessedTaskIds));
    });

    test("Scheduler two task with same priority", () async {
      Task task1 = new Task();
      Task task2 = new Task();
      List<int> expectedProcessedTaskIds = [task1.id, task2.id];
      Scheduler.instance.addTask(task1, 3);
      Scheduler.instance.addTask(task2, 3);

      await new Future.delayed(waitTime);
      expect(processedTaskIds, equals(expectedProcessedTaskIds));
    });

    test("Scheduler two task with different priority", () async {
      Task task1 = new Task();
      Task task2 = new Task();
      Task task3 = new Task();
      longTaskIds = [task1.id];
      List<int> expectedProcessedTaskIds = [task1.id, task3.id, task2.id];
      List<int> expectedProcessedTaskIdsSecondVersion = [task3.id, task1.id, task2.id];
      List<List<int>> acceptableStates = [expectedProcessedTaskIds,expectedProcessedTaskIdsSecondVersion];
      Scheduler.instance.addTask(task1, 3);
      Scheduler.instance.addTask(task2, 3);
      Scheduler.instance.addTask(task3, 5);
      await new Future.delayed(waitTime);
      List<Matcher> matchers = [];
      for(List<int> acceptableState in acceptableStates){
        matchers.add(equals(acceptableState));
      }
      expect(processedTaskIds, anyOf(matchers));
//      expect([5], contains(5));
    });
  });
}

void copyMain2() {
  main();
}
