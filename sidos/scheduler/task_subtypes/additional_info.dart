part of sidos.scheduler;

class AdditionalEventTagsTask extends Task{
  int eventId;
  List<int> eventTags;

  @override
  bool validate() {
    return true;
  }

  @override
  bool equals(o) {
    bool toReturn = o is AdditionalEventTagsTask;
    if(toReturn){
      //todo: discuss when relevant
      toReturn = (o as AdditionalEventTagsTask).eventId == eventId;
    }
    return false;
  }

  @override
  Map toFullMap() {
    Map map = super.toFullMap();

    map["eventId"] = eventId;
    map["eventTags"] = eventTags;

    return map;
  }

  @override
  void fromMap(Map map) {
    super.fromMap(map);
    eventId = map["eventId"];
    eventTags = (map["eventTags"] as List<int>);
  }
}

abstract class IncomingAdditionalInfoTask extends Task {
  static Task fromEnvelope(SidosSocketEnvelope envelope, Socket socket) {
    if (envelope.isRequestForEventTags) {
      AdditionalEventTagsTask task = new AdditionalEventTagsTask()
        ..returnData = {
          socket: [envelope]
        }
        ..sendResponseAfterProcessing = false
        ..eventId = envelope.eventId
        ..eventTags = envelope.tags;
      return task;
    }
    return new Task()
      ..returnData = {
        socket: [envelope]
      };
  }
}