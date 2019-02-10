part of view;

class SmartSelectOptionsWidget extends Widget {
  SmartSelectModel model;
  SmartSelectContWidget parent;

  int get substringLength => model.substring.length;

  SmartSelectOptionsWidget(this.model, this.parent) {
    template = parse("""
    <div class="appSsOptionTarget">
    {{#options}}
        <div class="appSsOptionCont appOption{{.}}"> </div>
    {{/options}}
    </div>
    """);
    model.onOptionsChanged.add(_onOptionsChanged);
    _onOptionsChanged();
  }

  @override
  void destroy() {
    model.onOptionsChanged.remove(_onOptionsChanged);
  }

  @override
  Map out() {
    Map out = lang.login.toMap();
    out["options"] = [];
    for (Tag tag in model.options) {
      out["options"].add(tag.id);
    }
    return out;
  }

  @override
  void setChildrenTargets() {
    for (SmartSelectOptionWidget option in children) {
      option.target = target.querySelector(".appOption${option.tag.id}");
    }
  }

  void _onOptionsChanged() {
    children.forEach((Widget c) => c.destroy());
    children.clear();
    for (Tag tag in model.options) {
      children.add(new SmartSelectOptionWidget(tag, model));
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

