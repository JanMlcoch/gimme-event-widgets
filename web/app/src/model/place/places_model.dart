part of model;

class PlacesModel{
  ClientPlaces placeRepository = new ClientPlaces();

  void addPlace(ClientPlace place) {
    placeRepository.addPlace(place);
  }
}