part of form;

class FormSectionEmailValidator extends FormSectionValidator {
  FormSectionEmailValidator({String validityMessage, bool checkAfterKeyUp: false})
      : super(validityMessage: validityMessage, checkAfterKeyUp: checkAfterKeyUp);

  @override
  bool checkValidity() {
    return validator.isEmail(inputValue);
  }
}