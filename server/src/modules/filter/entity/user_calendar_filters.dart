part of filter_module.entity;

class UserMailingFilter extends FilterBase<User> {
  DateTime _today;
  String filterType = TABLE_USERS;

  UserMailingFilter(List data) : super("userMailing", const ["int"], data);

  @override
  void fromList(List jsonArray) {
    _today = new DateTime.fromMillisecondsSinceEpoch(jsonArray.first);
  }

  @override
  bool match(User entity) {
    if (!entity.clientSettings.containsKey("mailer")) {
      return _today.weekday == (entity.id % 3 + 1);
    }
    dynamic mailerMap = entity.clientSettings["mailer"];
    if (mailerMap is Map<String, dynamic>) {
      Map<String, dynamic> mailerSetting = mailerMap;
      if (mailerSetting["firstDate"] == null || mailerSetting["frequency"] == null || mailerSetting["frequency"] == 0)
        return false;
      DateTime firstDate = new DateTime.fromMillisecondsSinceEpoch(mailerSetting["firstDate"]);
      if (_today.isBefore(firstDate)) return false;
      if (mailerSetting["isMonth"] == true) {
        if (_today.day != firstDate.day) return false;
        if (_today.month - firstDate.month % mailerSetting["frequency"] == 0) return true;
      } else {
        if (_today
            .difference(firstDate)
            .inDays % mailerSetting["frequency"] == 0) return true;
      }
    }
    return false;
  }

  @override
  String get sqlConstraint => "()";
}
