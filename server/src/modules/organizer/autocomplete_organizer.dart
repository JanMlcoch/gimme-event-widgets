part of organizerModule;

void _bindAutocompleteOrganizer() {
  libs.route(CONTROLLER_AUTOCOMPLETE_ORGANIZER, () => new AutocompleteOrganizerRC(),
      method: "POST", template: {"substring": "string"});
}

class AutocompleteOrganizerRC extends libs.RequestContext {
  Future validate() {
    return null;
  }

  @override
  Future<dynamic> execute() {
//    List<Organizer> organizers = new CompositeOrganizerFilter().construct([
//      {
//        "name": "subname",
//        "data": [data["substring"]]
//      }
//    ]).filter(model.organizers.list);
////    List<Organizer> organizers = model.organizers.filter(data["substring"]);
//    List<Map> organizersJson = [];
//    organizers.forEach((Organizer organizer){
//      organizersJson.add(organizer.toJson());
//    });
//    return writeJson(organizersJson);
    envelope.error(NOT_IMPLEMENTED);
    return null;
  }
}
