import "dart:io";
import "dart:async";
import '../server_libs/io_helper.dart';
import '../conf/conf.dart' as conf;
import 'package:path/path.dart' as path_lib;

String gitDir;
String akcnikLiveDirectory = conf.LinuxServerRules.productionDirectory;
String pathToPub = conf.LinuxServerRules.pathToPub;
List<String> insideWebForbiddenFolders = conf.WebFolderRules.notProductionFolders;

void main(List<String> args) {
  load();
}

Future load() async {
  gitDir = getProjectDirectoryName();

  // todo: stop generating resources from deploy
  ProcessResult result = Process.runSync("dart", ["$gitDir/${conf.PATH_TO_RESOURCES_GENERATOR}"]);
  print(result.stdout);
  print(result.stderr);

  if (path_lib.basename(gitDir) == akcnikLiveDirectory) {
    throw new Exception("Cannot deploy to project directory");
  }
  Directory akcnikDir = new Directory("$gitDir/../$akcnikLiveDirectory");
   List<String> forbiddenFolderNames = ["packages"];
  List<String> foldersToCopy = [
    "data", "lib", "mailer", "server", "server_libs", "sidos", "web", "conf"];
  for (String folderName in foldersToCopy) {
    Directory newFolder = pickGit(folderName);
    recursiveFolderCopySync(
        newFolder.path, "${akcnikDir.path}/$folderName", forbiddenFolderNames);
    print("copy $folderName from ${newFolder.path} to ${akcnikDir.path}");
  }
}


Directory pickGit(String name) {
  return new Directory("$gitDir/$name")
    ..createSync(recursive: true);
}
