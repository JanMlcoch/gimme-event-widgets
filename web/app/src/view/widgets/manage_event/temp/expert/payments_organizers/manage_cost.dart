part of view;

class ManageCostWidget extends Widget {
  ClientCost modelCost;
  ManageCostsWidget parent;
  List<String> currencies;
  String currency;

  NumberInputElement priceEl;
  SelectElement currencyEl;
  SelectElement flagEl;
  CheckboxInputElement priorityEl;
  TextAreaElement descriptionEl;
  ButtonInputElement moreEl;
  ButtonInputElement lessEl;
  ButtonInputElement destroyEl;

  StreamSubscription onPriceInput;
  StreamSubscription onCurrencySelection;
  StreamSubscription onFlagSelection;
  StreamSubscription onPriorityCheck;
  StreamSubscription onMore;
  StreamSubscription onLess;
  StreamSubscription onDescriptionInput;
  StreamSubscription onDestroy;

  ManageCostWidget(this.modelCost, this.parent, [this.currencies = null]) {
    template = parse(resources.templates.addEvent.paymentsOrganizers.cost);
    if (currencies == null) {
      currencies = CURRENCIES.toList();
    }
    currency = modelCost.currency;
    //if you will not let destroy be last in the list, onRemove will f*ck shit up
    modelCost.onCostRemoved.add(parent.requestRepaint);
    modelCost.onCostRemoved.add(destroy);
  }

  @override
  void destroy() {
    modelCost.onCostRemoved.remove(parent.requestRepaint);
    modelCost.onCostRemoved.remove(destroy);

    _unsubscribe();

    parent.children.remove(this);
  }

  @override
  Map out() {
    //see adequate template

    Map out = {};
    out["lang"] = lang.manageEvent.paymentsAndOrganizersLangs.toMap();
    out["price"] = modelCost.price;
    List<Map<String, dynamic>> currenciesForOut = [];
    for (String cur in currencies) {
      Map<String, dynamic> curForOut = {};
      curForOut["currency"] = cur;
      curForOut["selected"] = cur == currency;
      currenciesForOut.add(curForOut);
    }
    out["currencies"] = currenciesForOut;

    List<Map<String, dynamic>> flagsForOut = [];
    for (int flag in CostFlags.EVENT_FLAGS_VALUES) {
      Map<String, dynamic> flagForOut = {};
      flagForOut["flag"] = flag;
      flagForOut["flagName"] = CostFlags.EVENT_FLAGS_NAMES_EN.toList()[flag-1];
      flagForOut["selected"] = flag == modelCost.flag;
      flagsForOut.add(flagForOut);
    }
    out["flags"] = flagsForOut;

    out["priority"] = false;
    out["priorityConflict"] = modelCost.hasPriorityConflict();
    if (out["priorityConflict"]) {
      out["priority"] = modelCost.hasCurrencyPriority();
    }

    out["extended"] = modelCost.isDisplayedWithDetails;
    out["notExtended"] = !out["extended"];
    out["description"] = modelCost.description;

    out["hasColorClass"] = false;
    List<String> conflictedCurrencies = modelCost.parent.currenciesWithIndistinctRepresentativePrice();
    conflictedCurrencies.sort();
    print(conflictedCurrencies);
    if(conflictedCurrencies.length>1&&conflictedCurrencies.length<11){
      if(out["priorityConflict"]){
        out["hasColorClass"] = true;
        out["colorClass"] = "appManagePriceBorderColor${conflictedCurrencies.indexOf(currency)}";
      }
    }

    return out;
  }

  @override
  void setChildrenTargets() {
    // TODO: implement setChildrenTargets
  }

  @override
  void functionality() {
    _unsubscribe();
    priceEl = target.querySelector(".appPrice");
    currencyEl = target.querySelector(".appCurrency");
    flagEl = target.querySelector(".appFlag");
    if (modelCost.hasPriorityConflict()) {
      priorityEl = target.querySelector(".appPriority");
    }
    if (modelCost.isDisplayedWithDetails) {
      descriptionEl = target.querySelector(".appDescription");
      lessEl = target.querySelector(".appLess");
    } else {
      moreEl = target.querySelector(".appMore");
    }
    destroyEl = target.querySelector(".appDestroy");

    //starts binding
    onPriceInput = priceEl.onInput.listen((Event e) {
      modelCost.price = num.parse(priceEl.value, (String source) {
        //todo: errors and validation
        return modelCost.price;
      });
    });

    onCurrencySelection = currencyEl.onInput.listen((Event e) {
      modelCost.currency = currencyEl.value;
      parent.repaintRequested=true;

    });

    onFlagSelection = flagEl.onInput.listen((Event e) {
      modelCost.flag = int.parse(flagEl.value);
      parent.repaintRequested = true;
    });

    if (modelCost.hasPriorityConflict()) {
      onPriorityCheck = priorityEl.onClick.listen((Event e) {
        if (priorityEl.checked) {
          modelCost.setPriority();
          parent.repaintRequested = true;
        }
        else{
          repaintRequested = true;
        }
      });
    }

    if (modelCost.isDisplayedWithDetails) {
      onDescriptionInput = descriptionEl.onInput.listen((Event e) {
        modelCost.description = descriptionEl.value;
      });
      onLess = lessEl.onClick.listen((Event e) {
        modelCost.isDisplayedWithDetails = false;
        repaintRequested = true;
      });
    } else {
//      onMore = moreEl.onClick.listen((Event e) {
//        modelCost.isDisplayedWithDetails = true;
//        repaintRequested = true;
//      });
    }

//    onDestroy = destroyEl.onClick.listen((Event e) {
//      destroy();
//      parent.repaintRequested = true;
//      modelCost.onCostRemoved.forEach((Function f) {
//        f();
//      });
//    });

    // TODO: error handling + validation (frontEnd)
  }

  void _unsubscribe(){
    if(onPriceInput!=null){onPriceInput.cancel();}
    if(onCurrencySelection!=null){onCurrencySelection.cancel();}
    if(onFlagSelection!=null){onFlagSelection.cancel();}
    if(onPriorityCheck!=null){onPriorityCheck.cancel();}
    if(onMore!=null){onMore.cancel();}
    if(onLess!=null){onLess.cancel();}
    if(onDescriptionInput!=null){onDescriptionInput.cancel();}
    if(onDestroy!=null){onDestroy.cancel();}
  }
}
