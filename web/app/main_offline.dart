library app;

import 'dart:html';
import 'dart:async';
import "dart:convert";
import 'package:akcnik/resources.dart';
import "src/view/view.dart";
import "src/model/root.dart";
import 'src/gateway/gateway.dart';
import 'package:akcnik/json_helper.dart';

GeneratedResources resources;
Lang lang;
View view;
Model model;
String langShort;

void main() {
  Gateway.offline = true;
  model = new Model();
//  setModelInView(model);
//  loadResources().then((Map langJson) {
//    Map<String, dynamic> langEnCopy = {};
//    if (resources.langEn is String && resources.langEn == "error") {
//      throw new Exception("failed to create lang file");
//    }
//    extend(langEnCopy, resources.langEn.toMap());
//    extend(langEnCopy, langJson);
//    lang = new Lang()
//      ..fromMap(langEnCopy);
//    setLangInView(lang);
//    setLangInModel(lang);
//    setResourcesInView(resources);
//    view = new View(querySelector("#pageContainer"));
//  });
}

Future loadResources(){
  Completer completer = new Completer();
  Map langJson;

  HttpRequest.getString("../resources/module.json").then((String jsonString) {
    resources = new GeneratedResources();
    resources.fromMap(decodeJsonMap(jsonString));
    if (langJson != null) {
      completer.complete(langJson);
    }
  });
  Future getResources() async {
    if(langShort==""){
      langShort="en";
    }
    if (langShort == "en") {
      if (resources != null) {
        langJson = resources.langEn.toMap();
        return langJson;
      }
    } else {
      try {
        String jsonString = await HttpRequest.getString("../resources/lang$langShort.json");
        langJson = JSON.decode(jsonString);
        if (resources != null) {
          return langJson;
        }
      } catch (e) {
        if (resources != null) {
          return null;
        }
      }
    }
  }

  langShort = window.navigator.language.substring(0, 2);
  model.user.language = langShort;
  getResources().then((_) {
    if (langJson != null) {
      completer.complete(langJson);
    }
    return;
  });
  return completer.future;
}

//Future<Map> loadResources() {
//  Completer completer = new Completer();
//  Map langJson;
//
//  HttpRequest.getString("../resources/module.json").then((String jsonString) {
//    resources = new GeneratedResources();
//    resources.fromJson(JSON.decode(jsonString));
//    if (langJson != null) {
//      completer.complete(langJson);
//    }
//  });
//
//  Future getResources() async {
//    if(langShort==""){
//      langShort="en";
//    }
//    if (langShort == "en") {
//      if (resources != null) {
//        langJson = resources.langEn.toJson();
//        return langJson;
//      }
//    } else {
//      try {
//        String jsonString = await HttpRequest.getString("../resources/lang$langShort.json");
//        langJson = JSON.decode(jsonString);
//        if (resources != null) {
//          return langJson;
//        }
//      } catch (e) {
//        if (resources != null) {
//          return null;
//        }
//      }
//    }
//  }
//
//  HttpRequest.getString(CONTROLLER_USER).then((String jsonString) {
//    Map result = JSON.decode(jsonString);
//    if (result.containsKey("resp") && result["resp"] == "not logged") {
//      // not logged use default language
//      langShort = window.navigator.language.substring(0, 2);
//      model.user.language = langShort;
//    } else {
//      model.user.fromJson(result);
//      langShort = model.user.language;
//    }
//    getResources().then((_) {
//      if (langJson != null) {
//        completer.complete(langJson);
//      }
//      return;
//    });
//  }).catchError((_) {
//    langShort = window.navigator.language.substring(0, 2);
//    model.user.language = langShort;
//    getResources().then((_) {
//      if (langJson != null) {
//        completer.complete(langJson);
//      }
//      return;
//    });
//  });
//  return completer.future;
//}

