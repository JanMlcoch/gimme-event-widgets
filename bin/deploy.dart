import "dart:io";
import "dart:async";
import '../server_libs/io_helper.dart';
import '../conf/conf.dart' as conf;
import 'package:path/path.dart' as path_lib;
import 'package:args/args.dart' as arg_lib;

String gitDir;
String akcnikLiveDirectory = conf.LinuxServerRules.productionDirectory;
String pathToPub = conf.LinuxServerRules.pathToPub;
List<String> insideWebForbiddenFolders = conf.WebFolderRules.notProductionFolders;

void main(List<String> args) {
  load();
}

Future load() async {
  gitDir = getProjectDirectoryName();
  print("resolved project directory: $gitDir");
  if (path_lib.basename(gitDir) == akcnikLiveDirectory) {
    throw new Exception("Cannot deploy to project directory");
  }
  ProcessResult result = Process.runSync(
      "git", ["pull", "origin", "relese"], workingDirectory: "$gitDir");
  int i = 0;
  while (result.exitCode != 0 && i++ < 2) {
    result = Process.runSync(
        "git", ["pull", "origin", "relese"], workingDirectory: "$gitDir");
  }
  if (result.exitCode != 0) {
    print("operation failed  ${result.stderr}");
    return;
  }
  print("git pull success ${result.stdout}");

  Directory.current = gitDir;

  result = Process.runSync("pub", ["get"]);
  print(result.stdout);
  print(result.stderr);

  result = Process.runSync("dart", ["$gitDir/${conf.PATH_TO_RESOURCES_GENERATOR}"]);
  print(result.stdout);
  print(result.stderr);

  try {
    ProcessResult result = Process.runSync(
        "dart", ["--package-root=packages", "$gitDir/bin/buildscript.dart"]);
//        "dart", ["--package-root=packages", "$gitDir/bin/buildscript.dart", "--production"]);
    print(result.stdout);
  } catch (e) {
    print("dart2js compiler failed");
    print(e);
  }

  if (new File("$gitDir/web/app/main.dart.js").existsSync()) {
    print("js file created on address: $gitDir/web/app/main.dart.js");
  }

  Directory akcnikDir = new Directory("$gitDir/../$akcnikLiveDirectory")
    ..createSync(recursive: true);
  Directory originalImages = new Directory("${akcnikDir.path}/web/app/images")
    ..createSync(recursive: true);
  Directory imagesBackup = new Directory("$gitDir/../imagesBackup")
    ..createSync(recursive: true);
  String logsHistoryPath = "$gitDir/../history_logs/${new DateTime.now()
      .millisecondsSinceEpoch}";
  Directory logsDir = new Directory(logsHistoryPath)
    ..createSync(recursive: true);
  Directory originalLogs = new Directory("${akcnikDir.path}/logs");
  try {
    originalLogs.renameSync(logsDir.path);
    print("logs moved to $logsHistoryPath");
  } catch (e) {
    print("no logs to move");
  }

  imagesBackup
    ..deleteSync(recursive: true)
    ..createSync();
  print("images backup cleared");

  List<String> imagesToMove = ["events_images", "user_images", "specific_images"
  ];
  for (String image in imagesToMove) {
    try {
      Directory toMove = new Directory("${originalImages.path}/$image");
      toMove.renameSync(imagesBackup.path + "/$image");
      print("images $image moved to ${imagesBackup.path}");
    } catch (e) {
      print(image + " cannot be moved");
    }
  }

  akcnikDir
    ..deleteSync(recursive: true)
    ..createSync();
  print("${akcnikDir.path} is empty now");


//  akcnikDir.

  try {
    ProcessResult result = Process.runSync("dart", [conf.PATH_TO_COPY_TO_LIVE_SCRIPT]);
    print(result.stdout);
  } catch (e) {
    print(e);
  }


  for (String image in imagesToMove) {
    try {
      new Directory(originalImages.path + "/$image")
        ..deleteSync(recursive: true)
        ..createSync();
      Directory toMove = new Directory("${imagesBackup.path}/$image");
      toMove.renameSync(originalImages.path + "/$image");
      print("images $image moved to ${originalImages.path + "/$image"}");
    } catch (e) {
      print(image + " cannot be moved back");
    }
  }

  new File("$gitDir/pubspec.yaml").copy("${akcnikDir.path}/pubspec.yaml");
  print("pubspec copy");


  Directory.current = akcnikDir;
  try {
    ProcessResult result = Process.runSync("pub", ["get"]);
    print(result.stdout);
  } catch (e) {
    print(e);
  }


  deleteRecursively(new Directory("${akcnikDir.path}/web"),
      deleteFileChecker: (String basename) {
        return basename.endsWith(".dart");
      }, deleteDirectoryChecker: (String basename) {
        return insideWebForbiddenFolders.contains(basename);
      });


  new File("${akcnikDir.path}/web/app/index.html")
    ..deleteSync();
  new File("${akcnikDir.path}/web/app/production_index.html")
    ..renameSync("${akcnikDir.path}/web/app/index.html");

  print("production index placed");

  Directory.current = new Directory("${akcnikDir.path}");

  print("starting loader");
  Process.run("dart", ["server/server_loader.dart"], runInShell: true);
}

arg_lib.ArgResults parseArgs(List<String> args) {
  arg_lib.ArgParser parser = new arg_lib.ArgParser();
  parser.addOption("database",
      abbr: "d",
      allowed: ["test", "devel", "production"],
      defaultsTo: "devel",
      help: "Start server with selected database (default = devel database)");
  return parser.parse(args);
}


Directory pickGit(String name) {
  return new Directory("$gitDir/$name")
    ..createSync(recursive: true);
}
