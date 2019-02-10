part of filter_module.entity;

abstract class PlaceFilter extends FilterBase<Place> {
  final String filterType = TABLE_PLACES;

  PlaceFilter(String filterName, List<String> validateTemplate, List data) : super(filterName, validateTemplate, data);
}

//##############################################################################
class SubNamePlaceFilter extends PlaceFilter {
  String _subName;

  SubNamePlaceFilter(List data) : super("place_subname", const ["string"], data);

  @override
  void fromList(List<dynamic> jsonArray) {
    _subName = jsonArray.first;
  }

  @override
  bool match(Place place) => place.name.contains(_subName);

  String get sqlConstraint => "$filterType.\"name\" LIKE ${safeConvert("%$_subName%")}";
}

//##############################################################################
class DistancePlaceFilter extends PlaceFilter {
  double _latitude;
  double _longitude;
  double _distance2;
  final double _latitudeStep2 = math.pow(40000 / 360, 2); // 111,11 km/°
  double _longitudeStep2; // 71,42 km/°

  DistancePlaceFilter(List data) : super("distance", const ["double", "double", "num"], data);

//  num _calculateDistance(num lat1, num lon1, num lat2, num lon2){
//    const num EARTH_RADIUS = 6371; // km
//    num latDiff = lat2 - lat1;
//    num lonDiff = lon2 - lon1;
//
//    // a is the square of half the chord length between the points.
//    num a = math.pow(math.sin(latDiff / 2), 2) +
//        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(lonDiff / 2), 2);
//
//    num angularDistance = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//    return EARTH_RADIUS * angularDistance;
//  }
//
  @override
  bool match(Place place) =>
      math.pow(place.latitude - _latitude, 2) * _latitudeStep2 +
          math.pow(place.longitude - _longitude, 2) * _longitudeStep2 <=
      _distance2;

  String get sqlConstraint =>
      "power($filterType.longitude-$_longitude,2)*$_longitudeStep2" +
          "+power($filterType.latitude-$_latitude,2)*$_latitudeStep2" +
      " <= $_distance2";

  @override
  void fromList(List<dynamic> jsonArray) {
    _latitude = (jsonArray.first as num).toDouble();
    _longitude = (jsonArray[1] as num).toDouble();
    _distance2 = math.pow(jsonArray[2] as num, 2).toDouble();
    _longitudeStep2 = math.pow(40000 * math.cos(_latitude / 180 * math.PI) / 360, 2);
  }
}

//##############################################################################
class GpsWindowPlaceFilter extends PlaceFilter {
  double _topLatitude;
  double _bottomLatitude;
  double _leftLongitude;
  double _rightLongitude;

  GpsWindowPlaceFilter(List data)
      : super("gps_window", const ["double", "double", "double", "double"], data);

  void fromList(List<dynamic> jsonArray) {
    _topLatitude = jsonArray.first.toDouble();
    _bottomLatitude = jsonArray[1].toDouble();
    _leftLongitude = jsonArray[2].toDouble();
    _rightLongitude = jsonArray[3].toDouble();
  }

  bool match(Place place) =>
      _topLatitude >= place.latitude &&
      _bottomLatitude <= place.latitude &&
      _leftLongitude <= place.longitude &&
      _rightLongitude >= place.longitude;

  String get sqlConstraint =>
      "$filterType.\"latitude\" BETWEEN $_bottomLatitude AND $_topLatitude AND " +
          "$filterType.\"longitude\" BETWEEN $_leftLongitude AND $_rightLongitude";
}

//##############################################################################
