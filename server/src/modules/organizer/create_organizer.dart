part of organizerModule;

void _bindCreateOrganizer() {
  libs.route(CONTROLLER_CREATE_ORGANIZER, () => new CreateOrganizerRC(),
      method: "POST", template: {"name": "string"}, permission: Permissions.CREATE_ORGANIZER);
}

class CreateOrganizerRC extends libs.RequestContext {
  Future validate() {
    return null;
  }

  @override
  Future<dynamic> execute() async {
    envelope.error(NOT_IMPLEMENTED);
    return null;
//    Organizer organizer = await model.organizers.create(data);
//    return writeJson(organizer.toFullMap());
  }
}
