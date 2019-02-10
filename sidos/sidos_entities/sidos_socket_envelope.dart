part of sidos.entities;

///Instance of [SidosSocketEnvelope] is data transfer object.
class SidosSocketEnvelope {
  static const String TYPE_TEST = "test";
  static const String TYPE_TEST_WITH_ADDITIONAL_INFO = "testWIthAdditionalInfo";
  static const String TYPE_UPDATE_IMPRINT = "updateImprint";
  static const String TYPE_UPDATE_IMPRINT_INFO = "updateImprintInfo";
  static const String TYPE_UPDATE_PATTERN = "updatePattern";
  static const String TYPE_ATTEND = "attend";
  static const String TYPE_SORT_EVENTS_FOR_USER = "sortEventsForUser";
  static const String TYPE_HARD_LOG = "createHardLog";
  static const String TYPE_HARD_COPY = "createHardCopy";
  static const String TYPE_LOAD_HARD_COPY = "loadHardCopy";
  static const String TYPE_ADDITIONAL_INFO_REQUEST_EVENT_TAGS = "addiEventTags";
  static const String TYPE_ADDITIONAL_INFO_REQUEST_INFO_EVENT = "addiEvent";
  static const String TYPE_ADDITIONAL_INFO_REQUEST_USER_POINTS_OF_ORIGIN = "addiUserPointsOfOrigin";
  static const String TYPE_ADDITIONAL_INFO_REQUEST_ADDITIONAL_EVENT_TAGS = "addiMoreEventTags";

  int akcnikId;
  int sidosId;
  String type;
  bool isFinalResponse = false;
  bool success = true;
  bool isRequestForAdditionalInfo = false;
  bool isRequestForEventTags = false;
//optional attributes
  int userId;
  UserPattern pattern;
  Map<int, UserPattern> patterns;
  int eventId;
  List<int> tags;
  Imprint imprint;
  Map<int, Imprint> imprints;
  SidosUser user;
  List<SidosUser> users;
  SidosEvent event;
  List<SidosEvent> events;
  List<int> eventIds;
  String message;
  bool testBool;
  bool isRequestForEventInfo = false;
  List<String> missingEventInfo;
  bool isRequestForPointsOfOrigin = false;
  bool isDetailedInfo;
  int numberOfEventsDesired;

  ///in EUR
  double baseCost;
  GPS place;

  ///in milliseconds
  int visitLength;
  List<GPS> pointsOfOrigin;

  void fromMap(Map json) {
    if (json['pointsOfOrigin'] != null) {
      pointsOfOrigin = [];
      for (Map pointOfOriginJson in json['pointsOfOrigin']) {
        pointsOfOrigin.add(pointOfOriginJson == null ? null : new GPS.fromJsonMap(pointOfOriginJson));
      }
    }
    akcnikId = json['akcnikId'];
    sidosId = json['sidosId'];
    type = json["type"];
    isFinalResponse = json['isFinalResponse'];
    success = json['success'];
    isRequestForAdditionalInfo = json['isRequestForAdditionalInfo'];
    isRequestForEventTags = json['isRequestForEventTags'];
    isRequestForEventInfo = json['isRequestForEventInfo'];
    isRequestForPointsOfOrigin = json['isRequestForPointsOfOrigin'];
    missingEventInfo = (json['missingEventInfo'] as List<String>);
    baseCost = json['baseCost'];
    place = json['place'] == null ? null : (new GPS.fromJsonMap(json['place']));
    visitLength = json['visitLength'];

//optional attributes
    userId = json['userId'];

    if (json['pattern'] != null) {
      pattern = new UserPattern()..fromMap(json['pattern']);
    }

    if (json['patterns'] != null) {
      patterns = {};
      json['patterns'].forEach((int key, Map patternJson) {
        patterns.addAll({key: new UserPattern()..fromMap(patternJson)});
      });
    }

    eventId = json['eventId'];
    tags = (json['tags'] as List<int>);

    if (json['imprint'] != null) {
      imprint = new Imprint()..fromMap(json['imprint']);
    }

    if (json['imprints'] != null) {
      imprints = {};
      json['imprints'].forEach((int key, Map imprintJson) {
        imprints.addAll({key: new Imprint()..fromMap(imprintJson)});
      });
    }

    if (json['user'] != null) {
      user = new SidosUser()..fromMap(json['user']);
    }

    if (json['users'] != null) {
      users = [];
      json['users'].forEach((Map userJson) {
        users.add(new SidosUser()..fromMap(userJson));
      });
    }

    if (json['event'] != null) {
      event = new SidosEvent()..fromMap(json['event']);
    }

    if (json['events'] != null) {
      events = [];
      json['events'].forEach((Map eventJson) {
        events.add(new SidosEvent()..fromMap(eventJson));
      });
    }

//    if (json['eventIds'] != null) {
    eventIds = (json['eventIds'] as List<int>);
//      for(int i = 0; i<json['eventIds'].length; i++){
//        eventIds.add(json['eventIds'][i]);
//      }
//      for (int eventId in json['eventIds']) {
//        eventIds.add(eventId);
//      }
//    }

    message = json['message'];

    testBool = json['testBool'];
    isDetailedInfo = json['isDetailedInfo'];
    numberOfEventsDesired = json['numberOfEventsDesired'];
  }

