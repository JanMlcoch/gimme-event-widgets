part of akcnik.tests.sidos.prime;


typedef bool MatchesFunction(item, Map matchState);
typedef Description DescribeFunction(Description description);
typedef Description DescribeMismatchFunction(item, Description mismatchDescription, Map matchState, bool verbose);

class MatchAndComplete extends Matcher{
  MatchesFunction matchesFunction;
  DescribeFunction describeFunction;
  DescribeMismatchFunction describeMismatchFunction;
  Completer completer;

  MatchAndComplete(this.completer, Matcher matcher){
    matchesFunction = matcher.matches;
    describeFunction = matcher.describe;
    describeMismatchFunction = matcher.describeMismatch;
  }

  @override
  bool matches(item, Map matchState){
    completer.complete();
    return matchesFunction(item, matchState);
  }

  @override
  Description describe(Description description){
    return describeFunction(description);
  }

  @override
  Description describeMismatch(item, Description mismatchDescription, Map matchState, bool verbose){
    return describeMismatchFunction(item, mismatchDescription,matchState, verbose);
  }
}

MatchAndComplete equalsAndComplete(expected, Completer completer, [int limit = 100]){
  return new MatchAndComplete(completer, equals(expected,limit));
}
