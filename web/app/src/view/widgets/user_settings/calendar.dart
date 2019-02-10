part of view;

class UserSettingsCalendarWidget extends UserSettingsSubWidget {
  @override
  String get myRoute => UserSettingsModel.CALENDAR;

  UserSettingsCalendarWidget() {
    img = "images/icons/calendar.png";
    className = "calendar";
    iClass = "settingsCalendar";
    template = parse(resources.templates.userSettings.calendar);
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
    out["lang"] = lang.userSettings.calendar.toMap();
    out["calendarUrl"] = "dflksdfjsdlf";
    return out;
  }

  @override
  void setChildrenTargets() {
    // TODO: implement setChildrenTargets
  }
}