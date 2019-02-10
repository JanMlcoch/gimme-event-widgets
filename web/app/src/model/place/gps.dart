part of model;

class Gps{
  double lat;
  double lng;
  bool valid = false;

  Gps.fromLatLng(g_m.LatLng newPlaceLatLng){
    lat = newPlaceLatLng.lat;
    lng = newPlaceLatLng.lng;
    valid = true;
  }

  Gps.fromString(String gps){
    if (gps.length == 0){
      valid=false;
    }else if (gps.contains("E")) {
      try {
        String n = gps.substring(0, gps.indexOf("N"));
        String e = gps.substring(gps.indexOf(", ") + 2, gps.indexOf("E"));
        lat = double.parse(n);
        lng = double.parse(e);
        valid = true;
      } catch (e) {
        valid = false;
      }
    }else{
      try {
        String gpsCopy = gps.replaceAll("(", "").replaceAll(")", "").replaceAll(" ","");
        String n = gpsCopy.substring(0, gpsCopy.indexOf(","));
        String e = gpsCopy.substring(gpsCopy.indexOf(",") + 1, gpsCopy.length);
        lat = double.parse(n);
        lng = double.parse(e);
        valid = true;
      } catch (e) {
        valid = false;
      }
    }
  }

  String format(){
    return "${lat}N, ${lng}E";
  }
}