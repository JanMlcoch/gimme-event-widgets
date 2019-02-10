part of view;

class EventCardWidget extends Widget {
  ClientEvent event;
  Element editButton;
  Element deleteButton;
  Element cloneButton;
  Element header;
  Element annotation;
  Element showMore;
  Element leftPart;
  Element imageCont;
  UserSettingsModel model;
  bool shownMore = false;

  String get shortAnnotation => "${event.annotation.substring(0, 127)}...";

  EventCardWidget(this.event) {
    template = parse(resources.templates.userSettings.eventCard);
    widgetLang = lang.userSettings.myEvents.toMap();
    model = layoutModel.centralModel.userSettingsModel;
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  void functionality() {
    header = select(".eventContentLeftTop h3");
    showMore = select(".showMoreLink");
    annotation = select(".eventContentAnnotation");
    leftPart = select(".eventContentLeft");
    imageCont = select(".eventIconImage");
    editButton = select(".editButton");

    header.onClick.listen((_) {
      model.goToEventDetail(event.id);
    });

    editButton?.onClick?.listen((_) {
      model.goToEditEvent(event);
    });

    showMore?.onClick?.listen((_) {
      if (shownMore) {
        annotation.innerHtml = shortAnnotation;
        shownMore = false;
        showMore.innerHtml = widgetLang["showMore"];
      } else {
        annotation.innerHtml = event.annotation;
        shownMore = true;
        showMore.innerHtml = widgetLang["showLess"];
      }
    });

    cloneButton = select(".cloneButton");
    cloneButton?.onClick?.listen((_) {
      model.goToCloneEvent(event);
    });

    deleteButton = select(".deleteButton");
    deleteButton?.onClick?.listen((_) {
      if (window.confirm(widgetLang["confirmDelete"])) {
        event.delete();
      }
    });
    _setImage();
  }

  void _setImage() {
    ImageElement image;
    if (event.haveAvatar) {
      image = new ImageElement(src: event.src);
      image.onError.listen((_) {
        event.haveAvatar = false;
//        image.src = 'images/no_image.jpg';
      });
    }
    String bgColor = EventsModel.BG_COLORS[new math.Random().nextInt(EventsModel.BG_COLORS.length)];
    leftPart.style.background = bgColor;
    if (image != null) {
      image.classes.add("eventImage");
      image.onLoad.listen((_) {
        imageCont.append(image);
      });
    }
  }

  @override
  Map out() {
    Map out = event.toFullMap();
    out["placeName"] = "must have place name";
    out["placeCity"] = "city needed here";
    DateFormat dateFormat = new DateFormat(widgetLang["dateFormat"]);
    if (event.annotation.length > 130) {
      out["annotationShort"] = shortAnnotation;
      out["showMore"] = true;
    } else {
      out["annotationShort"] = event.annotation;
      out["showMore"] = false;
    }
    out["annotation"] = event.annotation;
    out["date"] = dateFormat.format(event.from);
    out["lang"] = widgetLang;
    out["past"] = event.isInPast();
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }
}
