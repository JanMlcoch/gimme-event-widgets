part of sidos.computor;
///this class's duty is to catalog information of function of sidos, and analyze
///various data for both automatic upgrades to matching mechanism and incentives
///for developers to provide additional data for critical entities.
class Evolutor {
  static Evolutor _instance;

  static Evolutor get instance {
    if (_instance == null) {
      _instance = new Evolutor();
    }
    return _instance;
  }

  Logger _logger;

  Evolutor() {
    _logger = new Logger();
  }

  ///Returns [Log] jsonable [Map] (in the meaning of [_logger.log])
  Map<String, dynamic> getJsonableLog(){
    return _logger.log.toFullMap();
  }

  ///Clears current [Log] (in the meaning of [_logger.log])
  void clearLog(){
    _logger.log = new Log([]);
  }

  ///Logs information about [Task][task]
  void logTask(Task task){
    _logger.log.list.add(new LogEntry.fromTask(task));
  }
}
