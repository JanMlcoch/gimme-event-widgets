part of view;

class SmartSelectTagsWidget extends Widget {
  SmartSelectModel model;

  SmartSelectTagsWidget(this.model) {
    template = parse("""
    <div class="appSsChosenTagsContainer">
      {{#chosens}}
        <div class="appSsChosenTagCont appTag{{.}}"> </div>
      {{/chosens}}
    </div>
    """);
    model.onChosenChanged.add(_onChosenChanged);
  }

  @override
  void destroy() {
    model.onChosenChanged.remove(_onChosenChanged);
  }

  @override
  Map out() {
    Map out = lang.login.toMap();
    List<int> chosen = [];
    for (Tag tag in model.chosenTags) {
      chosen.add(tag.id);
    }
    out["chosens"] = chosen;
    return out;
  }

  @override
  void setChildrenTargets() {
    for (SmartSelectTagWidget child in children) {
      child.target = target.querySelector(".appTag${child.tag.id}");
    }
  }

  void _onChosenChanged() {
    children.forEach((Widget c) => c.destroy());
    children.clear();
    for (Tag tag in model.chosenTags) {
      children.add(new SmartSelectTagWidget(tag, model));
    }
    repaintRequested = true;
  }

  @override
  void functionality() {
    if (children.isEmpty) {
      target.classes.add("hidden");
    } else {
      target.classes.remove("hidden");
    }
  }
}
