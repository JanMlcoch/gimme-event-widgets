part of eventModule;

void _bindDeleteEvent() {
  var editDataTemplate = {
    "id": "int"
  };
  libs.route(CONTROLLER_DELETE_EVENT, () => new DeleteEventRC(),
      method: "POST", template: editDataTemplate, permission: Permissions.DELETE_EVENT);
}

class DeleteEventRC extends libs.RequestContext {
  Event event;
  static const List<String> eventColumns = const [
    "id",
    "deleted"
  ];
  static const List<String> allowedColumns = const [
    "deleted"
  ];

  Future validate() async {
    return null;
  }

  @override
  Future execute() async {
    Map<String, dynamic> modifiedEventMap = await connection.events.deleteModel({
      "id": data["id"]});
    if (modifiedEventMap == null) {
      envelope.error(DATABASE_ERROR);
      return null;
    }
    new log.Logger("akcnik.server.context.deletedEvents").info(
        convert.JSON.encode(modifiedEventMap)
    );
    envelope.withMap((new Event()
      ..fromMap(modifiedEventMap)).toSafeMap());
    return null;
  }
}
