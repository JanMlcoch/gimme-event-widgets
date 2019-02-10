part of view;

class CityAutocompleteOptionsWidget extends Widget {
  CityAutocompleteModel autocompleteModel;

  CityAutocompleteOptionsWidget(this.autocompleteModel) {
    template = parse(resources.templates.ui.cityAutocomplete.cityAutocompleteOptions);
  }

  @override
  void functionality() {
    ElementList options = target.querySelectorAll(".cityAutocompleteOptionItem");
    for (Element option in options) {
      option.onClick.listen((_) {
        selectNewCity(option);
      });
    }
  }

  void selectNewCity(Element option) {
    String placeId = option.dataset["id"];
    CityAutocompleteOptionModel selectedOption = autocompleteModel.getOptionByPlaceId(placeId);
    autocompleteModel.addCity(selectedOption);
    autocompleteModel.clear();
  }

  @override
  Map out() {
    Map out = {};
    List options = [];
    for (CityAutocompleteOptionModel optionModel in autocompleteModel.points) {
      Map option = {};
      option["cityName"] = optionModel.description;
      option["placeId"] = optionModel.placeId;
      options.add(option);
    }
    out["options"] = options;
    out["empty"] = options.isEmpty;
    return out;
  }

  @override
  void setChildrenTargets() {}

  @override
  void destroy() {}
}