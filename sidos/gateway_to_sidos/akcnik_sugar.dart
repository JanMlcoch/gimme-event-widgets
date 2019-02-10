part of gateway_to_sidos;

///Send sort request to sidos and asynchronously returns sorted [eventIds] for user of id [userId]. If connection to SIDOS
///could not been established, returns the original list.
///
/// if [eventIds] is null, then all future events are sorted
Future<List<int>> sortEvents(List<int> eventIds, int userId,
    {int numberOfEventsDesired: 35, double localLatitude: null, double localLongitude: null, String message: "No message sent from client"}) async {
  GPS localPointOfOrigin =
      localLatitude == null || localLongitude == null ? null : new GPS.withValues(localLatitude, localLongitude);
  if(eventIds == null){
    eventIds = await Responder._getAllEventIds();
  }
  SidosSocketEnvelope envelope = new SidosSocketEnvelope.sortEventsForUser(userId, eventIds,
      localPointOfOrigin: localPointOfOrigin, message: message, numberOfEventsDesired: numberOfEventsDesired);
  SidosSocketEnvelope incomingEnvelope = await _demandAndRespond(envelope);
  return incomingEnvelope.success ? incomingEnvelope.eventIds : null;
}

///Gives SIDOS info about user attending events. Should return true on success.
///
///The returning value part might be bugged
Future<bool> eventAttended(int userId, int eventId) async {
  SidosSocketEnvelope envelope = new SidosSocketEnvelope.attendEnvelope(userId, eventId);
  SidosSocketEnvelope incomingEnvelope = await _demandAndRespond(envelope);
  return incomingEnvelope.success && incomingEnvelope.isFinalResponse;
}

///Function for mass information updates of attend info. Does not have any self-reflexe.
void massAttendEvents(int userId, List<int> eventIds) {
  for (int eventId in eventIds) {
    SidosSocketEnvelope envelope = new SidosSocketEnvelope.attendEnvelope(userId, eventId);
    _demandAndRespond(envelope);
  }
}

///Updates info about event in SIDOS with given info.
///
/// Future returns true on success.
Future<bool> updateImprint(int eventId, List<int> tagIds,
    {double baseCost: null, GPS place: null, int visitLength: null}) async {
  SidosSocketEnvelope envelope = new SidosSocketEnvelope.updateImprintEnvelope(eventId, tagIds,
      baseCost: baseCost, visitLength: visitLength, place: place);
  SidosSocketEnvelope incomingEnvelope = await _demandAndRespond(envelope);
  return incomingEnvelope.success && incomingEnvelope.isFinalResponse;
}

///Updates info about user in SIDOS with given info.
///
/// Future returns true on success.
/// Might be bugged right now.
Future<bool> updateUserPattern(int userId, {List<GPS> pointsOfOrigin: const []}) async {
  SidosSocketEnvelope envelope = new SidosSocketEnvelope.updatePatternEnvelope(userId, pointsOfOrigin: pointsOfOrigin);
  SidosSocketEnvelope incomingEnvelope = await _demandAndRespond(envelope);
  return incomingEnvelope.success && incomingEnvelope.isFinalResponse;
}

Future<SidosSocketEnvelope> _demandAndRespond(SidosSocketEnvelope envelope) async {
  GatewayToSidos gateWay = GatewayToSidos.instance;
  SidosSocketEnvelope incomingEnvelope;
  if (gateWay.socket?.remotePort == gateWay.sidosPort) {
    incomingEnvelope = await gateWay.demandFromSidos(envelope);
  } else {
    incomingEnvelope = envelope;
    envelope.message = "Connection with sidos unsuccesful, returning original data.";
    envelope.success = false;
  }
  return incomingEnvelope;
}
