part of view;

class MapDialogWidget extends Widget {
  ElementList buttons;
  ElementList names;
//  int selected = 0;

  MapDialogWidget() {
    template = parse(resources.templates.addEvent.places.placeSearchResults);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.manageEvent.quickPlace.toMap();
    if (model.createEvent.event.places.isEmpty) {
      List<Map> places = model.createEvent.quickPlaceInBaseManage.getFilteredPlacesJson();
//      for(int i =0;i<places.length;i++){
//        places[i]["selected"] = i==selected;
//      }
      out["placesSearchResult"] = places;
    } else {
      out["placesSearchResult"] = [];
    }
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void functionality() {
    buttons = target.querySelectorAll(".addPlaceToEvent");
    buttons.onClick.listen((MouseEvent e) {
      int id = int.parse((e.currentTarget as Element).parent.dataset["id"]);
      ClientPlace place = model.createEvent.quickPlaceInBaseManage.places.getPlaceById(id);
      model.createEvent.addPlace(place, true);
    });
    names = target.querySelectorAll(".appPlaceInEventLabel");
    names.onClick.listen((MouseEvent e) {
      int id = int.parse((e.currentTarget as Element).parent.dataset["id"]);
      ClientPlace place = model.createEvent.quickPlaceInBaseManage.places.getPlaceById(id);
      model.createEvent.addPlace(place, true);
    });
    _resolveActive();
  }

  void confirmActivePlace() {
    for (int i = 0; i < names.length; i++) {
      if (i == model.createEvent.quickPlaceInBaseManage.activeFilteredPlaceIndex) {
        int id = int.parse(names[i].parent.dataset["id"]);
        ClientPlace place = model.createEvent.quickPlaceInBaseManage.places.getPlaceById(
            id);
        model.createEvent.addPlace(place, true);
      }
    }
  }

  void _resolveActive() {
    for (int i = 0; i < names.length; i++) {
      if (i == model.createEvent.quickPlaceInBaseManage.activeFilteredPlaceIndex) {
        names[i].parent.classes.add("appActivePlace");
      } else {
        names[i].parent.classes.remove("appActivePlace");
      }
    }
  }
}