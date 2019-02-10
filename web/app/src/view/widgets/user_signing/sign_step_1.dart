part of view;

class SignStep1Widget extends Widget {
  Element newAccount;
  Element gPlus;
  Element facebook;
  DivElement externalLoginError;
  Element _login;
  LoginWidget loginWidget;
  SignUpWidget signUp;

  NavbarModel get model => layoutModel.navbarModel;

  SignStep1Widget(this.signUp) {
    template = parse(resources.templates.userSigning.signStep1);
    loginWidget = new LoginWidget(signUp);
    children = [loginWidget];
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  Map out() {
    Map out = {"lang": lang.navbar.registration.toMap()};
    out["signInPart"] = signUp.openWithSignIn;
    return out;
  }

  @override
  void setChildrenTargets() {
    loginWidget.target = _login;
  }

  @override
  void functionality() {
    js.context["checkFacebookStatus"] = checkFacebookStatus;
    fb_helpers.loadFacebookSDK();

    newAccount = select(".newAccount");
    gPlus = select(".gPlus");
    facebook = select(".facebook");
    externalLoginError = select(".external-login-error-message");
    _login = target.querySelector(".appLoginWidgetCont");

    newAccount.onClick.listen((_) {
      model.user.registration.step = 2;
    });
    bindGoogleLoginButton();
  }

  void bindGoogleLoginButton() {
    google_helpers.initAuthButton(gPlus, (String token) {
      model.user.loginByToken(token, ClientUser.GOOGLE_TOKEN).then((bool isLogged) {
        signUp.doClose();
        if (isLogged) {
          layoutModel.navbarModel.goToRecommendedEvents();
        } else {
          signUp.doClose();
          return model.user.createFromSocial(token, google: true).then((envelope_lib.Envelope envelope) {
            if (envelope.isSuccess) {
              model.user.fromMap(envelope.map);
            } else {
              throw new StateError(envelope.message);
            }
            layoutModel.navbarModel.goToUserSettings();
          });
        }
      });
    });
  }

  Future<bool> checkFacebookStatus() async {
    envelope_lib.Envelope envelope = await fb_helpers.checkFacebookStatus();
    if (envelope.isSuccess) {
      String token = envelope.map["token"];
      bool isLogged = await model.user.loginByToken(token, ClientUser.FACEBOOK_TOKEN);
      if (isLogged) {
        signUp.doClose();
        layoutModel.navbarModel.goToRecommendedEvents();
        return true;
      } else {
        signUp.doClose();
        envelope_lib.Envelope envelope = await model.user.createFromSocial(token, facebook: true);
        if (envelope.isSuccess) {
          model.user.fromMap(envelope.map);
        }
        layoutModel.navbarModel.goToUserSettings();
        return true;
      }
    } else {
      switch (envelope.message) {
        case 'connected':
          return _showExternalLoginError(lang.login.facebook.errorConnected);
        case 'not_authorized':
          return _showExternalLoginError(lang.login.facebook.errorNotInApp);
        default:
          return _showExternalLoginError(lang.login.facebook.errorNotInFB);
      }
    }
  }

  bool _showExternalLoginError(error) {
    externalLoginError.innerHtml = error;
    externalLoginError.style.visibility = "visible";
    return false;
  }
}
