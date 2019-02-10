part of model;

//IF in doubts about priorities, check server class Costs's method [getRepresentativePriceInEur]
class ClientCost extends CostBase {
  bool isDisplayedWithDetails = false;
  ClientCosts parent;
  List<Function> onCostRemoved = [];
  List<String> hasInvalidWhat = [];

  ClientCost() : super();

  ClientCost.fromData(num priceArg, String currencyArg,
      [String descriptionArg, int flagArg])
      : super.fromData(priceArg, currencyArg, descriptionArg, flagArg){
    if (currency == null) {
      currency = model.user.currency;
    }
    if (currency == null) {
      currency = "EUR";
    }
  }

  void removeFromParentList() {
    //first we need to adjust [parent.permutationToDisplayList]
    int indexOrder = parent.list.indexOf(this);
    int indexOrderForDisplay = parent.permutationToDisplayList.indexOf(indexOrder);
    for (int i = indexOrderForDisplay; i < parent.permutationToDisplayList.length - 1; i++) {
      parent.permutationToDisplayList[i] = parent.permutationToDisplayList[i + 1];
    }
    parent.permutationToDisplayList.removeLast();
    for (int i = 0; i < parent.permutationToDisplayList.length; i++) {
      if (parent.permutationToDisplayList[i] > indexOrder) {
        parent.permutationToDisplayList[i]--;
      }
    }
    //and finally removes [this] from [parent.list]
    parent.list.remove(this);
  }

  ///sets priority of this [ClientCost] in [parent] over other [ClientCost]s with same [currency] and [flag]
  void setPriority() {
    //we save the original state of list
    List<ClientCost> cache = parent.list.toList();

    //we make sure the display order will not change
    int indexOrder = parent.list.indexOf(this);
    int indexOrderForDisplay = parent.permutationToDisplayList.indexOf(indexOrder);
    List<int> displayOrdersOfMovedCosts = [];
    for (int i = 0; i < indexOrder; i++) {
      displayOrdersOfMovedCosts.add(parent.permutationToDisplayList.indexOf(i));
    }
    parent.permutationToDisplayList[indexOrderForDisplay] = 0;
    for (int i in displayOrdersOfMovedCosts) {
      parent.permutationToDisplayList[i]++;
    }

    //and we place [this] on the first place in list
    cache.remove(this);
    parent.list = [this];
    parent.list.addAll(cache);
  }

  ///works only in cases, where [hasPriorityConflict] would return true
  bool hasCurrencyPriority() {
    bool priority = true;

    int order = parent.list.indexOf(this);
    if (order != 0) {
      for (int i = 0; i < order; i++) {
        if (parent.list[i].currency == currency) {
          if (_hasHigherPriority(parent.list[i].flag, flag, parent.flagPriority)) {
            priority = false;
            break;
          }
        }
      }
    }
    return priority;
  }

  ///return [true] if cost with [flag1] has higher priority. Supposes that cost with flag1 has lower order that cost with flag2
  bool _hasHigherPriority(int flag1, int flag2, List<int> priorityFlags) {
    bool higherPriority;
    if (!priorityFlags.contains(flag2)) {
      higherPriority = true;
    }
    else {
      if (!priorityFlags.contains(flag1)) {
        higherPriority = false;
      }
      else {
        if (priorityFlags.indexOf(flag1) > priorityFlags.indexOf(flag2)) {
          higherPriority = false;
        }
        else {
          higherPriority = true;
        }
      }
    }
    return higherPriority;
  }

  ///returns answer to question whether the representativness of this cost for its currency depends on order of costs in list
  bool hasPriorityConflict() {
    bool conflict = false;
    int highestPriorityFlag = parent.highestPriorityFlag();
    if (highestPriorityFlag == null || highestPriorityFlag == flag) {
      if (parent.currenciesWithIndistinctRepresentativePrice().contains(currency)) {
        conflict = true;
      }
    }
    return conflict;
  }
}


class ClientCosts extends CostsBase {
  List<int> flagPriority;
  List<ClientCost> list = [];

  ///costs sometimes need to be displayed in different order from order in [list]. First will be displayed [list]"["[permutationToDisplayList.first]"]"
  List<int> permutationToDisplayList = [];

  ClientCosts({this.flagPriority: CostFlags.flagPriorityList});

  @override
  void fromList(List json) {
    list.clear();
    for (Map cost in json) {
      list.add(new ClientCost()
        ..fromMap(cost));
    }
  }

  @override
  List<Map> toList() {
    List<Map> out = [];
    for (ClientCost cost in list) {
      out.add(cost.toMap());
    }
    return out;
  }


  ///returns [List] of currencies, for which adequate [Costs.getRepresentativePrice] would return value depending on order of [Cost] in [Costs.list].
  List<String> currenciesWithIndistinctRepresentativePrice() {
    List<String> indistinctCurrencies = [];
    //list of Costs, which could be representatives for some currencies
    List<ClientCost> potentialRepresentatives = [];
    bool foundRepresentatives = false;
    if (list.isEmpty) {
      foundRepresentatives = true;
    }
    int i = 0;
    //finds correct set of [potentialRepresentatives]
    while (!foundRepresentatives) {
      potentialRepresentatives = [];
      if (i < flagPriority.length) {
        potentialRepresentatives = list.where((ClientCost cost) => (cost.flag == flagPriority[i])).toList();
      }
      else {
        potentialRepresentatives = list.toList();
      }
      if (potentialRepresentatives.isNotEmpty || list.isEmpty) {
        foundRepresentatives = true;
      }
      i++;
    }
    //gets [indistinctCurrencies]
    for (int i = 0; i < potentialRepresentatives.length - 1; i++) {
      CostBase cost1 = potentialRepresentatives[i];
      if (indistinctCurrencies.contains(cost1.currency)) {
        continue;
      }
      for (int j = i + 1; j < potentialRepresentatives.length; j++) {
        CostBase cost2 = potentialRepresentatives[j];
        if (cost1.currency == cost2.currency) {
          indistinctCurrencies.add(cost1.currency);
          break;
        }
      }
    }
    return indistinctCurrencies;
  }

  ///returns [null] if no preferred flag is present
  int highestPriorityFlag() {
    int toReturn;

    List<int> usedFlags = [];
    for (ClientCost cost in list) {
      if (!usedFlags.contains(cost.flag)) {
        usedFlags.add(cost.flag);
      }
    }

    for (int i = 0; i < flagPriority.length; i++) {
      if (usedFlags.contains(flagPriority[i])) {
        toReturn = flagPriority[i];
        break;
      }
    }

    print(toReturn);
    return toReturn;
  }

  void addCost(String currency, {int flag}) {
    ClientCost newCost = new ClientCost.fromData(0, currency);
    newCost.parent = this;
    newCost.onCostRemoved.add(newCost.removeFromParentList);
    int costFlag = flag == null ? flagPriority.first : flag;
    newCost.flag = costFlag;
    permutationToDisplayList.add(list.length);
    list.add(newCost);
  }

  bool isValid() {
    bool isValid = true;
    for (ClientCost cost in list) {
      if (cost.hasInvalidWhat.isNotEmpty) {
        isValid = false;
        break;
      }
    }
    return isValid;
  }

  ClientCost costFactory() {
    return new ClientCost();
  }

  void destroy() {
  }
}