part of sidos.brain;

///[Planner] handles primary planning of raw tasks from envelope, e. g. [PlanProcessingRequestTask].
class Planner {
  static Planner _instance;
  log.Logger logger = new log.Logger("sidos.brain.planner");

  static Planner get instance {
    if (_instance == null) {
      _instance = new Planner();
    }
    return _instance;
  }

  void processPlanningTask(PlanProcessingRequestTask task) {
    logger.fine("planning process for task: ${task.toFullMap()}");
    SidosSocketEnvelope envelope = task.onlyEnvelope;
//    envelope.isFinalResponse = true;
    if (envelope.validate()) {
      Task plannedTask = _planTask(envelope, task.onlySocket);
      Scheduler.instance.addTask(plannedTask, getPriorityByTaskType(plannedTask.getType()));
      task.returnData.clear();
      return null;
    } else {
      logger.severe("INVALID SidosSocketEnvelope");
      envelope.success = false;
      envelope.message = "Incomming message was not valid";
    }
  }

  Task _planTask(SidosSocketEnvelope envelope, Socket socket) {
    logger.fine("Planning task ${envelope.type}");
    String type = envelope.type;
    Task newTask;
    switch (type) {
      case SidosSocketEnvelope.TYPE_TEST:
        newTask = new TestTask();
        break;
      case SidosSocketEnvelope.TYPE_UPDATE_IMPRINT:
        newTask = new UpdateImprintTask();
        newTask.data = new TaskData();
        newTask.data.eventId = envelope.eventId;
        newTask.data.tags = envelope.tags;
        newTask.data.baseCost = envelope.baseCost;
        newTask.data.visitLength = envelope.visitLength;
        newTask.data.place = envelope.place;
        newTask.data.isDetailedInfo = envelope.isDetailedInfo;
        break;
      case SidosSocketEnvelope.TYPE_ATTEND:
        newTask = new AttendTask();
        newTask.data = new TaskData();
        newTask.data.eventId = envelope.eventId;
        newTask.data.userId = envelope.userId;
        break;
      case SidosSocketEnvelope.TYPE_UPDATE_PATTERN:
        newTask = new UpdatePatternTask();
        newTask.data = new TaskData();
        newTask.data.userId = envelope.userId;
        newTask.data.pointsOfOrigin = envelope.pointsOfOrigin;
        newTask.data.isDetailedInfo = envelope.isDetailedInfo;
        break;
      case SidosSocketEnvelope.TYPE_SORT_EVENTS_FOR_USER:
        if (envelope.eventIds.length < 36) {
          newTask = new SortFewEventsTask();
        } else {
          newTask = new MassSortEventsTask();
        }
        newTask.data = new TaskData();
        newTask.data.userId = envelope.userId;
        newTask.data.eventIds = envelope.eventIds;
        newTask.data.numberOfEventDesired = envelope.numberOfEventsDesired;
        break;
      case SidosSocketEnvelope.TYPE_HARD_LOG:
        newTask = new HardLogTask();
        break;
      case SidosSocketEnvelope.TYPE_HARD_COPY:
        newTask = new HardCacheTask();
        break;
      case SidosSocketEnvelope.TYPE_LOAD_HARD_COPY:
        newTask = new LoadHardCacheTask();
        break;
      default:
        logger.warning("Unknown request type - >>$type<<, ignoring ...");
        newTask = new Task();
        break;
    }
    newTask.returnData = {
      socket: [envelope]
    };
    return newTask;
  }

  int getPriorityByTaskType(String type) {
    switch (type) {
      case Task.TEST_TASK:
        return 5;
      default:
        logger.warning("Unknown request type - >>$type<<, given low priority");
        return 2;
    }
  }
}
