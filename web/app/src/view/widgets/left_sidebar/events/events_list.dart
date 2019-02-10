part of view;

class EventsListWidget extends Widget{
  ClientEvents events;

  EventsListWidget(this.events){
    template = parse(resources.templates.leftSidebar.eventsList);
    events.onChange.add(_childrenChanged);
  }

  void changeSource(ClientEvents events){
    if(events == this.events)return;
    this.events.onChange.remove(_childrenChanged);
    this.events = events;
    events.onChange.add(_childrenChanged);
    _childrenChanged();
  }

  @override
  void destroy() {
    events.onChange.remove(_childrenChanged);
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.leftSidebar.events.toMap();
    out["emptyChildren"] = true;
//    List<int> eventsList = [];
//    for (EventWidget child in children) {
//      eventsList.add(child.event.id);
//      out["emptyChildren"] = false;
//    }
    List<ClientEvent> sortedEvents = events.list;
    List<int> bestEventsIds = [];
    List<int> goodEventsIds = [];
    List<int> casualEventsIds = [];
    out["showBestRecommendation"] = false;
    out["showGoodRecommendation"] = false;
    out["showCasualRecommendation"] = false;
    for (int i = 0; i < sortedEvents.length; i++) {
      out["emptyChildren"] = false;
      if (i < 3) {
        out["showBestRecommendation"] = true;
        bestEventsIds.add(sortedEvents[i].id);
      } else if (i < 9) {
        out["showGoodRecommendation"] = true;
        goodEventsIds.add(sortedEvents[i].id);
      } else{
        out["showCasualRecommendation"] = true;
        casualEventsIds.add(sortedEvents[i].id);
      }
    }
    out["bestRecommendation"] = bestEventsIds;
    out["goodRecommendation"] = goodEventsIds;
    out["casualRecommendtaion"] = casualEventsIds;
    return out;
  }

  @override
  void setChildrenTargets() {
    for(EventWidget child in children){
      child.target = select("#event_${child.event.id}");
    }
  }

  @override
  void functionality() {
//    if(children.isNotEmpty){
//      int id = (children[0] as EventWidget).event.id;
//      select("#event_$id").classes.addAll(["event-col-2"]);
//    }
  }

  void _childrenChanged() {
    children.clear();
    for(ClientEvent event in events.list){
      EventWidget eventWidget = new EventWidget(event);
      children.add(eventWidget);
    }
    repaintRequested = true;
  }
}