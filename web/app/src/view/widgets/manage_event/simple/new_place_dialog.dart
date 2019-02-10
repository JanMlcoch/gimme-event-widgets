part of view;


class NewPlaceDialog extends Widget with Validator {
  ClientPlace place;
  Element createButton;
  InputElement _nameInput;
  TextAreaElement description;
  FormSectionReport nameReport;
  Element _eventPlaceNameValidatorMessage;

  LeftPanelModel model;

  NewPlaceDialog(this.place, this.model) {
    querySelector("#newPlaceDialog")?.remove();
    Element div = new DivElement()
      ..id = "newPlaceDialog";
    document.body.append(div);
    this.target = div;
    template = parse(resources.templates.manageEvent.simple.createPlaceDialog);
    widgetLang = lang.manageEvent.placesLangs.toMap();
    view.widgets.add(this);
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  void functionality() {
    createButton = select(".appCretePlaceButton")
      ..onClick.listen((_) {
        if(validator.isValid){
          model.addPlaceToCreatingEvent(place);
          js.context.callMethod(r"$", ["#newPlaceDialog"])
              .callMethod("dialog", ["close"]);
          querySelector("#newPlaceDialog")?.remove();
        }
      });
    _nameInput = select("#eventPlaceName")..onInput.listen((_){
      place.name = _nameInput.value;
    });
    _nameInput..select()..setSelectionRange(0, _nameInput.value.length);
    description = select("textarea")..onInput.listen((_){
      place.description = description.value;
    });

    _eventPlaceNameValidatorMessage = select(".eventPlaceNameValidatorMessage");


    Map options = {
      'dialogClass': 'noTitleStuff',
      'width':600,
      'height':500,
      'modal':true,
      'position': {"my": "center", "at": "center"}
    };

    js.context.callMethod(r"$", ["#newPlaceDialog"])
        .callMethod("dialog", [new js.JsObject.jsify(options)]);

    _createValidator();
  }

  void _createValidator() {
    validator.clearValidators();
    validator.addSectionReport(_createEventNameReport());
  }

  FormSectionReport _createEventNameReport() {
    nameReport = new FormSectionReport("eventName", _nameInput, _eventPlaceNameValidatorMessage);
    nameReport.addSectionValidator(new FormSectionStringValidator.notEmpty(validityMessage: lang.manageEvent.validators.base.cannotBeEmpty));
    nameReport.addSectionValidator(
        new FormSectionStringValidator.minimalChars(3, validityMessage: lang.manageEvent.validators.base.tooShortName));
    return nameReport;
  }

  @override
  Map out() {
    Map out = {
      "lang": widgetLang,
      "placeName": place.name,
      "description": place.description,
      "placeGPS": place.formattedGps()
    };

    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }
}