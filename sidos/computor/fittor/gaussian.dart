part of sidos.computor;

///[Gaussian] class is a representation of normal distribution.
///
///Keep in mind, that statistical parameters, such as mean value or variance have nice form only while taking into
///a count ALL values of distribution from minus infinity to infinity), while we will be mostly interested in
///interval <0,1>, thus actual values of variances and mean values can be different. Names of parameters vaguely
///correspondents with names of statistical parameters.
///
/// The distribution in mind is:
/// h(x) = coefficient*exp(-(x-value)^2/variance)
class Gaussian {
  ///stationary point of gaussian
  //todo: is null needed?
  double value = 0.5;

  ///this is in fact denominator of exponent
  //todo: is null needed?
  double variance = 1.0;

  ///factor (to exponential)
  //todo: is null needed?
  double coefficient = 1.0;

  Gaussian(this.value, this.variance, this.coefficient);

  ///Returns probability that value of random variables given by
  ///two [Gaussian] distribution will be close
  static double _coincidence(Gaussian gauss1, Gaussian gauss2) {
    double sumVar = gauss1.variance + gauss2.variance;
    double valueDiff = gauss1.value - gauss2.value;
    double coef = gauss1.coefficient * gauss2.coefficient;
    coef *= math.exp(valueDiff * valueDiff * sumVar);
    double val = gauss2.variance * gauss1.value + gauss1.variance * gauss2.value;
    val /= sumVar;
    double vari = gauss1.variance * gauss2.variance;
    vari /= sumVar;
    Gaussian probDensity = new Gaussian(val, vari, coef);
    return probDensity._probability();
  }


  ///Returns integral of [Gaussian] over the <0,1> interval.
  ///
  /// This value correspondents with probability of phenomenon occurring
  double _probability() {
    double std = math.sqrt(variance);
    double a = _errorFunction((1 - value) / std) + _errorFunction(value / std);
    a *= coefficient * 0.5 * math.sqrt(math.PI);
    return a;
  }

  ///Normalizes Gaussian in way, that its integral over the <0,1> interval is [norm]
  void _normalize({double norm: 1.0}) {
    coefficient = coefficient * norm / _probability();
  }

  ///Approximation of Error function
  double _errorFunction(double x) {
    //todo: optimize
    //todo: rough approximation
    double a1 = 0.278393;
    double a2 = 0.230389;
    double a3 = 0.000972;
    double a4 = 0.078108;
    double x2 = x * x;
    double x3 = x2 * x;
    double x4 = x3 * x;
    double px = 1 / (1 + a1 * x + a2 * x2 + a3 * x3 + x4 * a4);
    double px2 = px * px;
    double px4 = px2 * px2;
    return px4;
  }
}
