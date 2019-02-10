part of sidos.scheduler;

class PlanProcessingRequestTask extends Task {
  PlanProcessingRequestTask.fromEnvelope(SidosSocketEnvelope envelope, Socket socket) {
    new log.Logger("sidos.scheduler.plan_processing_reguest_task").finest(
        """Envelope for PlanProcessingTask is :${envelope.toFullMap()}
Purged envelope for PlanProcessingTask is :${envelope.toFullPurgedMap()}""");
    returnData = {
      socket: [envelope]
    };
  }

  PlanProcessingRequestTask();

  @override
  bool validate() {
    //todo: validation
    return true;
  }

  @override
  bool equals(o) {
    return false;
  }
}