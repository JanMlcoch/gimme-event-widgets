part of sidos.computor;

///The [Patternificator] class is responsible for creating [UserPattern]s for users.
class Patternificator {
  static Patternificator _instance;

  static Patternificator get instance {
    if (_instance == null) {
      _instance = new Patternificator();
    }
    return _instance;
  }

  //todo: weights, by type, time, distance, price, age of event ...
  ///Creates a [UserPattern] from [Imprint]s of attended events, places of users origin, ...
  UserPattern createUserPatternFromImprints(List<Imprint> eventImprints,
      {List<double> weights: null, List<GPS> pointsOfOrigin: const []}) {
    Imprint averageImprint = Imprint.sum(eventImprints, weights: weights);
    if (weights == null) {
      weights = [0.0];
    }
    if (weights.length == 0) {
      weights = [0.0];
    }
    double totalWeight = weights.reduce((a, b) => a + b);
//    print("Number of attended events is ${eventImprints.length} and weights are $weights");
//    print("Imprint (json is ${averageImprint.toJson()}");
    const String MONEY = "moneyCoeff";
    const String TIME = "timeCoeff";
    const String DISTANCE = "DISTANCE";
    int n = 0;
    Map<String, double> expensesSquares = {MONEY: 0.0, TIME: 0.0, DISTANCE: 0.0};
    if (pointsOfOrigin?.isNotEmpty != true) {
      //todo: clustering
      //todo: congruence check
      double totalLatitude = 0.0;
      double totalLongitude = 0.0;
      int eventCount = 0;
      for (Imprint imprint in eventImprints) {
        //todo: unhotfix
        if (imprint.place != null) {
          totalLatitude += imprint.place.latitude;
          totalLongitude += imprint.place.longitude;
          eventCount++;
        }
      }
      double latitude = totalLatitude / eventCount;
      double longitude = totalLongitude / eventCount;
      pointsOfOrigin = [];
      pointsOfOrigin.add(new GPS.withValues(latitude, longitude));
    }
    for (Imprint imprint in eventImprints) {
      double distance;
      //todo: hotfix
      if (imprint.place == null) {
        distance = 0.0;
      } else {
        distance = GPS.smallestDistance(imprint.place, pointsOfOrigin);
      }
      double length = (imprint.visitLength == null ? 0.0 : imprint.visitLength) + MILLISECONDS_PER_KILOMETER * distance;
      double money =
          ((imprint.baseCost == null ? 0.0 : imprint.baseCost) + EUR_PER_KILOMETER * distance) / math.pow(length, 0.85);
      expensesSquares[DISTANCE] += (distance * distance);
      expensesSquares[TIME] += (length * length);
      expensesSquares[MONEY] += (money * money);
      n++;
    }
//    ("Money conservation is : ${n == 0 ? 0.0 : expensesSquares[MONEY]/n}");
    UserPattern pattern = new UserPattern()
      ..eventCount = totalWeight
      ..points = averageImprint.points
      ..pointsOfOrigin = pointsOfOrigin
      ..moneyConservation = n == 0 ? 0.0 : expensesSquares[MONEY] / n
      ..timeConservation = n == 0 ? 0.0 : expensesSquares[TIME] / n
      ..travelReluctance = n == 0 ? 0.0 : expensesSquares[DISTANCE] / n;
    if(pattern.moneyConservation.toString() == double.NAN.toString())pattern.moneyConservation = 0.0;
    return pattern;
  }
}
