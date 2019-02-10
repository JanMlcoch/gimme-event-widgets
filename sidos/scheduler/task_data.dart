part of sidos.scheduler;

class TaskData {
  int userId;
  int eventId;
  List<int> eventIds;
  List<int> tags;
  bool testBool;
  bool isDetailedInfo;
  SidosSocketEnvelope innerEnvelope;
  List<GPS> pointsOfOrigin;
  int numberOfEventDesired;
  ///int EUR
  double baseCost;
  GPS place;
  ///in milliseconds
  int visitLength;

  Map toFullMap() {
    Map json = {};

    json["userId"] = userId;
    json["eventId"] = eventId;
    json["eventIds"] = eventIds;
    json["tags"] = tags;
    json['testBool'] = testBool;
//    if(innerEnvelope != null){
//      json['innerEnvelope'] = innerEnvelope.toFullPurgedMap();
//    }
    json['innerEnvelope'] = innerEnvelope?.toFullPurgedMap();
    json['pointsOfOrigin'] = [];
    if(pointsOfOrigin !=null){
      for(GPS point in pointsOfOrigin){
        json['pointsOfOrigin'].add(point.toFullMap());
      }
    }
    json['baseCost'] = baseCost;
    json['place'] = place?.toFullMap();
    json['visitLength'] = visitLength;
    json['isDetailedInfo'] = isDetailedInfo;
    json['numberOfEventDesired'] = numberOfEventDesired;

    return json;
  }

  void fromMap(Map map) {
    userId = map["userId"];
    eventId = map["eventId"];
    eventIds = (map["eventIds"] as List<int>);
    tags = (map["tags"] as List<int>);
    testBool = map["testBool"];
//    if(map['innerEnvelope'] != null){
//      innerEnvelope = new SidosSocketEnvelope()..fromMap(map['innerEnvelope']);
//    }
    if (map['innerEnvelope'] != null) {
      innerEnvelope = new SidosSocketEnvelope()..fromMap(map['innerEnvelope']);
    }
    if(map['pointsOfOrigin']!=null){
      for(Map pointMap in map["pointsOfOrigin"]){
        pointsOfOrigin = [];
        pointsOfOrigin.add(new GPS.fromJsonMap(pointMap));
      }
    }
    baseCost = map['baseCost'];
    place = map['place'] == null ? null : (new GPS.fromJsonMap(map['place']));
    visitLength = map['visitLength'];
    isDetailedInfo = map['isDetailedInfo'];
    numberOfEventDesired = map['numberOfEventDesired'];
  }

  @deprecated
  void mergeDataIntoThis(TaskData data) {
    if (eventIds != null) {
      if (data.eventIds != null) {
        eventIds.addAll(data.eventIds);
      }
    } else {
      eventIds = data.eventIds;
    }

    if (tags != null) {
      if (data.tags != null) {
        tags.addAll(data.tags);
      }
    } else {
      tags = data.tags;
    }
  }
}
