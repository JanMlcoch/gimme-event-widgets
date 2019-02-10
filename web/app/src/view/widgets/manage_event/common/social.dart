part of view;

class ManageEventSocialWidget extends ManageEventWidget {

  LeftPanelModel get model => layoutModel.leftPanelModel;

  ManageEventSocialWidget(String name) : super(name) {
    template = parse(resources.templates.manageEvent.common.social);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.manageEvent.socialLangs.toMap();
    out["languages"] = LANGUAGES;
    out["defaultCurrency"] = lang.defaultCurrency;
    out["hasPlaces"] = !model.createEvent.event.places.isEmpty;
    out["eventPlaces"] = model.createEvent.event.getPlacesViewJson();
    out["isOrganizerSelected"] = !model.createEvent.event.organizers.isEmpty;
    out["hasFacebook"] = model.createEvent.event.socialNetworks["facebook_id"] != null;
    out["facebook_id"] = model.createEvent.event.socialNetworks["facebook_id"];
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