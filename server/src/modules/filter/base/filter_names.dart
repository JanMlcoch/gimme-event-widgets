part of filter_module.base;

const String TABLE_EVENTS = "events";
const String TABLE_PLACES = "places";
const String TABLE_PLACE_IN_EVENT = "place_in_event";
const String TABLE_USERS = "users";
const String TABLE_ORGANIZERS = "organizers";
const String TABLE_ORGANIZER_IN_EVENT = "organizer_in_event";

FilterBase filterFactory(String name, List data) {
  dynamic first = data.length > 0 ? data.first : null;

  switch (name) {
    case "event_subname":
      return new SubNameEventFilter(data);
    case "event_in_future":
      return new FutureEventFilter();
    case "event_in_interval":
      return new FromToEventFilter(data);
    case "organizer_subname":
      return new SubNameOrganizerFilter(data);
    case "place_subname":
      return new SubNamePlaceFilter(data);
    case "distance":
      return new DistancePlaceFilter(data);
    case "gps_window":
      return new GpsWindowPlaceFilter(data);
    case "price_interval":
      return new PriceIntervalFilter(data);
//      case "contains_tag":
//        return new ContainsTagEventFilter();
    case "event_id_list":
      return new IdListEventFilter(data);
    case "place_id_list":
      return new IdListPlaceFilter(data);
    case "organizer_id_list":
      return new IdListOrganizerFilter(data);
    case "user_id_list":
      return new IdListUserFilter(data);
    case "user_login":
      return new LoginUserFilter(data);
    case "user_login_or_email":
      return new LoginOrEmailUserFilter(data);
    case "user_token":
      return new TokenUserFilter(data);
    case "owned_events":
      return new OwnedEventFilter(first);
    case "owned_places":
      return new OwnedPlaceFilter(first);
    case "owned_users":
      return new OwnedUserFilter(first);
    case "owned_organizers":
      return new OwnedOrganizerFilter(first);
  }
  return null;
}

///Provides const names of names of all TagFilters - if inputted as ServerTag or ClientTag, it should work ok.
abstract class TagFilterNames {
  static const String TAG_SUBSTRING = "substring";
  static const String TAG_FIRST_SUBSTRING = "first_substring";
  static const String TAG_CASE_INSENSITIVE_SUBSTRING = "case_insensitive_substring";
  static const String TAG_CASE_INSENSITIVE_FIRST_SUBSTRING = "case_insensitive_first_substring";

  ///leaves only tags with such a name, that it contains of words (splits by [SPLIT_MARKS]), that begin
  ///with such substrings, that those can form the substring the filter is given
  static const String TAG_ABBREVIATION_SUBSTRING = "abbreviation_substring";
}
