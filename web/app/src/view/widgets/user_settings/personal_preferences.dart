part of view;

class UserSettingsPersonalPreferencesWidget extends UserSettingsSubWidget {
  @override
  String get myRoute => UserSettingsModel.PERSONAL;

  UserSettingsPersonalPreferencesWidget() {
    img = "images/icons/heart.png";
    className = "personal";
    iClass = "settingsPersonalPreferences";
    template = parse(resources.templates.userSettings.personalPreferences);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void functionality() {
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.userSettings.personalPreferences.toMap();
    out["tags"] = _getTags();
    return out;
  }

  List _getTags() {
    List tags = <Map>[];
    Map tag1 = {};
    Map tag2 = {};
    Map tag3 = {};
    tag1["name"] = "Rock";
    tag2["name"] = "Outdoor";
    tag3["name"] = "Long night";
    tags.add(tag1);
    tags.add(tag2);
    tags.add(tag3);
    return tags;
  }

  @override
  void setChildrenTargets() {
    // TODO: implement setChildrenTargets
  }
}