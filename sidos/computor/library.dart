library sidos.computor;

import 'dart:math' as math;
import '../sidos_server_utils.dart';
import '../sidos_entities/library.dart';
//todo: depreceted, remove in future;
@deprecated
import '../scheduler/library.dart';
//todo: more division

part 'cachor/cachor.dart';
part 'fittor/fittor.dart';
part 'fittor/gaussian.dart';
part 'imprintificator/imprintificator.dart';
part 'patternificator/patternificator.dart';
part 'self_evaluator/evolutor.dart';
part 'self_evaluator/logger.dart';

//abstract class Computor{
//
//  static Map cacheToFullMap(){
//    return Cachor.instance.toFullMap();
//  }
//
//  static void cacheFromMap(Map json){
//    Cachor.instance.fromMap(json);
//  }
//
//  //todo: this is just hotfix
//  static Cachor get cachor{
//    return Cachor.instance;
//  }
//}