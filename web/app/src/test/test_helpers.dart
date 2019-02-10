library akcnik.web.test.helpers;

import '../model/root.dart' as root_model;
import 'test_manager.dart';
import 'package:matcher/matcher.dart';
import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;

void group(String name) {
  ClientTestModel testModel = root_model.model.testModel;
  for (ClientTestGroup group in testModel.groups) {
    if (group.name == name) {
      testModel.activeGroup = group;
      return;
    }
  }
  ClientTestGroup group = new ClientTestGroup(name, testModel);
  testModel.groups.add(group);
  testModel.activeGroup = group;
}

void test(String name, ClientTestFunction function, {String description, bool ignored: false}) {
  ClientTestModel testModel = root_model.model.testModel;
  if (testModel.activeGroup == null) {
    ClientTestGroup group = new ClientTestGroup("default", testModel);
    testModel.groups.add(group);
    testModel.activeGroup = group;
  }
  ClientTest test = new ClientTest(name, function, testModel.activeGroup, description, ignored);
  testModel.activeGroup.tests.add(test);
}

void xtest(String name, ClientTestFunction function, {String description}) {
  test(name, function, description: description, ignored: true);
}

void expect(dynamic actual, dynamic dynamicMatcher, {String reason}) {
  Matcher matcher = wrapMatcher(dynamicMatcher);
  var matchState = {};
  try {
    if (matcher.matches(actual, matchState)) return;
  } catch (e, trace) {
    if (reason == null) {
      reason = '${(e is String) ? e : e.toString()} at $trace';
    }
  }
  ClientTest activeTest = Zone.current[#activeTest];
  activeTest.fail(_defaultFailFormatter(actual, matcher, reason, matchState, true));
}
//###########################################################################################
String _defaultFailFormatter(actual, Matcher matcher, String reason, Map matchState, bool verbose) {
  var description = new StringDescription();
  description.add('Expected: ').addDescriptionOf(matcher).add('\n');
  description.add('  Actual: ').addDescriptionOf(actual).add('\n');

  var mismatchDescription = new StringDescription();
  matcher.describeMismatch(actual, mismatchDescription, matchState, verbose);

  if (mismatchDescription.length > 0) {
    description.add('   Which: $mismatchDescription\n');
  }
  if (reason != null) description.add(reason).add('\n');
  return description.toString();
}

Future openPageAndWaitFor(String hashUrl, bool checker()) {
  if (hashUrl == null) throw new ArgumentError.notNull("hashUrl");
  root_model.model.appState.goToGeneric(hashUrl);
  return waitFor(checker);
}

Future waitFor(bool checker()) {
  return Future.doWhile(() {
    if (checker()) return false;
    return new Future.delayed(new Duration(milliseconds: 100));
  }).timeout(new Duration(seconds: 3));
}

Future<html.Element> openPageAndWaitForElement(String hashUrl, String selector,
    {html.Element container, hidden: false}) {
  if (hashUrl == null) throw new ArgumentError.notNull("hashUrl");
  root_model.model.appState.goToGeneric(hashUrl);
  return waitForElement(selector, container: container, hidden: hidden);
}

Future<html.Element> waitForElement(String selector, {html.Element container, hidden: false}) {
  html.Element found;
  return Future
      .doWhile(() {
    List<html.Element> founds =
    container == null ? html.querySelectorAll(selector) : container.querySelectorAll(selector);
    if (founds.length != 0) {
      if (hidden) {
        founds.first;
      } else {
        found = founds.firstWhere((html.Element element) {
          return element.style.display != 'none';
        }, orElse: () => null);
      }
      if (found != null) return false;
    }
    return new Future.delayed(new Duration(milliseconds: 100), () => true);
  })
      .then((_) => found)
      .timeout(new Duration(seconds: 3),
      onTimeout: () => throw new StateError(
          'Element "$selector" is missing' + (container == null ? '' : ' in Element ".${container.className}"')));
}

String randomString([int length = 10]) {
  var rand = new math.Random();
  var codeUnits = new List.generate(length, (index) {
    int index = rand.nextInt(62);
    if (index < 10) return index + 48;
    if (index < 36) return index + 55;
    return index + 61;
  });
  return new String.fromCharCodes(codeUnits);
}

int randomInteger([int length = 10]) {
  double rand = new math.Random().nextDouble() * math.exp(length) * math.LN10;
  return rand.floor();
}
