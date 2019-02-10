part of sidos.entities;
///Data class, instance is representing state of a tag in some entity, in bi-Gaussian approximation
class ImprintPoint {
  double value;
  ///[valueVariance] is not variance, but denominator in exponent of gaussian
  double valueVariance;
  double zeroVariance;
  double probability;

  ImprintPoint();

  ImprintPoint.withData(this.value, this.probability, this.valueVariance, this.zeroVariance);

  ///method for combining [ImprintPoints]
  static ImprintPoint sum(List<ImprintPoint> imprintPoints, {List<double> weights: const[]}) {
    if(weights == null){
      weights = [];
    }
    ImprintPoint returnImprintPoint = new ImprintPoint();

    double sumProbVal = 0.0;
    double sumProbVal2 = 0.0;
    double sumProb = 0.0;
    double sumProb2var = 0.0;
    double sum0var2Qrob = 0.0;
    num count = 0;
//    int count = imprintPoints.length;

    for (int i = 0;i < imprintPoints.length;i++) {
      ImprintPoint point = imprintPoints[i];
//      while(i>=weights.length){
//        weights.add(1.0);
//      }
      double weight = i>=weights.length ? 1.0 : weights[i] == null ? 1.0 : weights[i];
      sumProb += point.probability*weight;
      sumProbVal += point.probability * point.value * weight;
      sumProbVal2 += point.probability * point.value * point.value * weight;
      double qrob = (1.0-point.probability);
      sumProb2var += point.probability*point.probability*point.valueVariance*weight*weight;
      sum0var2Qrob += qrob*qrob*point.zeroVariance*weight*weight;
      count += weight;
    }

    returnImprintPoint.value = sumProbVal/sumProb;
    returnImprintPoint.probability = sumProb/count;
    returnImprintPoint.valueVariance = sumProb2var/(sumProb*sumProb)+returnImprintPoint.value*returnImprintPoint.value-sumProbVal2/sumProb;
    double sumQrob = count-sumProb;
    returnImprintPoint.zeroVariance = sum0var2Qrob/(sumQrob*sumQrob);

    return returnImprintPoint;
  }

  void fromMap(Map json) {
    value = json["value"];
    valueVariance = json["valueVariance"];
    zeroVariance = json["zeroVariance"];
    probability = json["_probability"];
  }

  Map toFullMap() {
    return {
      "value": value,
      "valueVariance": valueVariance,
      "zeroVariance": zeroVariance,
      "_probability": probability
    };
  }
}