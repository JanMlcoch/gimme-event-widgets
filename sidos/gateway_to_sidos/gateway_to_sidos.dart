part of gateway_to_sidos;

///the [GatewayToSidos] class handles communication of server, where it is implemented to a [sidos] server.
class GatewayToSidos {
  static GatewayToSidos _instance;
  log.Logger logger = new log.Logger("sidos.outer_gateway");

  static GatewayToSidos get instance {
    if (_instance == null) {
      _instance = new GatewayToSidos();
//      _instance.initSocket();
    }
    return _instance;
  }

  ///IP address of [sidos] server.
  String sidosIp = '127.0.0.1';

  ///port of [sidos] server for communication.
  int sidosPort = 4042;

  ///[Socket], through which communication with [sidos] server is taking place
  Socket socket;

  ///local Hashes for identification of requests.
  int localHash = 0;

  ///Completers for requests for sidosIds
  Map<int, Completer<SidosSocketEnvelope>> completersForHash = {};

  ///Completers for requests for sidos's responses
  Map<int, Completer<SidosSocketEnvelope>> completersForResponses = {};

  ///Stores received final responses that has no corresponding pending request ([Completer] in [completersForResponses]
  ///by the same [SidosSocketEnvelope.sidosId]).
  ///
  ///When an additional [Completer] is added to [completersForResponses], [receivedResponsesWithoutRequests] ar checked
  ///for the case, when the response would arrive before creating the completer.
  Map<int, SidosSocketEnvelope> receivedResponsesWithoutRequests = {};

  //todo: make this not singleton
  //todo: test this
  void kill() {
    socket.destroy();
    Responder.goodStorage.then((DataStorage storage) {
      storage.killStorage();
    });
    _instance = null;
    completersForHash.values.forEach((Completer completer) {
      completer.complete(new SidosSocketEnvelope());
    });
    completersForResponses.values.forEach((Completer completer) {
      completer.complete(new SidosSocketEnvelope());
    });
  }

  ///Serializes and sends [SidosSocketEnvelope] to [sidos] server.
  Future<SidosSocketEnvelope> demandFromSidos(SidosSocketEnvelope envelope) async {
    await _makeSureSocketingIsInitialized();
    int hash = localHash++;
    Completer<SidosSocketEnvelope> completerForHash = new Completer();
    envelope.akcnikId = hash;
    logger.finer("Outcomming message (from akcnik) (preSidosId) is ${JSON.encode(envelope.toFullPurgedMap())}");
    socket.write(JSON.encode(envelope.toFullPurgedMap()));
    completersForHash[hash] = completerForHash;
    envelope = await completerForHash.future;
    completersForHash.remove(hash);
    int sidosHash = envelope.sidosId;
    Completer<SidosSocketEnvelope> completerForData = new Completer();
    completersForResponses[sidosHash] = completerForData;
    if (receivedResponsesWithoutRequests[sidosHash] != null) {
      completersForResponses[sidosHash].complete(receivedResponsesWithoutRequests[sidosHash]);
    }
    envelope = await completerForData.future;
    completersForResponses.remove(sidosHash);
    return envelope;
  }

  ///Initiates [Socket][socket] for use.
  Future initSocket() async {
    try {
      socket = await Socket.connect(sidosIp, sidosPort);
    } catch (_) {}
    if (socket?.remotePort == sidosPort) {
      socket.transform(UTF8.decoder).listen((String message) {
        //todo: better handling - splitter
        List<String> messages = message.split("}{");
        if (messages.length == 2) {
          messages[0] += "}";
          messages[1] = "{" + messages[1];
        }
        if (messages.length > 2) {
          messages[0] += "}";
          for (int i = 1; i < messages.length - 1; i++) {
            messages[i] = "{" + messages[i] + "}";
          }
          messages[messages.length - 1] = "{" + messages[messages.length - 1];
        }
        for (String atomicMessage in messages) {
          logger.finer("Incoming atomic message is $atomicMessage");
          SidosSocketEnvelope incomingEnvelope = new SidosSocketEnvelope()..fromMap(JSON.decode(atomicMessage));
          _handleIncoming(incomingEnvelope);
        }
      });
    }
  }

  Future _makeSureSocketingIsInitialized() async {
    if (socket == null) {
      //todo: discuss duration
      Timer timer = new Timer(new Duration(seconds: 1), () {
        //todo: smarter handling?
        throw new StateError(
            "Socket is not opened, SIDOS server is unavaviable or the connection took too long to establish.");
      });
      await initSocket();
      timer.cancel();
    }
  }

  ///Handles incoming data from [sidos]
  void _handleIncoming(SidosSocketEnvelope envelope) {
    if (envelope.isRequestForAdditionalInfo) {
      logger.fine("Recieved request for aditional info");
      Responder.handleRequest(envelope);
    } else {
      _handleOtherThanRequestForAdditionalInfo(envelope);
    }
  }

  void _handleOtherThanRequestForAdditionalInfo(SidosSocketEnvelope envelope) {
    if (envelope.isFinalResponse) {
      _handleFinalResponse(envelope);
    } else {
      _handleNonFinalResponse(envelope);
    }
  }

  void _handleFinalResponse(SidosSocketEnvelope envelope) {
    if (envelope.sidosId == null) {
      logger.fine("Recieved final responce from SIDOS without sidosId, ignoring...");
    } else {
      _handleFinalResponseWithSidosId(envelope);
    }
  }

  void _handleFinalResponseWithSidosId(SidosSocketEnvelope envelope) {
    if (completersForResponses[envelope.sidosId] == null) {
      _handleFinalResponseWithoutPendingRequest(envelope);
    } else {
      logger.fine("Recieved final responce from SIDOS with sidosId ${envelope.sidosId}, processing");
      completersForResponses[envelope.sidosId].complete(envelope);
    }
  }

  void _handleFinalResponseWithoutPendingRequest(SidosSocketEnvelope envelope) {
    if (receivedResponsesWithoutRequests[envelope.sidosId] == null) {
      logger.fine("""Recieved final responce from SIDOS with sidosId ${envelope.sidosId}, but it does not belong to any
                pending request, archived.""");
    } else {
      logger.fine("""Recieved final responce from SIDOS with sidosId ${envelope.sidosId}, but it does not belong to any
                pending request, and response with the same sidosId has been already archived. This response has been
                archived by overwriting previously archived response.""");
    }
    receivedResponsesWithoutRequests[envelope.sidosId] = envelope;
  }

  void _handleNonFinalResponse(SidosSocketEnvelope envelope) {
    if (envelope.akcnikId == null) {
      logger.warning("Recieved non-final responce from SIDOS without akcnikId, ignoring...");
    } else {
      if (completersForHash[envelope.akcnikId] == null) {
        logger.fine(
            "Recieved non-final responce from SIDOS with akcnikId ${envelope.akcnikId}, but it does not belong to any pending request, ignoring...");
      } else {
        _handleNonFinalResponseWithPendingHash(envelope);
      }
    }
  }

  void _handleNonFinalResponseWithPendingHash(SidosSocketEnvelope envelope) {
    if (envelope.sidosId == null) {
      logger.fine(
          "Recieved non-final responce from SIDOS with akcnikId ${envelope.akcnikId}, but it does include sidosId, ignoring...");
    } else {
      logger.fine(
          "Recieved non-final responce from SIDOS with akcnikId ${envelope.akcnikId} & sidosId ${envelope.sidosId}, request is probably delivered succesfully...");
      completersForHash[envelope.akcnikId].complete(envelope);
    }
  }
}
