library ui;

import "package:mustache_no_mirror/mustache.dart";
import "dart:html";
import "dart:convert";
//import "deskovka_libs.dart";

export "package:mustache_no_mirror/mustache.dart" show Template, parse;

part "widget.dart";

DivElement divFactory(int top, int left, int height, int width, String id, String html) {
  DivElement out = new DivElement()..style.position = "absolute";
  if (html != null) {
    out.innerHtml = html;
  }
  if (id != null) {
    out.id = id;
  }
  if (top != null) {
    out.style.top = "${top}px";
  }
  if (left != null) {
    out.style.left = "${left}px";
  }
  if (width != null) {
    out.style.width = "${width}px";
  }
  if (height != null) {
    out.style.height = "${height}px";
  }
  return out;
}

class OverlayDiv {
  DivElement div;
  CssStyleDeclaration get style => div.style;
  OverlayDiv([String className]) {
    div = new DivElement();
    _resize();
    if (className != null) div.classes.add(className);
    window.onResize.listen(_resize);
    document.body.append(div);
  }

  void _resize([Event _]) {
    div.style
      ..position = "absolute"
      ..top = "0px"
      ..left = "0px"
      ..width = "${window.innerWidth}px"
      ..height = "${window.innerHeight}px";
  }

  void destroy() {
    div.remove();
  }

}

Object findInMap(String path, Map map) {
  List<String> p = path.split("/");
  dynamic result = map;
  for (String s in p) {
    if (result is! Map) {
      return result;
    }
    if (result.containsKey(s) && result[s] != null) {
      result = result[s];
    }
  }
  return result;
}
