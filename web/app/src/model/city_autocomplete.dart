part of model;

class CityAutocompleteModel extends PointsOfOrigin{
  ClientUser userModel;
//  Stream get onOptionSelected => _onOptionSelectedController.stream;
//  StreamController _onOptionSelectedController = new StreamController();
//  CityAutocompleteOptionModel _selectedOption;

//  void set selectedOption(Object value){
//    _selectedOption = value;
//    _onOptionSelectedController.add(new CityAutocompleteSelectedEvent(value));
//  }

  CityAutocompleteModel(this.userModel);

  @override
  void fromMap(Map json){
    points.clear();
    for(Map optionJson in json["predictions"]){
      points.add(new CityAutocompleteOptionModel()..fromMap(optionJson));
    }
  }

  CityAutocompleteOptionModel getOptionByPlaceId(String placeId){
    return points.firstWhere((PointOfOrigin point){
      if(point is CityAutocompleteOptionModel){
        return point.placeId == placeId;
      }
      return false;
    });
  }

  void addCity(CityAutocompleteOptionModel selectedOption) {
    if(userModel.pointsOfOrigin.points.isNotEmpty){
      PointOfOrigin lastPointForRemove = userModel.pointsOfOrigin.points.last;
      userModel.pointsOfOrigin.removePointOfOrigin(lastPointForRemove);
    }
    userModel.pointsOfOrigin.addPointOfOrigin(selectedOption);
    userModel.selectedPointOfOrigin = selectedOption;
  }

  void clear() {
    points.clear();
  }
}


class CityAutocompleteOptionModel extends PointOfOrigin{
  String placeId;

  @override
  void fromMap(Map json){
//    id = json["id"];
    placeId = json["id"];
    description = json["description"];
    latitude = 45.4545;
    longitude = 35.555;
  }


}

class CityAutocompleteSelectedEvent{
  CityAutocompleteOptionModel newOption;

  CityAutocompleteSelectedEvent(this.newOption);
}