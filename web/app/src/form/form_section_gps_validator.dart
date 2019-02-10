part of form;

class FormSectionGpsValidator extends FormSectionValidator {
  static const String VALID_GOOGLE_LATITUDE_REGEXP_STRING =
      r"^-?([0-8]?\d|60)\.\d*";

  static const String VALID_GOOGLE_LONGITUDE_REGEXP_STRING =
      r"^-?((1[0-7]\d)|(\d{2})|\d|180)\.\d*";

  static const String COMPLETE_GPS_LATITUDE_NOTATION_REGEXP_STRING =
      "^([0-7]\\d|80)°([0-5]\\d|60)\\'([0-5]\\d|60)\\.\\d*\\\"[NS]\$";

  static const String COMPLETE_GPS_LONGITUDE_NOTATION_REGEXP_STRING =
      "^(1[0-7]\\d|180|[1-9]\\d|\\d)°([0-5]\\d|60)\\'([0-5]\\d|60)\\.\\d\\\"[EW]\$";

  static const String MAPYCZ_LATITUDE_REGEXP_STRING =
      r"^([0-8]?\d|90)\.\d*[NS]";

  static const String MAPYCZ_LONGITUDE_REGEXP_STRING =
      r"^(180|1[0-7]\d|\d{2}|\d)\.\d+[EW]";

  static RegExp validGoogleGpsRegExp = new RegExp(
      "$VALID_GOOGLE_LATITUDE_REGEXP_STRING,"
          " $VALID_GOOGLE_LONGITUDE_REGEXP_STRING");

  static RegExp validCompleteGpsRegExp = new RegExp(
      "$COMPLETE_GPS_LATITUDE_NOTATION_REGEXP_STRING"
          " $COMPLETE_GPS_LONGITUDE_NOTATION_REGEXP_STRING");

  static RegExp validMapyCzGpsRegExp = new RegExp(
      "$MAPYCZ_LATITUDE_REGEXP_STRING,"
          " $MAPYCZ_LONGITUDE_REGEXP_STRING");

  List<RegExp> regExps= [
    validCompleteGpsRegExp,
    validGoogleGpsRegExp,
    validMapyCzGpsRegExp
  ];

  FormSectionGpsValidator({String validityMessage, bool checkAfterKeyUp: false})
      :super(validityMessage: validityMessage, checkAfterKeyUp: checkAfterKeyUp);

  @override
  bool checkValidity() {
    for(RegExp rx in regExps){
      if(rx.hasMatch(inputValue)) return true;
    }
    return false;
  }
}