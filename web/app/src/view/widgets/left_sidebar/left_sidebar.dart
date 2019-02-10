part of view;

class LeftSidebarWidget extends Widget {
  Element sidebarContainer;
  Element eventsContainer;
  Element eventDetailContainer;
  Element sidebarManageEventContainer;
  EventsWidget eventsWidget;
  ManageEventLayoutWidget manageEventLayoutWidget;
  EventDetailWidget eventDetailWidget;
  String lastRoute;
  LeftPanelModel model;
  Element minimizePanelEl;
  bool minimized = false;
  List<Function> onMinimizationChange = [];

  LeftSidebarWidget() {
    model = layoutModel.leftPanelModel;
    name = "Left Sidebar";
    template = parse(resources.templates.leftSidebar.leftSidebar);
    eventsWidget = new EventsWidget();
    eventDetailWidget = new EventDetailWidget();
    manageEventLayoutWidget = new ManageEventLayoutWidget(this);
    model.onChange.add(resolveChildren);
    resolveChildren();
  }

  void resolveChildren() {
    if (model.isEventDetail) {
      children = [eventDetailWidget];
    } else if (model.isManageEvent) {
      children = [manageEventLayoutWidget];
    } else {
      children = [eventsWidget];
    }
    requestRepaint();
  }

  @override
  void destroy() {
    model.onChange.remove(resolveChildren);
  }

  @override
  Map out() {
    Map out = {};
    out["collapsed"] = false;
    return out;
  }

  void minimizePanel() {
    minimized = true;
    sidebarContainer.classes.add("minimizedLeftPanel");
    sidebarContainer.classes.remove("maximalizedLeftPanel");
    minimizePanelEl.setInnerHtml(">>");
  }

  void maximizePanel() {
    minimized = false;
    sidebarContainer.classes.remove("minimizedLeftPanel");
    sidebarContainer.classes.add("maximalizedLeftPanel");
    minimizePanelEl.setInnerHtml("<<");
  }

  @override
  void functionality() {
    sidebarContainer = select(".sidebarCont");
    minimizePanelEl = target.querySelector(".minimizePanel");
    eventsContainer = target.querySelector(".sidebarEventsContainer");
    eventDetailContainer = target.querySelector(".sidebarEventDetailContainer");
    sidebarManageEventContainer = target.querySelector(".sidebarManageEventContainer");
    minimizePanelEl.onClick.listen((_) {
      if (minimized) {
        maximizePanel();
      } else {
        minimizePanel();
      }
      onMinimizationChange.forEach((f)=>f());
    });
  }

  @override
  void setChildrenTargets() {
    eventsWidget.target = eventsContainer;
    if (eventDetailWidget != null) {
      eventDetailWidget.target = eventDetailContainer;
    }
    manageEventLayoutWidget.target = sidebarManageEventContainer;
  }

  void resetManageEventForm() {
    manageEventLayoutWidget = new ManageEventLayoutWidget(this);
    resolveChildren();
    requestRepaint();
  }
}
