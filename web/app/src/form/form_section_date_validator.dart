part of form;

class FormSectionDateValidator extends FormSectionValidator {
  DateFormat dateFormat;

  FormSectionDateValidator({String validityMessage, bool checkAfterKeyUp: false})
      : super(validityMessage: validityMessage, checkAfterKeyUp: checkAfterKeyUp);

  void _makeFormat() {
    dateFormat = new DateFormat(lang.datePicker.dateFormat);
  }

  @override
  bool checkValidity() {
    _makeFormat();
    if(inputValue.isEmpty){
      return true;
    }
    try {
      dateFormat.parse(inputValue);
      return true;
    } catch (e) {
      return false;
    }
  }
}