part of sidos.brain;

class Processor {
  static Processor _instance;

  log.Logger logger = new log.Logger("sidos.brain.processor");

  static Processor get instance {
    if (_instance == null) {
      _instance = new Processor();
    }
    return _instance;
  }

  void _markTaskAsSuccessfullyFinished(Task task, {String addToMessages: "", List<int> eventIds: null}) {
    task.returnData.forEach((socket, envelopes) {
      for (SidosSocketEnvelope envelope in envelopes) {
        envelope.isFinalResponse = true;
        envelope.success = true;
        envelope.message += addToMessages;
        envelope.eventIds = eventIds;
      }
    });
  }

  void processTestTask(TestTask task) {
    _markTaskAsSuccessfullyFinished(task, addToMessages: "+ checked by sidos server");
  }

  void processUpdateImprintTask(UpdateImprintTask task, int priority) {
    logger..finer("Processingt UpdateImprintTask as a result of recieved additional event tags");
    Imprint oldImprint = Cachor.instance.eventImprints[task.data.eventId];
    double baseCost = task.data.baseCost == null ? oldImprint?.baseCost : task.data.baseCost;
    GPS place = task.data.place == null ? oldImprint?.place : task.data.place;
    int visitLength = task.data.visitLength == null ? oldImprint?.visitLength : task.data.visitLength;
    List<int> tags = (task.data.tags?.isNotEmpty != true)
        ? (oldImprint?.points == null ? <int>[] : oldImprint?.points?.keys?.toList())
        : task.data.tags;


    List<String> missingEventInfo = [];
    if (tags?.isNotEmpty != true) {
      missingEventInfo.add("tags");
    }
    if (baseCost == null) {
      missingEventInfo.add("baseCost");
    }
    if (place == null) {
      missingEventInfo.add("place");
    }
    if (visitLength == null) {
      missingEventInfo.add("visitLength");
    }
    if (missingEventInfo.isEmpty || task.data.isDetailedInfo) {
      _processUpdateImprintTaskWithAllData(task, tags, baseCost, place, visitLength, !missingEventInfo.isEmpty);
    } else {
      Rescheduler._rescheduleTask(task, priority, eventId: task.data.eventId, missingEventInfo: missingEventInfo);
    }
  }

  void _processUpdateImprintTaskWithAllData(
      UpdateImprintTask task, List<int> tags, double baseCost, GPS place, int visitLength, bool eventNotFound) {
    Imprint imprint = eventNotFound
        ? new ImprintNotFound()
        : Imprintificator.instance.createImprint(tags, place, baseCost: baseCost, visitLength: visitLength);
    Cachor.instance.eventImprints[task.data.eventId] = imprint;
    if (imprint != null) {
      List<Requirement> requirements = [];
      requirements.add(new Requirement.imprint(task.data.eventId));
      requirements.add(new Requirement.baseCost(task.data.eventId));
      requirements.add(new Requirement.eventPlace(task.data.eventId));
      requirements.add(new Requirement.visitLength(task.data.eventId));
      for (Requirement requirement in requirements) {
        TaskCompleter.instance.testIfSomeRequirementHasBeenMet(requirement);
      }
    } else {
      throw "you wot null";
    }
    Cachor.instance.userEventFitIndices.forEach((int userId, Map<int, FitIndex> eventIdsFitIndices) {
      eventIdsFitIndices?.remove(task.data.eventId);
    });
    _markTaskAsSuccessfullyFinished(task);
  }

  void processAttendTask(AttendTask task) {
    if (Cachor.instance.attends[task.data.userId] == null) {
      Cachor.instance.attends[task.data.userId] = [];
    }
    bool contains = Cachor.instance.attends[task.data.userId]?.contains(task.data.eventId) == true;
    if (!contains) {
      Cachor.instance.attends[task.data.userId].add(task.data.eventId);
      UpdatePatternTask updatePatternTask = new UpdatePatternTask()..data.userId = task.data.userId;
      Scheduler.instance.addTask(updatePatternTask, 4);
    }

    _markTaskAsSuccessfullyFinished(task);
  }

