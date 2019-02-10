///Purpose of this library is to stretch the way to process various tasks or factor them to smaller subtasks.
///Apart of of computing logic itself, this is the cardinal part of SIDOS;
library sidos.brain;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import '../scheduler/library.dart';
import '../scheduler/task_completer/completer.dart';
import '../computor/library.dart';
import '../sidos_entities/library.dart';
import 'package:logging/logging.dart' as log;

part 'async_processer.dart';
part 'processer.dart';
part 'planner.dart';
part 'rescheduler.dart';


typedef void SendEnvelopeBrain(SidosSocketEnvelope envelope, Socket socket);

///Main objective of [Brain] is to direct [Task]s, requests and responses to appropriate parts of [sidos].
class Brain {
  static Brain _instance;

  static Brain get instance {
    if (_instance == null) {
      _instance = new Brain();
    }
    return _instance;
  }

  log.Logger logger = new log.Logger("sidos.brain.brain");

  static void logTask(Task task){
    Evolutor.instance.logTask(task);
  }


  ///[Function], specifically [SendEnvelope], that will be called upon some [Task] completion.
  static SendEnvelopeBrain _sendEnvelope; // = (_,_nope){};

  ///sets [SendEnvelope] ([_sendEnvelope]) that will be called upon some [Task] when its processing is finished (and it is not specified to not do this yet).
  static void setSendEnvelope(SendEnvelopeBrain sendEnvelope) {
    _sendEnvelope = sendEnvelope;
  }

  ///Handles processing of general [Task]
  Future processTask(Task task, int priority) async {
    String taskType = task.getType();
//    SidosSocketEnvelope envelope = new SidosSocketEnvelope();
    switch (taskType) {
      case Task.PLAN_PROCESSING_REQUEST:
        Planner.instance.processPlanningTask(task);
        break;
      case Task.IDLE:
        logger.info("wtf is this still doing here?");
//        await AsyncProcesser.instance.processIdleTask(task);
//        Scheduler.instance.addTask(new Idle(), 1);
        break;
      case Task.TEST_TASK:
        Processor.instance.processTestTask(task);
        break;
      case Task.UPDATE_IMPRINT:
        Processor.instance.processUpdateImprintTask(task, priority);
        break;
      case Task.ATTEND:
        Processor.instance.processAttendTask(task);
        break;
      case Task.UPDATE_PATTERN:
        Processor.instance.processUpdatePatternTask(task, priority);
        break;
      case Task.ADDITIONAL_EVENT_TAGS:
        Processor.instance.processAdditionalEventTagsTask(task, priority);
        break;
      case Task.SORT_FEW_EVENTS_TASK:
        Processor.instance.processSortFewEventsTask(task, priority);
        break;
      case Task.MASS_SORT_EVENTS_TASK:
        Processor.instance.processMassSortEventsTask(task, priority);
        break;
      case Task.COMPUTE_FIT_INDEX:
        Processor.instance.processComputeFitIndexTask(task, priority);
        break;
      case Task.HARD_LOG:
        await AsyncProcessor.instance.processHardLogTask(task);
        break;
      case Task.HARD_CACHE:
        await AsyncProcessor.instance.processHardCacheTask(task);
        break;
      case Task.LOAD_FROM_HARD_CACHE:
        await AsyncProcessor.instance.processLoadHardCacheTask(task);
        break;
      case Task.COMPOUND_WAITING_FOR_ADDITIONAL_INFO:
        logger.warning("Some kinf of archaic Task type ... interesting ...");
        break;
      default:
        logger.warning("Unknown task type - >>$taskType<<, ignoring ...");
    }
    if (task.sendResponseAfterProcessing) {
      logger.finest("Task of type ${task.getType()} will be returned with return data ${task.returnData.toString()}");
      task.sendResponses();
    }
  }
}
