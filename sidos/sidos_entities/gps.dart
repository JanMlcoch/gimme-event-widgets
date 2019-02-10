part of sidos.entities;

///Class for work with GPS coordinates

class GPS {
  double longitude;
  double latitude;

  ///There should never be empty [GPS],
  @deprecated
  GPS();

  GPS.fromJsonMap(Map json) {
    fromMap(json);
  }

  GPS.withValues(this.latitude, this.longitude);

  ///in R_earth
  static double smallestDistance(GPS place, List<GPS> pointsOfOrigin) {
    if (pointsOfOrigin == null) {
      return null;
    } else if (pointsOfOrigin.length == 0) {
      return null;
    } else {
      double minimalDistance = 4.0;
      for (GPS origin in pointsOfOrigin) {
        minimalDistance = math.min(minimalDistance, distance(place, origin));
      }
      return minimalDistance;
    }
  }

  ///in R_Earth
  static double distance(GPS place1, GPS place2) {
    if (place1 == null || place2 == null) return 0.0;
      double lat1 = math.PI * place1.latitude / 180;
      double lat2 = math.PI * place2.latitude / 180;
      double lon1 = math.PI * place1.longitude / 180;
      double lon2 = math.PI * place2.longitude / 180;
      double x1 = math.cos(lat1) * math.sin(lon1);
      double x2 = math.cos(lat2) * math.sin(lon2);
      double y1 = math.cos(lat1) * math.cos(lon1);
      double y2 = math.cos(lat2) * math.cos(lon2);
      double z1 = math.sin(lat1);
      double z2 = math.sin(lat2);
      double lineDistance = math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) + (z1 - z2) * (z1 - z2));
      double surfaceDistance = 2 * math.asin(lineDistance / 2);
      return surfaceDistance;
  }

  void fromMap(Map json) {
    longitude = json["longitude"];
    latitude = json["latitude"];
  }

  Map toFullMap() {
    Map json = {};

    json["longitude"] = longitude;
    json["latitude"] = latitude;

    return json;
  }
}
