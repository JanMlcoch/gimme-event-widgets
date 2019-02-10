part of view;

class SimilarsWidget extends Widget {
  ElementList buttons;
  ElementList names;
//  int selected = 0;

  CreatePlaceModel qpm;
  SimilarsWidget() {
    template = parse(resources.templates.addEvent.places.similars);
    qpm = model.createEvent.createPlace;
    qpm.onSimilarsChanged.add((){

    });
//    model.createEvent.quickPlace.onFilteredEventsChanged.add(requestRepaint);
//    model.createEvent.quickPlace.onActivePlaceChanged.add(_resolveActive);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.manageEvent.placesLangs.toMap();
    out["hints"] = [];
//    out["languages"] = LANGUAGES;
//    out["defaultCurrency"] = lang.defaultCurrency;
//    out["hasPlaces"] = !model.createEvent.event.places.isEmpty;
//    out["eventPlaces"] = model.createEvent.event.getPlacesViewJson();
//    out["isOrganizerSelected"] = !model.createEvent.event.organizers.isEmpty;
//    out["places"] = [];
//    out["placeName"] = "";
//    out["placeGPS"] = "";
//    out["hints"] = [];
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void functionality() {
//    buttons = target.querySelectorAll(".addPlaceToEvent");
//    buttons.onClick.listen((MouseEvent e) {
//      int id = int.parse((e.currentTarget as Element).parent.dataset["id"]);
//      ClientPlace place = model.createEvent.quickPlace.places.getPlaceById(id);
//      model.createEvent.addPlace(place, true);
//    });
//    names = target.querySelectorAll(".appPlaceInEventLabel");
//    names.onClick.listen((MouseEvent e) {
//      int id = int.parse((e.currentTarget as Element).parent.dataset["id"]);
//      ClientPlace place = model.createEvent.quickPlace.places.getPlaceById(id);
//      model.createEvent.addPlace(place, true);
//    });
//    _resolveActive();
  }


}