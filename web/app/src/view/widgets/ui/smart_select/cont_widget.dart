part of view;

class SmartSelectContWidget extends Widget with Validator {
  SmartSelectModel model;
  TextInputElement _input;
  Element _chosenTarget;
  Element _options;
  String classes;

  int get substringLength => model.substring.length;
  SmartSelectTagsWidget _chosen;
  SmartSelectOptionsWidget _optionsWidget;

//  Validation block
  Element inputValidatorMessage;
  FormSectionReport inputReport;

  SmartSelectContWidget(this.model, [this.classes]) {
    template = parse("""
      <label for="eventTags">{{lang.tagsLabel}}*</label>
      <div class="appSsTagContainer">
          <div class="appChosenTagsTarget float-left"></div>
          <div class="appSsTagActivePartsContainer">
              <input type="text" class="appSsTagAutocomplete {{classes}}" placeholder='{{placeholder}}'/>
              <div class="appSsTagOptionsTarget">
              </div>
          </div>
      </div>
      <div class="errorMessage appSsTagValidatorMessage validatorMessage"></div>
    """);
    resetWidget();
    children = [_chosen, _optionsWidget];
    model.onChosenAdded.add(onTagChoose);
  }

  void onTagChoose() {
    _input.value = "";
    new Future.delayed(Duration.ZERO).then((_) {
      _input.focus();
    });
  }

  @override
  void destroy() {
    _chosen.destroy();
    model.onChosenAdded.remove(onTagChoose);
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.smartSelect.toMap();
    out["placeholder"] = model.placeholder;
    out["classes"] = classes;
    return out;
  }

  @override
  void setChildrenTargets() {
    _chosen.target = _chosenTarget;
    _optionsWidget.target = _options;
  }

  @override
  void functionality() {
    _chosenTarget = target.querySelector(".appChosenTagsTarget");
    _input = target.querySelector(".appSsTagAutocomplete");
    _options = target.querySelector(".appSsTagOptionsTarget");
    inputValidatorMessage = target.querySelector(".appSsTagValidatorMessage");
    _input.onInput.listen((Event e) {
      model.setSubstring(_input.value);
    });
    _input.onKeyDown.listen((e) {
      if (e.keyCode == KeyCode.DOWN) {
        model.moveDown();
      }
      if (e.keyCode == KeyCode.UP) {
        model.onMoveUp();
      }
      if (e.keyCode == KeyCode.ENTER) {
        model.confirm();
        validator.checkValidity();
      }
    });
    _createValidator();
  }

  void resetWidget() {
    classes = "";
    _chosen = new SmartSelectTagsWidget(model);
    _optionsWidget = new SmartSelectOptionsWidget(model, this);
    model.placeholder = lang.smartSelect.findTag;
  }

  void _createValidator() {
    validator.clearValidators();
    validator.addSectionReport(_createInputReport());
  }

  FormSectionReport _createInputReport() {
    inputReport = new FormSectionReport("eventName", _input, inputValidatorMessage);
    inputReport.addSectionValidator(
        new FormSectionListValidator.notEmpty(
            () => model.chosenTags,
            validityMessage: lang.smartSelect.invalidNumberOfTags)
    );
    return inputReport;
  }
}
