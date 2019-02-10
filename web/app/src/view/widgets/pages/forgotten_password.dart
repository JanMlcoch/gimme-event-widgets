part of view;

class ForgottenPasswordWidget extends Widget {
  bool hasResult = false;
  bool emailSent = false;
  InputElement input;
  ButtonElement resetPassword;
  CentralModel centralModel;

  ForgottenPasswordWidget(this.centralModel) {
    template = parse(resources.templates.pages.forgottenPassword);
  }

  @override
  void destroy() {}

  @override
  Map out() {
    Map out = {};
    Map langMap = lang.forgottenPassword.toMap();
    out["lang"] = langMap;
    out["result"] = hasResult;
    out["emailSent"] = emailSent;
    return out;
  }

  @override
  void setChildrenTargets() {}

  @override
  void functionality() {
    input = select("#forgottenPasswordInput");
    resetPassword = select(".resetPassword");
    resetPassword.disabled = input.value.length == 0;
    input.onInput.listen((_) {
      resetPassword.disabled = input.value.length == 0;
      return;
    });
    resetPassword.onClick.listen(_forgottenPassword);
  }

  Future _forgottenPassword(MouseEvent event) async {
    envelope_lib.Envelope envelope =
    await Gateway.instance.post(CONTROLLER_FORGOTTEN_PASSWORD, data: {"login": input.value});
    emailSent = envelope.isSuccess;
    hasResult = true;
    repaintRequested = true;
  }
}
