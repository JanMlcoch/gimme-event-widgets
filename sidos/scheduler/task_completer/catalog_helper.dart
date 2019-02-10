part of sidos.scheduler.task_completer;

abstract class TaskCompleterCatalogHelper{

  static List<int> _catalogRequirements(List<Requirement> newRequirements, TaskCompleter taskCompleter) {
    List<int> toReturn = [];
    for (Requirement requirement in newRequirements) {
      taskCompleter._requirements.forEach((int requirementId, Requirement catalogedRequirement) {
        TaskCompleter.instance.logger.finest("Requiurement equivalence check for catalogging");
        if (requirement == null ? catalogedRequirement == null : requirement._equals(catalogedRequirement)) {
          //bacha: zacatek prasarny
          taskCompleter._lowestFreeRequirementId = requirementId;
        }
      });
      toReturn.add(taskCompleter._lowestFreeRequirementId);
      taskCompleter._requirements[taskCompleter._lowestFreeRequirementId] = requirement;
      _updateLowestHigherFreeRequirementId(taskCompleter);
    }
    return toReturn;
  }

  static void _updateLowestHigherFreeTaskId(TaskCompleter taskCompleter) {
    while (taskCompleter._tasks[taskCompleter._lowestFreeTaskId] != null) {
      taskCompleter._lowestFreeTaskId++;
    }
  }

  static void _updateLowestHigherFreeRequirementId(TaskCompleter taskCompleter) {
    while (taskCompleter._requirements[taskCompleter._lowestFreeRequirementId] != null) {
      taskCompleter._lowestFreeRequirementId++;
    }
  }

  static void _updateLowestHigherFreeRequirementCombinationId(TaskCompleter taskCompleter) {
    while (taskCompleter._requirementCombinations[taskCompleter._lowestFreeRequirementCombinationId] != null) {
      taskCompleter._lowestFreeRequirementCombinationId++;
    }
  }

  static void _catalogTaskByRequirementIds(int taskId, int requirementCombinationId, TaskCompleter taskCompleter) {
    if (taskCompleter._tasksByRequirements[requirementCombinationId] == null) {
      taskCompleter._tasksByRequirements[requirementCombinationId] = [];
    }
    taskCompleter._tasksByRequirements[requirementCombinationId].add(taskId);
  }

  static int _catalogRequirementCombination(List<int> requirementCombinationIds, TaskCompleter taskCompleter) {
    int combinationId = taskCompleter._lowestFreeRequirementCombinationId;
    taskCompleter._requirementCombinations[combinationId] = requirementCombinationIds.toSet();
    for (int requirementId in requirementCombinationIds) {
      if (taskCompleter._existingCombinationsByRequirement[requirementId] == null) {
        taskCompleter._existingCombinationsByRequirement[requirementId] = new Set();
      }
      if (!taskCompleter._existingCombinationsByRequirement[requirementId].contains(requirementCombinationIds)) {
        taskCompleter._existingCombinationsByRequirement[requirementId].add(taskCompleter._lowestFreeRequirementCombinationId);
      }
    }
    _updateLowestHigherFreeRequirementCombinationId(taskCompleter);
    return combinationId;
  }
}