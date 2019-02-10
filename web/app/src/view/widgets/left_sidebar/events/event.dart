part of view;

class EventWidget extends Widget {
  ClientEvent event;
  Element eventBody;
  ImageElement image;
  Element imageCont;
  LeftSidebarWidget leftSidebar;

  LeftPanelModel get model => layoutModel.leftPanelModel;

  EventWidget(this.event, [this.leftSidebar]) {
    template = parse(resources.templates.leftSidebar.eventsNew.event);
  }

  @override
  Map out() {
    Map out = {};
    DateFormat formatter = new DateFormat(lang.timeFormats.shortDateFormat);
    out["lang"] = lang.leftSidebar.toMap();
    out["eventId"] = event.id;
    out["title"] = event.name;
    out["placeName"] = event.mapPlace.name;
    out["placeCity"] = event.mapPlace.city;
    out["date"] = formatter.format(event.from);
    return out;
  }

  @override
  void destroy() {
  }

  @override
  void functionality() {
    eventBody = select(".sidebarEventBody");
    imageCont = select(".eventIconImage");
    target = querySelector("#event-${event.id}");
    target.onClick.listen((_) {
      model.navigateToEventDetail(event.id);
    });
    _setImage();
  }

  void _setImage() {
    ImageElement image;
    if (event.haveAvatar) {
      image = new ImageElement(src: event.src);
      image.onError.listen((_) {
        event.haveAvatar = false;
      });
    }
    String bgColor = EventsModel.BG_COLORS[new math.Random().nextInt(EventsModel.BG_COLORS.length)];
    eventBody.style.background = bgColor;
    if (image != null) {
      image.classes.add("eventImage");
      image.onLoad.listen((_) {
        imageCont.append(image);
      });
    }
  }

  @override
  void setChildrenTargets() {
  }
}