part of view;

class ConfirmUserWidget extends Widget {
  ButtonElement continueToApp;
  String token;

  CentralModel get model => layoutModel.centralModel;

  ConfirmUserWidget() {
    template = parse(resources.templates.pages.confirmUser);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void functionality() {
    token = model.getTokenFromHash();
    continueToApp = select(".continueToApp");
    model.confirmUser(token);
    continueToApp.onClick.listen((_) {
      model.goToRecommendedEvents();
    });
  }

  @override
  Map out() {
    Map out = {};
    Map langMap = lang.confirmUser.toMap();
    out["lang"] = langMap;
    return out;
  }

  @override
  void setChildrenTargets() {
    // TODO: implement setChildrenTargets
  }
}