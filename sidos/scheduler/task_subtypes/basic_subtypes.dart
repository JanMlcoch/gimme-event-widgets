part of sidos.scheduler;

class UpdateImprintTask extends Task {
  @override
  bool validate() {
    return (data.eventId != null && data.tags != null);
  }

  @override

  ///two [UpdateImprint] [Task]s are equal, when they are to update
  ///Imprint of the same Event.
  bool equals(o) {
    bool isEqual = false;
    if (o is UpdateImprintTask) {
      if (this.validate() && o.validate()) {
        isEqual = data.eventId == o.data.eventId;
      }
    }
    return isEqual;
  }
}

class UpdatePatternTask extends Task {
  @override
  bool validate() {
    return (data.userId != null);
  }

  @override
  bool equals(o) {
    bool isEqual = false;
    if (o is UpdatePatternTask) {
      if (this.validate() && o.validate()) {
        isEqual = data.userId == o.data.userId;
//        print("equality: $isEqual");
      }
    }
    return isEqual;
  }
}

class AttendTask extends Task {
  @override
  bool validate() {
    return (data.userId != null && data.eventId != null);
  }

  @override
  bool equals(o) {
    bool isEqual = false;
    if (o is AttendTask) {
      if (this.validate() && o.validate()) {
        isEqual = data.userId == o.data.userId && data.eventId == o.data.eventId;
      }
    }
    return isEqual;
  }
}

class Idle extends Task {
  @override
  bool validate() {
    return true;
  }

  @override
  bool equals(o) {
    return o is Idle;
  }
}

class ComputeFitIndexTask extends Task {
  @override
  bool validate() {
    return data.userId != null && data.eventId != null;
  }

  @override
  bool equals(Task o) {
    bool isEqual;
    isEqual = (o is ComputeFitIndexTask) && data.userId == o.data.userId && data.eventId == o.data.eventId;
    return isEqual;
  }
}

///this descendant of [Task] should be use only for small set of events, for larger sets use [MassSortEventsTask]
class SortFewEventsTask extends Task {
  @override
  bool validate() {
    return data.userId != null && data.eventIds != null;
  }

  @override
  bool equals(Task o) {
    bool isEqual;
    isEqual = (o is SortFewEventsTask) && data.userId == o.data.userId && data.eventIds == o.data.eventIds;
    return isEqual;
  }
}

class MassSortEventsTask extends Task {
  @override
  bool validate() {
    return data.userId != null && data.eventIds != null;
  }

  @override
  bool equals(Task o) {
    bool isEqual;
    isEqual = (o is MassSortEventsTask) && data.userId == o.data.userId && data.eventIds == o.data.eventIds;
    return isEqual;
  }
}

class TestTask extends Task {
  @override
  bool validate() {
    return true;
  }

  @override
  bool equals(o) {
    return false;
  }
}

