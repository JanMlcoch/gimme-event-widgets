library eventModule;

import '../../../../server_libs/server/library.dart' as libs;
import 'package:akcnik/constants/constants.dart';
import 'package:akcnik/common/library.dart';
import '../../model/library.dart';
import "../filter/common/library.dart";
import "dart:convert" as convert;
import 'dart:async';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:akcnik/envelope.dart';
import '../../../../sidos/gateway_to_sidos/main.dart' as gateway_to_sidos;
import "../resources/resources.dart";
import 'dart:typed_data' show Uint8List;
import 'dart:math' as math;
import 'package:logging/logging.dart' as log;
import '../filter/entity/library.dart';
import '../../../../server_libs/io_helper.dart';
import 'package:mustache_no_mirror/mustache.dart';
import '../../storage/constants/constants.dart';

part "event_provider.dart";
part "create_event.dart";
part "event_image_converter.dart";
part "edit_event.dart";
part "rate_event.dart";
part "event_avatar_picker.dart";
part 'facebook_events.dart';
part 'facebook_create_event.dart';
part "editable_events.dart";
part 'static_page_generator.dart';
part 'delete_event.dart';
part 'planned_events.dart';

void loadEventModule() {
  _bindEventProviders();
  _bindDeleteEvent();
  _bindEventCreator();
  _bindEventEditor();
  _bindEventRator();
  _bindEventImageConverter();
  _bindFacebookEvents();
  _bindGetEditableEvents();
  _bindPlannedEvents();
  gateway_to_sidos.GatewayToSidos.instance.initSocket();
  //todo: more attempts to establish connection
}
