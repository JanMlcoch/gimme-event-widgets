import "dart:io" as io;
import "dart:async";
import "dart:convert";
import '../server_libs/io_helper.dart';
import '../conf/conf.dart' as conf;
import 'package:args/args.dart' as arg_lib;

io.File log;
io.File errorLog;
io.IOSink logFile;
io.IOSink errorLogFile;
arg_lib.ArgResults parsedArgs;

Future main(List<String> args) async {
  if (await terminateMe(conf.Ports.loaderServicePort)) {
    print("previous loader terminated");
  } else {
    print("no loader started before launch");
  }
  createTerminator(conf.Ports.loaderServicePort);
  parsedArgs = parseServerRunnerArgs(args);
  print("server loader alive on ${io.Directory.current.path}");
  log = new io.File("logs/log.txt");
  errorLog = new io.File("logs/error.txt");
  log.createSync(recursive: true);
  errorLog.createSync(recursive: true);
  logFile = log.openWrite();
  errorLogFile = errorLog.openWrite();
  startServer();
}

void startServer() {
  io.Process.start("dart", ["server/main.dart", "--database=${parsedArgs["database"]}"]).then((io.Process process) {
    Stream<List<int>> stdout = process.stdout;
    Stream<List<int>> stderr = process.stderr;
    stderr.transform(UTF8.decoder).listen((String data) {
      errorLogFile.writeln(data);
    });
    stdout.transform(UTF8.decoder).listen((String data) {
      logFile.writeln(data);
    });
    process.exitCode.then((int exitCode) {
      errorLogFile.writeln("exited with code $exitCode");
      new Future.delayed(const Duration(seconds: 5)).then((_) {
        startServer();
      });
    });
  });
}