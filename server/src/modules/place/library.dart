library placeModule;

import '../../../../server_libs/server/library.dart' as libs;
import 'package:akcnik/constants/constants.dart';
import '../../model/library.dart';
import "../filter/common/library.dart" as common_filter;
import "../filter/entity/library.dart" as entity_filter;
//import '../../storage/library.dart' as storage;
//import "../sorter/library.dart";
import "dart:convert" as convert;
import 'dart:async';
import 'package:akcnik/envelope.dart';
import 'package:logging/logging.dart' as log;
import '../../storage/library.dart';

part "autocomplete_place.dart";
part "create_place.dart";
part "place_provider.dart";
part "nearby.dart";

part "editable_places.dart";
part 'edit_and_delete.dart';

void loadPlaceModule() {
  _bindAutocompletePlace();
  _bindCreatePlace();
  _bindPlacesProvider();
  _bindNearby();
  _bindEditablePlaces();
  _bindEditAndDelete();
}
