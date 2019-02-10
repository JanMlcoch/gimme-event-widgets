part of form;

class FormSectionStringValidator extends FormSectionValidator {
  static const String STRING_NOT_EMPTY = r"\S";
  RegExp regexp;

  FormSectionStringValidator({String validityMessage, bool checkAfterKeyUp: false})
      : super(validityMessage: validityMessage, checkAfterKeyUp: checkAfterKeyUp);

  FormSectionStringValidator.notEmpty({String validityMessage, bool checkAfterKeyUp: false})
      : super(validityMessage: validityMessage, checkAfterKeyUp: checkAfterKeyUp) {
    regexp = new RegExp(STRING_NOT_EMPTY);
  }

  FormSectionStringValidator.minimalChars(int minimalCharacter,
      {String validityMessage, bool checkAfterKeyUp: false})
      : super(validityMessage: validityMessage, checkAfterKeyUp: checkAfterKeyUp) {
    String regexpString = r".{" + minimalCharacter.toString() + ",}";
    regexp = new RegExp(regexpString);
  }

  @override
  bool checkValidity() {
    return regexp.hasMatch(inputValue);
  }
}
