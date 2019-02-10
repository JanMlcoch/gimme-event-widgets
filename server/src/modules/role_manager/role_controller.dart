library akcnik.role_manager;

import '../../../../server_libs/server/library.dart' as libs;
import 'package:akcnik/constants/constants.dart';
import '../../model/library.dart';
import '../../storage/constants/constants.dart';

//import '../../storage/library.dart' as storage;
//import "../sorter/library.dart";
import 'dart:async';

const String CONTROLLER_ROLE_GET = "/api/role/get";
const String CONTROLLER_ROLE_ADD = "/api/role/add";
const String CONTROLLER_ROLE_EDIT = "/api/role/edit";

void loadRoleManager() {
  libs.route(CONTROLLER_ROLE_GET, () => new GetRoleRC(),
      method: "GET", permission: Permissions.EDIT_PERMISSIONS_IN_ROLE);
  libs.route(CONTROLLER_ROLE_ADD, () => new AddRoleRC(),
      method: "POST", template: {"role": "String"}, permission: Permissions.EDIT_PERMISSIONS_IN_ROLE);
  libs.route(CONTROLLER_ROLE_EDIT, () => new EditRoleRC(),
      method: "POST",
      template: {"role": "String", "permissions": "Map"},
      permission: Permissions.EDIT_PERMISSIONS_IN_ROLE);
}

//###########################################################################
class GetRoleRC extends libs.RequestContext {

  @override
  Future execute() async {
    CustomList list = await connection.customs(USER_ROLES_TABLE_NAME).load(null, null, fullColumns: true, limit: -1);
    envelope.withList(list.toFullList());
  }
}

//###########################################################################
class AddRoleRC extends libs.RequestContext {

  @override
  Future execute() async {
    CustomEntity entity = await connection.customs(USER_ROLES_TABLE_NAME).saveModel(data);
    envelope.withMap(entity.toFullMap());
  }
}

//###########################################################################
class EditRoleRC extends libs.RequestContext {

  @override
  Future execute() async {
//    return envelope.withMap(data);
    CustomEntity entity = await connection.customs(USER_ROLES_TABLE_NAME).updateModel(data, ["permissions"]);
    if (entity == null) {
      envelope.error("unknown role");
      return null;
    }
    envelope.withMap(entity.toFullMap());
  }
}
