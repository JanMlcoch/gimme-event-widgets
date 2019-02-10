library model.test;

import 'dart:async';
import '../test/test_initer.dart' as test_initer;

typedef Future ClientTestFunction();

class ClientTestModel {
  ClientTestGroup activeGroup;
  List<ClientTestGroup> groups = [];
  List<Function> onChange = [];

  ClientTestModel() {
    test_initer.main().then((_) => fireChanges());
  }


  void fireChanges() {
    onChange.forEach((Function f) => f());
  }

  Future run() {
    return Future.forEach(groups.toList()
      ..shuffle(), (ClientTestGroup group) => group.run());
  }
}

class ClientTestGroup {
  final String name;
  String simpleName;
  final ClientTestModel parent;
  List<ClientTest> tests = [];

  ClientTestGroup(this.name, this.parent) {
    simpleName = name.toLowerCase().replaceAll(new RegExp(r"[^\w]"), "_");
  }

  Future run() {
    tests.forEach((ClientTest test) => test.reset());
    return Future.forEach(tests.toList()
      ..shuffle(), (ClientTest test) => test.run());
  }
}

class ClientTest {
  final String name;
  final String description;
  final ClientTestGroup parent;
  final ignored;
  String simpleName;
  String error;
  bool isFinished = false;
  ClientTestFunction function;

  ClientTest(this.name, this.function, this.parent, this.description, this.ignored) {
    simpleName = name.toLowerCase().replaceAll(new RegExp(r"[^\w]"), "_");
  }


  void fail(String message) => throw new ClientTestFailure(message);

  Future run() {
    if (ignored) return new Future.value();
    reset();
    return runZoned(() {
      return new Future(() => function()).then((_) {
        finish();
      }).catchError((e) {
        error = e.toString();
        if (e is Error)
          error += "\n" + e.stackTrace.toString();
        finish();
      });
    }, zoneValues: {#activeTest:this});
  }

  void reset() {
    isFinished = false;
    error = null;
  }

  void finish() {
    isFinished = true;
    parent.parent.fireChanges();
  }
}

class ClientTestFailure implements Exception {
  String message;

  ClientTestFailure(this.message);

  String toString() {
    return "Expectation failed:\n$message";
  }
}
