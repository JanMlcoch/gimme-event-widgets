library envelope;

const String LOGIN_DUPLICATE = "loginDuplicate";
const String EMAIL_DUPLICATE = "emailDuplicate";
const String INCORRECT_EMAIL = "incorrectEmail";
const String INCORRECT_PASSWORD = "incorrectPassword";
const String MESSAGE_NOT_EXIST = "messageForClientServerCommunicationNotExist";
const String DATA_NOT_VALID_JSON = "dataCannotBeParsed";
const String DATA_IMPROPER_STRUCTURE = "dataImproperStructure";
const String BAD_FILTER_IN_FILTER_EVENTS = "badFilterInFilterEvents";
const String BAD_FILTER_IN_FILTER_PLACES = "badFilterInFilterPlaces";
const String BAD_FILTER = "badFilter";
const String COULD_NOT_CONNECT_TO_DATABASE = "databaseConnectionError";
const String DATABASE_ERROR = "databaseError";
const String ERROR_IN_EVENT_CREATION = "errorInEventCreation";
const String ERROR_IN_PLACE_CREATION = "errorInPlaceCreation";
const String ERROR_IN_USER_CREATION = "errorInClientCreation";
const String NOT_IMPLEMENTED = "notImplemented";
const String TAG_DATA_NOT_READY = "tagDataNotReady";
const String USER_NOT_LOGGED = "userNotLogged";
const String USER_LOGGED = "userLogged";
const String USER_CANNOT_EDIT_ANOTHER_USER = "wrongUser";
const String USER_CANNOT_CHANGE_PASSWORD_OF_ANOTHER_USER = "wrongUserToChangePassword";
const String EVENT_NOT_FOUND = "eventNotFound";
const String PLACE_NOT_FOUND = "placeNotFound";
const String ORGANIZER_NOT_FOUND = "organizerNotFound";
const String USER_NOT_FOUND = "userNotFound";
const String RESET_PASSWORD_EMAIL_SENT = "emailSent";
const String UNEXPECTED_DATA_FORMAT = "unexpected_data_format";
const String RESET_PASSWORD_ERROR = "resetPasswordError";
const String ENVELOPE_INVALID_MESSAGE = "envelopeInvalidMessage";
const String REQUEST_NOT_CLOSED = "requestNotClosed";
const String MISSING_PERMISSIONS = "missingPermissions";
const String INTERNAL_SERVER_ERROR = "internalServerError";
const String INCORRECT_REQUEST_ARGUMENTS = "incorrectRequestArguments";
const String TEST_SUCCESS = "testSuccess";
const String TEST_WARNING = "testSuccess";
const String TEST_ERROR = "testError";
const String ENVELOPE_ALREADY_FILLED = "envelopeAlreadyFilled";
const String RESOURCE_NOT_FOUND = "resourceNotFound";
const String REQUEST_SUCCESS = "requestSuccess";
const String EXTERNAL_REQUEST_FAILED = "externalRequestFailed";
const String USER_ALREADY_CONNECTED = "userAlreadyConnected";

const List<String> messageCategories = const [
  LOGIN_DUPLICATE,
  EMAIL_DUPLICATE,
  INCORRECT_EMAIL,
  INCORRECT_PASSWORD,
  MESSAGE_NOT_EXIST,
  DATA_NOT_VALID_JSON,
  DATA_IMPROPER_STRUCTURE,
  BAD_FILTER_IN_FILTER_EVENTS,
  COULD_NOT_CONNECT_TO_DATABASE,
  ERROR_IN_EVENT_CREATION,
  NOT_IMPLEMENTED,
  ERROR_IN_PLACE_CREATION,
  TAG_DATA_NOT_READY,
  ERROR_IN_USER_CREATION,
  USER_NOT_LOGGED,
  USER_LOGGED,
  USER_CANNOT_CHANGE_PASSWORD_OF_ANOTHER_USER,
  USER_CANNOT_EDIT_ANOTHER_USER,
  USER_NOT_FOUND,
  PLACE_NOT_FOUND,
  EVENT_NOT_FOUND,
  ORGANIZER_NOT_FOUND,
  DATABASE_ERROR,
  UNEXPECTED_DATA_FORMAT,
  ENVELOPE_INVALID_MESSAGE,
  MISSING_PERMISSIONS,
  INTERNAL_SERVER_ERROR,
  BAD_FILTER,
  ENVELOPE_ALREADY_FILLED,
  REQUEST_NOT_CLOSED,
  TEST_SUCCESS,
  TEST_WARNING,
  TEST_ERROR,
  RESOURCE_NOT_FOUND,
  RESET_PASSWORD_EMAIL_SENT,
  REQUEST_SUCCESS,
  EXTERNAL_REQUEST_FAILED,
  USER_ALREADY_CONNECTED
];

