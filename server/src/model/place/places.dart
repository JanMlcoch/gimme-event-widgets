part of model;

class Places extends ModelList<Place> {
  String type = "places";

  @override
  Place entityFactory() {
    return new Place();
  }

  @override
  Places copyType() => new Places();
}
