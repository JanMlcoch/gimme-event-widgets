part of model;

class PointsOfOrigin{
  Stream<PointOfOriginAddEvent> get onAddPoint => _onAddPointController.stream.asBroadcastStream();
  StreamController<PointOfOriginAddEvent> _onAddPointController = new StreamController();
  List<PointOfOrigin> points = [];

  void fromMap(Map json){
    points.clear();
    for(Map optionJson in json["pointsOfOrigin"]){
      points.add(new PointOfOrigin()..fromMap(optionJson));
    }
  }

  Map toMap(){
    Map out = {};
    List predictions = [];
    for(PointOfOrigin option in points){
      predictions.add(option.toMap());
    }
    out["pointsOfOrigin"] = predictions;
    return out;
  }

  Future addPointOfOrigin(PointOfOrigin pointOfOrigin) async{
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_ADD_POINT_OF_ORIGIN, data: {"userId": model.user.id, "newPointOfOrigin": pointOfOrigin.toMap()});
    if (envelope.isSuccess){
      fromMap(envelope.map);
      _onAddPointController.add(new PointOfOriginAddEvent(pointOfOrigin));
      return OK;
    }else{
      return envelope.message;
    }
  }

  Future removePointOfOrigin(PointOfOrigin pointOfOrigin) async{
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_DELETE_POINT_OF_ORIGIN, data: {"pointOfOriginId": pointOfOrigin.id});
    if (envelope.isSuccess){
      fromMap(envelope.map);
      return OK;
    }else{
      return envelope.message;
    }
  }
}


class PointOfOrigin{
  int id;
  int userId;
  String description;
  double latitude;
  double longitude;

  PointOfOrigin();

  void fromMap(Map json){
    id = json["id"];
    userId = json["userId"];
    description = json["description"];
    latitude = json["latitude"];
    longitude = json["longitude"];
  }

  Map toMap(){
    Map out = {};
    out["id"] = id;
    out["userId"] = userId;
    out["description"] = description;
    out["latitude"] = latitude;
    out["longitude"] = longitude;
    return out;
  }

}

class PointOfOriginAddEvent{
  PointOfOrigin newPoint;

  PointOfOriginAddEvent(this.newPoint);
}