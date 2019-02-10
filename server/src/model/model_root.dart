part of model;

class ModelRoot extends ModelRootBase {
  Users users;
  Events events;
  Tags tags;
//  Mailer mailer;
  SynonymProvider synonymProvider;
  Places places;
  Organizers organizers;

  ModelRoot() {
    users = new Users();
    events = new Events();
    tags = new Tags();
//    mailer = new Mailer();
    synonymProvider = new SynonymProvider();
    places = new Places();
    organizers = new Organizers();

    // TODO: filter editable places list
  }

  @override
  Event getEventById(int id) => events.getById(id);

  @override
  Organizer getOrganizerById(int id) => organizers.getById(id);

//  @override
//  Place getPlaceById(int id) => places.getById(id);

  @override
  User getUserById(int id) => users.getById(id);
}
