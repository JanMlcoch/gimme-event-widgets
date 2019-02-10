part of sidos.entities;

///instance of [UserPattern] is minimal abstraction of user for [sidos] prime function
class UserPattern {
  Map<int, ImprintPoint> points = {};
  double eventCount;
  List<GPS> pointsOfOrigin = [];
  //todo: unhotfix
  double get moneyConservation => _moneyConservation == null ? 1.0 : _moneyConservation;
  set moneyConservation(double val){
    _moneyConservation = val;
  }
  double _moneyConservation;
  double timeConservation;
  double travelReluctance;

  UserPattern();

  ///method for combining [UserPattern]s - mainly for the purpose of [Fittor]'s [Fittor._defaultPattern]
  ///
  /// If weights are not specified (or are specified with wrong [List.length]), for the purpose of expense
  /// parameters ([moneyConservation], [travelReluctance], [timeConservation]), the [eventCount] is used as [weights].
  /// Same goes for the case, where [isSumEventCountWeights] is given as true and wring weights are specified.
  ///
  /// If [isSumEventCountWeights] is given as true, the resulting [UserPattern.eventCount] will be
  /// the sum of weights (with the exception described above). Otherwise, it will be the sum of [UserPattern.eventCount]
  /// of [UserPattern]s in [patterns].
  ///
  static UserPattern sum(List<UserPattern> patterns, {List<double> weights: null, bool isSumEventCountWeights: false}) {
    UserPattern toReturn = new UserPattern();
    patterns = patterns.toList();
    patterns.removeWhere((UserPattern pattern) => pattern is PatternNotFound);

    double newEventCount = 0.0;
    Map<int, List<ImprintPoint>> setsOfPoints = {};
    for (UserPattern pattern in patterns) {
      pattern.points.forEach((int tag, ImprintPoint point) {
        setsOfPoints[tag] = _addPointToSetOfPoints(setsOfPoints[tag], point);
      });
    }

    setsOfPoints.forEach((int tag, List<ImprintPoint> setOfPoints) {
      toReturn.points[tag] = ImprintPoint.sum(setOfPoints, weights: weights);
    });

    List<num> weightsCopy = weights?.toList();
    if(weightsCopy?.length != patterns.length){
      weightsCopy = [];
      for(UserPattern pattern in patterns){
        weightsCopy.add(pattern.eventCount == null ? 0.0 : pattern.eventCount);
      }
    }

    double weightedSumMoney = 0.0;
    double weightedSumTime = 0.0;
    double weightedSumTravel = 0.0;
    double weightsCopySum = 0.0;

    for(int i = 0;i<patterns.length;i++){
      UserPattern pattern = patterns[i];
      double weight = weightsCopy[i];
      weight = weight == null ? 0.0 : weight;
      newEventCount += isSumEventCountWeights ? weight : pattern.eventCount == null ? 0.0 : pattern.eventCount;
      weightsCopySum += weight;
//      print("${pattern.toFullMap()}");
      weightedSumMoney += weight*pattern.moneyConservation;
      //todo: check hotfixes
      weightedSumTime += weight*(pattern.timeConservation == null ? 0.0 : pattern.timeConservation);
      weightedSumTravel += weight*(pattern.travelReluctance == null ? 0.0 : pattern.travelReluctance);
    }

    toReturn.moneyConservation  = weightsCopySum!=0 ? weightedSumMoney  /weightsCopySum : 0.0;
    toReturn.timeConservation   = weightsCopySum!=0 ? weightedSumTime   /weightsCopySum : 0.0;
    toReturn.travelReluctance   = weightsCopySum!=0 ? weightedSumTravel /weightsCopySum : 0.0;

    toReturn.eventCount = newEventCount;

    return toReturn;
  }

  static List<ImprintPoint> _addPointToSetOfPoints(List<ImprintPoint> setOfPoints, ImprintPoint point) {
    if (setOfPoints == null) {
      setOfPoints = [point];
    } else {
      setOfPoints.add(point);
    }

    return setOfPoints;
  }

  void fromMap(Map json) {
    Map pointsJson = json["points"];
    pointsJson.forEach((String key, Map point) {
      points.addAll({int.parse(key): new ImprintPoint()..fromMap(point)});
    });
    for (Map gpsJson in json["pointsOfOrigin"]) {
      pointsOfOrigin.add(new GPS.fromJsonMap(gpsJson));
    }
    moneyConservation = json['moneyConservation'];
    timeConservation = json['timeConservation'];
    travelReluctance = json['travelReluctance'];
    eventCount = json['eventCount'];
  }

  Map toFullMap() {
    Map json = {};
    json["points"] = {};
    points.forEach((int key, ImprintPoint point) {
      json["points"][key.toString()] = point.toFullMap();
    });
    json["pointsOfOrigin"] = [];
    for (GPS point in pointsOfOrigin) {
      json["pointsOfOrigin"].add(point.toFullMap());
    }
    json['moneyConservation'] = moneyConservation;
    json['timeConservation'] = timeConservation;
    json['travelReluctance'] = travelReluctance;
    json['eventCount'] = eventCount;

    return json;
  }
}
