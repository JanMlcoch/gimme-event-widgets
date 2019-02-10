library server.resources;

import "dart:io" as io;
import "dart:convert";
import '../../../../server_libs/io_helper.dart' as io_helper;
import 'package:akcnik/json_helper.dart';
import "package:mustache_no_mirror/mustache.dart" as mustache;
import 'package:akcnik/resources.dart';
import "package:akcnik/extend.dart";

class ResourcesProvider {
  static ResourcesProvider _instance;

  static ResourcesProvider get instance {
    if (_instance == null) {
      _instance = new ResourcesProvider();
    }
    return _instance;
  }

  GeneratedResources resources;
  Map<String, Lang> _languages = {};

  ResourcesProvider() {
    String rootPath = io_helper.getProjectDirectoryName();
    io.File file = new io.File('$rootPath/web/resources/module.json');
    resources = new GeneratedResources();
    resources.fromMap(decodeJsonMap(file.readAsStringSync()));
  }

  Lang getLangByShortcut(String shortcut) {
    if (_languages[shortcut] == null) {
      String rootPath = io_helper.getProjectDirectoryName();
      io.File langFile = new io.File("$rootPath/resources/lang_$shortcut.json");
      Map<String, dynamic> langBase = decodeJsonMap(new io.File("$rootPath/resources/lang_en.json").readAsStringSync());
      if (langFile.existsSync()) {
        Map langJson = JSON.decode(langFile.readAsStringSync());
        extend(langBase, langJson);
      }
      _languages[shortcut] = new Lang()..fromMap(langBase);
      return _languages[shortcut];
    }
    return _languages[shortcut];
  }

  static String enhanceByPartials(String template, Map<String, String> partials) {
    for (int i = 0; i < 10; i++) {
      bool changed = false;
      template = template.replaceAllMapped(new RegExp(r'\{\{partial.(\w+)\}\}'), (Match match) {
        String partialName = match.group(1);
        changed = true;
        if (partials[partialName] == null) return "";
        return partials[partialName];
      });
      if (changed == false) break;
    }
    return template;
  }

  static String enhanceHtml(String template, Map<String, dynamic> data, [Map<String, String> partials = null]) {
    if (partials == null) {
      return mustache.parse(template).renderString(data);
    }
    template = enhanceByPartials(template, partials);
    return mustache.parse(template).renderString(data /*, htmlEscapeValues: false*/);
  }
}
