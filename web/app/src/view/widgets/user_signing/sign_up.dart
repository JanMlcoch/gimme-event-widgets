part of view;

class SignUpWidget extends Widget {
  SignStep1Widget step1;
  SignStep2Widget step2;
  SignStep3Widget step3;
  SignStep4Widget step4;
  Element cont;
  Function doClose;
  bool openWithSignIn = false;

  NavbarModel get model => layoutModel.navbarModel;

  SignUpWidget() {
    template = parse(resources.templates.userSigning.signUp);
    step1 = new SignStep1Widget(this);
    step2 = new SignStep2Widget(this);
    step3 = new SignStep3Widget(this);
    step4 = new SignStep4Widget(this);
    children = [step1];
    model.user.registration.onStepChanged.add(_makeChildren);
  }

  void _makeChildren() {
    switch (model.user.registration.step) {
      case 1:
        children = [step1];
        break;
      case 2:
        children = [step2];
        break;
      case 3:
        children = [step3];
        break;
      case 4:
        children = [step4];
        break;
    }
    repaintRequested = true;
  }

  @override
  void destroy() {
    step1.destroy();
    step2.destroy();
    step3.destroy();
    step4.destroy();
    model.user.registration.onStepChanged.remove(_makeChildren);
    view.widgets.remove(this);
    target.remove();
  }

  @override
  Map out() {
    Map out = lang.signUp.toMap();
    return out;
  }

  @override
  void setChildrenTargets() {
    children.first.target = cont;
  }

  @override
  void functionality() {
    cont = select(".registrationCont");
  }
}