part of mailer.periodic.recommended;

Future main({int cycles: 1}) async {
  int counter = 0;
//  log_helper.RootLogger.init(log_helper.LogLevel.FINE).addSubLevel("sidos",log_helper.LogLevel.FINE);
  log_helper.RootLogger.init(level: log.Level.FINER).addSubLevel("sidos", log_helper.LogLevel.WARNING);
//  log_helper.rootLoggerPrint(finer: true);
  log.Logger logger = new log.Logger("akcnik.mailer.cruncher");
  io.Process sidosProcess = await runSidosServer();
  if (sidosProcess == null) {
    logger.shout("sidosProcess is null");
    return null;
  }
  StreamController<String> controller = new StreamController<String>();
  mailer_private.Mailer.instance.testOut = controller;
  controller.stream.listen((String data) {
    new log.Logger("akcnik.mailer.cruncher.task").finer(data);
  });
  await gateway.GatewayToSidos.instance.initSocket();
  storage_lib.DataStorage storage = await storage_lib.loadDefaultStorage();
  await periodicTimer(new Duration(seconds: 1), (CancelCallback cancel) {
    Future lastProcess = dayCrunch(storage);
    counter++;
    if (cycles != null && counter >= cycles) {
      cancel(lastProcess);
    }
  });
  logger.finer("Cruncher finished, killing processes started");
  await storage.killStorage();
  sidosProcess.kill();
  await gateway.GatewayToSidos.instance.kill();
  logger.finer("Cruncher helper processes killed");
}

Future<io.Process> runSidosServer() {
  return io.Process.start(
      dartExecutable, ["-c --package-root=packages", "${getProjectDirectoryName()}/sidos/main.dart", "-lOFF"])
      .then(
      (io.Process process) {
    return waitForSignal(process, "SIDOS server started")
        .then((bool result) => process)
        .timeout(new Duration(seconds: 10), onTimeout: () => null);
  });
}
