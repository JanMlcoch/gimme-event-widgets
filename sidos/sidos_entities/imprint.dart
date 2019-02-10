part of sidos.entities;

///instance of [Imprint] class represent minimal abstraction of Event with regards to sidos prime function.
class Imprint {
  ///set f data regarding tags
  Map<int, ImprintPoint> points = {};

  ///in EUR
  double baseCost;
  GPS place;// = new GPS();
  //in milliseconds
  num visitLength;

  Imprint();

  ///method for combining Imprints (for [Patternificator] and [Fittor]'s default [Imprint] purposes
  static Imprint sum(List<Imprint> imprints, {List<double> weights: null}) {
    Imprint toReturn = new Imprint();
    toReturn.points = {};

    Map<int, List<ImprintPoint>> setsOfPoints = _createSetsOfPoints(imprints);

    setsOfPoints.forEach((int tag, List<ImprintPoint> setOfPoints) {
      toReturn.points[tag] = ImprintPoint.sum(setOfPoints, weights: weights);
    });

    return toReturn;
  }

  static Map<int, List<ImprintPoint>> _createSetsOfPoints(List<Imprint> imprints) {
    Map<int, List<ImprintPoint>> setsOfPoints = {};
    for (Imprint imprint in imprints) {
//      print(imprint == null);
      setsOfPoints = _addImprintToSetsOfPoints(imprint, setsOfPoints);
    }
    return setsOfPoints;
  }

  static Map<int, List<ImprintPoint>> _addImprintToSetsOfPoints(
      Imprint imprint, Map<int, List<ImprintPoint>> setsOfPoints) {
    imprint.points.forEach((int tag, ImprintPoint point) {
      if (setsOfPoints[tag] == null) {
        setsOfPoints[tag] = [point];
      } else {
        setsOfPoints[tag].add(point);
      }
    });
    return setsOfPoints;
  }

  void fromMap(Map json) {
    points = {};
    Map protoList = json["points"];
    protoList.forEach((String keyString, Map value) {
      points.addAll({int.parse(keyString): new ImprintPoint()..fromMap(value)});
    });
    baseCost = json['baseCost'];
    visitLength = json['visitLength'];
    place = json['place'] == null ? null : new GPS.fromJsonMap(json['place']);
  }

  Map toFullMap() {
    Map json = {};
    json["points"] = {};
    points.forEach((int key, ImprintPoint value) {
      json["points"].addAll({key.toString(): value.toFullMap()});
    });
    json['baseCost'] = baseCost;
    json['visitLength'] = visitLength;
    json['place'] = place?.toFullMap();
    return json;
  }
}