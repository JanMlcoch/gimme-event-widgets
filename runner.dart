import "dart:io";
import 'dart:async';
import 'server_libs/io_helper.dart';
import 'package:args/args.dart' as arg_lib;

void main(List<String> args) {
  String projectDir = getProjectDirectoryName();
  arg_lib.ArgResults parsedArgs = parseServerRunnerArgs(args);
  Directory logs = new Directory("$projectDir/nginx/logs");
  File accessLog = new File("$projectDir/nginx/logs/access.log");
  File errorLog = new File("$projectDir/nginx/logs/error.log");

  if (!logs.existsSync()) {
    logs.createSync();
    accessLog.createSync();
    errorLog.createSync();
  } else {
    if (accessLog.existsSync() && !errorLog.existsSync())
      errorLog.createSync();
    else if (!accessLog.existsSync() && errorLog.existsSync())
      accessLog.createSync();
    else {
      accessLog.createSync();
      errorLog.createSync();
    }
  }
  Completer nginxCompleter = new Completer();
  if (Platform.operatingSystem == "linux") {

  } else {
    Process.start("nginx/nginx.exe", [], workingDirectory: "$projectDir/nginx")
        .then((Process process) {
      nginxCompleter.complete();
      printFromOutputStreams(process, "Nginx");
    });
  }

  Completer serverCompleter = new Completer();
  if (args.contains("--no-server") || args.contains("-s")) {
    serverCompleter.complete();
  } else {
    Process.start(dartExecutable, [
      "-c --package-root=packages",
      "$projectDir/server/main.dart",
      "--database=${parsedArgs["database"]}"
    ]).then((Process process) {
      serverCompleter.complete();
      printFromOutputStreams(process, "Server");
    });
  }

  Completer watcherCompleter = new Completer();
  Process.start(dartExecutable,
      ["$projectDir/bin/watcher.dart"]).then((
      Process process) {
    watcherCompleter.complete();
    printFromOutputStreams(process, "Watcher");
  });
  Future.wait(
      [nginxCompleter.future, serverCompleter.future, watcherCompleter.future])
      .then((_) {
    print("All processes started");
  });

//  Process.start("pub", ["get", "--packages-dir"],workingDirectory: projectDir);
//  Process.start("pub", [],workingDirectory: projectDir);
}
