part of view;

class UserSettingsBaseWidget extends UserSettingsSubWidget {
  @override
  String get myRoute => "";

  static String cannotBeEmpty = lang.forms.cannotBeEmpty;
  Element nameInput;
  Element surname;
  Element email;
  Element cityAutocomplete;
  InputElement oldPassword;
  InputElement newPassword1;
  InputElement newPassword2;
  ButtonElement setNewPassword;
  SelectElement language;
  List<Element> editableElements = [];

  FormValidator validator;

  Element nameValidatorMessage;
  Element surnameValidatorMessage;
  Element oldPasswordValidatorMessage;
  Element newPassword1ValidatorMessage;
  Element newPassword2ValidatorMessage;

  Element imageCont;

  FormSectionReport nameReport;
  FormSectionReport surnameReport;
  FormSectionReport oldPasswordReport;
  FormSectionReport newPassword1Report;
  FormSectionReport newPassword2Report;

  ImagePickerWidget imagePicker;
  CityAutocompleteWidget cityAutocompleteWidget;
  CentralModel get model => layoutModel.centralModel;

  UserSettingsBaseWidget() {
    img = "images/icons/pen.png";
    className = "base";
    iClass = "settingsUserSettings";
    template = parse(resources.templates.userSettings.base);
    imagePicker = new ImagePickerWidget(USER_AVATAR_WIDTH, USER_AVATAR_HEIGHT, imgSrc: model.user.imgSrc);
    cityAutocompleteWidget = new CityAutocompleteWidget(model.user);
    imagePicker.onChange.add(imageChanged);
    imagePicker.onCancel.add(imageCanceled);
    children = [imagePicker, cityAutocompleteWidget];
    model.user.onUserChanged.add(requestRepaint);
  }

  void imageChanged() {
    model.user.imageData = imagePicker.imgSrc;
    model.user.fireChange();
    if (!window.localStorage.containsKey("userSettingsImageHash")) {
      window.localStorage["userSettingsImageHash"] = "0";
    } else {
      int hash = int.parse(window.localStorage["userSettingsImageHash"]);
      hash++;
      window.localStorage["userSettingsImageHash"] = "$hash";
    }
    _save();
  }

  void imageCanceled() {
    imagePicker.imgSrc = model.user.imgSrc;
  }

  @override
  void destroy() {
    imagePicker.onChange.remove(imageChanged);
    imagePicker.onCancel.remove(imageCanceled);
    model.user.onUserChanged.remove(requestRepaint);
  }

  @override
  void functionality() {
    nameInput = select(".nameValue");
    surname = select(".surnameValue");
    language = select(".languageValue");
    cityAutocomplete = select(".cityAutocompleteContainer");
    editableElements = [nameInput, surname];

    oldPassword = select("input[name=userSettingsOldPassword]");
    newPassword1 = select("input[name=userSettingsNewPassword]");
    newPassword2 = select("input[name=userSettingsNewPasswordAgain]");
    setNewPassword = select(".userSettingsChangePasswordButton button");

    setNewPassword.onClick.listen((_) {
      Map passwordData = {};
      passwordData["oldPassword"] = oldPassword.value;
      passwordData["newPassword"] = newPassword1.value;
      passwordData["id"] = model.user.id;
      model.user.changePassword(passwordData);
    });

    language.onInput.listen((_) {
      print(model.user.language);
      _save();
      print(model.user.language);
      window.location.reload();
    });

    oldPasswordValidatorMessage = select(".oldPasswordNotValid");
    newPassword1ValidatorMessage = select(".newPassword1NotValid");
    newPassword2ValidatorMessage = select(".newPassword2NotValid");

    imageCont = select(".userSettingsImage");

    imagePicker.imgSrc = model.user.imgSrc;

    _createValidator();

    _bindEditButtons();
  }

  void _createValidator() {
    validator = new FormValidator();
    validator.addSectionReport(_createOldPasswordReport());
    validator.addSectionReport(_createNewPassword1Report());
    validator.addSectionReport(_createNewPassword2Report());
  }

  FormSectionReport _createOldPasswordReport() {
    oldPasswordReport = new FormSectionReport(
        "oldPassword", oldPassword, oldPasswordValidatorMessage);
    FormSectionStringValidator notEmptyValidator = new FormSectionStringValidator
        .notEmpty(validityMessage: cannotBeEmpty);
    oldPasswordReport.addSectionValidator(notEmptyValidator);
    return oldPasswordReport;
  }

  FormSectionReport _createNewPassword1Report() {
    newPassword1Report = new FormSectionReport(
        "newPassword1", newPassword1, newPassword1ValidatorMessage);
    FormSectionStringValidator minimalCharsValidator = new FormSectionStringValidator
        .minimalChars(
        5, validityMessage: lang.navbar.registration.minimalCharacters);
    newPassword1Report.addSectionValidator(minimalCharsValidator);
    return newPassword1Report;
  }

  FormSectionReport _createNewPassword2Report() {
    newPassword2Report = new FormSectionReport(
        "newPassword2", newPassword2, newPassword2ValidatorMessage);
    FormSectionIdentityValidator samePasswordValidator = new FormSectionIdentityValidator(
        newPassword1, validityMessage: lang.navbar.registration.notSamePassword,
        checkAfterKeyUp: true);
    newPassword2Report.addSectionValidator(samePasswordValidator);
    return newPassword2Report;
  }

  void _bindEditButtons() {
    for (Element element in editableElements) {
      Element editIcon = element.parent.querySelector(".userSettingsEditIcon");
      editIcon.onClick.listen((_) {
        _toggleEdit(element);
      });
      element.onKeyUp.listen((_) {
        String data = element.dataset["input"];
        InputElement hiddenInput = select(".${data}ValueHiddenInput");
        hiddenInput.value = element.text;
      });
      element.onKeyDown.listen((KeyboardEvent event) {
        if (event.keyCode == KeyCode.ENTER) {
          event.stopImmediatePropagation();
          element.contentEditable = "false";
        }
      });
      element.onBlur.listen((_) {
        _save();
        element.contentEditable = "false";
      });
    }
  }

  void _toggleEdit(Element element) {
    if (element.isContentEditable) {
      element.contentEditable = "false";
    } else {
      element.contentEditable = "true";
      element.focus();
      window.getSelection().selectAllChildren(element);
    }
  }

  void _save([_]) {
    model.user.language = language.value;
    model.user.firstName = nameInput.text;
    model.user
      ..surname = surname.text
      ..clientSettings["haveImage"] = model.user.clientSettings["haveImage"] ||
          model.user.imageData.startsWith("data");
    model.user.saveChanges();
  }

  @override
  Map out() {
    Map out = {};
    Map langs = {};
    langs["en"] = "English";
    langs["cs"] = "Čeština";
    String options = "";
    langs.forEach((String key, String value) {
      options += "<option value='$key' ${model.user.language == key
          ? "selected"
          : ""}>$value</option>";
    });
    out["lang"] = lang.userSettings.base.toMap();
    out["languageOptions"] = options;
    out["usersName"] = model.user.firstName;
    out["usersSurname"] = model.user.surname;
    out["usersEmail"] = model.user.email;
    out["usersCity"] = model.user.residenceTown;
    out["editImageSRC"] = "images/settings_images/editPenTool.png";
    return out;
  }

  @override
  void setChildrenTargets() {
    imagePicker.target = imageCont;
    cityAutocompleteWidget.target = cityAutocomplete;
  }
}
