part of akcnik.role_manager.index;

class RoleModel {
  Map user;
  List roles = [];
  List<Widget> widgets = [];

  Future loadRoles() {
    return Gateway.instance.get("/api/role/get").then((envelope_lib.Envelope envelope) {
      if (envelope.isSuccess && envelope.message == "") return null;
      roles = envelope.list;
      fireChanges();
    });
  }

  Future isLogged() {
    return Gateway.instance.get(CONTROLLER_USER).then((envelope_lib.Envelope envelope) {
      if (!envelope.isSuccess) return;
      user = envelope.map;
      loadRoles();
      fireChanges();
    });
  }

  Future logUser(String login, String password) {
    return Gateway.instance
        .post(CONTROLLER_LOGIN, data: {"login": login, "password": password}).then((envelope_lib.Envelope envelope) {
      if (!envelope.isSuccess) return;
      user = envelope.map["user"];
      loadRoles();
      fireChanges();
    });
  }

  void logout() {
    Gateway.instance.logout();
  }

  void fireChanges() {
    for (Widget widget in widgets) {
      widget.repaint();
    }
  }

  Future updateRole(String role, Map<String, String> permissions) {
    return Gateway.instance.post("/api/role/edit", data: {"role": role, "permissions": permissions}).then(
        (envelope_lib.Envelope envelope) {
      Map updatedRole = envelope.map;
      for (int i = 0; i < roles.length; i++) {
        if (updatedRole["role"] == roles[i]["role"]) {
          roles[i] = updatedRole;
          fireChanges();
          break;
        }
      }
      return updatedRole;
    });
  }
}
