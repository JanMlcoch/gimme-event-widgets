part of view;

class ResetPasswordWidget extends Widget {
  Element setNewPassword;
  InputElement newPassword;
  InputElement newPasswordAgain;
  FormSectionReport password2Report;
  Element password2ValidMessage;

  ResetPasswordWidget() {
    template = parse(resources.templates.pages.resetPassword);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void functionality() {
    setNewPassword = select(".setNewPassword");
    newPassword = select("#passwordReset");
    newPasswordAgain = select("#passwordResetAgain");
    password2ValidMessage = select(".errorMessage");
    password2Report = _createPassword2Validator();

    setNewPassword.onClick.listen((_){_setNewPassword();});
    newPasswordAgain.onInput.listen((_) {
      password2Report.checkValidity();
    });
  }

  FormSectionReport _createPassword2Validator() {
    password2Report = new FormSectionReport('password2', newPasswordAgain, password2ValidMessage);
    FormSectionIdentityValidator passwordIdentity = new FormSectionIdentityValidator(newPassword,
        validityMessage: lang.navbar.registration.notSamePassword, checkAfterKeyUp: true);
    password2Report.addSectionValidator(passwordIdentity);
    return password2Report;
  }

  @override
  Map out() {
    Map out = {};
    Map langMap = lang.resetPassword.toMap();
    out["lang"] = langMap;
    return out;
  }

  @override
  void setChildrenTargets() {
    // TODO: implement setChildrenTargets
  }

  void _setNewPassword([Event _]) {
    if (!password2Report.checkValidity()) return;
    String token = layoutModel.centralModel.getTokenFromHash();
    _resetPassword(newPassword.value, token);
  }

  Future _resetPassword(String newPassword, String token) async {
    await layoutModel.centralModel.resetPassword(newPassword, token);
    layoutModel.centralModel.goToRecommendedEvents();
  }
}
