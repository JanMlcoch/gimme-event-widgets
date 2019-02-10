part of view;

class SmartSelectOptionWidget extends Widget {
  DivElement container;
  Tag tag;
  SmartSelectModel model;

  SmartSelectOptionWidget(this.tag, this.model) {
    template = parse("""
    <div class="appSsOptionContainer{{#active}} appSsOptionActive{{/active}}">
    <div class="appTagNameInSsOption">{{tagName}}</div>
    </div>
    """);
    model.onActiveOptionChange.add(requestRepaint);
  }

  @override
  void destroy() {
    model.onActiveOptionChange.remove(requestRepaint);
  }

  @override
  Map out() {
    Map out = lang.login.toMap();
    out["tagName"] = tag.tagName;
    out["active"] = model.activeOption == tag;
    return out;
  }

  @override
  void setChildrenTargets() {}

  @override
  void functionality() {
    container = select(".appSsOptionContainer");
    container.onMouseOver.listen((MouseEvent e) {
      container.classes.toggle("appSsOptionOnHover");
    });
    container.onMouseOut.listen((MouseEvent e) {
      container.classes.toggle("appSsOptionOnHover");
    });
    container.onMouseDown.listen((_) {
      model.addChosenTag(tag);
      model.setActiveOption(tag);
      model.confirm();
    });
  }
}
