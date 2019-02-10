library watcher;

import "dart:io";
import "dart:async";
import '../conf/conf.dart';
import '../server_libs/io_helper.dart';

bool changed = true;
bool changedInLangs = true;
Map<String, dynamic> structure;
int counter = 0;
List<String> classes;

void main() {
  print("watcher started");
  Directory dir = new Directory("resources");
  dir.watch(recursive: true).listen((FileSystemEvent e) {
    if (e.path.contains("lang_")) return;
    if (e.path.contains("jb_bak")) return;
    if (e.path.contains("jb_old")) return;
    if (!changedInLangs) {
      changed = true;
    }
  });

  new Directory("langs").watch(recursive: true).listen((_) {
    changedInLangs = true;
  });

  check();
}

void check() {
  if (changed || changedInLangs) {
    changed = false;
    generate();
    new Future<Null>.delayed(const Duration(seconds: 2)).then((_) {
      changedInLangs = false;
    });
  }
  new Future<Null>.delayed(const Duration(seconds: 3)).then((_) => check());
}

Future<Null> generate() async {
  print("watcher generating");
  Process.start(
      "dart", [PATH_TO_RESOURCES_GENERATOR])
      .then((Process process) {
    printFromOutputStreams(process, "Server");
  });
}
