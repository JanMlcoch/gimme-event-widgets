part of sidos.scheduler;

typedef void ProcessTask(Task task, int priority);
typedef void SendEnvelope(SidosSocketEnvelope envelope, Socket socket);
typedef void LogTask(Task task);

///[Scheduler] class is responsible for scheduling and prioritizing of [Task]s.
///
///priorities: 0 - waiting, 1 - idle, 2 - for the time being saved for Tasks with unordinarily
///low priority, 3 - low priority, 5 - free user high priority.
class Scheduler {
  static Scheduler _instance;
  log.Logger logger = new log.Logger("sidos.scheduler");

  ///Before using, [Scheduler] should always be initialised by this function.
  static void init(ProcessTask processTask, SendEnvelope sendEnvelope, {LogTask logTask: null}) {
    _instance = new Scheduler();
    _instance._processTask = processTask;
    _instance._logTask = logTask == null ? (_){} : logTask;
    _instance.setSendEnvelope(sendEnvelope);
    _instance.addTask(new Idle(), 1);
    _instance._chooseNextTask();
  }

  static void reset() {
    ProcessTask processTask = _instance._processTask;
    LogTask logTask = _instance._logTask;
    SendEnvelope sendEnvelope = _instance._sendEnvelope;
    _instance = new Scheduler();
    _instance._processTask = processTask;
    _instance._logTask = logTask;
    _instance.setSendEnvelope(sendEnvelope);
    _instance.addTask(new Idle(), 1);
    _instance._chooseNextTask();
  }

  ///This getter provides singleton instance of class [Scheduler]. When [_instance] is [null], this will give default value to [_processTask].
  static Scheduler get instance {
    if (_instance == null) {
      _instance = new Scheduler();
      _instance._processTask = (_, _nope) {};
      _instance.addTask(new Idle(), 1);
      _instance._chooseNextTask();
    }
    return _instance;
  }

  ///[List] of [function] that will execute on [addTask]
  List<Function> onAddTask = [];

  ///All [Task]s that are known to be in need of processing
  List<Queue<Task>> _taskQueue = [];

  ///[Function], specifically [ProcessTask], that will be called upon [Task] when its time had come.
  ProcessTask _processTask; // = (_,_nope){};

  ///sets [LogTask] ([_logTask]) that will be called upon [Task] completion to log it.
  void setLogTask(LogTask logTask) {
    _logTask = logTask;
  }

  ///[Function], specifically [LogTask], that will be called upon [Task] completion to log it.
  LogTask _logTask;

  ///sets [ProcessTask] that will be called upon [Task] when its time had come ([_processTask]).
  void setProcessTaskFunction(ProcessTask processTask) {
    _processTask = processTask;
  }

  ///[Function], specifically [SendEnvelope], that will be called upon [Task] completion.
  SendEnvelope _sendEnvelope; // = (_,_nope){};

  ///sets [SendEnvelope] ([_sendEnvelope]) that will be called upon [Task] when its processing is finished (and it is not specified to not do this yet).
  void setSendEnvelope(SendEnvelope sendEnvelope) {
    _sendEnvelope = sendEnvelope;
  }

  ///If there is en equivalent [Task] in [_taskQueue], this merges with that
  ///[Task] using newer [data] and higher priority.
  void addTask(Task task, int priority) {
//    print("something added");
    bool isBroken = false;
//    for (Queue<Task> queue in _taskQueue) {
//      isBroken = false;//_findAndMergeTaskInQueue(task, queue, priority);
//      if (isBroken) {
//        break;
//      }
//    }
    if (!isBroken) {
      task.whenCataloged = new DateTime.now();
      _scheduleTask(task, priority);
    }
    for (Function f in onAddTask) {
      f();
    }
    onAddTask.clear();
  }

  ///method to indicate, that [Task] that was currently being processed is now finished
  void taskFinished() {
    bool isBroken = false;
    for (Queue<Task> queue in _taskQueue) {
      isBroken = _finishTaskIfFoundInQueue(queue);
      if (isBroken) {
        break;
      }
    }
    _chooseNextTask();
  }

  ///Chooses Next [Task] to be processed
  Future _chooseNextTask() async{
    if (_taskQueue.isEmpty) {
      addTask(new Idle(), 1);
    }
    while (_taskQueue.last.isEmpty) {
      _taskQueue.removeLast();
      if (_taskQueue.isEmpty) {
        addTask(new Idle(), 1);
      }
    }
    Task nextTask = _taskQueue.last.last;
    int priority = _taskQueue.indexOf(_taskQueue.last);
    nextTask.isBeingProcessed = true;
    nextTask.whenProcessingStarted = new DateTime.now();
    logger.fine("nextTaskChosen is a ${nextTask.getType()}");
    logger.fine("priority is $priority");
    if (nextTask is Idle) {
        Scheduler.instance.addTask(new Idle(),1);
        Completer completer = new Completer();
        Scheduler.instance.onAddTask.add(() {
          completer.complete();
        });
        await completer.future;
    } else {
      await _processTask(nextTask, priority);
    }
    Scheduler.instance.taskFinished();
//    Brain.instance.processTask(nextTask, priority);
  }

  void _scheduleTask(Task task, int priority) {
    while (_taskQueue.length <= priority) {
      _taskQueue.add(new Queue());
    }
    _taskQueue[priority].addFirst(task);
  }

  bool _finishTaskIfFoundInQueue(Queue<Task> queue) {
    bool isBroken = false;

    for (Task taskInQueue in queue) {
      isBroken = _finishTaskIfEqual(taskInQueue, queue);
      if (isBroken) {
        break;
      }
    }
    return isBroken;
  }

  bool _finishTaskIfEqual(Task taskInQueue, Queue<Task> queue) {
    bool isBroken = false;
    if (taskInQueue.isBeingProcessed) {
      taskInQueue.whenProcessingFinished = new DateTime.now();
      _logTask(taskInQueue);
      queue.remove(taskInQueue);
      isBroken = true;
    }
    return isBroken;
  }
}
