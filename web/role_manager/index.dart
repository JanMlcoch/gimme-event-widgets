library akcnik.role_manager.index;

import 'dart:html';
import "package:mustache_no_mirror/mustache.dart";
import 'dart:async';
import 'package:akcnik/resources.dart';
import '../app/src/gateway/gateway.dart';
import 'package:akcnik/envelope.dart' as envelope_lib;
import 'package:akcnik/constants/constants.dart';
import 'package:akcnik/json_helper.dart';

part 'table_widget.dart';

part 'login_widget.dart';

part 'role_model.dart';

GeneratedResources resources;
RoleModel model = new RoleModel();

Future main() async {
  resources = await loadResources();
  await model.isLogged();
  model.fireChanges();
}

Future loadResources() {
  return HttpRequest.getString("../resources/module.json").then((String jsonString) {
    GeneratedResources resources = new GeneratedResources();
    resources.fromMap(decodeJsonMap(jsonString));
    return resources;
  });
}
