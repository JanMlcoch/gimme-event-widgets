part of akcnik.role_manager.index;

class TableWidget extends Widget {
  static const Map<String, List<String>> possiblePermissions = const {
    "edit-user": const ["any", "own", "none"],
    "show-user": const ["any", "own", "none"],
    "create-user": const ["any", "own", "none"],
    "delete-user": const ["any", "own", "none"],

    "create-event": const ["any", "own", "none"],
    "edit-event": const ["any", "own", "none"],
    "show-event": const ["any", "own", "none"],
    "delete-event": const ["any", "own", "none"],

    "create-place": const ["any", "own", "none"],
    "edit-place": const ["any", "unused", "own-unused", "none"],
    "delete-place": const ["any", "unused", "own-unused", "none"],
    "merge-place": const ["any", "own", "none"],

    "create-organizer": const ["any", "own", "none"],
    "edit-organizer": const ["any", "own", "none"],
    "delete-organizer": const ["any", "own", "none"],

    "comment-event": const ["any", "own", "none"],
    "edit-permission": const ["any", "own", "none"],
    "edit-userPermission": const ["any", "own", "none"]
//    "request-merge-place": const ["any", "own", "none"]
  };

  TableWidget() {
    model.widgets.add(this);
    template = parse(resources.templates.roleManager.table);
  }

  Map<String, dynamic> out() {
    List rolesOut = [];
    if (model.roles == null) return {"permission_labels": possiblePermissions.keys, "roles": rolesOut};
    for (Map role in model.roles) {
      Map<String, dynamic> roleOut = {"role": role["role"]};
      List<Map> permissionsOut = [];
      for (String permission in possiblePermissions.keys) {
        List<String> options = possiblePermissions[permission];
        List<Map> optionsOut = [];
        for (String option in options) {
          optionsOut.add({
            "label": option,
            "option": option,
            "selected": isOptionSelected(role, permission, option) ? "selected" : ""
          });
        }
        permissionsOut.add({"permission": permission, "options": optionsOut});
      }
      roleOut["permissions"] = permissionsOut;
      rolesOut.add(roleOut);
    }
    return {"permission_labels": possiblePermissions.keys, "roles": rolesOut};
  }

  void repaint() {
    Element target = querySelector("#role_table_cont");
    target.setInnerHtml(template.renderString(out()));
    tideFunctionality(target);
  }

  void tideFunctionality(Element target) {
    List<Element> selects = target.querySelectorAll("select");
    for (SelectElement select in selects) {
      setSelectClass(select);
      select.onChange.listen((_) {
        setSelectClass(select);
        TableRowElement tr = select.closest(".role-row");
        updateRole(tr.id.replaceFirst("role_row_", ""));
      });
    }
  }

  Future updateRole(String role) {
    ElementList<SelectElement> selects = querySelector("#role_row_$role").querySelectorAll("select");
    Map<String, String> permissions = {};
    for (SelectElement select in selects) {
      String permission = select.id.replaceFirst("select_${role}_", "");
      if (select.value != "none") permissions[permission] = select.value;
    }
    return model.updateRole(role, permissions);
  }

  bool isOptionSelected(Map roleModel, String permission, String option) {
    List<String> options = possiblePermissions[permission];
    if (roleModel == null || options == null) return option == "none";
    if (roleModel["permissions"][permission] == null) {
      return option == "none";
    }
    return roleModel["permissions"][permission] == option;
  }

  void setSelectClass(SelectElement select) {
    String value = select.value;
    select.className = "role-permission-select-$value";
  }
}
