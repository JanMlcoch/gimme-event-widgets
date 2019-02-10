import "dart:html";
import "dart:async";
import "dart:convert";

import "package:akcnik/constants/constants.dart";

void main(){
  login().then((_){
    HttpRequest
    .request("http://localhost" + CONTROLLER_CREATE_USER, method: "POST", sendData: JSON.encode({
      "login": "newUser",
      "password": "aaa",
      "name": "me",
      "address": "",
      "mail": "mail@mail.cz"
    }))
    .then((HttpRequest req){
      print(req.responseText);
      HttpRequest
      .request("http://localhost" + CONTROLLER_LOGIN, method: "POST", sendData: JSON.encode({
        "login": "newUser",
        "password": "aaa"
      }))
      .then((HttpRequest req){
        print(req.responseText);
        HttpRequest.request("http://localhost" + CONTROLLER_USER, method: "GET").then((HttpRequest req){
          print(req.responseText);
        });
      });
    });
  });


}

Future login(){
  Completer completer = new Completer();
  HttpRequest
  .request("http://localhost" + CONTROLLER_USER, method: "GET")
  .then((HttpRequest req){
    print(req.responseText);
    HttpRequest
    .request("http://localhost" + CONTROLLER_LOGIN, method: "POST", sendData: JSON.encode({
      "login": "taliesin",
      "password": "aaa"
    }))
    .then((HttpRequest req){
      print(req.responseText);
      HttpRequest.request("http://localhost" + CONTROLLER_USER, method: "GET").then((HttpRequest req){
        print(req.responseText);
        print("logout attemp");
        HttpRequest.request("http://localhost" + CONTROLLER_LOGOUT, method: "GET").then((HttpRequest req){
          print(req.responseText);
          HttpRequest.request("http://localhost" + CONTROLLER_USER, method: "GET").then((HttpRequest req){
            print(req.responseText);
            completer.complete(null);
          });
        });
      });
    });
  });
  return completer.future;

}


