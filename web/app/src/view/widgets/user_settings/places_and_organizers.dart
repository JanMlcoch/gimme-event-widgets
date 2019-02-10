part of view;

class UserSettingsPlacesAndOrganizersWidget extends UserSettingsSubWidget {
  UserSettingsModel model;
  ClientPlaces places;
  CentralWidget centralWidget;
  bool placesOrdered = false;

  @override
  String get myRoute => UserSettingsModel.PLACES;

  UserSettingsPlacesAndOrganizersWidget(this.centralWidget) {
    img = "images/icons/map.png";
    className = "placesAndOrganizers";
    iClass = "settingsPlaceAndOrganizator";
    template = parse(resources.templates.userSettings.placesAndOrganizers);
    model = layoutModel.centralModel.userSettingsModel;
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  void functionality() {
    if (!placesOrdered) {
      model.downloadMyPlaces().then((ClientPlaces p) {
        places = p;
        createChildrenFromPlaces();
        subscribeForPlacesChange();
        model.myPlaces.onNewPlaces.add(() {
          children.clear();
          createChildrenFromPlaces();
          requestRepaint();
        });
        requestRepaint();
      });
      placesOrdered = true;
    }
  }

  void createChildrenFromPlaces() {
    for (ClientPlace place in places.list) {
      children.add(new PlaceCardWidget(place, centralWidget));
    }
  }

  void subscribeForPlacesChange() {
    places.onNewPlaces.add(() {
      children.clear();
      createChildrenFromPlaces();
      requestRepaint();
    });
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.userSettings.placesAndOrganizers.toMap();
    out["places"] = _getPlaces();
    return out;
  }

  List _getPlaces() {
    if (places == null) {
      return [];
    }
    List out = [];
    for (ClientPlace place in places.list) {
      out.add(place.id);
    }
    return out;
  }

  @override
  void setChildrenTargets() {
    for (PlaceCardWidget child in children) {
      child.target = select(".placeContainer${child.place.id}");
    }
  }
}