library hovno;

import 'dart:async';
import 'sidos_entities/library.dart';
import 'gateway_to_sidos/main.dart';

Future main() async {
//  GPS gps = new GPS.withValues(15.0, 18.1);
  SidosSocketEnvelope outcomingEnvelope;
  SidosSocketEnvelope incomingEnvelope;
  String message;

//    message = "Random message1";
//    outcomingEnvelope = new SidosSocketEnvelope.updatePatternEnvelope(1, message: message);
//    incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
//    print("${incomingEnvelope.message} vs $message");

//  message = "Random message1";
//  outcomingEnvelope = new SidosSocketEnvelope.updateImprintEnvelope(1, [1], message: message);
//  incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
//  print("${incomingEnvelope.message} vs $message");
//
//  message = "Random message2";
//  outcomingEnvelope = new SidosSocketEnvelope.updatePatternEnvelope(1, pointsOfOrigin: [gps], message: message);
//  incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
//  print("${incomingEnvelope.message} vs $message");
//
//  message = "Random message2.5";
//  outcomingEnvelope = new SidosSocketEnvelope.attendEnvelope(1, 2, message: message);
//  incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
//  print("${incomingEnvelope.message} vs $message");
//
//  message = "Random message3";
//  outcomingEnvelope = new SidosSocketEnvelope.updatePatternEnvelope(1, message: message);
//  incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
//  print("${incomingEnvelope.message} vs $message");

  message = "Random message4";
  outcomingEnvelope = new SidosSocketEnvelope.sortEventsForUser(65, [1, 2], message: message);
  incomingEnvelope = await GatewayToSidos.instance.demandFromSidos(outcomingEnvelope);
  print("${incomingEnvelope.message} vs $message");
}
