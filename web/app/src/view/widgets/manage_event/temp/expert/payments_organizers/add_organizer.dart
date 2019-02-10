part of view;

class AddOrganizerWidget extends Widget{

  AddOrganizerWidget() {
    template = parse(resources.templates.addEvent.paymentsOrganizers.addOrganizer);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void functionality() {
    // TODO: implement functionality
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.manageEvent.paymentsAndOrganizersLangs.toMap();
    out["organizerName"] = "";
    return out;
  }

  @override
  void setChildrenTargets() {
    // TODO: implement setChildrenTargets
  }
}