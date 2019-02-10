part of mailer.queue;

class QueueManager {
  static const int QUEUE_NUMBER = 24;
  final List<Queue> queues;
  int addPointer = 0;
  int processPointer = 0;
  Future lastProcess = new Future.value();

  QueueManager() : queues = initQueues();

  static List<Queue> initQueues() {
    List<Queue> queues = [];
    for (int i = 0; i < QUEUE_NUMBER; i++) {
      queues.add(new Queue());
    }
    return queues;
  }

  void addTask(QueueTask task) {
    queues[addPointer].addTask(task);
    addPointer++;
    if (addPointer >= QUEUE_NUMBER) addPointer = 0;
  }

  void addAsyncTask(QueueTask task) {
    queues[addPointer].addAsyncTask(task);
    addPointer++;
    if (addPointer >= QUEUE_NUMBER) addPointer = 0;
  }

  Future start() {
    return periodicTimer(new Duration(milliseconds: 100), round);
  }

  Future round(CancelCallback cancel) {
    int pointer = processPointer;
    lastProcess.then((_) {
      lastProcess = queues[pointer].start();
    });
    processPointer++;
    if (processPointer >= QUEUE_NUMBER) {
      cancel(lastProcess);
    }
    return lastProcess;
  }
}
