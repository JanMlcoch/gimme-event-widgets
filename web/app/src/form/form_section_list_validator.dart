part of form;

class FormSectionListValidator extends FormSectionValidator {
  Function getDataset;

  FormSectionListValidator.notEmpty(List getDataset(), {String validityMessage, bool checkAfterKeyUp: false})
      : super(validityMessage: validityMessage, checkAfterKeyUp: checkAfterKeyUp){
    this.getDataset = getDataset;
  }

  @override
  bool checkValidity() {
    return getDataset().isNotEmpty;
  }
}
