library constants;

part "filter_names.dart";
part 'permissions.dart';

const String OK = "ok";
const String NOT_LOGGED = "notLogged";
const String ERROR = "error";

// user
const String CONTROLLER_LOGIN = "/api/login";
const String CONTROLLER_TOKEN_LOGIN = "/api/token_login";
const String CONTROLLER_LOGOUT = "/api/logout";
const String CONTROLLER_USER = "/api/user";
const String CONTROLLER_CREATE_USER = "/api/create_user";
const String CONTROLLER_CREATE_USER_FROM_FACEBOOK = "/api/facebook/create_user";
const String CONTROLLER_CREATE_USER_FROM_GOOGLE = "/api/google/create_user";
const String CONTROLLER_FACEBOOK_CONNECT_USER = "/api/facebook/connect_user";
const String CONTROLLER_GOOGLE_CONNECT_USER = "/api/google/connect_user";
const String CONTROLLER_GOOGLE_PLACE_API = "/api/google/place_api";
const String CONTROLLER_MERGE_USERS = "/api/merge_users";
const String CONTROLLER_CONFIRM_USER = "/api/confirm_user";
const String CONTROLLER_FIND_USER = "/api/find_user";
const String CONTROLLER_EDIT_USER = "/api/edit_user";
const String CONTROLLER_FORGOTTEN_PASSWORD = "/api/forgotten_password";
const String CONTROLLER_CHANGE_PASSWORD = "/api/change_password";
const String CONTROLLER_RESET_PASSWORD = "/api/reset_password";

// events
const String CONTROLLER_CREATE_EVENT = "/api/create_event";
const String CONTROLLER_ALL_EVENTS = "/api/all_events";
const String CONTROLLER_OWN_EVENTS = "/api/own_events";
const String CONTROLLER_EDIT_EVENT = "/api/edit_event";
const String CONTROLLER_RATE_EVENT = "/api/rate_event";
const String CONTROLLER_PLANNED_EVENT = "/api/planned_events";
const String CONTROLLER_DELETE_EVENT = "/api/delete_event";
const String CONTROLLER_FILTER_EVENTS = "/api/filter_events";
const String CONTROLLER_FACEBOOK_EVENTS = "/api/facebook/events";
const String CONTROLLER_FACEBOOK_CHECK_EVENTS = "/api/facebook/check_events";
const String CONTROLLER_FACEBOOK_CREATE_EVENT = "/api/facebook/create_event";
const String CONTROLLER_EDITABLE_EVENTS = "/api/editable_events";
const String CONTROLLER_FILTER_EVENTS_BASE64_IMAGES= "api/filter_events/base64_image";
const String CONTROLLER_DETAIL_EVENT = "/api/detail_events";
//const String CONTROLLER_SUGGEST_EVENTS= "/api/suggest_events";

// places
const String CONTROLLER_GET_NEARBY_PLACES = "/api/get_nearby_places";
const String CONTROLLER_AUTOCOMPLETE_PLACES = "/api/autocomplete_places";
const String CONTROLLER_EDITABLE_PLACES = "/api/editable_places";
const String CONTROLLER_CREATE_PLACE = "/api/create_places";
const String CONTROLLER_EDIT_PLACE = "/api/edit_place";
const String CONTROLLER_DELETE_PLACE = "/api/delete_place";
const String CONTROLLER_FILTER_PLACES = "/api/filter_places";

// organizer
const String CONTROLLER_AUTOCOMPLETE_ORGANIZER = "/api/autocomplete_organizer";
const String CONTROLLER_CREATE_ORGANIZER = "/api/create_organizer";
const String CONTROLLER_TAG_FILTER_GET_OPTIONS = "/api/tag_model/get_options";
const String CONTROLLER_GET_EXCHANGE_RATE = "/api/currency_provider/get_exchange_rate";

// other
const String CONTROLLER_GET_POINTS_OF_ORIGIN = "/api/get_points_of_origin";
const String CONTROLLER_ADD_POINT_OF_ORIGIN = "/api/add_point_of_origin";
const String CONTROLLER_DELETE_POINT_OF_ORIGIN = "/api/delete_point_of_origin";


//const String SPLIT_MARK = "lonG FUCKIng generiC SPLIT STRINg diha o54621sylcibzasnolifhmcy.dcn,gja";
//const String TAG_AUTOCOMPLETE = "tag_autocomplete";
const String GET_EXCHANGE_RATE = "get_exchange_rate";

const int USER_AVATAR_HEIGHT = 200;
const int USER_AVATAR_WIDTH = 200;
const int EVENT_AVATAR_HEIGHT = 200;
const int EVENT_AVATAR_WIDTH = 200;


const List<num> DISTANCE_EVENT_FILTER_TICS = const [
  1,
  2,
  3,
  4,
  5,
  7,
  10,
  12,
  15,
  20,
  25,
  30,
  35,
  40,
  45,
  50,
  60,
  70,
  80,
  100,
  120,
  140,
  160,
  180,
  200,
  250,
  300,
  350,
  400,
  500,
  700,
  1000,
  1500,
  2000,
  3000,
  4000,
  5000,
  7000,
  10000,
  15000,
  25000
];
const List<num> PRICE_EVENT_FILTER_PREFERRED_TICS_NOMINAL_VALUES = const [1, 1.2, 1.5, 2, 2.5, 3, 4, 5, 6, 8];
const num SMALLEST_NONZERO_PRICE_EVENT_FILTER_TIC_IN_EUR = 0.5;
const int PRICE_EVENT_FILTER_TIC_COUNT = 36;

const List<String> CURRENCIES = const [
  "AUD",
  "BRL",
  "BGN",
  "CNY",
  "DKK",
  "EUR",
  "PHP",
  "HKD",
  "HRK",
  "INR",
  "IDR",
  "ILS",
  "JPY",
  "ZAR",
  "KRW",
  "CAD",
  "HUF",
  "MYR",
  "MXN",
  "XDR",
  "NOK",
  "NZD",
  "PLN",
  "RON",
  "RUB",
  "SGD",
  "SEK",
  "CHF",
  "THB",
  "TRY",
  "USD",
  "GBP",
  "CZK"
];

const List LANGUAGES = const ["en", "cz"];

const List<String> SPLIT_MARKS = const [" ", ",", "-", "_", ".", '"', "'"];

const String CONNECTION_ERROR = "connectionError";

const num EARTH_RADIUS = 6371; // km
const num EARTH_EQUATORIAL_RADIUS = 6378; //km
const num PI = 3.14159265358979323846264338327950288419716939937510;
const num LATITUDE_DEGREE_IN_KM = EARTH_RADIUS * PI * 2 / 360;
const num LONGITUDE_DEGREE_IN_KM_ON_EQUATOR = EARTH_EQUATORIAL_RADIUS * PI * 2 / 360;

const List<String> BG_COLORS_XAML_COMPATIBLE = const [
  "#FF1ABC9C",
  "#FF2ECC71",
  "#FF3498DB",
  "#FF9B59B6",
  "#FF34495E",
  "#FFF1C40F",
  "#FFE67E22",
  "#FFE74C3C",
  "#FF95A5A6"
];
