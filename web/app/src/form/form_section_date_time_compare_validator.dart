part of form;

class FormSectionDateTimeCompareValidator extends FormSectionValidator {
  Function origDate;
  Function toCompareDate;
  DateFormat dateFormat;

  FormSectionDateTimeCompareValidator(DateTime origDateCallback(),
      DateTime toCompareDateCallback(), {String validityMessage, bool checkAfterKeyUp: false})
      : super(validityMessage: validityMessage, checkAfterKeyUp: checkAfterKeyUp) {
    dateFormat = new DateFormat(lang.datePicker.dateFormat);
    origDate = origDateCallback;
    toCompareDate = toCompareDateCallback;
  }

  @override
  bool checkValidity() {
    DateTime dateFrom = origDate();
    DateTime dateTo = toCompareDate();
    if (dateFrom == null || dateTo == null) {
      return false;
    }
    if (dateTo.isAfter(dateFrom) || dateTo.isAtSameMomentAs(dateFrom)) {
      return true;
    }
    return false;
  }
}