  void processUpdatePatternTask(UpdatePatternTask task, int priority) {
    List<int> eventIds = Cachor.instance.attends[task.data.userId];
    if (eventIds == null) {
      eventIds = [];
    }
    List<int> missingImprintIds = [];
    for (int eventId in eventIds) {
      if (Cachor.instance.shouldAskForImprint(eventId)) missingImprintIds.add(eventId);
    }
    if (task.data.pointsOfOrigin?.isNotEmpty != true) {
      task.data.pointsOfOrigin = Cachor.instance.userPatterns[task.data.userId]?.pointsOfOrigin;
    }
    bool shouldAskForPointsOfOrigin;
    bool missingPoint = task.data.pointsOfOrigin?.isNotEmpty != true;
    bool shouldAskForPattern = Cachor.instance.shouldAskForPattern(task.data.userId);
    shouldAskForPointsOfOrigin = missingPoint && shouldAskForPattern;
    logger.finer(
        "Will UpdatePatternTask be completed now? :${(missingImprintIds.isEmpty && !shouldAskForPointsOfOrigin) || task.data?.isDetailedInfo == true}");
    if ((missingImprintIds.isEmpty && !shouldAskForPointsOfOrigin) || task.data?.isDetailedInfo == true) {
      _processUpdatePatternTaskWithAllData(task, eventIds);
    } else {
      logger.finer("...And it is because there are missingImprints: ${!missingImprintIds
              .isEmpty}, or beacause of bad pointsOfOrigin?: $shouldAskForPointsOfOrigin");
      logger.finer("...the points of origin are: ${task.data.pointsOfOrigin}");
      logger.finer("...the pattern is: ${Cachor.instance.userPatterns[task.data.userId]}");
      Rescheduler._rescheduleTask(task, priority,
          missingEventIds: missingImprintIds,
          usersWithMissingPointsOfOrigin: task.data.pointsOfOrigin?.isNotEmpty != true ? [task.data.userId] : []);
    }
  }

  void _processUpdatePatternTaskWithAllData(UpdatePatternTask task, List<int> eventIds) {
    task.sendResponseAfterProcessing = true;
    List<Imprint> imprints = [];
    for (int id in eventIds) {
      if (Cachor.instance.eventImprints[id] != null) {
        imprints.add(Cachor.instance.eventImprints[id]);
      }
    }
    if (task.data.pointsOfOrigin?.isNotEmpty != true) {
      throw "no points in all datra";
    }
    logger.finer("points of origin are: ${task.data.pointsOfOrigin}");
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(new Requirement.pointsOfOrigin(task.data.userId));
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(new Requirement.pattern(task.data.userId));
    UserPattern pattern =
        Patternificator.instance.createUserPatternFromImprints(imprints, pointsOfOrigin: task.data.pointsOfOrigin);
    Cachor.instance.userPatterns[task.data.userId] = pattern;
    Cachor.instance.userEventFitIndices.remove(task.data.userId);
    _markTaskAsSuccessfullyFinished(task);
  }

