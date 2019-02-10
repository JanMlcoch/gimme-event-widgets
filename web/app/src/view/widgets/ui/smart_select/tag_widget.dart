part of view;

class SmartSelectTagWidget extends Widget {
  Tag tag;
  SmartSelectModel model;

  SmartSelectTagWidget(this.tag, this.model) {
    template = parse("""
    <div class="appSsChosenTagContainer">
      {{chosenTagName}}
      <button type="button" class="appRemoveChosenTagButton float-right">X</button>
    </div>
    """);
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    Map out = lang.login.toMap();
    out["chosenTagName"] = tag.tagName;
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void functionality() {
    target
        .querySelector(".appRemoveChosenTagButton")
        .onClick
        .listen((Event e) {
      model.removeChosenTag(tag);
    });
  }
}