part of view;

class ManageEventExtendedWidget extends ManageEventWidget {
  InputElement organizerInput;
  TextAreaElement description;
  SelectElement language;
  SelectElement physicalDemands;
  InputElement facebookEventUrl;
  InputElement webPageUrl;

  Element facebookEventUrlValidatorMessage;
  Element webPageEventUrlValidatorMessage;

  LeftPanelModel get model => layoutModel.leftPanelModel;

  ManageEventExtendedWidget(String name) : super(name) {
    template = parse(resources.templates.manageEvent.simple.extended);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  Map out() {
    ClientEvent clientEvent = model.createEvent.event;
    Map out = {};
    out["lang"] = lang.manageEvent.extendedLangs.toMap();
    out["languages"] = LANGUAGES;
    out["defaultCurrency"] = lang.defaultCurrency;
    out["hasPlaces"] = !model.createEvent.event.places.isEmpty;
    out["eventPlaces"] = model.createEvent.event.getPlacesViewJson();
    out["isOrganizerSelected"] = !model.createEvent.event.organizers.isEmpty;
    out["organizers"] = [];

    if (clientEvent.language != null) {
      out["language"] = clientEvent.language;
    } else {
      out["language"] = model.userLanguage;
    }
    out["description"] = clientEvent.description != null ? clientEvent.description : "";
    out["fbEvent"] = clientEvent.fbLink != null ? clientEvent.fbLink : "";
    out["webpage"] = clientEvent.webpage != null ? clientEvent.webpage : "";
    out["editImageSRC"] = "images/icons/question_mark.png";
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void functionality() {
    language = select("#appManageEventExtendedLanguage");
    language.value = model.userLanguage;
    language.onChange.listen((_) {
      model.createEvent.event.language = language.value;
    });
    organizerInput = select("#eventQuickOrganizer");
    organizerInput.onChange.listen((_) {
      model.createEvent.event.clientSettings["organizer"] = organizerInput.value;
    });
    description = select("#eventDescription");
    description.onChange.listen((_) {
      model.createEvent.event.description = description.value;
    });
    facebookEventUrl = select("#eventFbEvent");
    facebookEventUrlValidatorMessage = select(".eventFbEventValidatorMessage");
    facebookEventUrl.onKeyUp.listen((_) {
      model.createEvent.event.fbLink = facebookEventUrl.value;
    });
    webPageUrl = select("#eventWebpage");
    webPageEventUrlValidatorMessage = select(".eventWebpageValidatorMessage");
    webPageUrl.onKeyUp.listen((_) {
      model.createEvent.event.webpage = webPageUrl.value;
    });
    physicalDemands = select("#eventPhysicalDemands");
    physicalDemands.onChange.listen((_) {
      model.createEvent.event.clientSettings["physicalDemands"] = physicalDemands.value;
    });

    _createValidator();
    if (checkAfterRepainted) {
      validator.checkValidity();
    }
  }

  void _createValidator() {
    validator.clearValidators();
    validator.addSectionReport(_createEventFbEventSectionReport());
    validator.addSectionReport(_createEventWebpageSectionReport());
  }

  FormSectionReport _createEventFbEventSectionReport() {
    FormSectionReport report = new FormSectionReport(
        "eventFbEvent validator", facebookEventUrl, facebookEventUrlValidatorMessage);
    report.addSectionValidator(
        new FormSectionUrlValidator.facebook(validityMessage: lang.manageEvent.extendedLangs.eventWebLinkNotValid));
    return report;
  }

  FormSectionReport _createEventWebpageSectionReport() {
    FormSectionReport report = new FormSectionReport(
        "eventWebpage validator", webPageUrl, webPageEventUrlValidatorMessage);
    report.addSectionValidator(
        new FormSectionUrlValidator(validityMessage: lang.manageEvent.extendedLangs.eventFbLinkNotValid));
    return report;
  }
}