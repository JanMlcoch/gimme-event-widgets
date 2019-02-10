library app;

import 'dart:html';
import 'dart:async';
import "dart:convert";
import 'package:akcnik/resources.dart';
import "package:akcnik/extend.dart";
import "src/view/view.dart";
import "src/model/root.dart";
import "src/model/view_model/library.dart" as view_model;
import "package:akcnik/json_helper.dart";

GeneratedResources resources;
Lang lang;
View view;
Model model;
String langShort;

Future main() async {
  model = new Model();
  // parallel load of lang and resources
  await Future.wait([loadResources(), loadLoggedUser()]);
  model.routes.setActualRoute();
  Map<String, dynamic> langEnCopy = {};
  if (resources.langEn is String && resources.langEn == "error") {
    throw new Exception("failed to create lang file");
  }
  extend(langEnCopy, resources.langEn.toMap());
  langShort = findLangType();
  if (langShort != "en") {
    Map langMap = await loadLang(langShort);
    extend(langEnCopy, langMap);
  }
  lang = new Lang()..fromMap(langEnCopy);
  setLangInView(lang);
  setLangInModel(lang);
  view_model.init(model);
//  setModelInView(model);
  setViewModelInView(view_model.layoutModel);
  setResourcesInView(resources);
  view = new View(querySelector("#pageContainer"));
  new Timer.periodic(const Duration(minutes: 10), (_) {
    // keep logged
    model.user.checkLoginStatus();
  });
}

Future loadResources() {
  Completer completer = new Completer();

  // not async to be parallel
  HttpRequest.getString("../resources/module.json").then((String jsonString) {
    resources = new GeneratedResources();
    resources.fromMap(decodeJsonMap(jsonString));
    if (resources.langEn != null) {
      completer.complete(null);
    }
  });
  return completer.future;
}

Future<bool> loadLoggedUser() async {
  return model.user.checkLoginStatus();
}

String findLangType() {
  langShort = "en";
  if (model.user.id != null) {
    langShort = model.user.language != null ? model.user.language.substring(0, 2) : null;
  } else {
    langShort = window.navigator.language.substring(0, 2);
    model.user.language = langShort;
  }
  return langShort;
}

Future loadLang(langType) async {
  if (langType == "en") return new Future.value();
  try {
    String jsonString = await HttpRequest.getString("../resources/lang$langType.json");
    return JSON.decode(jsonString);
  } catch (e) {
    return resources.langEn;
  }
}
