part of mailer.queue;

class Queue {
  List<QueueTask> tasks = [];
  List<QueueTask> asyncTasks = [];

  void addTask(QueueTask task) => tasks.add(task);

  void addAsyncTask(QueueTask task) => asyncTasks.add(task);

  Future start() {
    return Future.wait(asyncTasks.map((QueueTask task) => task.start())).then((_) {
      return Future.forEach(tasks, (QueueTask task) => task.start());
    });
  }
}
