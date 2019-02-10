part of form;

class FormSectionIdentityValidator extends FormSectionValidator {
  InputElement compareInput;

  FormSectionIdentityValidator(this.compareInput,
      {String validityMessage, bool checkAfterKeyUp})
      : super(validityMessage: validityMessage, checkAfterKeyUp: checkAfterKeyUp);

  @override
  bool checkValidity() {
    return compareInput.value == inputValue;
  }
}