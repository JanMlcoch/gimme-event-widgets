library akcnik.tests.sidos.task_completer;

import 'package:test/test.dart';
import 'dart:async';
import '../../../sidos/scheduler/task_completer/completer.dart';

part 'empty.dart';
part 'task_requirement.dart';
part 'task_requirements.dart';
part 'tasks_requirements.dart';
part 'tasks_requirement.dart';
part 'task_same_requirements.dart';
part 'task_equivalent_requirements.dart';
part 'weird_tasks.dart';
part 'weird_requirements.dart';

int timeoutInSeconds = 1;

void main(){
  group("Empty task completer tests", () {
    emptyCompleterTests();
  });
  group("Task completer tests - single Task with Single Requirements", () {
    task1req1();
  });
  group("Task completer tests - single Task with multiple Requirements", () {
    task1req2();
  });
  group("Task completer tests - single Task with multiple same Requirements", () {
    task1sameReq2();
  });
  group("Task completer tests - single Task with multiple equivalent Requirements", () {
    task1equivalentReq2();
  });
  group("Task completer tests - weird form of Tasks", () {
    weirdTasks();
  });
  group("Task completer tests - weird form of Requirements", () {
    weirdRequirements();
  });
  group("Task completer tests - multiple Tasks with single Requirements", () {
    task2Req1();
  });
  group("Task completer tests - multiple Tasks with multiple Requirements", () {
    task2Req2();
  });
}