  Map<String, dynamic> toFullMap() {
    Map<String, dynamic> json = {};

    if (pointsOfOrigin != null) {
      json['pointsOfOrigin'] = [];
      for (GPS pointOfOrigin in pointsOfOrigin) {
        json['pointsOfOrigin'].add(pointOfOrigin?.toFullMap());
      }
    }

    json['akcnikId'] = akcnikId;
    json['sidosId'] = sidosId;
    json['type'] = type;
    json['isFinalResponse'] = isFinalResponse;
    json['success'] = success;
    json['isRequestForAdditionalInfo'] = isRequestForAdditionalInfo;
    json['isRequestForEventTags'] = isRequestForEventTags;
    json['isRequestForEventInfo'] = isRequestForEventInfo;
    json['isRequestForPointsOfOrigin'] = isRequestForPointsOfOrigin;
    json['missingEventInfo'] = missingEventInfo;
    json['baseCost'] = baseCost;
    json['place'] = place?.toFullMap();
    json['visitLength'] = visitLength;

    json['userId'] = userId;
    json['pattern'] = pattern == null ? null : pattern.toFullMap();
    if (patterns != null) {
      patterns.forEach((int key, UserPattern patternValue) {
        json['patterns'].addAll({key: patternValue.toFullMap()});
      });
    }
    json['eventId'] = eventId;
    json['tags'] = tags;
    json['imprint'] = imprint == null ? null : imprint.toFullMap();
    if (imprints != null) {
      imprints.forEach((int key, Imprint imprintValue) {
        json['imprints'].addAll({key: imprintValue.toFullMap()});
      });
    }
    json['user'] = user == null ? null : user.toFullMap();
    if (users != null) {
      json['users'] = [];
      for (SidosUser userValue in users) {
        json['users'].add(userValue.toFullMap());
      }
    }
    json['event'] = event == null ? null : event.toFullMap();
    if (events != null) {
      json['events'] = [];
      for (SidosEvent eventValue in events) {
        json['events'].add(eventValue.toFullMap());
      }
    }
    json['eventIds'] = eventIds;
    json['message'] = message;
    json['testBool'] = testBool;
    json['isDetailedInfo'] = isDetailedInfo;
    json['numberOfEventsDesired'] = numberOfEventsDesired;

    return json;
  }

  Map<String, dynamic> purgeMap(Map map) {
    Map<String, dynamic> mapCopy = (JSON.decode(JSON.encode(map)) as Map<String, dynamic>);
    map.forEach((String key, dynamic value) {
      if (value == null) {
        mapCopy.remove(key);
      }
    });
    return mapCopy;
  }

  Map<String, dynamic> toFullPurgedMap() {
    Map map = toFullMap();
    return purgeMap(map);
  }

  bool validate() {
    return true;
//    if (type == null) {
//      type = "null";
//    }
//    switch (type) {
//      case TYPE_TEST:
//        return message != null;
//      case TYPE_TEST_WITH_ADDITIONAL_INFO:
//        return testBool != null;
//      case TYPE_HARD_COPY:
//        return true;
//      case TYPE_HARD_LOG:
//        return true;
//      case TYPE_LOAD_HARD_COPY:
//        return true;
//      case TYPE_SORT_EVENTS_FOR_USER:
//        bool isValid = true;
//        if (userId == null) {
//          isValid = false;
//        }
//        if (eventIds == null) {
//          isValid = false;
//        }
//        return isValid;
//      case TYPE_UPDATE_IMPRINT:
//        return (eventId != null && tags != null);
//      case TYPE_UPDATE_PATTERN:
//        return userId != null;
//      case TYPE_ATTEND:
//        return (eventId != null && userId != null);
//      case "null":
//        print("Tested SidosSocketEnvelope without type, NOT VALID");
//        return false;
//      default:
//        print("Tested SidosSocketEnvelope with unknown type $type, NOT VALID");
//        return false;
//    }
  }

