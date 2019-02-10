part of sidos.scheduler;

class HardCacheTask extends Task {
  @override
  bool validate() {
    return true;
  }

  @override
  bool equals(o) {
    return o is HardCacheTask;
  }
}

class HardLogTask extends Task {
  @override
  bool validate() {
    return true;
  }

  @override
  bool equals(o) {
    return o is HardLogTask;
  }
}

class LoadHardCacheTask extends Task {
  @override
  bool validate() {
    return true;
  }

  @override
  bool equals(o) {
    return o is LoadHardCacheTask;
  }
}
