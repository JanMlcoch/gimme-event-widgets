part of view;

class CreatePlaceWidget extends Widget {
  Element nameErrorCont;
  Element _createPlace;
  InputElement gps;
  InputElement _nameInput;
  TextAreaElement description;
  CreatePlaceModel cpm;

  CreatePlaceWidget(this.cpm) {
    template = parse(resources.templates.addEvent.places.createPlace);
    cpm.onSavedAndUsed.add(savedAndUsed);
    model.createEvent.onActiveTabChanged.add(() {
      if (model.createEvent.activeTab == ManageEventModel.PLACES) {
        js.context.callMethod("registerPlaceCallback", [(js.JsObject latLng) {
          if (gps == null) return;
          gps.value = latLng.toString();
          cpm.gps = gps.value;
        }
        ]);
      } else {
        try {
          js.context.callMethod("registerPlaceCallback", [null]);
        } catch (_) {
          // memory leak doesn't matter
        }
      }
    });
  }

  void savedAndUsed() {
    destroy();
  }

  @override
  void destroy() {
    try {
      js.context.callMethod("registerPlaceCallback", [null]);
    } catch (_) {
      // memory leak doesn't matter
    }
    js.context.callMethod("removeCreatingPlace", []);
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.manageEvent.placesLangs.toMap();
    out["placeName"] = cpm.name;
    out["description"] = cpm.description;
    out["placeGPS"] = cpm.gps;
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void functionality() {
    _nameInput = select("#eventPlaceName");
    description = select("#eventPlaceDescription");
    gps = select("#eventPlaceGPS");
    nameErrorCont = select(".eventPlaceNameErrorDescription");
    _createPlace = select(".appCretePlaceButton");

    void nameChange([_]) {
      cpm.name = _nameInput.value;
    }
    _nameInput.onKeyUp.listen(nameChange);
    _nameInput.onChange.listen(nameChange);
    gps.onInput.listen((_) {
      cpm.gps = gps.value;
      js.context.callMethod("showCreatingPlace", [cpm.lat, cpm.lon]);
    });
    new Future.delayed(Duration.ZERO).then((_) {
      _nameInput.focus();
      _nameInput.setSelectionRange(0, _nameInput.value.length);
    });

    _createPlace.onClick.listen((_) {
      cpm.saveAndUse(description.value);
    });
  }
}