part of view;

class ManageEventLayoutWidget extends Widget {
  ManageEventBaseWidget base;
  ManageEventExtendedWidget extended;
  ManageEventSocialWidget social;
  ManageEventGalleryWidget gallery;
  ManageFacebookEventsWidget facebook;
  LeftSidebarWidget sidebarWidget;
  Map<String, Widget> widgets;
  ButtonElement sendButton;
  Element content;
  ElementList labels;
  Element activeTab;
  Element continueEditing;
  Element newEvent;
  bool success = false;
  bool error = false;

  LeftPanelModel get model => layoutModel.leftPanelModel;

  Widget get activeWidget => widgets[model.createEvent.activeTab];

  ManageEventLayoutWidget(this.sidebarWidget) {
    template = parse(resources.templates.manageEvent.simple.layout);
    base = new ManageEventBaseWidget(ManageEventModel.BASE, sidebarWidget);
    extended = new ManageEventExtendedWidget(ManageEventModel.EXTENDED);
    social = new ManageEventSocialWidget(ManageEventModel.SOCIAL);
    gallery = new ManageEventGalleryWidget(ManageEventModel.GALLERY);
    facebook = new ManageFacebookEventsWidget(ManageEventModel.FACEBOOK);
    widgetLang = lang.manageEvent.toMap();
    widgets = {
      ManageEventModel.BASE: base,
      ManageEventModel.EXTENDED: extended,
      ManageEventModel.SOCIAL: social,
      ManageEventModel.GALLERY: gallery,
      ManageEventModel.FACEBOOK: facebook
    };
    _makeChildren();
    model.createEvent.onActiveTabChanged.add(activeTabChanged);
    model.onChange.add(requestRepaint);
  }

  void activeTabChanged() {
    _makeChildren();
    repaintRequested = true;
  }

  void _makeChildren() {
    children = [activeWidget];
  }

  @override
  void destroy() {
    model.createEvent.onActiveTabChanged.remove(activeTabChanged);
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = widgetLang;
    out["languages"] = LANGUAGES;
    out["displayCreateSuccessfull"] = success;
    out["displayCreateError"] = error;
    out["defaultCurrency"] = lang.defaultCurrency;
    out["hasPlaces"] = !model.createEvent.event.places.isEmpty;
    out["eventPlaces"] = model.createEvent.event.getPlacesViewJson();
    out["isOrganizerSelected"] = !model.createEvent.event.organizers.isEmpty;
    return out;
  }

  @override
  void setChildrenTargets() {
    widgets[model.createEvent.activeTab].target = content;
  }

  @override
  void functionality() {
    continueEditing = select(".continueEditing");
    newEvent = select(".newEvent");
    content = target.querySelector(".manageEventContent");
    labels = target.querySelectorAll(".tabLabel");
    sendButton = target.querySelector(".saveEventButton");
    labels.onMouseDown.listen((MouseEvent e) {
      if ((e.target as Element).classes.contains("disabled")) {
        return;
      }
      model.createEvent.activeTab = (e.target as Element).dataset["id"];
    });
    labels.forEach((Element label) {
      if (label.dataset["id"] == model.createEvent.activeTab) {
        label.classes.add("active");
      }
    });
    sendButton.onClick.listen((_) {
      manageCreateEvent();
    });

    continueEditing?.onClick?.listen((_) {
      children = [base];
      success = false;
      error = false;
      requestRepaint();
    });
    newEvent?.onClick?.listen((_) {
      model.createEvent.reset();
      children = [base];
      success = false;
      error = false;
      requestRepaint();
    });
  }

  void manageCreateEvent() {
    List tabsWithValidator = _getValidators();
    List invalidWidgets = <ManageEventWidget>[];
    bool activeTabIsValid = false;
    tabsWithValidator.forEach((Validator widget) {
      if (!widget.validator.checkValidity()) {
        print("widget is invalid ${JSON.encode(widget.validator.explain())}");
        invalidWidgets.add(widget as ManageEventWidget);
      } else {}
      widget.checkAfterRepainted = true;
      if (widget == activeWidget) {
        activeTabIsValid = widget.validator.isValid;
      }
    });

    if (activeTabIsValid && invalidWidgets.isNotEmpty) {
      model.createEvent.activeTab = invalidWidgets.first.name;
      return;
    } else if (invalidWidgets.isNotEmpty) {
      return;
    }

    createEvent();
    model.createEvent.activeTab = ManageEventModel.BASE;
  }

  Future createEvent() async {
    String message = await model.createEvent.event.submitEvent();
    if (message == OK) {
      success = true;
      error = false;
      model.navigateToEventDetail(model.createEvent.event.id);
      _resetManageEventForm();
    } else {
      error = true;
      success = false;
    }
    repaintRequested = true;
  }

  List<Validator> _getValidators() {
    return [base, extended];
  }

  void _resetManageEventForm() {
    model.resetCreateEventModel();
    destroy();
    sidebarWidget.resetManageEventForm();
  }
}