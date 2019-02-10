///SIDOS - engine for systematic intelligent induction and deduction(from Czech Systematický Inteligentní Dovozovací a Odvozovací Stroj)
library sidos.runner;

import 'dart:async';
import 'dart:io';
import 'gateway/gateway.dart';
import 'scheduler/library.dart';
import 'brain/brain.dart';
import 'sidos_entities/library.dart';
//import 'package:logging/logging.dart' as log;
import 'package:akcnik/log_helper.dart' as log_helper;
import 'package:args/args.dart' as arg_lib;
import '../server_libs/io_helper.dart' as io_helper;

Future main([List<String> args = const[]]) async {
  arg_lib.ArgResults parsedArgs = io_helper.parseArgs(null, args);
  log_helper.RootLogger.init(text: parsedArgs["loglevel"]);
  log_helper.rootLoggerPrint(all: true);
  ProcessEnvelope processRequest = (SidosSocketEnvelope envelope, Socket socket) {
    Scheduler.instance.addTask(new PlanProcessingRequestTask.fromEnvelope(envelope, socket), 5);
  };
  ProcessEnvelope processAdditionalInfo = (SidosSocketEnvelope envelope, Socket socket) {
    Scheduler.instance.addTask(IncomingAdditionalInfoTask.fromEnvelope(envelope, socket), 4);
  };
  await Gateway.init(processRequest, processAdditionalInfo);
  ProcessTask processTask = (Task task, int priority) {
    Brain.instance.processTask(task, priority);
  };
  SendEnvelope sendEnvelope = (SidosSocketEnvelope envelope, Socket socket) {
    Gateway.instance.sendEnvelope(envelope, socket);
  };
  SendEnvelopeBrain sendEnvelopeBrain = sendEnvelope;
  LogTask logTask = (Task task){
    Brain.logTask(task);
  };
  Brain.setSendEnvelope(sendEnvelopeBrain);
  Scheduler.init(processTask, sendEnvelope, logTask: logTask);
  print("SIDOS server started");
}
