part of model;

class ClientEvents{
  List<ClientEvent> list = [];
  num distance = 30000;
  num latitude;
  num longtitude;
  ClientPlaces places;
  List<ClientOrganizerInEvent> organizersInEvent;
  ClientOrganizers organizers;
  List<Function> onChange = [];

  bool placeFilterApplied = false;

  ClientEvents(this.places,this.organizers);

//  List getFilters(){
//    if(latitude==null){
//      throw new Exception("latitude missing");
//    }
//    if(longtitude==null){
//      throw new Exception("longtitude missing");
//    }
//    return [{"name": "event_in_future", "data": []},{"name": "distance", "data": [latitude,longtitude,distance]}];
//  }

  ClientEvent getEventById(int id){
    try{
      return list.firstWhere((ClientEvent event) => event.id == id);
    }catch(e){
      return null;
    }
  }

  void fromList(List events){
    list.clear();
    for(Map event in events){
      ClientEvent clientEvent = new ClientEvent(places, organizers)..fromMap(event);
      clientEvent.parent = this;
      list.add(clientEvent);
    }
    onChange.forEach((Function f)=>f());
  }

  List toFullList(){
    List out = [];
    for(ClientEvent event in list){
      out.add(event.toFullMap());
    }
    return out;
  }

  void clear() {
    list.clear();
    onChange.forEach((Function f)=>f());
  }

  void addEvent(ClientEvent clientEvent) {
    list.add(clientEvent);
    onChange.forEach((Function f)=>f());
  }

  void refillByEvents(List<ClientEvent> events) {
    list.clear();
    for(ClientEvent e in events){
      list.add(e);
    }
    onChange.forEach((Function f)=>f());
  }

  Future<ClientEvents> getMyEditableEvents() async {
    envelope_lib.Envelope result = await Gateway.instance.post(CONTROLLER_EDITABLE_EVENTS,
        data: {"filters":[{"name": "owned_events", "data": [model.user.id]}]});
    if (result.isSuccess) {
      fromList(result.map["events"]);
    }
    return this;
  }

  Future<ClientEvents> getEditableEvents() async{
    envelope_lib.Envelope result = await Gateway.instance.post(CONTROLLER_EDITABLE_EVENTS,
        data: {});
    if(result.isSuccess){
      fromList(result.map["events"]);
    }
    return this;
  }

  void orderByTimeDesc() {
    list.sort((ClientEvent event1, ClientEvent event2){
      return event2.to.compareTo(event1.to);
    });
  }

  void removeEvent(ClientEvent clientEvent) {
    list.remove(clientEvent);
    onChange.forEach((f)=>f());
  }
}

