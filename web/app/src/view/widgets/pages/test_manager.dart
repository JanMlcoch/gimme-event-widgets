part of view;

class TestManagerWidget extends Widget {
  ClientTestModel get testModel => layoutModel.centralModel.rootModel.testModel;

  TestManagerWidget() {
    name = "TestManagerWidget";
    template = parse(resources.templates.pages.testManager);
    testModel.onChange.add(() {
      repaintRequested = true;
    });
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void functionality() {
    ClientTestModel model = testModel;
    target
        .querySelector("#test_manager_heading")
        .onClick
        .listen((MouseEvent e) => model.run().then(goToTestManager));
    for (ClientTestGroup group in model.groups) {
      target
          .querySelector("#test_manager_group_" + group.simpleName)
          .onClick
          .listen((MouseEvent e) => group.run().then(goToTestManager));
      for (ClientTest test in group.tests) {
        target
            .querySelector("#test_manager_" + test.simpleName)
            .onClick
            .listen((MouseEvent e) => test.run().then(goToTestManager));
      }
    }
  }

  void goToTestManager(_) {
    layoutModel.centralModel.rootModel.appState.goToTestManager();
  }

  @override
  Map out() {
    ClientTestModel model = testModel;
    Map<String, dynamic> result = {};
    result["groups"] = model.groups.map((ClientTestGroup group) {
      return {
        "name": group.name,
        "simple": group.simpleName,
        "tests": group.tests.map((ClientTest test) {
          String style;
          if (test.isFinished) {
            style = test.error == null ? "test-manager-button-success" : "test-manager-button-fail";
          }
          if (test.ignored) {
            style = "test-manager-button-ignored";
          }
          if (test.error == null) {
            return {
              "name": test.name,
              "simple": test.simpleName,
              "haveResult":false,
              "style": style,
              "description":test.description,
              "haveDescription":test.description != null
            };
          } else {
            List<String> resultLines = test.error.split("\n");
            return {
              "name": test.name,
              "simple": test.simpleName,
              "firstLine":resultLines.first,
              "resultLines": resultLines..removeAt(0),
              "haveResult":true,
              "haveDescription":false,
              "style": style
            };
          }
        }).toList()
      };
    }).toList();
    return result;
  }

  @override
  void setChildrenTargets() {
    // TODO: implement setChildrenTargets
  }
}
