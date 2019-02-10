part of sidos.brain;

class AsyncProcessor {
  static AsyncProcessor _instance;
  log.Logger logger = new log.Logger("sidos.brain.asyncProcessor");

  static AsyncProcessor get instance {
    if (_instance == null) {
      _instance = new AsyncProcessor();
    }
    return _instance;
  }

  Directory get projectDir {
    Directory projectDir = Directory.current;
    while (projectDir.parent != null && !projectDir.path.endsWith("akcnik")) {
      projectDir = projectDir.parent;
    }
    return projectDir;
  }

  void _markTaskAsSuccessfullyFinished(Task task, {String addToMessages: "", List<int> eventIds: null}) {
    task.returnData.forEach((socket, envelopes) {
      for (SidosSocketEnvelope envelope in envelopes) {
        envelope.isFinalResponse = true;
        envelope.success = true;
        envelope.message += addToMessages;
        envelope.eventIds = eventIds;
      }
    });
  }

  ///Creates a hard copy of cache ([Cachor])
  Future processHardCacheTask(HardCacheTask task) async {
    // Creates dir/, dir/subdir/, and dir/subdir/file.txt in the system
    // temp directory.
    File file = await new File('${projectDir.path}/sidos/computor/cachor/hard_cache/file.txt').create(recursive: true);

    String toPrint = "";
    JsonEncoder encoder = new JsonEncoder.withIndent("   ");
//    toPrint = encoder.convert(Computor.cacheToFullMap());
    Map cachorJson = Cachor.instance.toPurgedMap();
    try {
      toPrint = encoder.convert(cachorJson);
      file.writeAsStringSync(toPrint);
      _markTaskAsSuccessfullyFinished(task);
    } catch (exception, stackTrace) {
      logger.severe("Cachor failed to encode");
      logger.severe(exception);
      logger.severe(stackTrace);
    }
  }

  Future processHardLogTask(HardLogTask task) async {
    String millisecondsSinceEpochString = new DateTime.now().millisecondsSinceEpoch.toString();
    // Creates dir/, dir/subdir/, and dir/subdir/file.txt in the system
    // temp directory.
    File file =
        await new File('${projectDir.path}/sidos/computor/cachor/hard_cache/log_$millisecondsSinceEpochString.txt')
            .create(recursive: true);

    String toPrint = "";
    JsonEncoder encoder = new JsonEncoder.withIndent("   ");
    Map<String, dynamic> jsonableMap = Evolutor.instance.getJsonableLog();
    Evolutor.instance.clearLog();
    toPrint = encoder.convert(jsonableMap);

    await file.writeAsString(toPrint);
    _markTaskAsSuccessfullyFinished(task);
  }

  Future processLoadHardCacheTask(LoadHardCacheTask task) async {
    // Get the system temp directory.
    Directory systemTempDir = projectDir;
    logger.info("Cache started loading");
    File file = new File('${systemTempDir.path}/sidos/computor/cachor/hard_cache/file.txt');
    if (file.existsSync()) {
      String jsonString =
          new File('${systemTempDir.path}/sidos/computor/cachor/hard_cache/file.txt').readAsStringSync();
      try {
        logger.finest(jsonString);
        Cachor.instance.fromMap(JSON.decode(jsonString));
        logger.info("Cache loaded");
        _markTaskAsSuccessfullyFinished(task);
      } catch (exception, stackTrace) {
        logger.severe("Hard cache failed to encode");
        logger.severe(exception);
        logger.severe(stackTrace);
      }
    } else {
      logger.severe("Cache file not found", 0);
      _markTaskAsSuccessfullyFinished(task);
    }
  }
}
