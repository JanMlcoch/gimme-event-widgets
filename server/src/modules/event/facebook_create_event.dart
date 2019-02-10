part of eventModule;

class FacebookCreateEventRC extends libs.RequestContext {

  Future execute() async {
    if(data["token"] is! String){throw new Exception("token is not string");}
    String token = data["token"];
    Uri uri = new Uri.https("graph.facebook.com", "/v2.7/${data["facebook_id"]}", {
      "access_token": token,
      "fields": "name,place,start_time,end_time,id,description,attending{id,name}"
    });
    http.Response response = await http.get(uri);
    Map<String, dynamic> fbJson;
    try {
      fbJson = convert.JSON.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      envelope.error("cannot parse JSON " + response.body, DATA_NOT_VALID_JSON);
      return null;
    }
    Event event;

    Map<String, dynamic> eventMap = {
      "name":fbJson["name"],
      "socialNetworks":{"facebook_id":data["facebook_id"]}
    };

    eventMap["insertedById"] = user.id;
    eventMap["ownerId"] = user.id;
    event = await connection.events.saveModel(eventMap);
    if (event != null) {
//      if (data["imageData"] != null && data["imageData"] != "") {
//        _saveImage(event, data["imageData"]);
//      }
      envelope.withMap(event.toEventDetailMap());
      new log.Logger("akcnik.server.context").info("event ${convert.JSON.encode(event.toFullMap())} by ${user?.login}");
    } else {
      envelope.error(ERROR_IN_EVENT_CREATION);
    }
    return null;
  }
}
