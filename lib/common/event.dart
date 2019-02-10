part of common;

abstract class EventBase implements Jsonable {
  static const String DONT_HAVE_AVATAR = "noImage";
  int id;
  String name;
  DateTime from;
  DateTime to;
  double mapLatitude;
  double mapLongitude;
  int insertedById;
  int placeId;
  String language = "en";
  String description = "";
  String annotation = "";
  String webpage;
  Map socialNetworks = {};
  double representativePrice;
  bool private = false;
  double averageRating;
  int parentEventId;
  int profileQuality = 0;
  bool get haveAvatar => !clientSettings.containsKey(DONT_HAVE_AVATAR);
  void set haveAvatar(bool val) {
    // no significant effect, just close multiple attempts to get image
    clientSettings[DONT_HAVE_AVATAR] = !val;
  }

  String get fbLink => socialNetworks["fbLink"];

  void set fbLink(String value) {
    socialNetworks["fbLink"] = value;
  }

  Map clientSettings = {};

  void fromMap(Map map) {
    name = map["name"];
    if (map["id"] != null) {
      id = map["id"];
    }
    if (map["from"] is DateTime) {
      from = map["from"];
    } else if (map["from"] is int) {
      from = new DateTime.fromMillisecondsSinceEpoch(map["from"]);
    } else {
      from = new DateTime.now();
    }
    if (map["to"] == null) {
      to = from;
    } else if (map["to"] is DateTime) {
      to = map["to"];
    } else if (map["to"] is int) {
      to = new DateTime.fromMillisecondsSinceEpoch(map["to"]);
    } else {
      to = new DateTime.now();
    }
    if (map["socialNetworks"] != null) {
      socialNetworks = map["socialNetworks"];
    }
    mapLatitude = map["mapLatitude"];
    mapLongitude = map["mapLongitude"];
    placeId = map["placeId"];
    language = map["language"];
    description = map["description"];
    if (map["annotation"] != null) annotation = map["annotation"];
    representativePrice = map["representativePrice"];
    private = map["private"];
    profileQuality = map["profileQuality"];
    parentEventId = map["parentEventId"];
    insertedById = map["insertedById"];
    dynamic cs = map["clientSettings"];
    if (cs != null) {
      if (cs is Map) {
        clientSettings = cs;
      }
      if (cs is String && cs != "") {
        try {
          clientSettings = JSON.decode(cs);
        } catch (e) {
          print("clientSettings not converted $cs");
        }
      }
    }
    dynamic guestRateRaw = map["guestRate"];
    if (guestRateRaw is int) {
      averageRating = guestRateRaw.toDouble();
    }
    if (guestRateRaw is double) {
      averageRating = guestRateRaw;
    }
    webpage = map["webpage"];
  }

  Map toCreateMap() {
    Map out = {};
    out["name"] = name;
    out["from"] = from == null ? null : from.millisecondsSinceEpoch;
    out["to"] = to == null ? null : to.millisecondsSinceEpoch;
    out["placeId"] = placeId;
    out["language"] = language;
    out["annotation"] = annotation;
    out["description"] = description;
    out["socialNetworks"] = socialNetworks == null ? null : socialNetworks;
    out["private"] = private;
    out["parentEventId"] = parentEventId;
    out["clientSettings"] = clientSettings;
    return out;
  }

  Map<String, dynamic> toFullMap() {
    Map<String, dynamic> out = toSafeMap();
    return out;
  }

  Map<String, dynamic> toSafeMap() {
    Map<String, dynamic> out = {};
    if (id != null) {
      out["id"] = id;
    }
    out["mapLatitude"] = mapLatitude;
    out["mapLongitude"] = mapLongitude;
    out["placeId"] = placeId;
    out["name"] = name;
    out["from"] = from == null ? null : from.millisecondsSinceEpoch;
    out["to"] = to == null ? null : to.millisecondsSinceEpoch;
    out["insertedById"] = insertedById;
    out["language"] = language;
    out["description"] = description;
    out["annotation"] = annotation;
    out["representativePrice"] = representativePrice;
    out["private"] = private;
    out["profileQuality"] = profileQuality;
    out["parentEventId"] = parentEventId;
    out["clientSettings"] = clientSettings;
    out["webpage"] = webpage;
    out["socialNetworks"] = socialNetworks == null ? null : socialNetworks;
    // TODO: remove after repaired
    if(averageRating==null){
      out["guestRate"] = null;
    }else{
      out["guestRate"] = averageRating.isNaN?0:averageRating;
    }
    return out;
  }
}
