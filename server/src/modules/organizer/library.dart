library organizerModule;

import '../../../../server_libs/server/library.dart' as libs;
import 'package:akcnik/constants/constants.dart';
import 'package:akcnik/envelope.dart';
//import '../../model/library.dart';
//import "../filter/library.dart";
//import "../sorter/library.dart";
//import "dart:convert";
import 'dart:async';

part "autocomplete_organizer.dart";
part "create_organizer.dart";

void loadOrganizerModule() {
  _bindAutocompleteOrganizer();
  _bindCreateOrganizer();
}
