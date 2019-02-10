part of sidos.brain;

///The [Rescheduler] class handles rescheduling [Task]s, that need some [Requirement]s to be met before processing completely.
abstract class Rescheduler {
  static log.Logger logger = new log.Logger("sidos.brain.rescheduler");

  static void _rescheduleTask(Task task, int priority,
      {List<int> missingEventIds: const [],
      List<String> missingUserInfo: const [],
      int userId: null,
      int eventId: null,
      List<int> usersWithMissingPointsOfOrigin: const [],
      int missingPatternUserId: null,
      List<String> missingEventInfo: const [],
      Map<int, List<int>> missingFitIndices: const {},
      List<Function> onAllRequirementsMet: const []}) {
    logger.fine("Task is being rescheduled");
    logger.fine("Task being rescheduled is : ${task.toFullMap()}");
    task.sendResponseAfterProcessing = false;
    Task taskCopy = task.copy(keepReturnData: true);
    taskCopy.sendResponseAfterProcessing = true;
    List<Requirement> requirements = [];

    if (missingEventIds?.isNotEmpty == true) {
      logger.finer("There are some missingEvents");
      for (int id in missingEventIds) {
        Requirement requirement = new Requirement.imprint(id);
        requirements.add(requirement);
        SidosSocketEnvelope requestEnvelope = new SidosSocketEnvelope.requestAdditionalInfoEventTags(id,
            message: "Requesting tags for event with id: $id");
        task.returnData.forEach((Socket socket, _) {
          logger.finer("SIDOS tried to get add. info");
          Brain._sendEnvelope(requestEnvelope, socket);
        });
      }
    }

    if (eventId != null && missingEventInfo.isNotEmpty) {
      logger.finer("There are some missingEventInfo");
      for (String info in missingEventInfo) {
        Requirement requirement;
        if (info == "baseCost") {
          requirement = new Requirement.baseCost(eventId);
        }
        if (info == "place") {
          requirement = new Requirement.eventPlace(eventId);
        }
        if (info == "visitLength") {
          requirement = new Requirement.visitLength(eventId);
        }
        if (info == "tags") {
          requirement = new Requirement.imprint(eventId);
        }
        requirements.add(requirement);
      }
      SidosSocketEnvelope requestEnvelope = new SidosSocketEnvelope.requestSpecificAdditionalInfoEvent(
          eventId, missingEventInfo,
          message: "Requesting info for event with id: $eventId");
//      print(task.returnData);
//      if(task.returnData.isEmpty){throw "no socket in task?";}
      task.returnData.forEach((Socket socket, _) {
        logger.finer("SIDOS tried to get add. info");
        Brain._sendEnvelope(requestEnvelope, socket);
      });
    }

    if (usersWithMissingPointsOfOrigin.isNotEmpty) {
      logger.finer("There are some pointsOfOrigin missing");
      for (int user in usersWithMissingPointsOfOrigin) {
        requirements.add(new Requirement.pointsOfOrigin(user));
        SidosSocketEnvelope requestEnvelope = new SidosSocketEnvelope.requestUserPointsOfOriginAdditionalInfo(user,
            message: "Requesting pointsOfOrigin for user with id: $user");
        task.returnData.forEach((Socket socket, _) {
          logger.finer("SIDOS tried to get add. info (points of origin)");
          Brain._sendEnvelope(requestEnvelope, socket);
        });
      }
    }

    if (missingPatternUserId != null) {
      logger.finer("There are some missing patterns");
      requirements.add(new Requirement.pattern(missingPatternUserId));
      UpdatePatternTask updatePatternTask = new UpdatePatternTask();
      updatePatternTask.data.userId = task.data.userId;
      updatePatternTask.returnData = {};
      task.returnData.forEach((Socket socket, _) {
        updatePatternTask.returnData[socket] = [
          new SidosSocketEnvelope.testEnvelope(message: "This envelope is pointles")
        ];
      });
      Processor.instance.processUpdatePatternTask(updatePatternTask, priority);
    }

    if (missingFitIndices.isNotEmpty) {
      logger.finer("There are some missing fit indices");
      missingFitIndices.forEach((int userIdx, List<int> eventIdsx) {
        for (int eventId in eventIdsx) {
          requirements.add(new Requirement.fitIndex(userIdx, eventId));
          ComputeFitIndexTask fitIndexTask = new ComputeFitIndexTask()
            ..data = (new TaskData()
              ..userId = userIdx
              ..eventId = eventId
              ..pointsOfOrigin = task.data.pointsOfOrigin)
            ..returnData = {};
          task.returnData.forEach((Socket socket, _) {
            fitIndexTask.returnData[socket] = [
              new SidosSocketEnvelope.testEnvelope(message: "This envelope is pointles")
            ];
          });
          Scheduler.instance.addTask(fitIndexTask, priority);
        }
      });
    }

    taskCopy.isBeingProcessed = false;
//    TaskCompleter.instance.clearCompleter();

    Function executor1 = () {
      Task task = taskCopy.copy(keepReturnData: true);
      task.data.isDetailedInfo = true;
      Scheduler.instance.addTask(task, priority);
    };

    List<Function> onCompletion = [executor1];
    onCompletion.addAll(onAllRequirementsMet);
    TaskCompleter.instance.addTask(onCompletion, requirements, priority);
  }
}
