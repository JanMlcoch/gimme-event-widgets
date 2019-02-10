part of eventModule;

void _saveImage(Event event, String body) {
  String prefix = "data:image/png;base64,";
  String bStr = body.substring(prefix.length);
  List<int> bytes = convert.BASE64.decode(bStr);

  new io.File('web/app/images/events_images/event_avatar_${event.id}.png')
    ..createSync()
    ..writeAsBytesSync(bytes);
}
