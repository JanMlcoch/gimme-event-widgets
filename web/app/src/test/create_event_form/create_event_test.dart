library akcnik.web.test.create_event;

import '../../model/root.dart' as model;
import '../test_helpers.dart';
import 'dart:html' as html;
import 'package:matcher/matcher.dart';
import '../../model/root.dart';

void main() {
  void setValue(html.Element input, dynamic value) {
    expect(input, isNotNull);
    if (input is html.InputElement) {
      input
        ..focus()
        ..value = value
        ..blur();
    } else if (input is html.TextAreaElement) {
      input
        ..focus()
        ..value = value
        ..blur();
    }
  }

  group("Event creation");
  test("by Anonym", () async {
    model.model.user.logout();
    int counter = 0;
    await waitFor(() {
      counter++;
      return counter < 4;
    });
    expect(html.querySelector(".appAddEventRoute"), isNull);
    await openPageAndWaitFor(model.ROUTE_ADD_EVENT, () {
      counter++;
      return counter < 7;
    });
    expect(html.querySelector(".sidebarManageEventContainer"), isNull);
  });
  test("client basic validation", () async {
    ClientUser user = model.model.user;
    bool result = await user.submitCredentials("gratzky", "gratzky");
    expect(result, isTrue);
    expect(user.firstName, "Gregor");
    html.ButtonElement addEventButton = await waitForElement(".appAddEventRoute");
    expect(addEventButton, isNotNull);
    addEventButton.click();
    html.ButtonElement sendEventButton = await waitForElement(".akcButton.saveEventButton");
    html.DivElement cont = html.querySelector(".appAddEventWidgetCont");

    html.InputElement nameInput = cont.querySelector("#eventName");
    html.InputElement fromInput = cont.querySelector("#eventFrom");
    html.InputElement toInput = cont.querySelector("#eventTo");
    html.InputElement fromTimeInput = cont.querySelector("#eventFromTime");
    html.InputElement toTimeInput = cont.querySelector("#eventToTime");
    html.TextAreaElement annotationTextArea = cont.querySelector("#appEventAnnotation");
    html.InputElement tagsInput = cont.querySelector(".appSsTagAutocomplete");
    html.InputElement placesInput = cont.querySelector(".appSearchAndAddPlaceInput");
    setValue(fromTimeInput, "");
    setValue(toTimeInput, "");

    sendEventButton.click();
    expect(nameInput.classes, contains("invalid"));
    expect(fromInput.classes, contains("invalid"));
    expect(toInput.classes, contains("invalid"));
    expect(fromTimeInput.classes, contains("invalid"));
    expect(toTimeInput.classes, contains("invalid"));
    expect(annotationTextArea.classes, contains("invalid"));
    expect(tagsInput.classes, contains("invalid"));
    expect(placesInput.classes, contains("invalid"));


    setValue(nameInput, "aa");
    setValue(fromInput, randomInteger(20));
    setValue(toInput, randomInteger(20));
    setValue(fromTimeInput, randomString());
    setValue(toTimeInput, randomString());
    setValue(tagsInput, randomString(20));
    setValue(placesInput, randomString(20));

    sendEventButton.click();
    expect(nameInput.classes, contains("invalid"));
    expect(fromInput.classes, contains("invalid"));
    expect(toInput.classes, contains("invalid"));
    expect(fromTimeInput.classes, contains("invalid"));
    expect(toTimeInput.classes, contains("invalid"));
    expect(tagsInput.classes, contains("invalid"));
    expect(placesInput.classes, contains("invalid"));

    setValue(nameInput, randomString());
    setValue(fromInput, "29.6.2016");
    setValue(toInput, "30.6.2016");
    setValue(fromTimeInput, "10:00");
    setValue(toTimeInput, "24:00");
    setValue(annotationTextArea, randomString(150));
//    setValue(tagsInput,"pi");
//    html.DivElement firstTagElement = $cont.querySelector(".appSsTagOptionsTarget .appSsOptionCont");
//    firstTagElement.click();
//    await waitForElement(".appChosenTagsTarget .appSsChosenTagContainer");

    sendEventButton.click();
    expect(nameInput.classes, isNot(contains("invalid")));
    expect(fromInput.classes, isNot(contains("invalid")));
    expect(toInput.classes, isNot(contains("invalid")));
    expect(fromTimeInput.classes, isNot(contains("invalid")));
    expect(toTimeInput.classes, isNot(contains("invalid")));
    expect(annotationTextArea.classes, isNot(contains("invalid")));

    setValue(nameInput, randomString(10000));
    setValue(fromInput, "38.6.2016");
    setValue(toInput, "21.13.2016");
    setValue(fromTimeInput, "30:00");
    setValue(toTimeInput, "-2:00");
    setValue(annotationTextArea, randomString(10000));

    sendEventButton.click();
    expect(nameInput.classes, contains("invalid"));
    expect(fromInput.classes, contains("invalid"));
    expect(toInput.classes, contains("invalid"));
    expect(fromTimeInput.classes, contains("invalid"));
    expect(toTimeInput.classes, contains("invalid"));
    expect(annotationTextArea.classes, contains("invalid"));

    await user.logout();
  },
      description: "Check client validations from first tab without actually sending data. It log in an user as a first step");
}