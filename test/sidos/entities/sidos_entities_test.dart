library akcnik.tests.sidos.task_completer;

import 'package:test/test.dart';
import 'dart:async';
import '../../../sidos/sidos_entities/library.dart';
import 'dart:math' as math;
import 'dart:convert';

part 'gps.dart';
part 'imprint.dart';
part 'imprint_point.dart';
part 'pattern.dart';
part 'sidos_socket_envelope.dart';

int timeoutInSeconds = 1;

dynamic roundJsonObject(dynamic json, {int validDigits: 4}) {
  if (json is Map) {
    return roundMapJson(json, validDigits: validDigits);
  }
  if (json is List) {
    return roundListJson(json, validDigits: validDigits);
  }
  if (json is double) {
    return roundInJson(json, validDigits: validDigits);
  }
  return null;
}

Map roundMapJson(Map map, {int validDigits: 4}) {
  Map toReturn = JSON.decode(JSON.encode(map));

  map.forEach((dynamic key, dynamic val) {
    if (val is Map) {
      toReturn[key] = roundMapJson(val, validDigits: validDigits);
    }
    if (val is List) {
      toReturn[key] = roundListJson(val, validDigits: validDigits);
    }
    if (val is double) {
      toReturn[key] = roundInJson(val, validDigits: validDigits);
    }
  });

  return toReturn;
}

List roundListJson(List list, {int validDigits: 4}) {
  List toReturn = JSON.decode(JSON.encode(list));

  for (int i = 0; i < list.length; i++) {
    if (list[i] is Map) {
      toReturn[i] = roundMapJson(list[i], validDigits: validDigits);
    }
    if (list[i] is List) {
      toReturn[i] = roundListJson(list[i], validDigits: validDigits);
    }
    if (list[i] is double) {
      toReturn[i] = roundInJson(list[i], validDigits: validDigits);
    }
  }

  return toReturn;
}

double roundInJson(double val, {int validDigits: 4}) {
  int digitsBeforeDecimalPoint = (math.log(val) / math.log(10)).ceil();
  double orderShift = math.pow(10, validDigits - digitsBeforeDecimalPoint).toDouble();
  double roundedVal = (val * orderShift).roundToDouble() / orderShift;
  return roundedVal;
}

void main() {
  group("GPS tests", () {
    gpsTests();
  });
  group("Imprint tests", () {
    imprintTests();
  });
  group("ImprintPoint tests", () {
    imprintPointTests();
  });
  group("Pattern tests", () {
    patternTests();
  });
  group("SidosSocketEnvelope tests", () {
    sidosSocketEnvelopeTests();
  });
}
