part of server_common;

void initServerLogger() {
  log_helper.RootLogger logger = log_helper.RootLogger.init(logLevel: log_helper.LogLevel.FINE);
  File _logFile = new File("${io_helper.getProjectDirectoryName()}/logs/applog.txt")..createSync(recursive: true);
  File _deletedEventsLogFile = new File("${io_helper.getProjectDirectoryName()}/logs/deleted_events.txt")
    ..createSync(recursive: true);

  logger.addSubLevel("akcnik.server.context", log_helper.LogLevel.INFO);

  IOSink _logFileIO = _logFile.openWrite(mode: FileMode.APPEND);
  IOSink _deletedEventsLogFileIO = _deletedEventsLogFile.openWrite(mode: FileMode.APPEND);

  logger.addSubLevel("akcnik.server", log_helper.LogLevel.FINE)
    ..onRecord.listen((log.LogRecord record) {
      _logFileIO.writeln("${record.time.toIso8601String()} - ${record.toString()}");
    });

  logger.addSubLevel("akcnik.server.context.deletedEvents", log_helper.LogLevel.FINE)
    ..onRecord.listen((log.LogRecord record) {
      _deletedEventsLogFileIO.writeln("${record.time.toIso8601String()} - \n${record.toString()}\n");
    });
}
