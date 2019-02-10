part of view;

class EventsWidget extends Widget {
  Element filters;
  Element events;
  Element footer;
  FooterWidget footerWidget;
  EventsListWidget eventsListWidget;

  LeftPanelModel get model => layoutModel.leftPanelModel;

  EventsWidget() {
    template = parse(resources.templates.leftSidebar.eventsNew.events);
    eventsListWidget = new EventsListWidget(model.isPlaceFilterActive ? model.filteredEventsByPlace : model.baseEvents);
    footerWidget = new FooterWidget();
    children = [eventsListWidget, footerWidget];
    model.onChange.add(() {
      if (model.isPlaceFilterActive) {
        eventsListWidget.changeSource(model.filteredEventsByPlace);
      } else {
        eventsListWidget.changeSource(model.baseEvents);
      }
    });
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void functionality() {
    filters = target.querySelector(".appFilterWidgetCont");
    events = target.querySelector(".appEventsWidgetCont");
    footer = target.querySelector(".appFooterWidgetCont");
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.leftSidebar.toMap();
    return out;
  }

  @override
  void setChildrenTargets() {
    eventsListWidget.target = events;
    footerWidget.target = footer;
  }
}