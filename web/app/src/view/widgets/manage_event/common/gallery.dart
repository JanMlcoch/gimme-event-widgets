part of view;

class ManageEventGalleryWidget extends ManageEventWidget {
  LeftPanelModel get model => layoutModel.leftPanelModel;

  ManageEventGalleryWidget(String name) : super(name) {
    template = parse(resources.templates.manageEvent.common.gallery);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  Map out() {
    Map out = lang.manageEvent.toMap();
    out["lang"] = lang.manageEvent.toMap();
    out["languages"] = LANGUAGES;
    out["defaultCurrency"] = lang.defaultCurrency;
    out["hasPlaces"] = !model.createEvent.event.places.isEmpty;
    out["eventPlaces"] = model.createEvent.event.getPlacesViewJson();
    out["isOrganizerSelected"] = !model.createEvent.event.organizers.isEmpty;
    return out;
  }

  @override
  void setChildrenTargets() {
    // TODO: implement setChildrenTargets
  }

  @override
  void functionality() {
    // TODO: implement tideFunctionality
  }
}