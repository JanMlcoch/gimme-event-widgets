part of mailer.periodic.recommended;

const userColumns = const ["id", "name", "surname", "maleGender", "serverSettings"];
const bool testRun = true;

Future dayCrunch(storage_lib.DataStorage storage) async {
  common_filter.RootFilter filter = new entity_filter.UserMailingFilter([new DateTime.now().millisecondsSinceEpoch])
      .upgrade();
  Users users = await storage.connectHandler((storage_lib.Connection connection) {
    return connection.users.load(null, userColumns, limit: testRun ? 3 : -1);
  });
  new log.Logger("akcnik.mailer.cruncher.day").info("Emails will be send for ${users.length}");
  QueueManager manager = new QueueManager();
  if (!testRun) {
    users = filter.filter(users);
  }
  users.list.forEach((User user) {
    manager.addAsyncTask(new RecommendTask(user, storage));
  });
  return manager.start();

//  int counter = 0;
//  await Future.wait(users.list.map((User user) =>
//      sendEmailForUser(user, storage).then((bool result) {
//        counter++;
//        logger.fine("${user.login} DONE ($counter/${users.length})");
//      })));
}
