part of view;

class CentralWidget extends Widget {
  static const String ADD_EVENT_WIDGET_CLASS = "appAddEventWidgetCont";
  static const String USER_SETTINGS_WIDGET_CLASS = "appUserSettingsWidgetCont";
  static const String SIGN_UP_WIDGET_CLASS = "appSignUpWidgetCont";
  static bool firstAccess = true;
  Element cont;
  UserSettingsWidget userSettingsWidget;
  ForgottenPasswordWidget forgottenPasswordWidget;
  ResetPasswordWidget resetPasswordWidget;
  ConfirmUserWidget confirmUserWidget;
  TestManagerWidget testManagerWidget;
  PlannedEventsWidget plannedEventsWidget;

  CentralModel get model => layoutModel.centralModel;

  CentralWidget() {
    template = parse(resources.templates.central);
    userSettingsWidget = new UserSettingsWidget(this);
    forgottenPasswordWidget = new ForgottenPasswordWidget(model);
    resetPasswordWidget = new ResetPasswordWidget();
    confirmUserWidget = new ConfirmUserWidget();
    testManagerWidget = new TestManagerWidget();
    plannedEventsWidget = new PlannedEventsWidget();
    switchWidgets();
    model.onChange.add(switchWidgets);
  }

  void switchWidgets() {
    if (model.inUserSettings) {
      children = [userSettingsWidget];
    } else if (model.inForgottenPassword) {
      children = [forgottenPasswordWidget];
    } else if (model.inResetPassword) {
      children = [resetPasswordWidget];
    } else if (model.inConfirmUser) {
      children = [confirmUserWidget];
    } else if (model.inTestManager) {
      children = [testManagerWidget];
    } else if (model.isPlannedEvents) {
      children = [plannedEventsWidget];
    } else {
      children = [];
    }
    requestRepaint();
  }

  @override
  void destroy() {
  }

  @override
  Map out() {
    Map out = {};
    out["addEventClass"] = "";
    out["userSettingsClass"] = model.inUserSettings ? USER_SETTINGS_WIDGET_CLASS : "";
    out["signUpClass"] = "";
    return out;
  }

  @override
  void setChildrenTargets() {
    userSettingsWidget.target = cont;
    forgottenPasswordWidget.target = cont;
    resetPasswordWidget.target = cont;
    confirmUserWidget.target = cont;
    testManagerWidget.target = cont;
    plannedEventsWidget.target = cont;
  }

  @override
  void functionality() {
    model;
    if (firstAccess) {
      firstAccess = false;
      _openAlphaTestingDialog();
    }
    cont = target.querySelector(".appCentralWidgetsCont");
  }

  void _openAlphaTestingDialog() {
    querySelector("#testingDialog")?.remove();
    Element div = new DivElement()
      ..id = "testingDialog";

    Map options = {
      'dialogClass': 'noTitleStuff',
      'width':600,
      'height':500,
      'modal':true,
      'position': {"my": "center", "at": "center"}
    };

    js.context.callMethod(r"$", ["#testingDialog"])
        .callMethod("dialog", [new js.JsObject.jsify(options)]);

    ButtonElement close = new ButtonElement()
      ..text = "Vstoupit do aplikace";
    ButtonElement doc = new ButtonElement();
    AnchorElement docA = new AnchorElement(
        href: "https://docs.google.com/document/d/1TKyBe5WitXzV8JWneULqYvdw8G-HQSxFMuHxcZs88LI")
      ..text = "Dokument na poznámky"
      ..target = "_blank";
    doc.append(docA);
    close.classes.add("akcButton");
    doc.classes.add("akcButton");
    HtmlElement content = new DivElement();
    content.append(new HeadingElement.h1()..text = "Akčník.cz");
    content.append(
        new Element.tag("p")..setInnerHtml("Představujeme Vám první publikovanou verzi projektu Akčník.cz."));
    content.append(new Element.tag("p")
      ..innerHtml = "Jedná se zatím pouze o verzi pro alfa testování, tak <i>please</i> buďte trpěliví.");
    content.append(new Element.tag("p")
      ..innerHtml = "Budeme rádi za Vaše poznámky a připomínky, protože Akčník, to jste především Vy&nbsp;a&nbsp;Vaše akce.");
    content.append(new Element.tag("p")..text = "Díky!");
    content.append(new Element.tag("p")
      ..text = "(Poznámky a nápady můžete psát do připraveného Google dokumentu, který najdete zde:)");
    content.append(doc);
    content.append(new Element.tag("p")..text = "Akčník");
    content.append(new Element.tag("p")..text = "Spojuje ty správné akce se správnými lidmi.");
    content.append(close);
    content.style
      ..margin = "10px"
      ..textAlign = "center";
    div.append(content);

    close.onClick.listen((MouseEvent e) {
      js.context.callMethod(r"$", ["#testingDialog"])
          .callMethod("dialog", ["close"]);
    });
  }

  void minimizePanel() {
    cont.classes.add("hidden");
  }

  void maximizePanel() {
    cont.classes.remove("hidden");
  }
}