  void processSortFewEventsTask(SortFewEventsTask task, int priority) {
    List<int> missingImprintIds = [];
    bool areThereNullsInEventIdList = true;
    while (areThereNullsInEventIdList) {
      areThereNullsInEventIdList = task.data.eventIds.remove(null);
    }
    List<int> eventIds = task.data.eventIds.toList();
    for (int eventId in eventIds) {
      logger.finer("Should imprint be asked for? ${Cachor.instance.shouldAskForImprint(eventId)}");
      logger.finer("Imprint not found? ${Cachor.instance.shouldAskForImprint(eventId) is ImprintNotFound}");
      logger.finer("${Cachor.instance.eventImprints[eventId]?.toFullMap()}");
      if (Cachor.instance.shouldAskForImprint(eventId)) missingImprintIds.add(eventId);
    }

    int userId = task.data.userId;
    bool shouldAskForPattern = Cachor.instance.shouldAskForPattern(userId);

    logger.finer("${Cachor.instance.userPatterns[userId]?.toFullMap()}");
    logger.finer("Should ask for pattern: $shouldAskForPattern");
    logger.finer("Missing imprints: $missingImprintIds");
    logger.finer("Will sort be finished with all data: ${missingImprintIds.isEmpty && !shouldAskForPattern}");
    logger.severe("${Cachor.instance.userPatterns[userId]?.toFullMap()}");
    logger.severe("Should ask for pattern: $shouldAskForPattern");
    logger.severe("Missing imprints: $missingImprintIds");
    logger.severe("Will sort be finished with all data: ${missingImprintIds.isEmpty && !shouldAskForPattern}");

    if (missingImprintIds.isEmpty && !shouldAskForPattern) {
      UserPattern pattern = Cachor.instance.userPatterns[userId];
      GPS localPointOfOrigin = task.data.pointsOfOrigin?.first;
      if (localPointOfOrigin != null) {
        bool isBroken = false;
        for (GPS pointOfOrigin in pattern.pointsOfOrigin) {
          if (GPS.distance(pointOfOrigin, task.data.pointsOfOrigin.first) < 1 / 100000) {
            isBroken = true;
            break;
          }
        }
        if (!isBroken) pattern.pointsOfOrigin.add(task.data.pointsOfOrigin.first);
      }
      _processSortFewEventsTaskWithAllData(task, priority, pattern, localPointOfOrigin);
    } else {
      Rescheduler._rescheduleTask(task, priority,
          missingEventIds: missingImprintIds, missingPatternUserId: shouldAskForPattern ? userId : null);
    }
  }

  void _processSortFewEventsTaskWithAllData(
      SortFewEventsTask task, int priority, UserPattern pattern, GPS localPointOfOrigin) {
    List<int> eventIds = task.data.eventIds.toList();
    Map<int, double> fitIndices = {};
    for (int eventId in eventIds) {
      Imprint imprint = Cachor.instance.eventImprints[eventId];
      FitIndex fitIndex = Cachor.instance.userEventFitIndices[task.data.userId] == null
          ? null
          : Cachor.instance.userEventFitIndices[task.data.userId][eventId];
      if (fitIndex == null) {
        try {
//          pattern.moneyConservation = 0.0;
          /*UserPattern patternCopy = */new UserPattern()..fromMap(JSON.decode(JSON.encode(pattern.toFullMap())));
        } catch (_) {
          throw "${pattern.moneyConservation}${double.NAN}";
        }

        UserPattern patternCopy = new UserPattern()..fromMap(JSON.decode(JSON.encode(pattern.toFullMap())));
        if (localPointOfOrigin != null) patternCopy.pointsOfOrigin.add(localPointOfOrigin);
        fitIndex = Fittor.instance.fitIndex(patternCopy, imprint);
        Cachor.instance.addFitIndex(task.data.userId, eventId, fitIndex);
        Requirement fitIndexGenerated = new Requirement.fitIndex(task.data.userId, eventId);
        TaskCompleter.instance.testIfSomeRequirementHasBeenMet(fitIndexGenerated);
      }
      fitIndices.addAll({eventId: fitIndex.value});
    }
    eventIds.sort((a, b) {
      if (fitIndices[a] > fitIndices[b]) {
        return -1;
      } else {
        return 1;
      }
    });
    int end = eventIds.length;
    if (task.data.numberOfEventDesired == null) {
      task.data.numberOfEventDesired = 35;
    }
    if (end > task.data.numberOfEventDesired) {
      eventIds.removeRange(task.data.numberOfEventDesired, end);
    }
    _markTaskAsSuccessfullyFinished(task, eventIds: eventIds);
  }