  SidosSocketEnvelope();

  SidosSocketEnvelope.testEnvelope({String message: "No message sent from client"}) {
    type = TYPE_TEST;
    this.message = message;
  }

  SidosSocketEnvelope.updateImprintEnvelope(int eventId, List<int> tags,
      {double baseCost: null,
      GPS place: null,
      int visitLength: null,
      bool isDetailedInfo: false,
      String message: "No message sent from client"}) {
    type = TYPE_UPDATE_IMPRINT;
    this.eventId = eventId;
    this.tags = tags;
    this.baseCost = baseCost;
    this.place = place;
    this.visitLength = visitLength;
    this.message = message;
    this.isDetailedInfo = isDetailedInfo;
  }

  SidosSocketEnvelope.updatePatternEnvelope(int userId,
      {List<GPS> pointsOfOrigin: const [], bool isDetailedInfo: false, String message: "No message sent from client"}) {
    type = TYPE_UPDATE_PATTERN;
    this.userId = userId;
    this.pointsOfOrigin = pointsOfOrigin;
    this.isDetailedInfo = isDetailedInfo;
    this.message = message;
  }

  SidosSocketEnvelope.attendEnvelope(int userId, int eventId, {String message: "No message sent from client"}) {
    type = TYPE_ATTEND;
    this.userId = userId;
    this.eventId = eventId;
    this.message = message;
  }

  SidosSocketEnvelope.sortEventsForUser(int userId, List<int> eventIds,
      {int numberOfEventsDesired: 35, GPS localPointOfOrigin: null, String message: "No message sent from client"}) {
    type = TYPE_SORT_EVENTS_FOR_USER;
    this.numberOfEventsDesired = numberOfEventsDesired;
    this.userId = userId;
    this.eventIds = eventIds;
    this.message = message;
    this.pointsOfOrigin = [localPointOfOrigin];
  }

  SidosSocketEnvelope.createHardLog({String message: "No message sent from client"}) {
    type = TYPE_HARD_LOG;
    this.message = message;
  }

  SidosSocketEnvelope.createHardCache({String message: "No message sent from client"}) {
    type = TYPE_HARD_COPY;
    this.message = message;
  }

  SidosSocketEnvelope.loadHardCache({String message: "No message sent from client"}) {
    type = TYPE_LOAD_HARD_COPY;
    this.message = message;
  }

  SidosSocketEnvelope.requestAdditionalInfoEventTags(int eventIdx, {String message: "No message sent"}) {
    type = TYPE_ADDITIONAL_INFO_REQUEST_EVENT_TAGS;
    this.message = message;
    isRequestForAdditionalInfo = true;
    isRequestForEventTags = true;
    eventId = eventIdx;
  }

  SidosSocketEnvelope.requestSpecificAdditionalInfoEvent(int eventIdx, List<String> missingEventInfox,
      {String message: "No message sent"}) {
    type = TYPE_ADDITIONAL_INFO_REQUEST_INFO_EVENT;
    this.message = message;
    isRequestForAdditionalInfo = true;
    isRequestForEventInfo = true;
    missingEventInfo = missingEventInfox;
    eventId = eventIdx;
  }

  SidosSocketEnvelope.requestUserPointsOfOriginAdditionalInfo(int userId, {String message: "No message sent"}) {
    type = TYPE_ADDITIONAL_INFO_REQUEST_USER_POINTS_OF_ORIGIN;
    this.message = message;
    isRequestForAdditionalInfo = true;
    isRequestForPointsOfOrigin = true;
    this.userId = userId;
  }

  SidosSocketEnvelope.additionalEventTags(int eventIdx, List<int> eventTags,
      {String message: "No message sent from client"}) {
    type = TYPE_ADDITIONAL_INFO_REQUEST_ADDITIONAL_EVENT_TAGS;
    this.message = message;
    isRequestForAdditionalInfo = true;
    isRequestForEventTags = true;
    eventId = eventIdx;
    tags = eventTags;
  }
}
