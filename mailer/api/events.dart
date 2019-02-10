part of server.mailer;

Future<bool> sendRecommendedEventsEmail(User user, Events events) {
  Map<String, String> partials = {
    "content": resources.resources.templates.emailer.recommendedEvents,
    "event":resources.resources.templates.emailer.event
  };
  Lang lang = resources.getLangByShortcut(user.language);
  List<Map<String, dynamic>> eventList = [];
  DateFormat formatter = new DateFormat(lang.datePicker.dartDateFormat);
  for (Event event in events.list) {
    eventList.add({
      "id":event.id,
      "name":event.name,
      "from":formatter.format(event.from),
      "annotation":event.annotation
    });
  }
  Map<String, dynamic> data = {
    "events":eventList,
    "emailType":"recommended_events"
  };
  return sendEmail(user, data, partials);
}
