import 'dart:io';
import 'dart:async';
import '../server_libs/io_helper.dart';

void main(List<String> args) {
  print("buildscript alive");
  bool isProduction = args.contains("--production") ||
      Platform.environment["AKCNIK_ENV"] == "production";
  String projectDir = getProjectDirectoryName();
  print("lookiing for previous js file: $projectDir/web/app/main.dart.js");
  File js = new File("$projectDir/web/app/main.dart.js");
  if (js.existsSync()) {
    js.deleteSync();
  }
  print("$projectDir/web/app/main.dart.js deleted");
  String dart2jsName = "/usr/lib/dart/bin/dart2js";
  if (Platform.isWindows) {
    dart2jsName = "dart2js.bat";
  }
  List<String> parameters = [
    "--out=$projectDir/web/app/main.dart.js", "$projectDir/web/app/main.dart","-DMIRRORS=false"
  ];
  if (isProduction) {
    print("is in production");
    parameters =
    ["--minify", "--trust-type-annotations", "--trust-primitives"]
      ..addAll(parameters);
  }
  try{
    ProcessResult result = Process.runSync(dart2jsName, parameters);
    print("dart2js success: ${result.stdout}");
  }catch(e){
    print("dart2js error: $e");
  }
  removeOthers(projectDir);
}

Future removeOthers(String projectDir) {
  File js2 = new File("$projectDir/web/app/main.dart.js.map");
  File js3 = new File("$projectDir/web/app/main.dart.precompiled.js");
  File js4 = new File("$projectDir/web/app/main.dart.js.deps");
  return Future.wait([
    js2.exists().then((bool exist) {
      if (exist) {
        js2.delete();
      }
    }),
    js3.exists().then((bool exist) {
      if (exist) {
        js3.delete();
      }
    }),
    js4.exists().then((bool exist) {
      if (exist) {
        js4.delete();
      }
    })
  ]);
}
