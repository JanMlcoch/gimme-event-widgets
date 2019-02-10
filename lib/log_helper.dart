library akcnik.log_helper;

import 'package:logging/logging.dart' as log;

enum LogLevel { ALL, FINEST, FINER, FINE, CONFIG, INFO, WARNING, SEVERE, SHOUT, OFF }

void rootLoggerPrint({bool info: false,
log.Level level: null,
bool all: false,
bool finer: false,
bool fine: false,
bool warning: false}) {
  log.hierarchicalLoggingEnabled = true;
//  if (level == null) {
//    level = log.Level.INFO;
//    if (warning) level = log.Level.WARNING;
//    if (fine) level = log.Level.FINE;
//    if (finer) level = log.Level.FINER;
//    if (all) level = log.Level.ALL;
//  }
//  print("---- LOGGER inited with level ${level.name}");
//  log.Logger.root
//    ..level = level
//    ..clearListeners()
//    ..onRecord.listen((log.LogRecord record) {
//      print(record);
//    });
}

class RootLogger {
  static RootLogger _instance;
  Map<String, log.Level> levels = {};
  static const Map<LogLevel, log.Level> logLevelMapping = const {
    LogLevel.ALL: log.Level.ALL,
    LogLevel.FINEST: log.Level.FINEST,
    LogLevel.FINER: log.Level.FINER,
    LogLevel.FINE: log.Level.FINE,
    LogLevel.CONFIG: log.Level.CONFIG,
    LogLevel.INFO: log.Level.INFO,
    LogLevel.WARNING: log.Level.WARNING,
    LogLevel.SEVERE: log.Level.SEVERE,
    LogLevel.SHOUT: log.Level.SHOUT,
    LogLevel.OFF: log.Level.OFF
  };
  static const Map<String, log.Level> stringMapping = const {
    "ALL": log.Level.ALL,
    "FINEST": log.Level.FINEST,
    "FINER": log.Level.FINER,
    "FINE": log.Level.FINE,
    "CONFIG": log.Level.CONFIG,
    "INFO": log.Level.INFO,
    "WARNING": log.Level.WARNING,
    "SEVERE": log.Level.SEVERE,
    "SHOUT": log.Level.SHOUT,
    "OFF": log.Level.OFF
  };

  static log.Level _logLevelToLevel([LogLevel logLevel]) => logLevelMapping[logLevel] ?? LogLevel.INFO;

  static log.Level _stringToLevel(String text) => stringMapping[text] ?? LogLevel.INFO;

  static RootLogger init({LogLevel logLevel, String text, log.Level level}) {
    if (_instance != null) return _instance;
    if (level != null) {} else if (text != null) {
      level = _stringToLevel(text);
    } else {
      level = _logLevelToLevel(logLevel);
    }
    _instance = new RootLogger._(level);
    return _instance;
  }

  RootLogger._(log.Level level) {
    log.hierarchicalLoggingEnabled = true;
    log.Logger.root
      ..level = level
      ..clearListeners()
      ..onRecord.listen((log.LogRecord record) {
        print(record);
      });
  }

  log.Logger addSubLevel(String path, LogLevel logLevel) {
    if (levels[path] != null) return new log.Logger(path);
    levels[path] = _logLevelToLevel(logLevel);
    return new log.Logger(path)
      ..level = levels[path];
  }
}
