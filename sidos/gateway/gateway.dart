///This library is SIDOS's part of interface between SIDOS and akcnik (or other clients)
library sidos.gateway;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import '../sidos_entities/library.dart';
//import '../sidos_server_utils.dart';
import 'package:logging/logging.dart' as log;
import 'package:akcnik/log_helper.dart' as log_helper;

typedef void ProcessEnvelope(SidosSocketEnvelope envelope, Socket socket);

///[Gateway] class processes incoming data, serializes [sidos]'s responses and
/// handles addressing responses to proper clients.
class Gateway {
  ///Initiates functions of [Gateway] class.
  static Future init(ProcessEnvelope processRequest, ProcessEnvelope processAdditionalInfo, {String customSidosIp: SIDOS_IP, int customSidosPort: SIDOS_PORT}) async {
    _instance = new Gateway();
    _instance.setRequestHandle(processRequest);
    _instance.setAdditionalInfoHandle(processAdditionalInfo);
    await Gateway._instance.initSocketing(customSidosIp, customSidosPort);
  }

  ///Singleton instance of [Gateway]
  static Gateway _instance;
  log.Logger logger = new log.Logger("sidos.gateway");

  static Gateway get instance {
    if (_instance == null) {
      log_helper.rootLoggerPrint();
      _instance = new Gateway();
    }
    return _instance;
  }

  ///lowest unused hash for identifying requests
  int lowestFreeHash = 0;

  static const String SIDOS_IP = '127.0.0.1';
  static const int SIDOS_PORT = 4042;

  String sidosIp = '127.0.0.1';
  int sidosPort = 4042;

  ///Allows to change Function to be made with incoming request [SidosSocketEnvelope]s.
  void setRequestHandle(ProcessEnvelope process) {
    _handleIncomingRequest = process;
  }

  ///Allows to change Function to be made with incoming additional info [SidosSocketEnvelope]s.
  void setAdditionalInfoHandle(ProcessEnvelope process) {
    _handleIncomingAdditionalInfo = process;
  }

  ///"Function" to be called upon incoming additional info [SidosSocketEnvelope]s. Can be set via [setAdditionalInfoHandle] or when initialising using [init]
  ProcessEnvelope _handleIncomingAdditionalInfo;

  ///"Function" to be called upon incoming request [SidosSocketEnvelope]s. Can be set via [setRequestHandle] or when initialising using [init]
  ProcessEnvelope _handleIncomingRequest;

  ///Opens communication channels on [sidosIp] address on port [sidosPort]
  Future initSocketing(String newSidosIp, int newSidosPort) async {
    sidosIp = newSidosIp;
    sidosPort = newSidosPort;
    ServerSocket serverSocket = await ServerSocket.bind(sidosIp, sidosPort);
    logger.info('connected');
    serverSocket.listen((Socket socket) {
      socket.transform(UTF8.decoder).listen((String message) {
//        print(message);
        handleIncomingMessage(message, socket);
      });
    });
  }

  ///Handles incoming [String] message [message]. Decomposes this message to atomic messages and then
  ///converts them into [SidosSocketEnvelope]s.
  void handleIncomingMessage(String message, Socket socket) {
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
      SidosSocketEnvelope envelope = new SidosSocketEnvelope();
      logger.finest("Incoming atomic message from akcnik is $atomicMessage");
      Map envelopeJson = JSON.decode(atomicMessage);
      envelope.fromMap(envelopeJson);
      _handleIncoming(envelope, socket);
    }
  }

  ///Sends response [SidosSocketEnvelope][envelope] through [Socket][socket].
  ///
  ///When there is no [socket] given (shouldn't, but might happen as result of internal task division), nothing is send anywhere.
  void sendEnvelope(SidosSocketEnvelope envelope, Socket socket) {
    if (socket != null) {
      logger.finest("Outcomming message (from sidos) is: ${JSON.encode(envelope.toFullPurgedMap())}");
      socket.write(JSON.encode(envelope.toFullPurgedMap()));
    }
  }

  ///handles incoming envelope
  void _handleIncoming(SidosSocketEnvelope envelope, Socket socket) {
    if (envelope.isRequestForAdditionalInfo) {
      _handleIncomingAdditionalInfo(envelope, socket);
    } else {
      envelope = _beforeHandlingIncomingRequest(envelope, socket);
      _handleIncomingRequest(envelope, socket);
    }
  }

  SidosSocketEnvelope _beforeHandlingIncomingRequest(SidosSocketEnvelope envelope, Socket socket) {
    if (envelope.sidosId == null) {
      SidosSocketEnvelope sidosIdEnvelope = new SidosSocketEnvelope();
      sidosIdEnvelope.akcnikId = envelope.akcnikId;
      envelope.sidosId = lowestFreeHash++;
      sidosIdEnvelope.sidosId = envelope.sidosId;
      sidosIdEnvelope.isFinalResponse = false;
      logger.finest(
          "Outcomming message (from sidos, adding sidosId) is: ${JSON.encode(sidosIdEnvelope.toFullPurgedMap())}");
      socket.write(JSON.encode(envelope.toFullPurgedMap()));
    }
    return envelope;
  }
}
