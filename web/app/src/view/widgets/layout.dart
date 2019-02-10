part of view;

class LayoutWidget extends Widget {
  Element navbar;
  Element central;
  Element leftSidebar;
  Element map;
  NavbarWidget navbarWidget;
  LeftSidebarWidget leftSidebarWidget;
  CentralWidget centralWidget;

  void set leftWidth(int val) {
    layoutModel.leftPanelWidth = val;
  }

  LayoutWidget() {
    name = "Layout";
    template = parse(resources.templates.layout);
    navbarWidget = new NavbarWidget();
    centralWidget = new CentralWidget();
    leftSidebarWidget = new LeftSidebarWidget();
    _resolveChildren();
    layoutModel.onChange.add(_resolveChildren);
  }

  void _resolveChildren() {
    children = [];
    children.add(navbarWidget);
    if (layoutModel.isCentralVisible) {
      children.add(centralWidget);
    }
    if (layoutModel.isLeftVisible) {
      children.add(leftSidebarWidget);
    }
    repaintRequested = true;
  }

  @override
  void destroy() {
    layoutModel.onChange.remove(_resolveChildren);
  }

  @override
  Map out() {
    Map out = {};
    out["showCentral"] = layoutModel.isCentralVisible;
    return out;
  }

  @override
  void setChildrenTargets() {
    leftSidebarWidget.target = leftSidebar;
    navbarWidget.target = navbar;
    centralWidget.target = central;
  }

  @override
  void functionality() {
    navbar = target.querySelector(".appNavbarWidgetCont");
    map = target.querySelector(".appMapWidgetCont");
    leftSidebar = target.querySelector(".appLeftSidebarWidgetCont");
    central = target.querySelector(".appCentralWidgetCont");
  }
}
