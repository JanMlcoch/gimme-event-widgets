part of view;

class PlaceCardWidget extends Widget {
  ClientPlace place;
  Element editButton;
  Element deleteButton;
  Element confirmButton;
  Element cancelButton;
  Element selectInMap;
  InputElement placeName;
  InputElement placeGPS;
  TextAreaElement placeDescription;
  bool expanded = false;
  bool editMode = false;
  CentralWidget centralWidget;

  PlaceCardWidget(this.place, this.centralWidget) {
    template = parse(resources.templates.userSettings.placeCard);
    widgetLang = lang.userSettings.placesAndOrganizers.toMap();
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  void functionality() {
    editButton = select(".editButton");
    editButton?.onClick?.listen((_) {
      editMode = true;
      requestRepaint();
    });

    confirmButton = select(".confirmButton");
    confirmButton?.onClick?.listen((_) {
      sendForm();
    });

    cancelButton = select(".cancelButton");
    cancelButton?.onClick?.listen((_) {
      editMode = false;
      requestRepaint();
    });

    selectInMap = select(".selectInMap");
    selectInMap?.onClick?.listen((_){_selectInMap();});

    deleteButton = select(".deleteButton");
    deleteButton?.onClick?.listen((_) {
      if (window.confirm(widgetLang["confirmDelete"])) {
        place.sendDelete();
      }
    });

    if (editMode) {
      placeName = select(".placeName");
      placeName.focus();
      placeName.setSelectionRange(0, placeName.value.length);
      placeGPS = select(".placeGPS");
      placeDescription = select(".placeDescription");
    }
  }

  void _selectInMap([Event _]) {
    js.context.callMethod("registerPlaceCallback", [(js.JsObject latLng) {
      centralWidget.maximizePanel();
      if (!place.parseGPS(latLng.toString())) {
        throw new Exception("gps from map picking invalid");
      }
      placeGPS.value = place.formattedGps();
    }
    , place.latitude, place.longitude
    ]);
    centralWidget.minimizePanel();
  }

  void sendForm() {
    bool valid = true;
    if (placeName.value.isEmpty) {
      placeName.classes.add("invalid");
      valid = false;
    } else {
      place.name = placeName.value;
      placeName.classes.remove("invalid");
    }
    if (place.parseGPS(placeGPS.value)) {
      placeGPS.classes.remove("invalid");
    } else {
      placeGPS.classes.add("invalid");
      valid = false;
    }
    place.description = placeDescription.value;
    if (valid) {
      place.persist();
      editMode = false;
      requestRepaint();
    } else {}
  }

  @override
  Map out() {
    Map out = place.toFullMap();
    out["showDetail"] = expanded;
    out["region"] = "some region";
    out["isEdit"] = editMode;
    if (place.description == null || place.description.isEmpty) {
      out["description"] = widgetLang["noDescription"];
    }
    out["haveEvent"] = place.eventId != null;
    out["descriptionToEdit"] = place.description;
    out["lang"] = widgetLang;
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }
}
