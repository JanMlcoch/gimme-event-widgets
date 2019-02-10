part of akcnik.role_manager.index;

abstract class Widget {
  Template template;

  void repaint();
}

class LoginWidget extends Widget {
  Element target;

  LoginWidget() {
    model.widgets.add(this);
    template = parse(resources.templates.roleManager.login);
  }

  Map<String, dynamic> out() {
    return {"user": model.user, "logged": model.user != null};
  }

  @override
  void repaint() {
    target = querySelector("#role_login_cont");
    target.setInnerHtml(template.renderString(out()));
    tideFunctionality();
  }

  void tideFunctionality() {
    InputElement login = target.querySelector("#role_login_login");
    InputElement password = target.querySelector("#role_login_password");
    InputElement submit = target.querySelector("#role_login_submit");
    InputElement logout = target.querySelector("#role_login_logout");
    if (submit != null) {
      submit.onClick.listen((Event event) {
        model.logUser(login.value, password.value);
      });
    }
    if (logout != null) {
      logout.onClick.listen((_) {
        model.logout();
      });
    }
  }
}
