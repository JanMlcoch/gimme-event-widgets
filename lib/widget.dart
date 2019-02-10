part of ui;

abstract class Widget {
  static NodeValidatorBuilder nodeValidator = new NodeValidatorBuilder.common()
    ..allowHtml5()
    ..allowElement("fb:login-button", attributes: ["scope","onlogin"])
    ..allowElement("button", attributes: ["data-id"])
    ..allowElement("div", attributes: ["data-id", "data-input", "data-mobile", "data-size", "data-layout", "data-href", "data-mobile-iframe"])
    ..allowElement("li", attributes: ["data-index", "data-id"])
    ..allowElement("input", attributes: ["data-id"])
    ..allowElement("a", attributes: ["href"])
    ..allowElement("span", attributes: ["data-id"]);

  bool repaintRequested = true;
  bool keepPaintedState = false;
  String name = "unnamed";
  Template template;
  Element target;
  Widget parentWidget;
  Map widgetLang;
  List<Widget> children = [];

  Function requestRepaint;

  Widget() {
    requestRepaint = () {
      repaintRequested = true;
    };
  }

  Map out();

  void repaint([bool forceRepaint = false]) {
    if (template == null) throw new Exception("template missing in $name");
    if (keepPaintedState) {
      onNoRepaint();
      return;
    }
    if (repaintRequested || forceRepaint) {
      repaintRequested = false;
      if (target == null) {
        throw new StateError("Target is null in $this");
      }
      try {
        target.setInnerHtml(template.renderString(out(), lenient: true),
            validator: getHtmlValidator());
      } catch (e) {
        if (name == null) {
          throw new Exception("WidgetWithoutName");
        }
        print("TEMPLATE ERROR:" + name + this.toString() + JSON.encode(out()));
        throw e;
      }
      functionality();
      setChildrenTargets();
      for (Widget widget in children) {
        widget.repaint(true);
      }
    } else {
      onNoRepaint();
      for (Widget widget in children) {
        widget.repaint();
      }
    }
  }

  NodeValidatorBuilder getHtmlValidator(){
    return nodeValidator;
  }

  void setChildrenTargets();

  void functionality();

  void onNoRepaint() {}

  void destroy();

  Widget getChildByName(String name) {
    for (Widget w in children) {
      if (w.name == name) {
        return w;
      }
    }
    return null;
  }

  Element select(String selector) {
    return target.querySelector(selector);
  }
}

///Use this only if you want to allow all uris, this is potentially dangerous
class AllUriPolicy implements UriPolicy{
  @override
  bool allowsUri(String uri) {
    return true;
  }
}

class FacebookUriPolicy implements UriPolicy {
  bool allowsUri(String uri) =>
      uri.startsWith("https://scontent.xx.fbcdn.net/") || uri.startsWith("https://www.facebook.com/events/") ||
          uri.startsWith("https://fbcdn-sphotos-a-a.akamaihd.net/") ||
          uri.startsWith("https://fbcdn-sphotos-e-a.akamaihd.net/");
}
