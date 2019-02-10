part of model;

class ClientOrganizer extends OrganizerBase{
//  Future persist() async{
//    Gateway._instance.post(CONTROLLER_CREATE_ORGANIZER, data:toFullMap());
//  }
}

class ClientOrganizers{
  List<ClientOrganizer> list = [];


  void fromList(List json){
    list.clear();
    for(Map m in json){
      list.add(new ClientOrganizer()..fromMap(m));
    }
  }

  void addList(List json){
    for(Map m in json){
      list.add(new ClientOrganizer()..fromMap(m));
    }
  }

  List toFullMap(){
    List out = [];
    for(ClientOrganizer organizer in list){
      out.add(organizer.toFullMap());
    }
    return out;
  }
}

class ClientOrganizerInEvent extends OrganizerInEventBase{
  ClientOrganizer organizer;
  ClientEvent event;

  Map toFullMap(){
    Map out = super.toSafeMap();
    out["eventId"] = event.id;
    return out;
  }

  Map toViewJson() {
    Map out = super.toSafeMap();
    out["name"] = organizer.name;
    return out;
  }
}