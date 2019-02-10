part of sidos.scheduler;

abstract class TaskManufacturer {
  static Task newTaskOfType(String type) {
    switch (type) {
      case Task.UPDATE_IMPRINT:
        return new UpdateImprintTask();
      case Task.IDLE:
        return new Idle();
      case Task.PLAN_PROCESSING_REQUEST:
        return new PlanProcessingRequestTask();
      case Task.TEST_TASK:
        return new TestTask();
      case Task.UPDATE_PATTERN:
        return new UpdatePatternTask();
      case Task.ATTEND:
        return new AttendTask();
      case Task.HARD_LOG:
        return new HardLogTask();
      case Task.HARD_CACHE:
        return new HardCacheTask();
      case Task.ADDITIONAL_EVENT_TAGS:
        return new AdditionalEventTagsTask();
      case Task.LOAD_FROM_HARD_CACHE:
        return new LoadHardCacheTask();
      case Task.SORT_FEW_EVENTS_TASK:
        return new SortFewEventsTask();
      case Task.COMPUTE_FIT_INDEX:
        return new ComputeFitIndexTask();
      case Task.MASS_SORT_EVENTS_TASK:
        return new MassSortEventsTask();
      default:
        new log.Logger("sidos.scheduler.task_manufacturer").warning(
            "Task type >>$type<< not identified, so returning new (generic) Task()", 0);
        return new Task();
    }
  }

  static Task copy(Task task, {bool keepReturnData: false}) {
    String type = task.getType();
    Map jsonableMap = task.toFullMap();
    Map newMap = JSON.decode(JSON.encode(jsonableMap));
    Task copy = newTaskOfType(type);
    copy.fromMap(newMap);
    if (keepReturnData) {
      copy.returnData = task.returnData;
    }
    return copy;
  }
}
