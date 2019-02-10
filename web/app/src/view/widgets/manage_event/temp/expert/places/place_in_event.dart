part of view;

class PlaceInEventWidget extends Widget {
  ElementList buttons;
  ElementList names;
  ManageEventModel mem;
  bool _eventEditing = false;

  PlaceInEventWidget(this.mem) {
    template = parse(resources.templates.addEvent.places.placeInEvent);
    mem.onPlacesChanged.add(requestRepaint);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.manageEvent.placesLangs.toMap();
    List<Map> places = mem.event.getPlacesViewJson();
    out["placesInEvent"] = places;
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void functionality() {
    ElementList removeButtons = target.querySelectorAll(".removeButton");
    ElementList editButtons = target.querySelectorAll(".editButton");
    removeButtons.onClick.listen((MouseEvent e){
      int placeId = int.parse((e.currentTarget as Element).parent.parent.id);
      ClientPlaceInEvent placeToRemove = model.createEvent.event.places.firstWhere((ClientPlaceInEvent place) => place.place.id == placeId);
      model.createEvent.removePlace(placeToRemove);
      repaintRequested = true;
    });

    editButtons.onClick.listen((MouseEvent e){
      if(_eventEditing){
        _deactivateEditForPlace((e.currentTarget as Element).parent.parent);
      }else{
        _activateEditForPlace((e.currentTarget as Element).parent.parent);
      }
    });
  }

  void _activateEditForPlace(Element eventDetail){
    _eventEditing = true;
    int placeId = int.parse(eventDetail.id);
    ClientPlaceInEvent place = model.createEvent.event.places.firstWhere((ClientPlaceInEvent place) => place.place.id == placeId);
    _showSaveButton(eventDetail.querySelector(".editButton"));

    Element description = eventDetail.querySelector(".eventPlaceDescription");
    InputElement input = new InputElement()..value = place.description;
    description.setInnerHtml("");
    description.append(input);

    Element flag = eventDetail.querySelector(".eventPlaceFlag");
    SelectElement select = new SelectElement();
    OptionElement showInMap = new OptionElement()
      ..value = "show"
      ..text = lang.manageEvent.placesLangs.showInMapText
      ..selected = place.mapFlag;
    OptionElement dontShowInMap = new OptionElement()
      ..value = "dont"
      ..text = lang.manageEvent.placesLangs.dontShowInMapText
      ..selected = !place.mapFlag;
    select.add(showInMap, null);
    select.add(dontShowInMap, null);
    flag.setInnerHtml("");
    flag.append(select);

  }

  void _deactivateEditForPlace(Element eventDetail){
    _eventEditing = false;
    int placeId = int.parse(eventDetail.id);
    ClientPlaceInEvent place = model.createEvent.event.places.firstWhere((ClientPlaceInEvent place) => place.place.id == placeId);
    _showChangeButton(eventDetail.querySelector(".editButton"));

    Element description = eventDetail.querySelector(".eventPlaceDescription");
    InputElement input = description.querySelector("input");
    place.description = input.value;

    Element mapFlagEl = eventDetail.querySelector(".eventPlaceFlag");
    SelectElement select = mapFlagEl.querySelector("select");
    bool mapFlag = select.selectedOptions.first.value == "show";
    if(mapFlag){
      model.createEvent.changeMapFlag(place);
    }else{
      place.mapFlag = mapFlag;
    }
    repaintRequested = true;
  }

  void _showChangeButton(ButtonElement editButton){
    editButton.setInnerHtml(lang.manageEvent.placesLangs.eventPlacesEditButton);
    editButton.classes.remove("active");
  }

  void _showSaveButton(ButtonElement editButton){
    editButton.setInnerHtml(lang.manageEvent.placesLangs.eventPlacesSaveButton);
    editButton.classes.add("active");
  }
}