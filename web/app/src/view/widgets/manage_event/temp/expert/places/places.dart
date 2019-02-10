part of view;

class ManageEventPlacesWidget extends Widget {
  PlaceInEventWidget placeInEvent;
  SimilarsWidget similars;
  CreatePlaceWidget createPlace;
  MapDialogWidget dialog;
  QuickPlaceWidget quickPlace;
  Element createCont;
  Element placesInEventCont;
  Element similarsCont;
  Element dialogCont;
  Element quickPlaceCont;
  bool createActive = false;

  ManageEventPlacesWidget() {
    template = parse(resources.templates.addEvent.places.places);
    placeInEvent = new PlaceInEventWidget(model.createEvent);
    similars = new SimilarsWidget();
    createPlace = new CreatePlaceWidget(model.createEvent.createPlace);
    model.createEvent.createPlace.onSavedAndUsed.add(savedAndUsed);
    dialog = new MapDialogWidget();
    quickPlace = new QuickPlaceWidget(model.createEvent.createPlace.quickPlace, forceNotPlace: true, useValidator: false);
    doChildren();
    model.createEvent.quickPlaceInBaseManage.onCreatePlaceRequested.add((){
      model.createEvent.createPlace.name = model.createEvent.quickPlaceInBaseManage.value;
      model.createEvent.activeTab=ManageEventModel.PLACES;
      createActive = true;
      doChildren();
      repaintRequested=true;
    });
    // from places quick place
    model.createEvent.createPlace.quickPlace.onCreatePlaceRequested.add((){
      model.createEvent.createPlace.name = model.createEvent.createPlace.quickPlace.value;
      createActive = true;
      model.createEvent.createPlace.quickPlace.value="";
//      createPlace.focusAfterLoad=true;
      createPlace.repaint(true);
    });
  }

  void doChildren(){
    children = [quickPlace, placeInEvent];
    if(createActive){
      children.add(createPlace);
      children.add(similars);
    }
  }

  void savedAndUsed(){
    createActive= false;
    doChildren();
    requestRepaint();
  }

  @override
  void destroy() {
    model.createEvent.createPlace.onSavedAndUsed.remove(savedAndUsed);
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.manageEvent.placesLangs.toMap();
    out["hasPlace"] = model.createEvent.event.places.isNotEmpty;

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
    placeInEvent.target = placesInEventCont;
    quickPlace.target = quickPlaceCont;
    createPlace.target = createCont;
    similars.target = similarsCont;
  }

  @override
  void functionality() {
    placesInEventCont = select(".eventUsedPlacesBlock");
    createCont = select(".createPlaceCont");
    similarsCont = select(".similarsCont");
    quickPlaceCont = select(".quickPlaceCont");

    model.createEvent.onPlacesChanged.add(_placeChanged);
  }

  void _placeChanged(){
    if(model.createEvent.event.places.isEmpty){
      placesInEventCont.classes.add("hidden");
    }else{
      placesInEventCont.classes.remove("hidden");
    }
  }
}