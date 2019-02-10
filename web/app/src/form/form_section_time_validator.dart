part of form;

class FormSectionTimeValidator extends FormSectionValidator {
  DateFormat timeFormat;

  FormSectionTimeValidator({String validityMessage, bool checkAfterKeyUp: false})
      : super(validityMessage: validityMessage, checkAfterKeyUp: checkAfterKeyUp) {
    timeFormat = new DateFormat(lang.datePicker.timeFormat);
  }

  @override
  bool checkValidity() {
    if(inputValue.isEmpty){
      return true;
    }
    if(inputValue == "00:00"){
      return true;
    }
    try {
      timeFormat.parseStrict(inputValue);
      return true;
    } catch (e) {
      return false;
    }
  }
}