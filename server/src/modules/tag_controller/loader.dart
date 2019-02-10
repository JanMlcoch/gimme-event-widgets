library tag_controller;

import "../../model/library.dart";
import '../../../../server_libs/server/library.dart' as libs;
import 'package:akcnik/constants/constants.dart';
import 'package:akcnik/envelope.dart';
//import "../filter/library.dart";
import "dart:async";
import '../../storage/library.dart' as storage_lib;

part "tag_filter.dart";
part "tag_autocomplete.dart";
//part "tag_list.dart";

void loadTagControllerModule() {
  libs.route(CONTROLLER_TAG_FILTER_GET_OPTIONS, () => new TagFilterRequestContext(), method: "POST");
}

class TagFilterRequestContext extends libs.RequestContext {
  String mail;

  @override
  Future execute() {
    List<Map<String, dynamic>> responseIsh = [];
    try {
      responseIsh = executeAutocompleteRequest(data).toFullList();
    } catch (e) {
      envelope.error(e.toString(), TAG_DATA_NOT_READY);
      return null;
    }
    envelope.withList(responseIsh);
    return null;
  }
}
