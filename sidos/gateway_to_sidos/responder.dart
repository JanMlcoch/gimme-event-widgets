part of gateway_to_sidos;

abstract class Responder {
  //todo: ish. This construct will probably be on the importer's side storage
  static Future<DataStorage> storageInited;
  static Future<DataStorage> get goodStorage async {
    if (storageInited == null) {
      storageInited = loadDefaultStorage();
    }
    return storageInited;
  }

  ///Handles incoming [SidosSocketEnvelope], that has [SidosSocketEnvelope.isRequestForAdditionalInfo] true.
  static Future handleRequest(SidosSocketEnvelope envelope) async {
    if (envelope.isRequestForEventTags) {
      GatewayToSidos.instance.logger.finest("isRequestForEventTags");
      List<int> eventTags = await _getEventTags(envelope.eventId);
      SidosSocketEnvelope envelopeWithEventTags;
      if (eventTags == null) {
        envelopeWithEventTags = new SidosSocketEnvelope.additionalEventTags(envelope.eventId, eventTags,
            message: "Event Tags for event ${envelope.eventId} not found :-(");
      } else {
        envelopeWithEventTags = new SidosSocketEnvelope.additionalEventTags(envelope.eventId, eventTags,
            message: "Event Tags for event ${envelope.eventId} as requested");
      }
      GatewayToSidos.instance.logger.finest("send response");
      GatewayToSidos.instance.demandFromSidos(envelopeWithEventTags);
    }
    if (envelope.isRequestForEventInfo) {
      GatewayToSidos.instance.logger.fine("isRequestForEventInfo");
      Event event = await _getEvent(envelope.eventId);
      GatewayToSidos.instance.logger.fine("gotEvent");

      SidosSocketEnvelope envelopeWithEventInfo =
          new SidosSocketEnvelope.updateImprintEnvelope(envelope.eventId, event?.tags?.toIdList(),
              baseCost: event?.costs?.getRepresentativePrice(),
              place: new GPS.withValues(event?.mapLatitude, event?.mapLongitude), //todo:  visitLength
              isDetailedInfo: true,
              message: "Event info for event ${envelope?.eventId} as requested");
      GatewayToSidos.instance.demandFromSidos(envelopeWithEventInfo);
    }
    if (envelope.isRequestForPointsOfOrigin) {
      GatewayToSidos.instance.logger.finest("isRequestForPointsOfOrigin");
      //todo: get points of origin from akcnik
      List<GPS> pointsOfOrigin = [new GPS.withValues(14.5, 50.5)];
      SidosSocketEnvelope envelopeWithPointsOfOriginInfo = new SidosSocketEnvelope.updatePatternEnvelope(
          envelope.userId,
          pointsOfOrigin: pointsOfOrigin,
          message: "Event info for event ${envelope.eventId} as requested");
      GatewayToSidos.instance.demandFromSidos(envelopeWithPointsOfOriginInfo);
    }
    GatewayToSidos.instance.logger.finer("request handled");
  }

  static Future<List<int>> _getEventTags(int eventId) async {
    try {
      return (await goodStorage).connectHandler((Connection connection) async {
        GatewayToSidos.instance.logger.fine("asked for tags");
        IdEventFilter filter = new IdEventFilter(eventId);
        if (filter.invalid) {
          throw filter.invalidMessage;
        }
        Events events = await connection.events.load(
            filter.upgrade(),
            ["id", "tagIds"]);
        List<int> eventTags = events?.list?.isEmpty == false ? events?.list?.first?.tags?.toIdList() : null;
        GatewayToSidos.instance.logger.fine("got tags!");
        return eventTags;
      });
    } catch (e) {
      GatewayToSidos.instance.logger.severe("Failed to get tags from db");
      rethrow;
    }
  }

  static Future<List<int>> _getAllEventIds() async {
    Events events;
    try {
      return (await goodStorage).connectHandler((Connection connection) async {
        GatewayToSidos.instance.logger.fine("asked for allEventIds");
        //todo: optimize for db connections
        //todo: add active filter
        events = await connection.events.load(new FutureEventFilter().upgrade(), ["id"]);
        List<int> eventIds = events?.list?.isEmpty == false ? events?.toIdList() : null;
        GatewayToSidos.instance.logger.fine("got all event ids!");
        return eventIds;
      });
    } catch (e) {
      GatewayToSidos.instance.logger.severe("Failed to get event ids from db");
      rethrow;
    }
  }

  static Future<Event> _getEvent(int eventId) async {
    Events events;
    try {
      (await goodStorage).connectHandler((Connection connection) async {
        GatewayToSidos.instance.logger.fine("asked for event");
        EnvelopeHolder envelopeHolder = new EnvelopeHolder();
        events = await connection.events.load(
            new IdEventFilter(eventId).upgrade(message: new EnvelopeHolder()),
            ["id", "tagIds", "costs", "mapLatitude", "mapLongitude"]);
        if (!envelopeHolder.isSuccess) {
          throw envelopeHolder.envelope.message;
        }
      });
    } catch (e) {
      GatewayToSidos.instance.logger.severe("Failed to get events from db");
      rethrow;
    }
    return events?.list?.first;
  }
}
