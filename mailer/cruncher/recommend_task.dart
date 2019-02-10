part of mailer.periodic.recommended;

class RecommendTask extends QueueTask {
  static const eventColumns = const ["id", "name", "from", "to", "annotation"];
  static const eventsInEmail = 10;
  User user;
  storage_lib.DataStorage storage;

  RecommendTask(this.user, this.storage);

  @override
  Future<bool> start() async {
    log.Logger logger = new log.Logger("akcnik.mailer.cruncher.task");
    logger.fine("Send email with recommended events for ${user.login}");
    List<int> sortedIds = await gateway.sortEvents(null, user.id, message: "Sort for periodic mailer");
    if (sortedIds == null) {
      logger.severe("sortedIds is null");
      return false;
    }
    Events pickedEvents = await storage.connectHandler((storage_lib.Connection connection) {
      common_filter.RootFilter filter = new entity_filter.IdListEventFilter([sortedIds]).upgrade();
      return connection.events.load(filter, eventColumns, limit: eventsInEmail);
    });
    return sendRecommendedEventsEmail(user, pickedEvents);
  }
}
