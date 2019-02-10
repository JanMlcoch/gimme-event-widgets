part of sidos.computor;

class Fittor {
  //sets relevances to tagFits ordered by severity
  static const List<double> WEIGHTS_OF_INFLUENCES = const [1.0, 0.9, 0.7, 0.4, 0.2, 0.1];
  static Fittor _instance;

  static Fittor get instance {
    if (_instance == null) {
      _instance = new Fittor();
      _instance.init();
    }
    return _instance;
  }

  UserPattern _defaultPattern;
  Imprint _defaultImprint;

  void init() {
    List<UserPattern> allPatterns = [];
    Cachor.instance.userPatterns.forEach((_, UserPattern pattern) {
      allPatterns.add(pattern);
    });
    _defaultPattern = _createDefaultPattern(allPatterns);
    List<Imprint> allImprints = [];
    Cachor.instance.eventImprints.forEach((_, Imprint imprint) {
      allImprints.add(imprint);
    });
    _defaultImprint = _createDefaultImprint(allImprints);
  }

  ///Returns a [FitIndex] representing probable affinity of [pattern] to [imprint]
  FitIndex fitIndex(UserPattern pattern, Imprint imprint) {
    double contentIndex = _contentFitIndex(pattern, imprint);
    double expanseIndex = pattern == null ? 0.5 : _expanseIndex(pattern, imprint);
    double val = _harmonize(contentIndex, expanseIndex);
    return new FitIndex(val);
  }

  ///Returns [double] representing resentment of [pattern] to [imprint] resulting
  ///from expenses such as cost and distance with regard to length of visit
  double _expanseIndex(UserPattern pattern, Imprint imprint) {
    double distance = GPS.smallestDistance(imprint.place, pattern.pointsOfOrigin);
    if(distance == null){ distance = 4.0;}
    int visitLength = imprint.visitLength == null ? 0 : imprint.visitLength;
    //todo: unhotfix
    double expensiveness = ((imprint.baseCost == null ? 0.5 : imprint.baseCost) + EUR_PER_KILOMETER * distance) /
        (math.pow(visitLength + MILLISECONDS_PER_KILOMETER * distance, 0.85)); //todo: units of visitlength

    double expensivenessInfluence = math.pow(expensiveness, 2) * pattern.moneyConservation;
    if(pattern.travelReluctance == null){
      throw "${pattern is PatternNotFound}";
    }
    double distanceInfluence = math.pow(distance, 2) * pattern.travelReluctance;
    double lengthInfluence =
        math.pow(visitLength + MILLISECONDS_PER_KILOMETER * distance, 2) * pattern.timeConservation;

    double exponent = expensivenessInfluence + distanceInfluence + lengthInfluence;

    //todo: implement
    return math.exp(exponent);
  }

  ///Returns a [double] representing probable affinity
  ///of [pattern] to [imprint]'s content (tags), with no regards to expenses
  double _contentFitIndex(UserPattern pattern, Imprint imprint) {
    UserPattern effectivePattern = _createEffectivePattern(pattern);
    Map<int, double> tagFits = {};
    Map<int, double> defaultTagFits = {};
    _defaultImprint.points.forEach((tag, imprintPoint) {
      //todo: handle null better
      if (imprint.points[tag] == null) {
        //probably shouldn't throw on null
        throw new StateError("imprint.points[$tag]");
//        imprint.points[tag] = new ImprintPoint();
      }
      tagFits.addAll({tag: _tagFitIndex(effectivePattern.points[tag], imprint.points[tag])});
      defaultTagFits.addAll({tag: _tagFitIndex(effectivePattern.points[tag], imprintPoint)});
    });
    //todo: ??extraordinarrity??
    List<double> influences = [];
    tagFits.forEach((int tag, double prob) {
      double defaultProb = defaultTagFits[tag];
      influences.add(_harmonize(prob, defaultProb));
    });
    //todo: test this
    influences.sort((double a, double b) {
      return (a * a).compareTo(b * b);
    });
    double fitIndex = 0.0;
    int i = 0;
    while (i < WEIGHTS_OF_INFLUENCES.length && i < influences.length) {
      fitIndex += WEIGHTS_OF_INFLUENCES[i] * influences[i];
      i++;
    }
    return fitIndex;
  }

  //todo: discuss
  ///Harmonizes probability of match [prob] regarding match to average imprint - [defaultProb]
  double _harmonize(double prob, double defaultProb) {
    double harmonizedProbability = _harmonizeProbability(prob, defaultProb);
    harmonizedProbability = (harmonizedProbability - 0.5) * math.PI;
    return math.sin(harmonizedProbability);
  }

  double _harmonizeProbability(double prob, double defaultProb) {
    double k = -math.log(2) / math.log(defaultProb);

//    double b = (-defaultProb * defaultProb + 2 * defaultProb - 0.25) / (2 * defaultProb - 1);
//    double a = 1 - b;
//    double c2 = a * a + b * b;
//    double harmonizedProb = b + math.sqrt(c2 + (prob - a) * (prob - a));

    double harmonizedProb = math.pow(prob, k);
    return harmonizedProb;
  }

  //todo:discuss this
  ///Returns probability of match of two [ImprintPoints]
  double _tagFitIndex(ImprintPoint patternPoint, ImprintPoint imprintPoint) {
    Gaussian patternGauss = new Gaussian(patternPoint.value, patternPoint.valueVariance, 1.0)
      .._normalize(norm: patternPoint.probability);
    Gaussian patternZeroGauss = new Gaussian(0.0, patternPoint.zeroVariance, 1.0)
      .._normalize(norm: 1 - patternPoint.probability);
    Gaussian imprintGauss = new Gaussian(imprintPoint.value, imprintPoint.valueVariance, 1.0)
      .._normalize(norm: imprintPoint.probability);
    Gaussian imprintZeroGauss = new Gaussian(0.0, imprintPoint.zeroVariance, 1.0)
      .._normalize(norm: 1 - imprintPoint.probability);

    double coincidence = 0.0;
    //todo: weight for nonzero coincidences
    coincidence += Gaussian._coincidence(patternGauss, imprintGauss);
    coincidence += Gaussian._coincidence(patternGauss, imprintZeroGauss);
    coincidence += Gaussian._coincidence(patternZeroGauss, imprintGauss);
    coincidence += Gaussian._coincidence(patternZeroGauss, imprintZeroGauss);
    return coincidence;
  }

  //todo: OPTIMIZE, discuss weights
  UserPattern _createEffectivePattern(UserPattern pattern) {
    if(pattern!= null){

    List<UserPattern> listToSum = [pattern, _defaultPattern];
    List<double> weights = [pattern.eventCount, 3.0];
    return UserPattern.sum(listToSum, weights: weights);
    }
    else{
      return UserPattern.sum([_defaultPattern]);
    }
  }

  UserPattern _createDefaultPattern(List<UserPattern> allPatterns) {
    //todo: weights by users/events
    if (allPatterns.isEmpty) {
      //this eventuality is valid only for development purposes, IRL this should be considered an error
      return UserPattern.sum([]);
    } else {
      UserPattern defaultPattern = UserPattern.sum(allPatterns);
      return defaultPattern;
    }
  }

  Imprint _createDefaultImprint(List<Imprint> allImprints) {
    //todo: weights by users/events
    if (allImprints.isEmpty) {
      //this eventuality is valid only for development purposes, IRL this should be considered an error
      return new Imprint();
    } else {
      Imprint defaultImprint = new Imprint();
      defaultImprint = Imprint.sum(allImprints);
      return defaultImprint;
    }
  }
}
