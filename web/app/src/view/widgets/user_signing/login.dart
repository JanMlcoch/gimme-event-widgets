part of view;

class LoginWidget extends Widget {
  Element submitButton;
  Element wrongLogin;
  InputElement loginElement;
  InputElement password;
  Element signIn;
  AnchorElement forgottenPassword;
  SignUpWidget signUp;

  NavbarModel get model => layoutModel.navbarModel;

  LoginWidget(this.signUp) {
    name = "Login";
    template = parse(resources.templates.userSigning.login);
  }

  @override
  void destroy() {
    // do nothing
  }

  @override
  Map out() {
    Map out = lang.login.toMap();
    out["signInPart"] = true;
    out["forgottenPasswordHref"] = "#forgotten_password";
    return out;
  }

  @override
  void setChildrenTargets() {
    // do nothing
  }

  @override
  void functionality() {
    void submit(dynamic _) {
      if (loginElement.value.length == 0 || password.value.length == 0) {
        _showWrongLogin();
        return;
      };
      Future request = model.user.submitCredentials(loginElement.value, password.value);
      request.then((bool successful) {
        if (successful) {
          close();
          layoutModel.navbarModel.goToRecommendedEvents();
        } else {
          _showWrongLogin();
        }
      });
    }

    void onEnter(KeyboardEvent e) {
      if (e.keyCode == KeyCode.ENTER) {
        submit(null);
      }
    }

    wrongLogin = target.querySelector(".appLoginIncorrect");
    password = target.querySelector("#appPasswordInput");
    submitButton = target.querySelector(".submitCredentials");
    loginElement = target.querySelector("#appLoginInput");
    forgottenPassword = select(".appLoginWidgetForgot");
    submitButton.onClick.listen(submit);
    loginElement.onKeyDown.listen(onEnter);
    password.onKeyDown.listen(onEnter);
    forgottenPassword.onClick.listen((_) {
      layoutModel.navbarModel.goToForgottenPassword();
      close();
    });

    loginElement.focus();
  }

  void _showWrongLogin() {
    wrongLogin.style.visibility = "visible";
  }

  void close() {
    signUp.doClose();
  }
}