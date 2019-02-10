part of view;

class EventDetailWidget extends Widget {
  Element widthCont;
  Element imageCont;
  Element mapIcon;
  Element attendEvent;
  Element goodRecommedation;
  Element badRecommedation;
  ClientEvent event;
  EventDetailRatingWidget ratingWidget;
  bool hasData = false;

  LeftPanelModel get leftPanelModel => layoutModel.leftPanelModel;

  ClientUser get userModel => model.user;

  PlannedEventsModel get plannedEvents => userModel.clientAboutEvent.plannedEvents;

  RecommedationsFeedback get recommedationsFeedback => userModel.clientAboutEvent.recommedationsFeedback;

  EventDetailWidget() {
    name = "Event detail";
    template = parse(resources.templates.leftSidebar.eventDetail);
  }

  @override
  NodeValidatorBuilder getHtmlValidator(){
    Widget.nodeValidator
      ..allowHtml5()
      ..allowNavigation(new AllUriPolicy());
    return Widget.nodeValidator;
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.leftSidebar.eventDetail.toMap();
    if (!hasData) {
      out["hasData"] = false;
      _getEvent();
      return out;
    }

    out["hasData"] = true;
    out["name"] = event.name;
    out["webpage"] = event.webpage;
    out["hasWebpage"] = event.webpage != null;
    out["facebook"] = event.fbLink;
    out["hasFacebook"] = event.fbLink != null;
    //todo: fix so that the "null" case do not happen or add lang
    out["place"] = event.mapPlace == null
        ? {"name": "Place of unknown name", "city": "Unknown city"}
        : {"name": event.mapPlace.name, "city": event.mapPlace.city};

    DateFormat fullDateFormat = new DateFormat("d. M. yyyy");
    DateFormat timeFormat = new DateFormat("hh:mm");
    out["dateFrom"] = fullDateFormat.format(event.from);
    out["timeFrom"] = timeFormat.format(event.from);
    out["dateTo"] = fullDateFormat.format(event.to);
    out["dateToFromSame"] = fullDateFormat.format(event.from) == fullDateFormat.format(event.to);
    out["timeTo"] = timeFormat.format(event.to);
    out["userRating"] = 1.0 + event.averageRating;
    out["tags"] = _getTags();
    out["annotation"] = event.annotation;
    out["admissions"] = _createAdmissions();
    out["description"] = event.description;
    out["hasDescription"] = event?.description?.isNotEmpty;
    out["organizers"] = _createOrganizers();
    out["hasAdmissionNote"] = false;
    out["email"] = "to do email";
    out["phone"] = "to do phone";
    out["contactWebpage"] = "to do contactWebpage";
    out["isPlanned"] = plannedEvents.isEventInPlanned(event);
    out["recommendationIsPositivelyEvaluated"] = recommedationsFeedback.isPositivelyEvaluated(event);
    out["recommendationIsNegativelyEvaluated"] = recommedationsFeedback.isNegativelyEvaluated(event);
    out["logged"] = userModel.isLogged;
    return out;
  }

  List _getTags() {
    List tags = <Map>[];
    for (Tag tagData in event.tags) {
      Map tag = {"name": tagData.tagName};
      tags.add(tag);
    }
    return tags;
  }

  List _createOrganizers() {
    List viewOrganizers = [];
    for (ClientOrganizer organizer in event.organizersRepository.list) {
      Map viewOrganizer = {};
      viewOrganizer["name"] = organizer.name;
      viewOrganizer["address"] = organizer.address;
      viewOrganizers.add(viewOrganizer);
    }
    return viewOrganizers;
  }

  List _createAdmissions() {
    List viewAdmissions = [];
    if (event.costs.list.isEmpty) {
      Map viewAdmission = {};
      viewAdmission["flag"] = lang.leftSidebar.eventDetail.defaultFlag;
      viewAdmission["description"] = "";
      viewAdmission["value"] = "-";
      viewAdmission["currency"] = event.currency;
      viewAdmissions.add(viewAdmission);
    }
    for (CostBase admission in event.costs.list) {
      Map viewAdmission = {};
      viewAdmission["flag"] = admission.flag;
      viewAdmission["description"] = admission.description;
      viewAdmission["value"] = admission.price;
      viewAdmission["currency"] = admission.currency;
      viewAdmissions.add(viewAdmission);
    }
    return viewAdmissions;
  }

  @override
  void destroy() {}

  @override
  void functionality() {
    if (!hasData) {
      return;
    }
    widthCont = select(".sidebarEventDetail");
    imageCont = select(".eventDetailHeaderImage");
    mapIcon = select(".eventDetailMapPoint");
    attendEvent = select(".eventDetailAttend");
    goodRecommedation = select(".eventDetailRecommendedRight");
    badRecommedation = select(".eventDetailRecommendedWrong");
    Element backButton = target.querySelector(".eventDetailBackToEvents");
    backButton.onClick.listen((_) {
      leftPanelModel.backToBaseEvents();
    });
    _setImage();
    leftPanelModel.leftPanelWidth = widthCont.marginEdge.width;
    mapIcon.onClick.listen((_) {
      mapModel.onChange.forEach((Function f) => f());
    });
    leftPanelModel.onChange.add(() {
      hasData = false;
    });
    attendEvent.onClick.listen((_) {
      if (!plannedEvents.isEventInPlanned(event) && userModel.isLogged) {
        plannedEvents.addEventToPlanned(event);
        repaintRequested = true;
      }
    });
    goodRecommedation?.onClick?.listen((_) {
      recommedationsFeedback.evaluateRecommedationAsGood(event);
      goodRecommedation.classes.add("positive");
      badRecommedation.classes.remove("negative");
//      repaintRequested = true;
    });
    badRecommedation?.onClick?.listen((_) {
      recommedationsFeedback.evaluateRecommedationAsBad(event);
      badRecommedation.classes.add("negative");
      goodRecommedation.classes.remove("positive");
//      repaintRequested = true;
    });
  }

  Future _getEvent() async {
    event = await leftPanelModel.eventsModel.offerDetailForEvent();
    hasData = true;
    repaintRequested = true;
  }

  void _setImage() {
    ImageElement image;
    if (event.haveAvatar) {
      image = new ImageElement(src: 'images/events_images/event_avatar_${event.id}.png');
      image.onError.listen((_) {
        event.haveAvatar = false;
        image.src = 'images/no_image.jpg';
      });
    } else {
      image = new ImageElement(src: 'images/no_image.jpg');
    }
    image.classes.add("eventImage");
    image.onLoad.listen((_) {
      imageCont.append(image);
    });
  }

  @override
  void setChildrenTargets() {
    // TODO: implement setChildrenTargets
  }
}