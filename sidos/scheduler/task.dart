part of sidos.scheduler;

///[Task] class is a [sidos] internal class representing some activity.
///
///Typically, the [Scheduler] schedules [Task]s to be processed by [Brain] (from Brain library), but occasionally,
///some sub[Task] can be created and processed as a part of some different über[Task].
///
/// Main difference of [Task] to [SidosSocketEnvelope[ is, that [Task]s are meant
/// even for some procedures (in non IT meaning) that are not requestable
/// from outside, therefore not supported by [SidosSocketEnvelope].
class Task {
  static const String UPDATE_IMPRINT = "UpdateImprint";
  static const String UPDATE_PATTERN = "UpdatePattern";
  static const String ATTEND = "attend";
  static const String IDLE = "Idle";
  static const String PLAN_PROCESSING_REQUEST = "PlanProccesingRequest";
  static const String TEST_TASK = "TestTask";
  static const String SORT_FEW_EVENTS_TASK = "sortFewEventTask";
  static const String MASS_SORT_EVENTS_TASK = "massFewEventTask";
  static const String COMPUTE_FIT_INDEX = "computeFitIndex";
  static const String HARD_CACHE = "hardCache";
  static const String LOAD_FROM_HARD_CACHE = "fromHardCache";
  static const String HARD_LOG = "hardLog";
  static const String ADDITIONAL_EVENT_TAGS = "additionalEventTags";
  static const String COMPOUND_WAITING_FOR_ADDITIONAL_INFO = "compoundWaitingForAdditionalInfo";

  static int lowestFreeId = 0;

  bool isBeingProcessed = false;
  bool sendResponseAfterProcessing = true;
  TaskData data = new TaskData();
  Map<Socket, List<SidosSocketEnvelope>> returnData = {};
  DateTime whenCataloged;
  List<DateTime> whenUpdated = [];
  DateTime whenProcessingStarted;
  DateTime whenProcessingFinished;
  bool finishedAheadOfPlan = false;
  int id;

  ///returns [null] if there are multiple members in [returnData] or [returnData.first], if there is only one, it return the only [SidosSocketEnvelope] in [returnData]
  SidosSocketEnvelope get onlyEnvelope {
    if (returnData.length != 1) {
      return null;
    } else {
      return returnData.values.first.length == 1 ? returnData.values.first.first : null;
    }
  }

  ///returns [null] if there are multiple members in [returnData], if there is only one, it return the only [SidosSocketEnvelope] in [returnData]
  Socket get onlySocket {
    if (returnData.length != 1) {
      return null;
    } else {
      return returnData.keys.first;
    }
  }

  ///Default constructor
  Task(){
    id = lowestFreeId++;
  }

  bool validate() {
    return true;
  }

  Task copy({bool keepReturnData: false}) {
    return TaskManufacturer.copy(this, keepReturnData: keepReturnData);
  }

  ///only [Task]s of the same subtype can be equal (so far, april 2016). Further investigation of
  ///equality is left for corresponding subtype's [equals] method. Two tasks
  ///should be only equal, if it makes good sense to replace older [Task.data]
  ///with new ones.
  bool equals(Task o) {
    bool isEqual = false;

    if (o is Task) {
      if (o is UpdateImprintTask) {
        return o.equals(this);
      }
    }

    return isEqual;
  }

  String getType() {
    String type;
    if (this is UpdateImprintTask) {
      type = UPDATE_IMPRINT;
    }
    if (this is Idle) {
      type = IDLE;
    }
    if (this is PlanProcessingRequestTask) {
      type = PLAN_PROCESSING_REQUEST;
    }
    if (this is TestTask) {
      type = TEST_TASK;
    }
    if (this is UpdatePatternTask) {
      type = UPDATE_PATTERN;
    }
    if (this is AttendTask) {
      type = ATTEND;
    }
    if (this is SortFewEventsTask) {
      type = SORT_FEW_EVENTS_TASK;
    }
    if (this is MassSortEventsTask) {
      type = MASS_SORT_EVENTS_TASK;
    }
    if (this is ComputeFitIndexTask) {
      type = COMPUTE_FIT_INDEX;
    }
    if (this is HardLogTask) {
      type = HARD_LOG;
    }
    if (this is HardCacheTask) {
      type = HARD_CACHE;
    }
    if (this is LoadHardCacheTask) {
      type = LOAD_FROM_HARD_CACHE;
    }
    if (this is AdditionalEventTagsTask) {
      type = ADDITIONAL_EVENT_TAGS;
    }
    return type;
  }

  void sendResponses() {
    returnData.forEach((socket, envelopes) {
      for (SidosSocketEnvelope envelope in envelopes) {
        Scheduler._instance._sendEnvelope(envelope, socket);
      }
    });
  }

  Map toFullMap() {
    Map json = {};

    json["type"] = getType();
    json["isBeingProcessed"] = isBeingProcessed;
    json["whenCataloged"] = whenCataloged == null ? null : whenCataloged.millisecondsSinceEpoch;
    json["whenUpdated"] = [];
    for (DateTime time in whenUpdated) {
      json["whenUpdated"].add(time.millisecondsSinceEpoch);
    }
//    json["whenProcessingStarted"] = whenProcessingStarted==null ? null : whenProcessingStarted.millisecondsSinceEpoch.toString();
    json["whenProcessingStarted"] = whenProcessingStarted?.millisecondsSinceEpoch;
    json["whenProcessingFinished"] = whenProcessingFinished?.millisecondsSinceEpoch;
    json["finishedAheadOfPlan"] = finishedAheadOfPlan;
    json["data"] = data.toFullMap();
    json["envelope"] = onlyEnvelope?.toFullPurgedMap();
//    json["returnData"] = {};
//    returnData.forEach((Socket socket, envelope){

//    });

    return json;
  }

  void fromMap(Map map) {
    map["type"] = getType();
    //?
    isBeingProcessed = map["isBeingProcessed"];
    whenCataloged = map["whenCataloged"] == null ? null : new DateTime.fromMillisecondsSinceEpoch(map["whenCataloged"]);
    whenUpdated = [];
    for (int timeInMsSinceEpochString in map["whenUpdated"]) {
      whenUpdated.add(new DateTime.fromMicrosecondsSinceEpoch(timeInMsSinceEpochString));
    }
    whenProcessingStarted = map["whenProcessingStarted"] == null
        ? null
        : new DateTime.fromMillisecondsSinceEpoch(map["whenProcessingStarted"]);
    whenProcessingFinished = map["whenProcessingFinished"] == null
        ? null
        : new DateTime.fromMillisecondsSinceEpoch(map["whenProcessingFinished"]);
    finishedAheadOfPlan = map["finishedAheadOfPlan"];
    data = new TaskData()..fromMap(map["data"]);
  }
}
