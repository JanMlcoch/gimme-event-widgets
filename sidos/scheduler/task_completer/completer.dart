///Handles tasks waiting for their requirements to be met, so they can be properly finished
library sidos.scheduler.task_completer;

import 'package:logging/logging.dart' as log;

part 'requirement.dart';
part 'check_helper.dart';
part 'catalog_helper.dart';

///A singleton class that handles divided complex tasks's and Tasks waiting for additional info
class TaskCompleter {
  log.Logger logger = new log.Logger("sisos.scheduler.task_completer");
  static TaskCompleter _instance;

  ///Return Singleton instance of [TaskCompleter]
  static TaskCompleter get instance {
    if (_instance == null) {
      _instance = new TaskCompleter();
    }
    return _instance;
  }

  ///Refers to the lowest unoccupied key in [_tasks].
  ///
  ///The [null] values are considered empty.
  int _lowestFreeTaskId = 0;

  ///Refers to the lowest unoccupied key in [_requirements].
  ///
  ///The [null] values are considered empty.
  int _lowestFreeRequirementId = 0;

  ///Refers to the lowest unoccupied key in [_requirementCombinations].
  ///
  ///The [null] values are considered empty.
  int _lowestFreeRequirementCombinationId = 0;

  ///Stores all [Requirement]s relevant to tasks stored in [_tasks].
  Map<int, Requirement> _requirements = {};

  ///Stores all relevant tasks.
  Map<int, List<Function>> _tasks = {};

  ///Stores all relevant combinations of [Requirement]s, that are relevant to tasks currently stored in [_tasks].
  ///
  /// That means that [_requirementCombinations] contain only such [List]s of [int] key of [Requirements] in [_requirements],
  /// that corresponds with some set of requirements needed for a certain [Task] in [_tasks].
  Map<int, Set<int>> _requirementCombinations = {};

  ///Stores priorities of [Task]s stored in [_tasks]. It is a priority in the sense of [Scheduler] (for example [Scheduler.addTask])
  Map<int, int> _taskPriorities = {};

  ///This stores the [List] of [int] keys of [Task]s stored in [_tasks], with keys being the appropriate [int] keys in [_requirementCombinations]
  Map<int, List<int>> _tasksByRequirements = {};

  ///This stores all [int] keys of [_requirementCombinations] by the [int] keys of [_requirements].
  ///
  ///It is so to provide a quick way to find all relevant [Requirement] combinations that contains certain [Requirement].
  Map<int, Set<int>> _existingCombinationsByRequirement = {};

  ///Clears all data stored.
  void clearCompleter() {
    logger.fine("Task completer cleared!");
    _instance = null;
  }

  //todo: allow custom requirements with matchers
  ///Adds [Task] [task], which will be rescheduled when all [Requirement]s in [newRequirements] will be met.
  ///
  ///The parameter [priority] states the priority of the task being added.
  ///
  /// Be aware, that this treats [null] requirements as valid requirements and meets them if [null] is met
  void addTask(List<Function> task, List<Requirement> newRequirements, int priority) {
    logger.finer("A task has been added!");
    if(newRequirements == null){
      newRequirements = [];
    }
    if(newRequirements == []){
      return;
    }
    if(task == null){
      task = [];
    }
    _tasks[_lowestFreeTaskId] = task;
    _taskPriorities[_lowestFreeTaskId] = priority;
    List<int> requirementIds = TaskCompleterCatalogHelper._catalogRequirements(newRequirements, this);
    int requirementCombinationId = TaskCompleterCatalogHelper._catalogRequirementCombination(requirementIds, this);
    TaskCompleterCatalogHelper._catalogTaskByRequirementIds(_lowestFreeTaskId, requirementCombinationId, this);
    TaskCompleterCatalogHelper._updateLowestHigherFreeTaskId(this);
  }

  ///Tests if some [Requirements] have been met (from [_requirements]). It does so by the value of [Requirement._equals].
  ///
  /// If some requirements actually have been met, this function executes all appropriate steps,
  /// including rescheduling tasks, which have all their requirements met.
  List<bool> testIfSomeRequirementHasBeenMet(Requirement requirement) {
    _removeUselessNullRequirements();
    logger.finer("Testing if some requirement is met", 2);
    bool someRequirementHasBeenMet = false;
    bool someTaskWasRescheduled = false;

    _requirements.forEach((int requirementId, Requirement catalogedRequirement) {
      logger.finest("""____________
Id of tested requirement: $requirementId
Requirements: $_requirements
Existing combinations by requirement $_existingCombinationsByRequirement
Tasks by requirements $_tasksByRequirements
Requirement combinations $_requirementCombinations
____________""");
      if (requirement == null ? catalogedRequirement == null : requirement._equals(catalogedRequirement)){//requirement._equals(catalogedRequirement)) {
        logger.finer("Requirement $requirementId is equal to met requirement!");
        bool wasSomeTaskRescheduledBecauseOfThisRequirements;
        wasSomeTaskRescheduledBecauseOfThisRequirements = TaskCompleterCheckHelper._requirementMet(requirementId, this);
        someTaskWasRescheduled = someTaskWasRescheduled || wasSomeTaskRescheduledBecauseOfThisRequirements;
        someRequirementHasBeenMet = true;
      }
    });
    return [someRequirementHasBeenMet, someTaskWasRescheduled];
  }

  void _removeUselessNullRequirements(){
    List<int> requirementIdsToRemove = [];
    _requirements.forEach((int requirementId, Requirement req){
      if(req == null){TaskCompleter.instance.logger.finest(_existingCombinationsByRequirement[requirementId]);}
      if(req == null && _existingCombinationsByRequirement[requirementId]?.isNotEmpty != true){
        requirementIdsToRemove.add(requirementId);
      }
    });
    for(int requirementId in requirementIdsToRemove){
      _requirements.remove(requirementId);
    }
  }
}