  void processMassSortEventsTask(MassSortEventsTask task, int priority) {
    bool areThereNullsInEventIdList = true;
    while (areThereNullsInEventIdList) {
      areThereNullsInEventIdList = task.data.eventIds.remove(null);
    }
    List<int> eventIds = task.data.eventIds.toList();
    int userId = task.data.userId;
    List<int> missingFitIndices = [];
//    if (Cachor.instance.userEventFitIndices[userId] == null) {
//      Cachor.instance.userEventFitIndices[userId] = {};
//    }
    for (int eventId in eventIds) {
      if (Cachor.instance.shouldAskForFitIndex(userId, eventId)) missingFitIndices.add(eventId);
    }

    if (missingFitIndices.isEmpty) {
      _processMassSortEventsTaskWithAllData(task, priority);
    } else {
      Rescheduler._rescheduleTask(task, priority, missingFitIndices: {userId: missingFitIndices});
    }
  }

  void _processMassSortEventsTaskWithAllData(MassSortEventsTask task, int priority) {
    List<int> eventIds = task.data.eventIds.toList();
    Map<int, double> fitIndices = {};
    for (int eventId in eventIds) {
      FitIndex fitIndex = Cachor.instance.userEventFitIndices[task.data.userId][eventId];
      fitIndices.addAll({eventId: fitIndex.value});
    }
    eventIds.sort((a, b) {
      if (fitIndices[a] > fitIndices[b]) {
        return -1;
      } else {
        return 1;
      }
    });
    int end = eventIds.length;
    if (task.data.numberOfEventDesired == null) task.data.numberOfEventDesired = 35;
    if (end > task.data.numberOfEventDesired) {
      eventIds.removeRange(task.data.numberOfEventDesired, end);
    }
    _markTaskAsSuccessfullyFinished(task, eventIds: eventIds);
  }

  void processAdditionalEventTagsTask(AdditionalEventTagsTask task, int priority) {
    UpdateImprintTask newTask = new UpdateImprintTask();
    newTask.data = new TaskData();
    newTask.data.eventId = task.eventId;
    newTask.data.tags = task.eventTags;
    newTask.data.isDetailedInfo = true;
    processUpdateImprintTask(newTask, priority);
  }

  void processComputeFitIndexTask(ComputeFitIndexTask task, int priority) {
    int userId = task.data.userId;
    int eventId = task.data.eventId;

//    UserPattern pattern = Cachor.instance.userPatterns[userId];
    bool shouldAskForImprint = Cachor.instance.shouldAskForImprint(eventId);
    bool shouldAskForPattern = Cachor.instance.shouldAskForPattern(userId);

    if (!shouldAskForImprint && !shouldAskForPattern) {
      _processComputeFitIndexTaskWithAllData(task, priority);
    } else {
      Rescheduler._rescheduleTask(task, priority,
          missingEventIds: shouldAskForImprint ? [eventId] : [],
          missingPatternUserId: shouldAskForPattern ? userId : null);
    }
  }

  void _processComputeFitIndexTaskWithAllData(ComputeFitIndexTask task, int priority) {
    int userId = task.data.userId;
    int eventId = task.data.eventId;
    Imprint imprint = Cachor.instance.eventImprints[eventId];
    UserPattern pattern = Cachor.instance.userPatterns[userId];
    UserPattern patternCopy = new UserPattern()..fromMap(JSON.decode(JSON.encode(pattern.toFullMap())));
    if (task.data.pointsOfOrigin != null) patternCopy.pointsOfOrigin.addAll(task.data.pointsOfOrigin);
    FitIndex fitIndex = Fittor.instance.fitIndex(patternCopy, imprint);
    Cachor.instance.addFitIndex(userId, eventId, fitIndex);
    Requirement fitIndexRequirement = new Requirement.fitIndex(userId, eventId);
    TaskCompleter.instance.testIfSomeRequirementHasBeenMet(fitIndexRequirement);
    _markTaskAsSuccessfullyFinished(task);
  }
}
