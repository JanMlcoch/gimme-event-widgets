part of sidos.computor;
///class responsible or logging activity of [sidos].
class Logger {
  Log log;

  Logger() {
    log = new Log([]);
  }
}

///Class containing information about activity of [sidos].
class Log {
  List<LogEntry> list;

  Log(this.list);

  Map<String, dynamic> toFullMap(){
    Map<String,dynamic> map = {};

    map["list"] = [];
    for(LogEntry entry in  list){
      map["list"].add(entry.toFullMap());
    }

    return map;
  }
}

class LogEntry {
  String splitMark = "|";

  String entryType;
  String taskType;
  DateTime whenCataloged;
  DateTime whenStarted;
  DateTime whenFinished;
  Duration duration;
  List<DateTime> whenUpdated = [];
  bool wasFinishedAheadOfPlan;

  LogEntry();

  LogEntry.fromTask(Task task){
    entryType = "task";
    taskType = task.getType();
    whenCataloged = task.whenCataloged;
    whenStarted = task.whenProcessingStarted;
    whenFinished = task.whenProcessingFinished;
    duration = whenFinished.difference(whenStarted);
    whenUpdated = task.whenUpdated;
    wasFinishedAheadOfPlan = task.finishedAheadOfPlan;
//    print(this.toString());
  }

  @override
  String toString(){
    return """$entryType$splitMark$taskType$splitMark${whenCataloged.toString()}
    $splitMark${whenStarted.toString()}$splitMark${whenFinished.toString()}
    $splitMark${duration.toString()}$splitMark${whenUpdated.toString()}
    $splitMark${wasFinishedAheadOfPlan.toString()}/n""";
  }

  Map toFullMap(){
    Map json = {};

    json['entryType'] = entryType;
    json['taskType'] = taskType;
    json['whenCataloged'] = whenCataloged.millisecondsSinceEpoch;
    json['whenStarted'] = whenStarted.millisecondsSinceEpoch;
    json['whenFinished'] = whenFinished.millisecondsSinceEpoch;
    json['duration'] = duration.inMilliseconds;
    json['whenUpdated'] = [];
    for(DateTime updateTime in whenUpdated){
      json['whenUpdated'].add(updateTime.millisecondsSinceEpoch);
    }
    json['wasFinishedAheadOfPlan'] = wasFinishedAheadOfPlan;

    return json;
  }

  void fromMap(Map map){
    entryType               = map['entryType'];
    taskType                = map['taskType'];
    whenCataloged           = new DateTime.fromMillisecondsSinceEpoch(map['whenCataloged']);
    whenStarted             = new DateTime.fromMillisecondsSinceEpoch(map['whenStarted']);
    whenFinished            = new DateTime.fromMillisecondsSinceEpoch(map['whenFinished']);
    duration                = new Duration(milliseconds: map['duration']);
    whenUpdated             = [];
    for(int updateTimesInMillisecondsSinceEpoch in map["whenUpdated"]){
      whenUpdated.add(new DateTime.fromMillisecondsSinceEpoch(updateTimesInMillisecondsSinceEpoch));
    }
    wasFinishedAheadOfPlan  = map["wasFinishedAheadOfPlan"];
  }
}
