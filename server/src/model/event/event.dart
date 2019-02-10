part of model;

class Event extends EventBase {
  String imprintCache = "";
  Map serverSettings = {};
  DateTime insertionTime;
  Tags tags = new Tags();
  Costs costs;
  List<PlaceInEvent> places = [];
  List<OrganizerInEvent> organizers = [];
  int ownerId;
  int relevantRating;

  Event() {
    costs = new Costs();
  }

  Map<String, dynamic> toFullMap() {
    Map<String, dynamic> out = toEventDetailMap();
    out["clientSettings"] = clientSettings;
    out["insertedById"] = insertedById;
    out["serverSettings"] = serverSettings;
    if (insertionTime != null) {
      out["insertionTime"] = insertionTime.millisecondsSinceEpoch;
    }
    if (insertedById != null) {
      out["insertedById"] = insertedById;
    }
    out["imprintCache"] = imprintCache;

    List<Map> placesOut = [];
    for (PlaceInEvent place in places) {
      placesOut.add(place.toFullMap());
    }
    out["places"] = placesOut;
    out["tags"] = tags.toFullList();
    out["relevantRating"] = relevantRating;
    return out;
  }

  @override
  void fromMap(Map map) {
    super.fromMap(map);
    dynamic costList = map["costs"];
    if (costList is List<Map<String, dynamic>>) {
      costs.fromList(costList);
    }
    imprintCache = map["imprintCache"];
    if (map["serverSettings"] != null) {
      serverSettings = map["serverSettings"];
    }
    if (map["insertionTime"] != null) {
      if (map["insertionTime"] is DateTime) {
        insertionTime = map["insertionTime"];
      } else if (map["insertionTime"] is int) {
        insertionTime = new DateTime.fromMillisecondsSinceEpoch(map["insertionTime"]);
      } else {
        insertionTime = DateTime.parse(map["insertionTime"]);
      }
    }
    if (map["representativePrice"] == null) {
      representativePrice = costs.getRepresentativePrice();
    }

    if (map.containsKey("places")) {
      places.clear();
      for (Map place in map["places"]) {
        places.add(new PlaceInEvent()
          ..fromMap(place)
          ..event = this);
      }
    }

    if (map.containsKey("organizers")) {
      organizers.clear();
      for (Map organizer in map["organizers"]) {
        organizers.add(new OrganizerInEvent()
          ..fromMap(organizer)
          ..event = this);
      }
    }
//    if (map.containsKey("tags") && map["tags"] is List) {
//      oldTags.clear();
//      tags.clear();
//      List tagsJson = map["tags"];
//      if(tagsJson.length > 0){
//        if(tagsJson.first is String){
//          oldTags.addAll(map["tags"]);
//        }else if(tagsJson.first is Map){
//          tags.addAll(map["tags"].map((Map<String, dynamic> tagMap) => new Tag()..fromMap(tagMap)));
//        }
//      }
//
//    }
    if (map.containsKey("tags")) {
      dynamic tagList = map["tags"];
      if (tagList is List<Map<String, dynamic>>) {
        tags.addAll(tagList.map((Map<String, dynamic> tagMap) =>
        new Tag()
          ..fromMap(tagMap)));
      }
    }
    if (map.containsKey("tagIds")) {
      dynamic tagIdList = map["tagIds"];
      if (tagIdList is List<int>) tags = storage.storage.memory.tags.loadByIds(tagIdList);
    }
    ownerId = map["ownerId"];
    relevantRating = map["relevantRating"];
  }

  Map<String, dynamic> toEventDetailMap() {
    Map<String, dynamic> out = super.toSafeMap();
    out["costs"] = costs.toList();
    List<Map> placesOut = [];
    for (PlaceInEvent place in places) {
      placesOut.add(place.toFullMap());
    }
    out["places"] = placesOut;

    List<Map> organizersOut = [];
    for (OrganizerInEvent organizer in organizers) {
      organizersOut.add(organizer.toFullMap());
    }
    out["organizers"] = organizersOut;
    if (ownerId != null) {
      out["ownerId"] = ownerId;
    }
    out["tags"] = tags.toListList();
    out["relevantRating"] = relevantRating;
    return out;
  }

  Map toEventListMap() {
    Map<String, dynamic> out = {};
    out["from"] = from.millisecondsSinceEpoch;
    out["to"] = to.millisecondsSinceEpoch;
    out["name"] = name;
    out["id"] = id;
    out["mapLongitude"] = mapLongitude;
    out["mapLatitude"] = mapLatitude;
    out["clientSettings"] = clientSettings;
    out["relevantRating"] = relevantRating;
    return out;
  }
}
