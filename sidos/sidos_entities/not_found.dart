part of sidos.entities;

abstract class NotFound{
  DateTime lastRequested;
  String additionalMessage;
}

class ImprintNotFound extends Imprint with NotFound{
  ImprintNotFound({String additionalMessage: null}):super(){
    this.additionalMessage = additionalMessage;
    lastRequested = new DateTime.now();
  }
}

class PatternNotFound extends UserPattern with NotFound{
  PatternNotFound({String additionalMessage: null}):super(){
    this.additionalMessage = additionalMessage;
    lastRequested = new DateTime.now();
  }
}

class FitIndexNotFound extends FitIndex with NotFound{
  FitIndexNotFound({String additionalMessage: null}):super(double.NEGATIVE_INFINITY){
    this.additionalMessage = additionalMessage;
    lastRequested = new DateTime.now();
  }

  @override
  Map toMap(){
    Map map = super.toMap();
    map["lastRequested"] = lastRequested.millisecondsSinceEpoch;
    map["additionalMessage"] = additionalMessage;
    return map;
  }

  @override
  void fromMap(Map map){
    super.fromMap(map);
    lastRequested = new DateTime.fromMillisecondsSinceEpoch(map["lastRequested"]);
    additionalMessage = map["AdditionalMessage"];
  }
}