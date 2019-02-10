part of view;

class CityAutocompleteWidget extends Widget {
  CityAutocompleteModel autocompleteModel;
  InputElement _autocompleteInput;
  Element _autocompleteChangeValue;
  Element _autocompleteOptionsContainer;
  CityAutocompleteOptionsWidget cityAutocompleteOptionsWidget;
  ClientUser userModel;
  List<StreamSubscription> subs = [];
  bool showInput = true;

  PointOfOrigin get selectedPointOfOrigin => userModel.selectedPointOfOrigin;

  CityAutocompleteWidget(this.userModel) {
    template = parse(resources.templates.ui.cityAutocomplete.cityAutocomplete);
    autocompleteModel = new CityAutocompleteModel(userModel);
    cityAutocompleteOptionsWidget = new CityAutocompleteOptionsWidget(autocompleteModel);
    children = [cityAutocompleteOptionsWidget];
    userModel.onPointsOfOriginLoaded.add(_registerPointsOfOrigin);
    subs.add(userModel.pointsOfOrigin.onAddPoint.listen((_) {
      showInput = false;
      repaintRequested = true;
    }));
  }

  void _registerPointsOfOrigin() {
    showInput = userModel.pointsOfOrigin.points.isEmpty;
  }

  @override
  void destroy() {
    subs.forEach((StreamSubscription sub) => sub.cancel());
  }

  @override
  void functionality() {
    _autocompleteInput = select(".cityAutocompleteInput");
    _autocompleteChangeValue = select(".cityAutocompleteChange");
    _autocompleteOptionsContainer = select(".cityAutocompleteOptionsContainer");

    _autocompleteInput.onKeyUp.listen((_) {
      updateFoundCities(_autocompleteInput.value);
    });
    _autocompleteChangeValue.onClick.listen((_) {
      showInput = true;
      repaintRequested = true;
    });
  }

  Future updateFoundCities(String subString) async {
    Map citiesJson = await model.user.getResidencesForAutocomplete(subString);
    autocompleteModel.fromMap(citiesJson);
    cityAutocompleteOptionsWidget.repaintRequested = true;
  }

  @override
  Map out() {
    Map out = {};
    out["showInput"] = showInput;
    if (selectedPointOfOrigin != null) {
      out["selectedCity"] = selectedPointOfOrigin.description;
    } else {
      out["selectedCity"] = null;
    }
    out["editImageSRC"] = "images/settings_images/editPenTool.png";
    return out;
  }

  @override
  void setChildrenTargets() {
    cityAutocompleteOptionsWidget.target = _autocompleteOptionsContainer;
  }
}