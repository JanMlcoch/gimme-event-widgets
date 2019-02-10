part of model;

class Cost extends CostBase {
  Costs costs;
  Cost() : super();
  Cost.fromData(num priceArg, String currencyArg, [String descriptionArg, int flagArg])
      : super.fromData(priceArg, currencyArg, descriptionArg, flagArg);
}

class Costs extends CostsBase {
  List<Cost> list = [];
  Map<int, int> flagPriority;
  Map<String, int> currencyPriority;

  Costs({List<int> flagPriorityList: CostFlags.flagPriorityList, List<String> userPreferredCurrencies: const []}) {
    flagPriority = {};
    int index = 0;
    for (int flag in flagPriorityList) {
      flagPriority[flag] = index++;
    }
    List<String> currencyPriorityList = userPreferredCurrencies.toList()..addAll(CostFlags.currencyPriorityList);
    currencyPriority = {};
    index = 0;
    for (String currency in currencyPriorityList) {
      currencyPriority[currency] = index++;
    }
  }

  ///gets asynchronously representative price in EUR
  double getRepresentativePrice() {
    //if there aro no price, representative is zero
    //if there are prices, we are always capable of finding a representative
    if (list.isEmpty) {
      return 0.0;
    }
    //first priority has flag types in following order - the rest of them doesn't matter (have the same priority)
    //firstly, we check for flags in given order
    int bestPriority = 10000;
    int flagLength = flagPriority.length;
    for (CostBase cost in list) {
      int priority = flagPriority[cost.flag];
      if (priority == null) priority = flagLength;
      if (bestPriority > priority) {
        bestPriority = priority;
      }
    }
    Cost winner;
    int winnerCurrencyPriority;
    for (CostBase cost in list) {
      if (bestPriority != flagLength && bestPriority != flagPriority[cost.flag]) continue;
      if (winner == null) {
        winner = cost;
        winnerCurrencyPriority = currencyPriority[winner.currency];
        if (winnerCurrencyPriority == null) winnerCurrencyPriority = currencyPriority.length;
        continue;
      }
      int costPriority = currencyPriority[cost.currency];
      if (costPriority != null && winnerCurrencyPriority > costPriority) {
        winner = cost;
      }
    }
    if (winner.currency == CurrencyRater.MAIN_CURRENCY) return winner.price;
    return CurrencyRater.getInstance().getUnitedPrice(winner);
  }

  @override
  void fromList(List<Map<String, dynamic>> json) {
    list.clear();
    for (Map cost in json) {
      list.add(new Cost()
        ..fromMap(cost)
        ..costs = this);
    }
  }

  @override
  List<Map> toList() {
    List<Map> out = [];
    for (Cost cost in list) {
      out.add(cost.toMap());
    }
    return out;
  }
}
