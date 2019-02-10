part of akcnik.web.gateway;


class GatewayOffline extends Gateway {
  static Gateway _instance;

  static Gateway get instance {
    if (_instance == null) {
      _instance = new Gateway();
    }
    return _instance;
  }

  Future<envelope_lib.Envelope> _send(String url, {Map data: const {}, String method: "GET"}) async {
    if (url == CONTROLLER_USER) {
      return new envelope_lib.Envelope.withMap({"lell": "fsfsfs"});
    } else if (url == CONTROLLER_FILTER_EVENTS) {
      return _getFilteredEvents();
    } else if (url == CONTROLLER_DETAIL_EVENT) {
      return _getFilteredEvents();
    } else if (url == CONTROLLER_LOGIN) {
      return _getLoggedUser();
    } else if (url == CONTROLLER_LOGOUT) {
      return new envelope_lib.Envelope.withMap({"logout": true, "message": "logout successfull"});
    } else {
      return new envelope_lib.Envelope.timeout();
    }
  }

  envelope_lib.Envelope _getFilteredEvents() {
    Map<String, dynamic> events = {};
    events["places"] = _getPlaces();
    events["organizers"] = _getOrganizers();
    events["events"] = _getEvents();
    return new envelope_lib.Envelope.withMap(events);
  }

  envelope_lib.Envelope _getLoggedUser() {
    return new envelope_lib.Envelope.withMap({
      "login": true,
      "message": "login successfull",
      "user": {
        "login": "Crat",
        "logged": true,
        "id": 96,
        "language": "en",
        "address": "",
        "tags": "[]",
        "name": "Jan",
        "email": "mlcoch.jan@gmail.com",
        "city": "",
        "surname": "MlÄoch",
        "clientSettings": "{\"haveImage\":false}",
        "imageData": ""
      }
    });
  }

  envelope_lib.Envelope _getPlaces() {
    List<Map> places = [];
    Map place = {};
    place["id"] = 1;
    place["placeId"] = 1;
    place["latitude"] = 50.4;
    place["longitude"] = 20.4;
    place["name"] = "Testovaci misto";
    place["description"] = "Testovací popis";
    place["deprecated"] = false;
    place["city"] = "Praha";
    places.add(place);
    return new envelope_lib.Envelope.withList(places);
  }

  envelope_lib.Envelope _getOrganizers() {
    return new envelope_lib.Envelope.withList([]);
  }

  envelope_lib.Envelope _getEvents() {
    List<Map> events = [];
    Map event = {};
    event["id"] = 1;
    event["name"] = "testovací událost";
    event["from"] = new DateTime.now()
      ..add(new Duration(days: 2)).toIso8601String();
    event["to"] = new DateTime.now()
      ..add(new Duration(days: 3)).toIso8601String();
    event["insertedById"] = 1;
    event["tags"] = ["tag1", "tag2"];
    event["language"] = "en";
    event["description"] = "Toto je popis nějaké akce";
    event["annotation"] = "Toto je anotace nějaké akce";
    event["representativePrice"] = 25.4;
    event["private"] = false;
    event["profileQuality"] = 0;
    event["parentEventId"] = null;
    event["clientSettings"] = null;
    event["webpage"] = "http://www.akcenejakadivna.cz";
    event["guestRate"] = 0;
    event["imageData"] = "";
    event["places"] = _getPlaces();
    events.add(event);
    return new envelope_lib.Envelope.withList(events);
  }
}
