library watcher;

import "dart:io";
import "dart:async";
import "dart:convert";
import 'package:path/path.dart' as path_lib;
import '../conf/conf.dart' as conf;

Map<String, dynamic> structure;
int counter = 0;
List<String> classes;


void main() {
  generate();
}

Future<dynamic> compileLangs() async {
  try {
    Directory dir = new Directory("langs");
    for (FileSystemEntity entity in dir.listSync()) {
      if (!FileSystemEntity.isDirectorySync(entity.path)) {
        continue;
      }
      String name = "lang_${path_lib.basename(entity.path)}.json";
      await new File("resources/$name")
          .writeAsString(JSON.encode(getMergedJson(entity)));
    }
  } catch (e) {
    // do nothing
  }
}

Map<String, dynamic> getMergedJson(Directory directory) {
  Map<String, dynamic> out = {};
  for (FileSystemEntity entity in directory.listSync(recursive: true)) {
    if (path_lib.extension(entity.path) == ".json" &&
        FileSystemEntity.isFileSync(entity.path)) {
      File file = new File(entity.path);
      String content = file.readAsStringSync();
      extend(out, JSON.decode(content));
    }
  }
  return out;
}

Future<Null> generate() async {
  await compileLangs().then((_) {
    Map<String, dynamic> stringData = getFileMap("resources");
    structure = removeLangs(stringData);
    structure = generateData(structure);
    createStructureClass(structure);
    new File("${conf.RESOURCES_TARGET_FOLDER}/module.json")
      ..createSync(recursive: true)
      ..writeAsStringSync(JSON.encode(structure));
    Map<String, int> report = prepareReport(structure);
    print(JSON.encode(report));
  });
}

Map<String, int> prepareReport(Map<String, dynamic> map) {
  return new Map.fromIterables(map.keys,
      map.values.map((Map<String, dynamic> map) => countLeafsForReport(map)));
}

int countLeafsForReport(Map<String, dynamic> map) {
  int leafs = 0;
  map.forEach((String key, dynamic value) {
    if (value is String) {
      leafs++;
    }
    if (value is Map<String, dynamic>) {
      leafs += countLeafsForReport(value);
    }
  });
  return leafs;
}

Map<String, dynamic> removeLangs(Map<String, dynamic> structure) {
  List<String> removes = [];
  structure.forEach((String key, dynamic value) {
    String item = path_lib.basenameWithoutExtension(key);
    if (item.contains("lang") && item != "langEn") {
      File outFile = new File("${conf.RESOURCES_TARGET_FOLDER}/${key.toLowerCase()}")
        ..createSync(recursive: true);
      outFile.writeAsStringSync(value.toString());
      removes.add(key);
    }
  });
  removes.forEach((String v) {
    structure.remove(v);
  });
  return structure;
}

void createStructureClass(Map<String, dynamic> structure) {
  counter = 0;
  classes = [];
  String out = "library resources;\n";
  createMapClass("GeneratedResources", structure);
  for (String s in classes) {
    out += "$s\n";
  }
  new File(conf.RESOURCES_TARGET_DART_FILE)
    ..createSync(recursive: true)
    ..writeAsStringSync(out);
}

String createMapClass(String name, Map<String, dynamic> map) {
  String out = "class $name{\n";
  String fromMap = "";
  String toMap = "";
  map.forEach((String fileName, dynamic v) {
    String className;
    if (v is Map<String, dynamic>) {
      className = "Xr${counter++}$fileName";
      if (fileName == "langEn") {
        className = "Lang";
      }
      createMapClass(className, v);
      out += "$className $fileName; \n";
      fromMap += "$fileName = new $className()..fromMap(json['$fileName']); \n";
      toMap += "out['$fileName'] = $fileName.toMap();\n";
    } else {
      String type = getType(v);
      if (type == "String") {
        out += escapeAndShorten(v);
      }
      out += "$type $fileName; \n";
      fromMap += "$fileName = json['$fileName']; \n";
      toMap += "out['$fileName'] = $fileName;\n";
    }
  });
  out += "Map<String, dynamic> toMap(){\nMap<String,dynamic> out = {};\n$toMap\nreturn out;\n}\n";
  out += "void fromMap(Map<String,dynamic> json){\n$fromMap}\n}\n";

  classes.add(out);
  return out;
}

String escapeAndShorten(String input) {
  String out = input;
  if (out.length > 800) {
    out = out.substring(0, 399);
  }
  var sanitizer = const HtmlEscape();
  out = sanitizer.convert(out);
  out = "//////" + out;
  out = out.replaceAll("\n", "///<br />///");
  return out + "\n";
}