abstract class Envelope {
  Envelope();
  factory Envelope.error(String message, [String category]) => new MessageEnvelope(message, category, error: true);
  factory Envelope.warning(String message, [String category]) => new MessageEnvelope(message, category, warning: true);
  factory Envelope.success(String message, [String category]) => new MessageEnvelope(message, category);
  factory Envelope.withMap(Map<String, dynamic> mapData) => new DataEnvelope.withMap(mapData);

  factory Envelope.withList(List<Map<String, dynamic>> listData) => new DataEnvelope.withList(listData);

  factory Envelope.fromMap(Map<String, dynamic> data) {
    if (data.containsKey("message") || data.containsKey("category")) {
      if (data["message"] is! String || data["category"] is! String) {
        return new MessageEnvelope.error(ENVELOPE_INVALID_MESSAGE);
      }
      if (data["isError"] is! bool || data["isWarning"] is! bool) {
        return new MessageEnvelope.error(ENVELOPE_INVALID_MESSAGE);
      }
      if (data["isError"]) {
        return new MessageEnvelope(data["message"], data["category"], error: true);
      }
      if (data["isWarning"]) {
        return new MessageEnvelope(data["message"], data["category"], warning: true);
      }
      return new MessageEnvelope(data["message"], data["category"]);
    }
    dynamic mapDataMap = data["mapData"];
    if (mapDataMap is Map<String, dynamic>) {
      return new DataEnvelope.withMap(mapDataMap);
    } else if (data["listData"] is List<Map<String, dynamic>>) {
      return new DataEnvelope.withList(data["listData"] as List<Map<String, dynamic>>);
    } else {
      return new MessageEnvelope.error(DATA_NOT_VALID_JSON);
    }
  }
  factory Envelope.timeout() => new MessageEnvelope.error(REQUEST_NOT_CLOSED);
  bool get isSuccess;
  bool get isWarning;
  bool get isError;
  bool get isMapData;
  bool get isListData;
  String get category;
  String get message;

  Map<String, dynamic> get map;

  List<Map<String, dynamic>> get list;

  Map<String, dynamic> toMap();
}

class MessageEnvelope extends Envelope {
  final bool isSuccess;
  final bool isError;
  final bool isWarning;
  final String message;
  final String category;

  MessageEnvelope(String message, String category, {bool warning: false, bool error: false})
      : this.message = message,
        this.category = _isCategory(message) ? message : category,
        isSuccess = !error && !warning,
        isWarning = warning,
        isError = error{
    if(this.category==null) throw new ArgumentError.notNull("category");
  }
  factory MessageEnvelope.error(String message, [String category]) =>
      new MessageEnvelope(message, category, error: true);
  bool get isMapData => false;
  bool get isListData => false;
  Map<String, dynamic> get map => null;

  List<Map<String, dynamic>> get list => null;

  static bool _isCategory(String category) {
    if (messageCategories.contains(category)) {
      return true;
    }
    return false;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> out = {};
    out["message"] = message;
    out["category"] = category;
    out["isError"] = isError;
    out["isWarning"] = isWarning;
    return out;
  }
}

class DataEnvelope extends Envelope {
  final Map<String, dynamic> map;
  final List<Map<String, dynamic>> list;
  DataEnvelope.withMap(this.map) : list = null;
  DataEnvelope.withList(this.list) : map = null;
  bool get isSuccess => true;
  bool get isWarning => false;
  bool get isError => false;
  bool get isMapData => map != null;
  bool get isListData => list != null;
  String get category => null;
  String get message => null;

  Map<String, dynamic> toMap() => {"mapData": map, "listData": list};
}

class EnvelopeHolder {
  Envelope envelope;
  void error(String message, [String category]) {
    if (_isFilled()) return;
    envelope = new MessageEnvelope(message, category, error: true);
  }

  void warning(String message, [String category]) {
    if (_isFilled()) return;
    envelope = new MessageEnvelope(message, category, warning: true);
  }

  void success(String message, [String category]) {
    if (_isFilled()) return;
    envelope = new MessageEnvelope(message, category);
  }

  void withMap(Map<String, dynamic> mapData) {
    if (_isFilled()) return;
    envelope = new DataEnvelope.withMap(mapData);
  }

  void withList(List<Map<String, dynamic>> listData) {
    if (_isFilled()) return;
    envelope = new DataEnvelope.withList(listData);
  }

  bool get empty => envelope == null;
  bool get isSuccess => envelope == null || envelope.isSuccess;
  Map toMap() => envelope == null ? {} : envelope.toMap();
  bool _isFilled() {
    if (envelope != null) {
      envelope = new MessageEnvelope.error(ENVELOPE_ALREADY_FILLED);
      return true;
    }
    return false;
  }
}
