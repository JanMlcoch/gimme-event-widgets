part of common;

abstract class CostBase {
  num price = 0.0;
  String currency;
  int _flag;

  int get flag => _flag;

  void set flag(int newFlag) {
    if (!CostFlags.EVENT_FLAGS_VALUES.contains(newFlag)) {
      _flag = CostFlags.OTHER;
      //print("Attempted to enter unauthorized flag value, changed to >>other<<");
    } else {
      _flag = newFlag;
    }
  }

  String description = "";
  CostBase();
  CostBase.fromData(num priceArg, this.currency, [String descriptionArg, int flagArg]) {
    price = priceArg.toDouble();
    if (descriptionArg != null) description = descriptionArg;
    if (flagArg != null) flag = flagArg;
  }

  Map toMap() {
    Map out = {};
    out["price"] = price;
    out["currency"] = currency;
    out["flag"] = _flag;
    out["description"] = description;
    return out;
  }

  Map toViewMap() {
    Map out = {};
    out["costFlagId"] = _flag;
    out["price"] = price;
    out["currency"] = currency;
    out["flag"] = CostFlags.EVENT_FLAGS_NAMES_EN[_flag];
    out["description"] = description;
    return out;
  }

  void fromMap(Map map) {
    price = (map["price"] as num).toDouble();
    currency = map["currency"];
    description = map["description"];
    flag = map["flag"];
  }
}

abstract class CostsBase {
  void fromList(List<Map<String, dynamic>> json);
  List<Map> toList();
}
