part of view;

class UserSettingsWidget extends Widget {
  Element settingsContentElement;
  Element userBase;
  Element userEvents;
  Element userCalendar;
  Element userPersonal;
  Element userPlacesAndOrganizers;
  Element userSocial;
  UserSettingsBaseWidget userBaseWidget;
  UserSettingsMyEventsWidget userEventWidget;
  UserSettingsCalendarWidget userCalendarWidget;
  UserSettingsPersonalPreferencesWidget userPersonalWidget;
  UserSettingsPlacesAndOrganizersWidget userPlacesAndOrganizersWidget;
  UserSettingsSocialWidget userSocialWidget;
  Element activeMenuItem;
  UserSettingsModel model;
  List<UserSettingsSubWidget> possibleChildren;
  CentralWidget centralWidget;

  UserSettingsWidget(this.centralWidget) {
    model = layoutModel.centralModel.userSettingsModel;
    template = parse("""
    <div class="settingsMainContainer">
      <nav class="settingsLeftMenu">
        {{#menuData}}
          <div class="settingsMenuItem {{class}}{{#isActive}} active{{/isActive}}">
            <i class="{{iClass}}">
              <img src="{{img}}" />
            </i>
          </div>
        {{/menuData}}
      </nav>
      <div class="settingsContent"></div>
    </div>
    """);
    userBaseWidget = new UserSettingsBaseWidget();
    userEventWidget = new UserSettingsMyEventsWidget();
    userCalendarWidget = new UserSettingsCalendarWidget();
    userPersonalWidget = new UserSettingsPersonalPreferencesWidget();
    userPlacesAndOrganizersWidget = new UserSettingsPlacesAndOrganizersWidget(centralWidget);
    userSocialWidget = new UserSettingsSocialWidget();
    possibleChildren = [
      userBaseWidget,
      userEventWidget,
      userCalendarWidget,
      userPersonalWidget,
      userPlacesAndOrganizersWidget,
      userSocialWidget
    ];
    _resolveChildren();
    model.onChange.add(() {
      _resolveChildren();
      requestRepaint();
    });
  }

  void _resolveChildren() {
    if (model.inBase) {
      children = [userBaseWidget];
    }
    if (model.inEvents) {
      children = [userEventWidget];
    }
    if (model.inCalendar) {
      children = [userCalendarWidget];
    }
    if (model.inPersonal) {
      children = [userPersonalWidget];
    }
    if (model.inPlaces) {
      children = [userPlacesAndOrganizersWidget];
    }
    if (model.inSocial) {
      children = [userSocialWidget];
    }
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    Map out = lang.userSettings.toMap();
    List menuData = [];
    for (UserSettingsSubWidget widget in possibleChildren) {
      menuData.add({
        "img": widget.img,
        "class": widget.className,
        "iClass": widget.iClass,
        "isActive": widget.myRoute == model.subRoute
      });
    }
    out["menuData"] = menuData;
    return out;
  }

  @override
  void setChildrenTargets() {
    userBaseWidget.target = settingsContentElement;
    userEventWidget.target = settingsContentElement;
    userCalendarWidget.target = settingsContentElement;
    userPersonalWidget.target = settingsContentElement;
    userPlacesAndOrganizersWidget.target = settingsContentElement;
    userSocialWidget.target = settingsContentElement;
  }

  void changeChildren(String route) {
    model.setRoute(route);
    _resolveChildren();
    requestRepaint();
  }

  @override
  void functionality() {
    settingsContentElement = target.querySelector(".settingsContent");
    userBase = target.querySelector(".settingsMenuItem.base");
    userEvents = target.querySelector(".settingsMenuItem.events");
    userPlacesAndOrganizers = target.querySelector(".settingsMenuItem.placesAndOrganizers");
    userPersonal = target.querySelector(".settingsMenuItem.personal");
    userCalendar = target.querySelector(".settingsMenuItem.calendar");
    userSocial = target.querySelector(".settingsMenuItem.social");

    userBase.onClick.listen((_) {
      changeChildren("");
    });

    userEvents.onClick.listen((_) {
      changeChildren(UserSettingsModel.EVENTS);
    });

    userPlacesAndOrganizers.onClick.listen((_) {
      changeChildren(UserSettingsModel.PLACES);
    });

    userPersonal.onClick.listen((_) {
      changeChildren(UserSettingsModel.PERSONAL);
    });

    userCalendar.onClick.listen((_) {
      changeChildren(UserSettingsModel.CALENDAR);
    });

    userSocial.onClick.listen((_) {
      changeChildren(UserSettingsModel.SOCIAL);
    });
  }
}

abstract class UserSettingsSubWidget extends Widget {
  String img;
  String className;
  String iClass;

  String get myRoute;
}