String getType(Object value) {
  if (value is Map<String, dynamic>) return "Map";
  if (value is String) return "String";
  return value.runtimeType.toString();
}

Map<String, dynamic> getFileMap(String path) {
  Map<String, dynamic> out = {};
  Directory dir = new Directory(path);
  for (FileSystemEntity f in dir.listSync()) {
    if (FileSystemEntity.isFileSync(f.path)) {
      File file = new File(f.path);
      String ext = path_lib.extension(file.path);
      try {
        if (ext == ".jpg" || ext == ".png" || ext == ".jpeg" || ext == ".gif") {
          out[convertToCamelCase(path_lib.basename(f.path))] =
              file.readAsBytesSync();
        } else {
          out[convertToCamelCase(path_lib.basename(f.path))] =
              file.readAsStringSync();
        }
      } catch (e) {
        out[convertToCamelCase(path_lib.basename(f.path))] = "error";
      }
    } else if (FileSystemEntity.isDirectorySync(f.path)) {
      out[convertToCamelCase(path_lib.basenameWithoutExtension(f.path))] =
          getFileMap(f.path);
    }
  }
  return out;
}

Map<String, dynamic> generateData(Map<String, dynamic> node) {
  Map<String, dynamic> out = {};
  node.forEach((String fileName, dynamic value) {
    String withoutExtension = path_lib.basenameWithoutExtension(fileName);
    if (value is Map<String, dynamic>) {
      out[withoutExtension] = generateData(value);
    } else if (value is String) {
      if (fileName.contains(".json")) {
        try {
          out[withoutExtension] = JSON.decode(value);
        } catch (e) {
          out[withoutExtension] = "error";
        }
      } else {
        out[withoutExtension] = value;
      }
    } else if (value is List<int>) {
      out[withoutExtension] =
      "data:image/${path_lib.extension(fileName).replaceFirst(".",
          "")};base64,${new Base64Encoder().convert(value)}";
    } else {
      out[withoutExtension] = "error";
    }
  });
  return out;
}

void extend(Map<dynamic, dynamic> to, Map<dynamic, dynamic> from) {
  Function mapExtends;
  Function listExtends;
  mapExtends = (Map<dynamic, dynamic> to, Map<dynamic, dynamic> from) {
    if (from == null || !(from is Map<dynamic, dynamic>)) {
      return;
    }
    from.forEach((String key, dynamic value) {
      if (to.containsKey(key)) {
        dynamic item = to[key];
        if (item == null) {
          to[key] = value;
        } else if (item is Map<dynamic, dynamic>) {
          if (value is Map<dynamic, dynamic>) {
            mapExtends(to[key], from[key]);
          } else if (value is List<dynamic>) {
            to[key] = new List<dynamic>.from(value);
          } else {
            to[key] = value;
          }
        } else if (item is List<dynamic>) {
          if (value is List<dynamic>) {
            listExtends(to[key], from[key]);
          } else if (value is Map<dynamic, dynamic>) {
            Map<dynamic, dynamic> newTarget = {};
            extend(newTarget, value);
            to[key] = newTarget;
          } else {
            to[key] = value;
          }
        } else {
          to[key] = value;
        }
      } else {
        to.putIfAbsent(key, () => value);
      }
    });
  };
  listExtends = (List<dynamic> to, List<dynamic> from) {
    if (from == null || !(from is List<dynamic>)) {
      return;
    }
    for (int i = 0; i < from.length; i++) {
      dynamic value = from[i];
      if (i < to.length) {
        dynamic item = to[i];
        if (item == null) {
          to[i] = value;
        } else if (item is Map<dynamic, dynamic>) {
          if (value is Map<dynamic, dynamic>) {
            mapExtends(to[i], from[i]);
          } else if (value is List<dynamic>) {
            to[i] = new List<dynamic>.from(value);
          } else {
            to[i] = value;
          }
        } else if (item is List<dynamic>) {
          if (value is List<dynamic>) {
            listExtends(to[i], from[i]);
          } else if (value is Map<dynamic, dynamic>) {
            Map<dynamic, dynamic> newTarget = {};
            extend(newTarget, value);
            to[i] = newTarget;
          } else {
            to[i] = value;
          }
        }
      }
    }
  };
  mapExtends(to, from);
}

String convertToCamelCase(String name) {
  String out = '';
  for (int i = 0; i < name.length; i++) {
    String char = name[i];
    if (char != "_") {
      out += char;
    } else {
      out += name[++i].toUpperCase();
    }
  }
  return out;
}
