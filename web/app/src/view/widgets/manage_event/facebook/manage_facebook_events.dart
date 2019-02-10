part of view;

class ManageFacebookEventsWidget extends ManageEventWidget {
  List model = [];
  ButtonElement _loadFacebookEvents;

  ManageFacebookEventsWidget(String name) : super(name) {
    template = parse(resources.templates.manageEvent.facebook.eventList);
    widgetLang = lang.manageEvent.facebook.toMap();
    updateChildren();
  }

  void updateChildren() {
    destroy();
    for (Widget widget in children) {
      widget.destroy();
    }
    for (Map event in model) {
      children.add(new FacebookEventWidget(event));
    }
  }

  @override
  void destroy() {
    for (Widget widget in children) {
      widget.destroy();
    }
    children = [];
  }

  @override
  void functionality() {
    _loadFacebookEvents = target.querySelector("#loadFacebookEvents");
    _loadFacebookEvents?.onClick?.listen((_) {
      loadEventsFromFacebook();
    });
  }

  void loadEventsFromServer() {
    Gateway.instance.post(CONTROLLER_FACEBOOK_EVENTS, data: {
      "token": layoutModel.navbarModel.user.facebookToken,
      "tokenType": "facebookToken"
    }).then((envelope_lib.Envelope envelope) {
      if (envelope.isSuccess) {
        model = envelope.list;
        updateChildren();
        repaint(true);
      }
    });
  }

  Future loadEventsFromFacebook() async {
    await fb_helpers.loadFacebookSDK();
    envelope_lib.Envelope envelope = await fb_helpers.facebookLogin(scope: ["user_events"]);
    if (!envelope.isSuccess) {
      print(envelope.message);
      return;
    }
    String token = envelope.map['token'];
    layoutModel.navbarModel.user.facebookToken = token;
    envelope = await fb_helpers.facebookApi("/me/events", token, {
      "fields": "name,place,start_time,end_time,id,description,cover,attending{id,name}",
      "since": new DateTime.now().millisecondsSinceEpoch ~/ 1000
    });
    if (!envelope.isSuccess) {
      print(envelope.message);
      return;
    }
    List facebookEvents = envelope.list;
    List<int> facebookEventIds = facebookEvents.map((Map<String, dynamic> event) => int.parse(event["id"])).toList();

    Gateway.instance.post(CONTROLLER_FACEBOOK_CHECK_EVENTS, data: {"facebook_ids": facebookEventIds}).then(
        (envelope_lib.Envelope envelope) {
      if (envelope.isSuccess) {
        List events = envelope.list;
        List<String> foundFacebookIds = [];
        List<int> foundIds = [];
        for (int i = 0; i < events.length; i++) {
          foundFacebookIds.add(events[i]["socialNetworks"]['facebook_id']);
          foundIds.add(events[i]["id"]);
        }
        facebookEvents
            .where((Map event) => foundFacebookIds.contains(event["id"]))
            .forEach((Map event) => event["gimme_id"] = foundIds[foundFacebookIds.indexOf(event["id"])]);
        model = facebookEvents;
        updateChildren();
        repaint(true);
      } else {
        print(envelope.message);
        return;
      }
    });
  }

  @override
  Map out() => {"lang": widgetLang, "events": model};

  @override
  void setChildrenTargets() {
    ElementList<DivElement> subTargets = target.querySelectorAll(".facebookEventCont");
    for (int i = 0; i < math.min(subTargets.length, children.length); i++) {
      children[i].target = subTargets[i];
    }
  }
}
