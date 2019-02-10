part of placeModule;

void _bindPlacesProvider() {
  libs.route(CONTROLLER_FILTER_PLACES, () => new FilterPlacesRC(), method: "POST", template: {
    //"?sortBy": "string",
    //"?desc": "bool",
    "filters": [
      {"name": "string", "data": []}
    ]
  });
}

class FilterPlacesRC extends libs.RequestContext {
  static const placeColumns = const ["id", "name", "latitude", "longitude", "city", "description"];

  Future<dynamic> execute() async {
    EnvelopeHolder message = new EnvelopeHolder();
    common_filter.RootFilter placeFilter = new common_filter.RootFilter.construct(data["filters"], message);
    if (!message.empty) {
      envelope.error(message.envelope.message, BAD_FILTER_IN_FILTER_PLACES);
      return null;
    }
    Places places;
    places = await connection.places.load(placeFilter.concat(access.places), placeColumns);
    envelope.withMap({"places": places.toFullList()});
    return null;
  }
//  @override
//  Future<dynamic> executeOld() {
//    List<Place> places = model.places.list;
//    Message message = new Message();
//    List filters = data["filters"];
//    if (filters != null && filters.length > 0) {
//      RootFilter placeFilter = new RootFilter()
//          .construct(data["filters"], message: message);
//      if (placeFilter == null) {
//        return writeJson(message.toMap());
//      }
//      places = placeFilter.filter(places);
//    } else {
//      places = places.toList();
//    }
////    if (data["sortBy"] != null) {
////      bool ascending = true;
////      if (data["desc"] != null && data["desc"] == true) {
////        ascending = false;
////      }
////      PlaceSorter sorter = new PlaceSorter().build(data["sortBy"], ascending);
////      if (sorter == null) {
////        return respond("Wrong name of sorter", false);
////      }
////      places = sorter.sort(places);
////    }
//    if (places.length > 200) {
//      places = places.getRange(0, 200);
//    }
//    List<Map> placesList = places.map((Place place) => place.toFullMap()).toList();
//    envelope.listData = placesList;
//    sendEnvelope();
//    return null;
//  }
}
