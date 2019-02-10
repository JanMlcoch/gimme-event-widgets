part of view;

class UserSettingsSocialWidget extends UserSettingsSubWidget {
  DivElement socialConnectError;
  Element googleConnectButton;

  @override
  String get myRoute => UserSettingsModel.SOCIAL;

  UserSettingsSocialWidget() {
    img = "images/icons/social.png";
    className = "social";
    iClass = "settingsSocial";
    template = parse(resources.templates.userSettings.social);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void functionality() {
    js.context["connectFacebookUser"] = connectFacebookUser;
    socialConnectError = target.querySelector(".socialConnectError");
    googleConnectButton = target.querySelector(".gPlus");
    if (googleConnectButton != null) {
      google_helpers.initAuthButton(googleConnectButton, (String token) {
        return model.user.connectSocial(token, google: true).then((bool result) {
          requestRepaint();
          return result;
        });
      });
    }
  }

  @override
  Map out() {
    ClientUser user = model.user;
    Map out = {};
    out["lang"] = lang.userSettings.social.toMap();
    out["facebookConnected"] = user.clientSettings["facebook_id"] != null;
    out["googleConnected"] = user.clientSettings["google_id"] != null;
    return out;
  }

  @override
  void setChildrenTargets() {
    // TODO: implement setChildrenTargets
  }

  Future<bool> connectFacebookUser() async {
    envelope_lib.Envelope envelope = await fb_helpers.facebookLogin(scope: ["public_profile", "email"]);
    if (envelope.isSuccess) {
      String token = envelope.map["token"];
      bool result = await model.user.connectSocial(token, facebook: true);
      requestRepaint();
      return result;
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
    socialConnectError.innerHtml = error;
    socialConnectError.style.visibility = "visible";
    return false;
  }
}
