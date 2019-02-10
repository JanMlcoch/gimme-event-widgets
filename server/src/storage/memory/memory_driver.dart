part of storage.memory;

class MemoryDriver {
  ModelRoot _model;
  MemoryDriver(this._model);

  ModelRoot get model => _model;

  void replaceModel(ModelRoot modelRoot) {
    _model = modelRoot;
  }

//  void loadJson(Map<String, List<Map>> json) {
//    _model.events = new Events()..fromList(json["events"]);
//    _model.places = new Places()
//      ..fromList(json["places"]);
//    _model.users = new Users()
//      ..fromList(json["users"]);
//    _model.organizers = new Organizers()
//      ..fromList(json["organizers"]);
//  }
}
