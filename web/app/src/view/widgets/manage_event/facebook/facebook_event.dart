part of view;

class FacebookEventWidget extends Widget {
  final Map facebookEvent;
  ButtonElement _upgrade;

  ManageEventModel get model => layoutModel.leftPanelModel.createEvent;

  DateTime get dateFrom => DateTime.parse(facebookEvent["start_time"]);

  DateTime get dateTo {
    if (facebookEvent["end_time"] == null) {
      return null;
    } else {
      return DateTime.parse(facebookEvent["end_time"]);
    }
  }

  String get fbLink => "https://www.facebook.com/events/${facebookEvent["id"]}";

  FacebookEventWidget(this.facebookEvent) {
    name = "FacebookEventWidget";
    template = parse(resources.templates.manageEvent.facebook.facebookEvent);
    widgetLang = lang.manageEvent.facebook.toMap();
  }

  @override
  void destroy() {}

  @override
  void functionality() {
    _upgrade = target.querySelector(".facebookEventImportButton");
    _upgrade?.onClick?.listen(fillEventFromFacebook);
  }

  @override
  Map out() {
    DateFormat _dateFormatter = new DateFormat(widgetLang["dateFormat"]);
    Map out = {};
    out["lang"] = widgetLang;
    out["id"] = facebookEvent["id"];
    out["fbLink"] = fbLink;
    out["name"] = facebookEvent["name"];
    if(facebookEvent["place"] != null){
      out["place"] = facebookEvent["place"]["name"];
    }else{
      out["place"] = "Not set in Facebook event";
    }
    out["from_date"] = facebookEvent["start_time"] != null ? _dateFormatter.format(dateFrom) : null;
    out["to_date"] = facebookEvent["end_time"] != null ? " - ${_dateFormatter.format(dateTo)}" : null;
    out["isImported"] = facebookEvent["gimme_id"] != null;
    out["hasImage"] = facebookEvent["cover"] != null;
    out["imgUrl"] = facebookEvent["cover"] != null ? facebookEvent["cover"]["source"] : null;
    return out;
  }

  @override
  NodeValidatorBuilder getHtmlValidator(){
    Widget.nodeValidator
      ..allowHtml5()
      ..allowImages(new FacebookUriPolicy())
      ..allowNavigation(new FacebookUriPolicy());
    return Widget.nodeValidator;
  }

  void fillEventFromFacebook(_) {
    model.setName(facebookEvent["name"]);
    model.setAnnotation(facebookEvent["description"]);
    model.event.from = dateFrom;
    if (dateTo != null) {
      model.event.to = dateTo;
    } else {
      model.event.to = dateFrom;
    }
    model.event.fbLink = fbLink;
    model.event.socialNetworks["facebook_id"] = facebookEvent["id"];
    model.activeTab = ManageEventModel.BASE;
    if (facebookEvent["place"] != null) {
      if (facebookEvent["place"]["location"] != null) {
        createPlaceFromFacebook(facebookEvent["place"]).then((ClientPlace place) {
          model.addMapPlace(place);
        });
      }
    }
    if (facebookEvent["cover"] != null) {
      urlToBase64Image(facebookEvent["cover"]["source"]).then((String base64) {
        model.setImageData(base64);
      });
    }
  }

  Future<String> urlToBase64Image(String url) {
    return HttpRequest.request(url, responseType: "arraybuffer").then((HttpRequest response) {
      String contentType = response.getResponseHeader('Content-Type');

      var list = new typed_array.Uint8List.view((response.response as typed_array.ByteBuffer));

      String header = 'data:$contentType;base64,';
      String base64 = BASE64.encode(list);
      String image = "$header$base64";
      return image;
    });
  }

  Future<ClientPlace> createPlaceFromFacebook(Map facebookPlace) async {
    Map location = facebookPlace["location"];
    envelope_lib.Envelope envelope = await Gateway.instance.post(CONTROLLER_CREATE_PLACE, data: {
      "latitude": location["latitude"],
      "longitude": location["longitude"],
      "name": facebookPlace["name"],
      "description": location["street"]
    });
    if (!envelope.isSuccess) {
      print(envelope.message);
      return null;
    }
    ClientPlace place = new ClientPlace()
      ..fromMap(envelope.map);
    return place;
  }

  @override
  void setChildrenTargets() {}
}