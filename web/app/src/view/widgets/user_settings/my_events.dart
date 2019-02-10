part of view;

class UserSettingsMyEventsWidget extends UserSettingsSubWidget {
  bool eventsLoaded = false;
  Element eventsLeft;
  CheckboxInputElement showAllEventsCheckbox;
  bool showAllEvents = false;
  int scrollTop = 0;

  @override
  String get myRoute => UserSettingsModel.EVENTS;

  ClientEvents events;
  UserSettingsModel model;

  DateSeparatorWidget dateSeparatorWidget;

  UserSettingsMyEventsWidget() {
    img = "images/icons/events.png";
    className = "events";
    iClass = "settingsMyEvents";
    template = parse(resources.templates.userSettings.myEvents);
    model = layoutModel.centralModel.userSettingsModel;
    dateSeparatorWidget = new DateSeparatorWidget();
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void functionality() {
    showAllEventsCheckbox = select(".showAllEventsCheckbox");
    showAllEventsCheckbox?.onChange?.listen((_) {
      showAllEvents = showAllEventsCheckbox.checked;
      loadEvents();
    });
    eventsLeft = select(".eventsLeft");
    eventsLeft.onScroll.listen((Event e) {
      scrollTop = eventsLeft.scrollTop;
    });
    new Future.delayed(Duration.ZERO).then((_) {
      eventsLeft.scrollTop = scrollTop;
    });
    if (!eventsLoaded) {
      eventsLoaded = true;
      loadEvents();
    }
  }

  Future loadEvents() async {
    if (showAllEvents) {
      events = await model.downloadAllEvents();
      events.onChange.add(() {
        createChildren();
        requestRepaint();
      });
      events.orderByTimeDesc();
      createChildren();
      requestRepaint();
    } else {
      events = await model.downloadMyEvents();
      events.onChange.add(() {
        createChildren();
        requestRepaint();
      });
      events.orderByTimeDesc();
      createChildren();
      requestRepaint();
    }
  }

  void createChildren() {
    children.clear();
    for (ClientEvent event in events.list) {
      children.add(new EventCardWidget(event));
    }
    children.add(dateSeparatorWidget);
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.userSettings.myEvents.toMap();
    out["events"] = _getEvents();
    out["isAdmin"] = model.canEditAnyEvent();
    out["showAllEvents"] = showAllEvents;
    return out;
  }

  List _getEvents() {
    if (this.events == null) {
      return [];
    }
    List events = [];
    bool isInPastUsed = false;
    for (ClientEvent event in this.events.list) {
      if (event.isInPast()) {
        if (!isInPastUsed) {
          isInPastUsed = true;
          events.add({"id": "PastSeparator"});
        }
      }
      events.add({
        "id": event.id
      });
    }
    if (!isInPastUsed) {
      isInPastUsed = true;
      events.add({"id": "PastSeparator"});
    }
    return events;
  }

  @override
  void setChildrenTargets() {
    for (dynamic widget in children) {
      if (widget is EventCardWidget) {
        widget.target = select(".event${widget.event.id}");
      }
    }
    dateSeparatorWidget.target = select(".eventPastSeparator");
  }
}

class DateSeparatorWidget extends Widget {
  DateSeparatorWidget() {
    template = parse("""
    <div class="timeSeparator">
      <h3 class="pastEvents">
        {{pastEvents}}
      </h3>
    </div>
    """);
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  void functionality() {
    // do nothing
  }

  @override
  Map out() {
    return lang.userSettings.myEvents.toMap();
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }
}