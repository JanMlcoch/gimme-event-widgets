library sidos_runner;

import "dart:io";
import 'dart:async';
import '../server_libs/io_helper.dart';

Future main() {
  int msSinceEpoch = new DateTime.now().millisecondsSinceEpoch;
  // Get the system temp directory.
  Directory projectDir = new Directory(getProjectDirectoryName());
//  print(projectDir.path);
  File file = new File('${projectDir.path}/sidos/computor/cachor/hard_cache/runner_log_$msSinceEpoch.txt');
  file.createSync();
  return Process.start(dartExecutable, ["-c --package-root=packages", "${projectDir.path}/sidos/main.dart"]).then(
      (Process process) {
    print("SIDOS process started!");
    return waitForSignal(process, "SIDOS server started", printPrefix: "SIDOS")
        .then((bool result) => process)
        .timeout(new Duration(seconds: 10), onTimeout: () => null);
  });
}
