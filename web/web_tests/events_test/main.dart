import "dart:html";

import "package:akcnik/constants/constants.dart";

void main(){

//  new CreateEventForm(querySelector(".eventCreateForm"));

  HttpRequest.request("http://localhost" + CONTROLLER_ALL_EVENTS, method: "GET").then((HttpRequest req){
    print(req.responseText);
  });

}
//
//Future login(){
//  Completer completer = new Completer();
//  HttpRequest
//  .request("http://localhost" + CONTROLLER_USER, method: "GET")
//  .then((HttpRequest req){
//    print(req.responseText);
//    HttpRequest
//    .request("http://localhost" + CONTROLLER_LOGIN, method: "POST", sendData: JSON.encode({
//      "login": "taliesin",
//      "password": "aaa"
//    }))
//    .then((HttpRequest req){
//      print(req.responseText);
//      HttpRequest.request("http://localhost" + CONTROLLER_USER, method: "GET").then((HttpRequest req){
//        print(req.responseText);
//        print("logout attemp");
//        HttpRequest.request("http://localhost" + CONTROLLER_LOGOUT, method: "GET").then((HttpRequest req){
//          print(req.responseText);
//          HttpRequest.request("http://localhost" + CONTROLLER_USER, method: "GET").then((HttpRequest req){
//            print(req.responseText);
//            completer.complete(null);
//          });
//        });
//      });
//    });
//  });
//  return completer.future;
//
//}


