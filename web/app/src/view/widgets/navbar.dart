part of view;

class NavbarWidget extends Widget {
  DivElement _container;
  Element _navbarTop;
  ButtonElement _toggleMenu;
  Element _goToUserSettings;
  Element _goToAddEvent;
  Element _goToSignIn;
  Element _goToSignUp;
  Element _goToRecommendedEvents;
  Element _goToPlannedEvents;

  Element _activeTab;
  Element _logOut;
  Element _login;
  Element _settings;
  ImageElement _image;
  SignUpWidget signUpWidget;
  bool firstRepaint = true;
  NavbarModel model;

  NavbarWidget() {
    name = "Navbar";
    model = layoutModel.navbarModel;
    template = parse(resources.templates.navbar);
    signUpWidget = new SignUpWidget();
    recheck();
    model.onChange.add(recheck);
    model.onUserChange.add(requestRepaint);
  }

  void recheck() {
    if (model.user.isLogged) {
      children = [];
    }
    if (model.isSignUpDialog) {
      signUpWidget.openWithSignIn = model.isSignIn;
      _openSignUpDialog();
    }
    requestRepaint();
  }

  @override
  void destroy() {
    model.onChange.remove(recheck);
  }

  @override
  Map out() {
    Map out = {};
    out["lang"] = lang.navbar.toMap();
    out["logged"] = model.user.isLogged;
    out["userLogin"] = model.user.login;
    out["langShortCut"] = model.user.language;
    out["loggedUserIcon"] = "images/user_images/user_avatar_${model.user.id}.png";
    return out;
  }

  @override
  void setChildrenTargets() {}

  @override
  void functionality() {
    _container = querySelector("#pageContainer");
    _navbarTop = target.querySelector("#navbar");
    _toggleMenu = target.querySelector("#navbarBtn");
    _goToAddEvent = target.querySelector(".appAddEventRoute");
    _goToUserSettings = target.querySelector(".appUserSettingsRoute");
    _goToSignIn = target.querySelector(".appSignIn");
    _goToSignUp = target.querySelector(".appSignUpRoute");
    _goToRecommendedEvents = target.querySelector(".appRecommendedEvents");
    _goToPlannedEvents = target.querySelector(".appPlannedEvents");
    _logOut = select(".appUserLogOut");
    _login = select(".appNavbarWidgetUserLogin");
    _settings = select(".appNavbarWidgetSettings");
    _image = select(".appNavbarWidgetSettings");

    _toggleMenu.dataset["target"] = "#sidebar-right";
    String menuTarget = _toggleMenu.dataset["target"];

    _toggleMenu.onClick.listen((MouseEvent e) {
      if (_container.classes.contains("open-sidebar-right")) {
        closeSidebar("right", menuTarget);
      } else {
        openSidebar("right", menuTarget);
      }
    });

    _goToAddEvent?.onClick?.listen((_) {
      model.goToAddEvent();
    });
    _goToUserSettings?.onClick?.listen((_) {
      model.goToUserSettings();
    });
    _goToPlannedEvents?.onClick?.listen((_) {
      model.goToPlannedEvents();
    });

    if (_goToSignIn != null) {
      _goToSignIn.onClick.listen((_) {
        model.goToSignIn();
      });
    }
    if (_goToSignUp != null) {
      _goToSignUp.onClick.listen((_) {
        model.goToSignUp();
      });
    }

    _goToRecommendedEvents?.onClick?.listen((_) {
      model.goToRecommendedEvents();
    });

    _logOut?.onClick?.listen((_) {
      model.user.logout();
    });

    _settings?.onClick?.listen((_) {
      model.goToUserSettings();
    });

    _setImage();
    setActiveTab();
  }

  void setActiveTab() {
    if (model.isRecommendedEvents) {
      _activeTab = _goToRecommendedEvents;
    } else if (model.isAddEvent) {
      _activeTab = _goToAddEvent;
    } else if (model.isUserSettings) {
      _activeTab = _goToUserSettings;
    } else if (model.isSignIn) {
      _activeTab = _goToSignIn;
    } else if (model.isSignUpDialog) {
      _activeTab = _goToSignUp;
    } else if (model.isPlannedEvents) {
      _activeTab = _goToPlannedEvents;
    }

    if (_activeTab == null) {
      return;
    }
    _cancelActiveTab();
    _activeTab.classes.add("active");
  }

  void _cancelActiveTab() {
    if (_activeTab != null) {
      _activeTab.classes.remove("active");
    }
  }

  void _setImage() {
    if (_image == null) return;
    _image.src = model.user.imgSrc;
    _image.onError.listen((Event event) {
      _image.src = 'images/user_images/user_avatar_default.png';
    });
  }

  void _openSignUpDialog([_]) {
    querySelector("#signUpDialog")?.remove();
    Element div = new DivElement()
      ..id = "signUpDialog";
    document.body.append(div);

    Map options = {
      'width': 360,
      'modal': true,
      'position': {"my": "bottom", "at": "center"},
      'close': ([_, _nope]) {
        model.closeSignUpDialog();
      },
      'open': ([event, ui]) {
        document
            .querySelector(".ui-widget-overlay")
            .onClick
            .listen((MouseEvent e) {
          js.context.callMethod(r"$", ["#signUpDialog"]).callMethod("dialog", ["close"]);
        });
      }
    };

    js.context.callMethod(r"$", ["#signUpDialog"]).callMethod("dialog", [new js.JsObject.jsify(options)]);
    model.user.registration.restart();
    signUpWidget
      ..target = div
      ..doClose = () {
        js.context.callMethod(r"$", ["#signUpDialog"]).callMethod("dialog", ["close"]);
      };
    view.widgets.remove(signUpWidget);
    view.widgets.add(signUpWidget);
    signUpWidget.requestRepaint();
  }

  bool isLeftSidebarVisible() {
    return _container.classes.contains("open-sidebar-left");
  }

  void openSidebar(String side, String targetSelector) {
    String classToAdd = "open-sidebar-$side";
    _container.classes.add(classToAdd);
    _navbarTop.classes.add(classToAdd);

    querySelector("$targetSelector").classes.remove("hidden-custom");
  }

  void closeSidebar(String side, String targetSelector) {
    String classToDelete = "open-sidebar-$side";
    querySelector("$targetSelector").classes.add("hidden-custom");

    _container.classes.remove(classToDelete);
    _navbarTop.classes.remove(classToDelete);
  }
}
