part of view;

class SignStep4Widget extends Widget {
  SignUpWidget signUp;

  NavbarModel get model => layoutModel.navbarModel;

  SignStep4Widget(this.signUp) {
    template = parse(resources.templates.userSigning.signStep4);
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  Map out() {
    Map out = {
      "lang":lang.navbar.registration.toMap()
    };
    return out;
  }

  @override
  void setChildrenTargets() {
    // TODO: implement setChildrenTargets
  }

  @override
  void functionality() {
    // TODO: implement tideFunctionality
  }
}