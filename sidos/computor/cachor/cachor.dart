//library sidos.computor.cachor;
part of sidos.computor;

//import '../../sidos_entities/library.dart';

///this part will be (at least partially) replaced by database.
class Cachor {
  static Cachor _instance;

  static Cachor get instance {
    if (_instance == null) {
      _instance = new Cachor();
    }
    return _instance;
  }

  static const int validityOfFailingToFindEntityInMilliseconds = 300000;

  Map<int, Imprint> eventImprints = {};
  Map<int, UserPattern> userPatterns = {};
  Map<int, List<GPS>> userPointsOfOrigin = {};
  Map<int, Map<int, FitIndex>> userEventFitIndices = {};
  Map<int, List<int>> attends = {};
  Map<int, Map<int, ImprintPoint>> tagRelations = {};

  //todo: test
  bool shouldAskForPattern(int userId) {
    if (userPatterns[userId] == null) return true;
    bool patternNotRecentlyFound = userPatterns[userId] is PatternNotFound;
    if (patternNotRecentlyFound) {
      DateTime lastRequested = (userPatterns[userId] as PatternNotFound).lastRequested;
      Duration requestAge = lastRequested.difference(new DateTime.now());
      Duration validity = new Duration(milliseconds: validityOfFailingToFindEntityInMilliseconds);
      patternNotRecentlyFound = requestAge.compareTo(validity) > 0;
    }
    return patternNotRecentlyFound;
  }

  //todo: test
  bool shouldAskForImprint(int eventId) {
//    print("is null: ${eventImprints[eventId] == null}");
    if (eventImprints[eventId] == null) return true;
    bool imprintNotRecentlyNotFound = eventImprints[eventId] is ImprintNotFound;
//    print("is imprintNotFound: $imprintNotRecentlyNotFound");
    if (imprintNotRecentlyNotFound) {
      DateTime lastRequested = (eventImprints[eventId] as ImprintNotFound).lastRequested;
      Duration requestAge = lastRequested.difference(new DateTime.now());
      Duration validity = new Duration(milliseconds: validityOfFailingToFindEntityInMilliseconds);
//      print("Request age: $requestAge");
//      print("Validity: $validity");
//      print("IS really imprint not found for a long time?: ${requestAge.compareTo(validity) > 0}");
      imprintNotRecentlyNotFound = requestAge.compareTo(validity) > 0;
    }
//    print("is imprint Not recently not found Found: $imprintNotRecentlyNotFound");
    return imprintNotRecentlyNotFound;
  }

  //todo: test
  bool shouldAskForFitIndex(int userId, int eventId) {
    if (userEventFitIndices[userId] == null) return true;
    if (userEventFitIndices[userId][eventId] == null) return true;
    bool fitIndexRecentlyNotFound = userEventFitIndices[userId][eventId] is FitIndexNotFound;
    if (fitIndexRecentlyNotFound) {
      DateTime lastRequested = (userEventFitIndices[userId][eventId] as FitIndexNotFound).lastRequested;
      Duration requestAge = lastRequested.difference(new DateTime.now());
      Duration validity = new Duration(milliseconds: validityOfFailingToFindEntityInMilliseconds);
      fitIndexRecentlyNotFound = requestAge.compareTo(validity) > 0;
    }
    return fitIndexRecentlyNotFound;
  }

  void addFitIndex(int userId, int eventId, FitIndex fitIndex) {
    if (userEventFitIndices[userId] == null) {
      userEventFitIndices[userId] = {};
    }
    userEventFitIndices[userId][eventId] = fitIndex;
  }

  void addFitIndexValue(int userId, int eventId, double fitIndexValue) {
    addFitIndex(userId, eventId, new FitIndex(fitIndexValue));
  }

  static void wipe() {
    _instance = new Cachor();
  }

  Map toFullMap() {
    Map json = {};

    json['eventImprints'] = {};
    eventImprints.forEach((eventId, imprint) {
      if (imprint != null) {
        json['eventImprints'].addAll({eventId.toString(): imprint.toFullMap()});
      }
    });

    json['userPatterns'] = {};
    userPatterns.forEach((userId, userPattern) {
      json['userPatterns'].addAll({userId.toString(): userPattern?.toFullMap()});
    });

    json['userPointsOfOrigin'] = {};
    userPointsOfOrigin.forEach((int userId, List<GPS> pointsOfOrigin) {
      json['userPointsOfOrigin'][userId.toString()] = [];
      if (pointsOfOrigin != null) {
        for (GPS pointOfOrigin in pointsOfOrigin) {
          json['userPointsOfOrigin'][userId.toString()].add(pointOfOrigin?.toFullMap());
        }
      }
    });

    json['userEventFitIndices'] = {};
    userEventFitIndices.forEach((int userId, Map<int, FitIndex> eventFitIndices) {
      Map<int, double> eventFitIndicesJson = {};
      eventFitIndices.forEach((eventId, FitIndex fitIndex) {
        eventId = eventId?.round();
        eventFitIndicesJson.addAll({eventId: fitIndex?.value});
      });
      json['userEventFitIndices'].addAll({userId.toString(): eventFitIndicesJson});
    });

    json['attends'] = {};
    attends.forEach((userId, eventIds) {
      json['attends'].addAll({userId.toString(): eventIds});
    });

    return json;
  }

