part of sidos.scheduler.task_completer;

class Requirement {
  static const String _TYPE_IMPRINT = "TYPE_IMPRINT";
  static const String _TYPE_MISSING_BASE_COST = "TYPE_MISSING_BASE_COST";
  static const String _TYPE_MISSING_EVENT_PLACE = "TYPE_MISSING_EVENT_PLACE";
  static const String _TYPE_MISSING_VISIT_LENGTH = "TYPE_MISSING_VISIT_LENGTH";
  static const String _TYPE_MISSING_USER_POINTS_OF_ORIGIN = "TYPE_MISSING_USER_POINTS_OF_ORIGIN";
  static const String _TYPE_MISSING_USER_PATTERN = "TYPE_MISSING_USER_PATTERN";
  static const String _TYPE_MISSING_FIT_INDEX = "_TYPE_MISSING_FIT_INDEX";
  String _type;
  int _imprintEventId;
  int _userId;

  Requirement.fitIndex(this._userId, this._imprintEventId) {
    _type = _TYPE_MISSING_FIT_INDEX;
  }

  Requirement.imprint(this._imprintEventId) {
    _type = _TYPE_IMPRINT;
  }

  Requirement.baseCost(this._imprintEventId) {
    _type = _TYPE_MISSING_BASE_COST;
  }

  Requirement.eventPlace(this._imprintEventId) {
    _type = _TYPE_MISSING_EVENT_PLACE;
  }

  Requirement.visitLength(this._imprintEventId) {
    _type = _TYPE_MISSING_VISIT_LENGTH;
  }

  Requirement.pointsOfOrigin(this._userId) {
    _type = _TYPE_MISSING_USER_POINTS_OF_ORIGIN;
  }

  Requirement.pattern(this._userId) {
    _type = _TYPE_MISSING_USER_PATTERN;
  }

  bool _equals(Requirement requirement) {
    TaskCompleter.instance.logger
        .finest("Testing equivalence of requirements ${requirement?.toMap()} and ${this.toMap()}");
    if (requirement == null) {
      return false;
    }
    if(_type == _TYPE_MISSING_FIT_INDEX){
      return requirement._userId == _userId && requirement._imprintEventId == _imprintEventId;
    }
    if (_type != _TYPE_MISSING_USER_POINTS_OF_ORIGIN && _type != _TYPE_MISSING_USER_PATTERN) {
      bool typeMatch = requirement._type == _type;
      bool imprintEventIdMatch = _imprintEventId == requirement._imprintEventId;
      TaskCompleter.instance.logger.finest("And the answer is: ${typeMatch && imprintEventIdMatch}");
      return typeMatch && imprintEventIdMatch;
    } else {
      bool typeMatch = requirement._type == _type;
      bool userIdMatch = _userId == requirement._userId;
      TaskCompleter.instance.logger.finest("And the answer is: ${typeMatch && userIdMatch}");
      return typeMatch && userIdMatch;
    }
  }

  Map toMap() {
    Map map = {};

    map["type"] = _type;
    map["imprintEventId"] = _imprintEventId;
    map["userId"] = _userId;

    return map;
  }
}
