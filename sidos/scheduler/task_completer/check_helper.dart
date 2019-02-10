part of sidos.scheduler.task_completer;

abstract class TaskCompleterCheckHelper {
  static log.Logger logger = new log.Logger("sidos.scheduler.task_completer");
  static bool _requirementMet(int requirementId, TaskCompleter taskCompleter) {
    bool toReturn = false;
    taskCompleter._requirements[requirementId] = null;
    if (requirementId < taskCompleter._lowestFreeRequirementId) {
      taskCompleter._lowestFreeRequirementId = requirementId;
    }

    if (taskCompleter._existingCombinationsByRequirement[requirementId] == null) {
      logger.finer("Some requirement was useless", 1);
      return false;
    }
    for (int requirementCombinationId in taskCompleter._existingCombinationsByRequirement[requirementId].toList()) {
//      consolePrint("____________", 2);
//      consolePrint("Id of tested requirement: $requirementId", 2);
//      consolePrint("Id of tested requirementCombination: $requirementCombinationId", 2);
//      consolePrint("Existing combinations by requirement ${taskCompleter._existingCombinationsByRequirement}", 2);
//      consolePrint("Tasks by requirements ${taskCompleter._tasksByRequirements}", 2);
//      consolePrint("Requirement combinations ${taskCompleter._requirementCombinations}", 2);
//      consolePrint("____________", 2);
      List<int> requirementCombination = taskCompleter._requirementCombinations[requirementCombinationId].toList();
      if (_equal(requirementCombination, [requirementId])) {
        toReturn = true;
        _resolveTasksToBeScheduled(requirementCombinationId, requirementId, taskCompleter);
      } else {
        _resolveTasksNotToBeScheduled(requirementCombination, requirementId, requirementCombinationId, taskCompleter);
      }
      taskCompleter._requirementCombinations[requirementCombinationId] = null;
      if (requirementCombinationId < taskCompleter._lowestFreeRequirementCombinationId) {
        taskCompleter._lowestFreeRequirementCombinationId = requirementCombinationId;
      }
      taskCompleter._tasksByRequirements[requirementCombinationId] = null;
    }
    return toReturn;
  }

  static void _resolveTasksToBeScheduled(int requirementCombinationId, int requirementId, TaskCompleter taskCompleter) {
    for (int taskId in taskCompleter._tasksByRequirements[requirementCombinationId]) {
      logger.fine("Some task was rescheduled from Task Completer");
      _scheduleTask(taskId, taskCompleter);
    }
    taskCompleter._existingCombinationsByRequirement[requirementId].remove(requirementCombinationId);
  }

  static void _resolveTasksNotToBeScheduled(
      List<int> requirementCombination, int requirementId, int requirementCombinationId, TaskCompleter taskCompleter) {
    List<int> newCombination = requirementCombination.toList()..remove(requirementId);
    int newCombinationId = TaskCompleterCatalogHelper._catalogRequirementCombination(newCombination, taskCompleter);
    if (taskCompleter._tasksByRequirements[newCombinationId] == null) {
      taskCompleter._tasksByRequirements[newCombinationId] = [];
    }
    taskCompleter._tasksByRequirements[newCombinationId]
        .addAll(taskCompleter._tasksByRequirements[requirementCombinationId].toList());
    for (int requirement in requirementCombination) {
      if (requirement == requirementId) {
        taskCompleter._existingCombinationsByRequirement[requirement].remove(requirementCombinationId);
        if(taskCompleter._existingCombinationsByRequirement[requirement] == []){
          taskCompleter._existingCombinationsByRequirement[requirement] = null;
        }
      } else {
        taskCompleter._existingCombinationsByRequirement[requirement].remove(requirementCombinationId);
        if (taskCompleter._existingCombinationsByRequirement[requirement] == null) {
          taskCompleter._existingCombinationsByRequirement[requirement] = new Set();
        }
        taskCompleter._existingCombinationsByRequirement[requirement].add(newCombinationId);
      }
    }
  }

  static void _scheduleTask(int taskId, TaskCompleter taskCompleter) {
//    int priority = taskCompleter._taskPriorities[taskId];
    for(Function f in taskCompleter._tasks[taskId]){
      f();
    }
    taskCompleter._tasks[taskId] = null;
    taskCompleter._taskPriorities[taskId] = null;
    if (taskId < taskCompleter._lowestFreeTaskId) {
      taskCompleter._lowestFreeTaskId = taskId;
    }
  }

  static bool _equal(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }
    if (b.isEmpty && a.isEmpty) {
      return true;
    }
    if (b.contains(a.first)) {
      List<int> aCopy = a.toList();
      List<int> bCopy = b.toList();
      aCopy.remove(a.first);
      bCopy.remove(a.first);
      return _equal(aCopy, bCopy);
    } else {
      return false;
    }
  }
}