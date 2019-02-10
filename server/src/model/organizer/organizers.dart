part of model;

class Organizers extends ModelList<Organizer> {
  String type = "organizers";

  Organizer getById(int id) {
    return _map[id];
  }

  @override
  Organizer entityFactory() => new Organizer();

  @override
  Organizers copyType() => new Organizers();
}