  Map purgeMap(Map map) {
    Map toReturn = {};

    map.forEach((key, val) {
      dynamic purgedVal = purgeDynamic(val);
      if (purgedVal != null && key is String && key != "null" && purgedVal != "null") {
        toReturn.addAll({key: purgedVal});
      }
    });

    return toReturn;
  }

  List purgeList(List list) {
    List toReturn = [];

    for (dynamic b in list) {
      toReturn.add(purgeDynamic(b));
    }

    return toReturn;
  }

  Map toPurgedMap() {
    return purgeMap(toFullMap());
  }

  dynamic purgeDynamic(dynamic a) {
    bool valIsBool = a is bool;
    bool valIsString = a is String;
    bool valIsNum = a is num;
    if (valIsNum) {
      String valIsString = a.toString();
      bool endsRight = valIsString.endsWith("0") ||
          valIsString.endsWith("0") ||
          valIsString.endsWith("1") ||
          valIsString.endsWith("2") ||
          valIsString.endsWith("3") ||
          valIsString.endsWith("4") ||
          valIsString.endsWith("5") ||
          valIsString.endsWith("6") ||
          valIsString.endsWith("7") ||
          valIsString.endsWith("8") ||
          valIsString.endsWith("9");
      valIsNum = endsRight;
    }
    if (a is Map) {
      return purgeMap(a);
    }
    if (a is Iterable) {
      return purgeList(a);
    }
    if (valIsNum || valIsString || valIsBool) {
      return a;
    }
    return null;
  }

  void fromMap(Map json) {
    eventImprints = {};
    Map eventImprintsJson = json["eventImprints"];
    eventImprintsJson.forEach((String eventIdString, Map imprintJson) {
      int eventId = int.parse(eventIdString, onError: (_) {
        return null;
      });
      eventImprints.addAll({eventId: new Imprint()..fromMap(imprintJson)});
    });

    userPatterns = {};
    Map userPatternsJson = json["userPatterns"];
    userPatternsJson.forEach((String userIdString, Map patternJson) {
      int userId = int.parse(userIdString, onError: (_) {
        return null;
      });
      userPatterns.addAll({userId: (patternJson == null ? null : (new UserPattern()..fromMap(patternJson)))});
    });

    userPointsOfOrigin = {};
    Map userPointsOfOriginJson = json["userPointsOfOrigin"];
    userPointsOfOriginJson.forEach((String key, List<Map> val) {
      List<GPS> pointsOfOrigin = [];
      for (Map map in val) {
        pointsOfOrigin.add(map == null ? null : new GPS.fromJsonMap(map));
      }
      int intKey = int.parse(key, onError: (_) {
        return null;
      });
      userPointsOfOrigin[intKey] = pointsOfOrigin;
    });

    userEventFitIndices = {};
    json["userEventFitIndices"].forEach((String userIdString, Map eventFitIndicesJson) {
      Map<int, FitIndex> eventFitIndices = {};
      eventFitIndicesJson.forEach((String eventIdString, double fitIndexValue) {
        if (eventIdString != null && eventIdString != "null") {
          int eventIdInt = int.parse(eventIdString, onError: (String source) {
            print(source);
            //todo: maybe implement assert
            throw ":_(";
//            return 0;
          });
          //todo: review this
          eventFitIndices.addAll({eventIdInt: new FitIndex(fitIndexValue)});
        }
      });
      int userId = int.parse(userIdString, onError: (string) {
        return null;
      });
      userEventFitIndices.addAll({userId: eventFitIndices});
    });

    attends = {};
    json["attends"].forEach((String userIdString, List<int> attendedEventIds) {
      int userId = int.parse(userIdString, onError: (_) {
        return null;
      });
      attends.addAll({userId: attendedEventIds});
    });
  }

  @deprecated
  bool isJson(dynamic a) {
    print("---->");
    bool isReallyJson = true;
    if (a is Map) {
//      print("Argument is Map");
      a.forEach((key, val) {
        isReallyJson = isReallyJson && key is String && isJson(val);
        if (!(key is String && isJson(val))) {
          print("Key is : $key");
          print("and is it String? : ${key is String}");
          print("Value is $val");
          isJson(val);
        }
      });
    } else {
      if (a is List) {
//        print("Argument is List");
        for (dynamic b in a) {
          isReallyJson = isReallyJson && isJson(b);
        }
      } else {
        if (a == null || a is String || a is num || a is bool) {
          isReallyJson = true;
//          print("argument is primitive - jsonable");
        } else {
          print("argument is some bullshit");
          isReallyJson = false;
        }
      }
    }
    return isReallyJson;
  }
}
