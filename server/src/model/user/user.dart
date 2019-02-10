part of model;

class User extends UserBase {
  bool proven = false;
  String role = "none";
  Map serverSettings = {};
  Tags preferenceTags = new Tags();
  String imprintCache = "";
  String levelCache = "0";
  String _currency = "EUR";
  String authenticationToken = "";
  void set currency(String val) {
    _currency = val;
    _exchangeRateToEur = CurrencyRater.getInstance().getExchangeRate(_currency, "EUR");
  }

  String get currency => _currency;
  double _exchangeRateToEur = 1.0;
  double get exchangeRateToEur => _exchangeRateToEur;

  User() : super();

  void fromMap(Map<String, dynamic> json) {
    super.fromMap(json);
    proven = json["proven"];
    role = json["role"];
    if (json.containsKey("serverSettings") && json["serverSettings"] != null) {
      serverSettings = json["serverSettings"];
    }
    imprintCache = json["imprintCache"];
    levelCache = json["levelCache"];
    _currency = json["currency"];
    _exchangeRateToEur = json["exchangeRateToEur"];
    authenticationToken = json["authenticationToken"];
//    if(json.containsKey("preferenceTags")){
//      preferenceTags..clear()..addAll(json["preferenceTags"]);
//    }
    if (json.containsKey("preferenceTags")) {
      dynamic tagList = json["preferenceTags"];
      if (tagList is List<Map<String, dynamic>>) {
        preferenceTags.addAll(tagList.map((Map<String, dynamic> tagMap) =>
        new Tag()
          ..fromMap(tagMap)));
      }
    }
    if (json.containsKey("preferenceTagIds") && json["preferenceTagIds"] is List) {
      dynamic tagIdList = json["preferenceTagIds"];
      if (tagIdList is List<int>) preferenceTags = storage.storage.memory.tags.loadByIds(tagIdList);
    }
  }

//  void fromEditJson(Map json){
//    for(String key in ["login", "id", "password", "logged", "email"]){
//      if(json.containsKey(key)){
////        json.remove(key);
//        json[key] = toJson()[key];
//      }
//    }
//    super.fromJson(json);
//  }

  Map<String, dynamic> toFullMap() {
    Map<String, dynamic> out = super.toFullMap();
    out["proven"] = proven;
    out["role"] = role;
    out["permissions"] = permissions;
    out["serverSettings"] = serverSettings;
    out["imprintCache"] = imprintCache;
    out["levelCache"] = levelCache;
    out["currency"] = _currency;
    out["exchangeRateToEur"] = _exchangeRateToEur;
    out["authenticationToken"] = authenticationToken;
    out["preferenceTags"] = preferenceTags.toFullList();
    return out;
  }

  Map<String, dynamic> toSafeMap() {
    Map<String, dynamic> out = super.toSafeMap();
    out["proven"] = proven;
    out["role"] = role;
    out["permissions"] = permissions;
    out["levelCache"] = levelCache;
    out["currency"] = _currency;
    out["exchangeRateToEur"] = _exchangeRateToEur;
    out["preferenceTags"] = preferenceTags.toListList();
    return out;
  }

  static String encryptPassword(String plain) {
    return new db_crypt.DBCrypt().hashpw(plain, new db_crypt.DBCrypt().gensalt());
  }

  bool havePermission(String permission) {
    return permissions[permission] != null && permissions[permission] != "none";
  }
}
