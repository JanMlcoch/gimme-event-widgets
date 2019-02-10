part of common;

abstract class ModelRootBase {
  static ModelRootBase instance;
  static ModelRootBase getModel() {
    return instance;
  }

  EventBase getEventById(int id);
  OrganizerBase getOrganizerById(int id);
//  PlaceBase getPlaceById(int id);
  UserBase getUserById(int id);
}
