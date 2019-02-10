//library create_event_form;
//
//import "dart:html";
//import "dart:convert";
//import "package:akcnik/common/library.dart";
//import "package:akcnik/constants/constants.dart";
//
//class CreateEventForm {
//  Element target;
//  Element sendButton;
//  EventBase event;
//  CreateEventForm(this.target){
//    sendButton = target.querySelector("button");
//    sendButton.onClick.listen((e){
//      Map properties = event.toJson();
//      Map out = {};
//      properties.forEach((String k, v){
//        dynamic element = querySelector("#$k");
//        if(element is InputElement || element is TextAreaElement){
//          out[k] = element.value;
//        }
//        if(element is SelectElement){
//          out[k] = element.value;
//        }
//      });
//      event.fromJson(out);
//      HttpRequest
//      .request("http://localhost" + CONTROLLER_CREATE_EVENT, method: "POST", sendData: JSON.encode(event.toJson()))
//      .then((HttpRequest req){
//
//      });
//    });
//    event = new Event();
//    Map properties = event.toJson();
//    properties.forEach((String k, v){
//      dynamic element = querySelector("#$k");
//      if(element is InputElement || element is TextAreaElement){
//        element.value = v==null?"":v.toString();
//      }
//      if(element is SelectElement){
//        if(v!=null){
//          (element as SelectElement).value = v;
//        }
//      }
//    });
//
//  }
//
//}