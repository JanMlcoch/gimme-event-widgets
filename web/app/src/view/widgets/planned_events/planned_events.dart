part of view;

class PlannedEventsWidget extends Widget {
  PlannedEventsModel plannedModel;

  PlannedEventsWidget() {
    name = "Planned events";
    plannedModel = model.user.clientAboutEvent.plannedEvents;
    template = parse(resources.templates.plannedEvents.plannedEvents);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void functionality() {
    querySelectorAll(".plannedEvent").forEach((Element eventEl) {
      int eventId = int.parse(eventEl.id);
      ClientEvent event = plannedModel.plannedEvents.firstWhere((ClientEvent e) => e.id == eventId);
      Element imageElement = eventEl.querySelector(".plannedEventImage");
      _setImage(event, imageElement);
    });
  }

  void _setImage(ClientEvent event, Element imageContainer) {
    ImageElement image;
    if (event.haveAvatar) {
      image = new ImageElement(src: event.src);
      image.onError.listen((_) {
        event.haveAvatar = false;
//        image.src = 'images/no_image.jpg';
      });
    }
    String bgColor = EventsModel.BG_COLORS[new math.Random().nextInt(EventsModel.BG_COLORS.length)];
    imageContainer.style.background = bgColor;
    if (image != null) {
      image.classes.add("eventImage");
      image.onLoad.listen((_) {
        imageContainer.append(image);
        imageContainer.style.background = 'initial';
      });
    }
  }

  @override
  Map out() {
    if (!plannedModel.loaded) {
      plannedModel.onDataLoaded.add(() => repaintRequested = true);
    }
    Map out = {};
    Map langRet = lang.plannedEvents.toMap();
    DateFormat dateFormat = new DateFormat(langRet["dateFormat"]);
    out["lang"] = langRet;
    List<Map> events = [];
    for (ClientEvent eventData in plannedModel.futurePlannedEvents) {
      Map event = {};
      event["name"] = eventData.name;
      event["dateFrom"] = dateFormat.format(eventData.from);
      event["dateTo"] = dateFormat.format(eventData.to);
      event["annotation"] = '${_getShortAnnotation(eventData.annotation)}...';
      event["id"] = eventData.id;
      events.add(event);
    }
    out["events"] = events;
    return out;
  }

  String _getShortAnnotation(String annotation){
    if(annotation.length>300){
      return annotation.substring(0,300);
    }else{
      return annotation;
    }
  }

  @override
  void setChildrenTargets() {
    // TODO: implement setChildrenTargets
  }
}
