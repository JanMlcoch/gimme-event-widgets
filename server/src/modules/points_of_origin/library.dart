library pointsOfOriginModule;

import '../../../../server_libs/server/library.dart' as libs;
import 'package:akcnik/constants/constants.dart';
import '../../model/library.dart';
import 'dart:async';
import '../../storage/constants/constants.dart';
import '../filter/entity/library.dart' as entity_filters;
import 'package:akcnik/envelope.dart';
import '../../storage/library.dart' as storage_lib;

part "add_point_of_origin.dart";
part "get_points_of_origin.dart";
part "delete_point_of_origin.dart";

void loadPointsOfOriginModule(){
  _bindPointOfOriginAddor();
  _bindPointOfOriginProvider();
  _bindPointOfOriginDestroyer();
}