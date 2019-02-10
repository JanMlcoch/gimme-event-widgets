part of view;

class MapWidget extends Widget {
  Element mapElement;
  Element googleLogo;
  Element message;
  bool mapLoaded = false;

  MapModel get model => mapModel;
  g_m.GMap map;

  MapWidget() {
    name = "Map";
    template = parse("""
    <div id="appMap"></div>
    <div class='topMapMessage'>

    </div>
""");
    model.onMessage.add(_message);
  }

  Future _message() async {
    message
      ..innerHtml = model.message
      ..style.opacity = "1"
      ..style.display = "block";
    var animation = new animation_lib.CssAnimation.properties(
        { 'opacity': 1},
        { 'opacity': 0}
    );
    await new Future.delayed(const Duration(seconds: 3));
    animation.apply(message, duration: 2000, alternate: true);
    await new Future.delayed(const Duration(seconds: 2));
    message.style.display = "none";
  }

  @override
  Map out() {
    Map out = lang.toMap();
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void functionality() {
    mapElement = target.querySelector(".appMap");
    target.style.height = "${window.innerHeight - 51}px";
    window.onResize.listen((_) {
      target.style.height = "${window.innerHeight - 51}px";
    });
    message = select(".topMapMessage");
    new Future.delayed(const Duration(milliseconds: 200)).then((_) => model.init());
  }

  @override
  void destroy() {
    // do nothing
  }
}