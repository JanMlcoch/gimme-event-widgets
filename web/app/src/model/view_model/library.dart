library view_model;

import "dart:async";
import "dart:convert";
import 'package:google_maps/google_maps.dart' as g_m;
import 'package:google_maps/google_maps_places.dart' as g_m_p;
import '../root.dart';
import 'dart:html';

part 'central.dart';
part 'layout.dart';
part 'left_panel.dart';
part 'navbar.dart';
part "map_model.dart";
part "user_settings.dart";
part 'map_wrap.dart';

Model _model;
LayoutModel layoutModel;
MapModel mapModel;


void init(Model model){
  _model = model;
  layoutModel = new LayoutModel();
  mapModel = new MapModel();
}