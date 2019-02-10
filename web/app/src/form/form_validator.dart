part of form;

class FormValidator {
  List<FormSectionReport> sectionsReport = [];
  List<FormValidator> subValidators = [];

//  getter valid only returns if form is valid, checkValidity returns if form
//  is valid and shows validity message
  bool get isValid{
    bool valid = true;
    valid = !sectionsReport.any((FormSectionReport report) => !report.valid);
    valid = !subValidators.any((FormValidator validator) => !validator.checkValidity());
    return valid;
  }

  FormValidator();

  void addSectionReport(FormSectionReport sectionReport) {
    if (!sectionsReport.contains(sectionReport)) {
      sectionsReport.add(sectionReport);
    }
  }

  void addSubValidator(FormValidator subValidator){
    if (!subValidators.contains(subValidator)) {
      subValidators.add(subValidator);
    }
  }

  void clearValidators(){
    sectionsReport.clear();
  }

  bool checkValidity({bool checkOnlyAfterBlur: false}) {
    bool valid = true;
    for (FormSectionReport report in sectionsReport) {
      if (!report.checkValidity(checkOnlyAfterBlur: checkOnlyAfterBlur)) {
        valid = false;
      }
    }
    for (FormValidator subValidator in subValidators){
      if(!subValidator.checkValidity()){
        valid = false;
      }
    }
    return valid;
  }

  Map explain() {
    return {
      "sections": _explainSections(),
      "sub": _explainSubs()
    };
  }

  List _explainSubs() {
    List out = [];
    for(FormValidator validator in subValidators){
      out.add(validator.explain());
    }
    return out;
  }

  List _explainSections() {
    List out = [];
    for(FormSectionReport report in sectionsReport){
      out.add(report.explain());
    }
    return out;
  }
}

class FormSectionReport {
  bool onceBlurred = false;
  bool onceBlurredSecond = false;
  String name;
  Element formSection;
  Element messagePlaceholder;
  FormSectionValidator primaryValidator;
  List<FormSectionValidator> validators = [];
  List<FormSectionValidator> validatorsToCheckAfterKeyUp = [];
  List<FormSectionValidator> invalidValidators = [];
  async.StreamSubscription formSectionKeyUp;

  bool get checkAfterKeyUp => validatorsToCheckAfterKeyUp.isNotEmpty;

  bool get valid => !validators.any((FormSectionValidator validator) => !validator.valid);

  String get formSectorValue {
    String _value;
    if (formSection is TextAreaElement) {
      _value = (formSection as TextAreaElement).value;
    } else if (formSection is InputElement) {
      _value = (formSection as InputElement).value;
    }
    return _value;
  }

  void set formSectionValue(String newValue) {
    if (formSection is TextAreaElement) {
      (formSection as TextAreaElement).value = newValue;
    } else if (formSection is InputElement) {
      (formSection as InputElement).value = newValue;
    }
  }

  FormSectionReport(this.name, this.formSection, this.messagePlaceholder,
      {bool validateAfterBlur: true, String beforeBlur(String inputValue)}) {
    if (validateAfterBlur) {
      formSection.onBlur.listen((_) {
        if (beforeBlur != null && formSectorValue != null) {
          formSectionValue = beforeBlur(formSectorValue);
        }
        onceBlurred = true;
        checkValidity();
      });
    }
  }

  void setPrimaryValidator(FormSectionValidator validator) {
    primaryValidator = validator;
  }

  void addSectionValidator(FormSectionValidator validator) {
    validator.formSection = formSection;
    if(validator.checkAfterKeyUp){
      validatorsToCheckAfterKeyUp.add(validator);
    }
    if(formSectionKeyUp == null){
      formSectionKeyUp = formSection.onInput.listen((e){
        validatorsToCheckAfterKeyUp.addAll(invalidValidators);
        if(checkAfterKeyUp){
          checkValidity(onlyValidatorsToBeValidate: validatorsToCheckAfterKeyUp);
        }
      });
    }
    validators.add(validator);
  }

  bool checkValidity({bool checkOnlyAfterBlur: false, List<FormSectionValidator> onlyValidatorsToBeValidate}) {
    invalidValidators.clear();
    bool primaryValidatorValid = true;
    if (primaryValidator != null) {
      primaryValidatorValid = primaryValidator.checkValidity();
    }
    if (primaryValidatorValid) {
      invalidValidators = _getInvalidValidators(onlyValidatorsToBeValidate: onlyValidatorsToBeValidate);
    }

    if (!checkOnlyAfterBlur) {
      if (invalidValidators.isEmpty) {
        _setValid();
        return true;
      } else {
        _setInvalid(invalidValidators.first);
        return false;
      }
    } else {
      if (invalidValidators.isNotEmpty && onceBlurred) {
        _setInvalid(invalidValidators.first);
        return false;
      } else {
        _setValid();
        return true;
      }
    }
  }

  List<FormSectionValidator> _getInvalidValidators({List onlyValidatorsToBeValidate}){
    List<FormSectionValidator> invalid = [];
    if(onlyValidatorsToBeValidate == null){
      for (FormSectionValidator validator in validators) {
        if (!validator.checkValidity()) {
          invalid.add(validator);
        }
      }
    }else{
      for (FormSectionValidator validator in onlyValidatorsToBeValidate) {
        if (!validator.checkValidity()) {
          invalid.add(validator);
        }
      }
    }
    return invalid;
  }

  void hideValidityMessage() {
    _setValid();
  }

  void _setInvalid(FormSectionValidator validator) {
    formSection.classes.add("invalid");
    messagePlaceholder.setInnerHtml(validator.validityMessage);
  }

  void _setValid() {
    formSection.classes.remove("invalid");
    messagePlaceholder.setInnerHtml("");
  }

  Map explain() {
    Map out = {};
    out["name"] = name;
    out["formSectionClassName"] = formSection.classes.toString();
    out["isValid"] = checkValidity();
    List validators = [];
    for(var validator in this.validators){
      validators.add(validator.explain());
    }
    out["validators"] = validators;
    return out;
  }

}

abstract class FormSectionValidator {
  bool checkAfterKeyUp;
  InputElement _input;
  TextAreaElement _textArea;
  String validityMessage;

  Element get inputElement => _input != null ? _input : _textArea;

  bool get valid => checkValidity();

  void set formSection(Element section) {
    if (section is InputElement) {
      _input = section;
    } else if (section is TextAreaElement) {
      _textArea = section;
    } else {
      throw "Invalid form section type";
    }
  }

  String get inputValue {
    String _value;
    if (_textArea != null) {
      _value = _textArea.value;
    } else if (_input != null) {
      _value = _input.value;
    }
    return _value;
  }

  FormSectionValidator({this.validityMessage, this.checkAfterKeyUp: false});

  bool checkValidity();

  Map explain() {
    return {
      "afterKeyUp": checkAfterKeyUp,
      "message": validityMessage,
      "isValid": checkValidity()
    };
  }
}