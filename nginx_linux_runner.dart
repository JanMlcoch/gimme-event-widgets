import "dart:io";
import 'dart:async';
import 'server_libs/io_helper.dart';

void main(List<String> args) {
  String projectDir = getProjectDirectoryName();

  Completer nginxCompleter = new Completer();
  if (Platform.operatingSystem == "linux") {
    Process.runSync("sudo", ["nginx", "-s", "stop"]);
    Process.start("sudo",
        [ "nginx", "-c", "conf/nginx.conf", "-p","$projectDir/nginx/"],
        workingDirectory: "$projectDir/nginx")
        .then((Process process) {
      nginxCompleter.complete();
      printFromOutputStreams(process, "Nginx");
    });
  }
}
