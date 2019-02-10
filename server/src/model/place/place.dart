part of model;

class Place extends PlaceBase {
  int tempSearchRating;
  List<String> wordsForSearchInName;

  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    if (map["id"] != null) {
      id = map["id"];
    }
    if (map["name"] != null) {
      fillWords();
    }
  }

  void fillWords() {
    wordsForSearchInName = name.split(" ");
  }

  static Future<String> getCity(double latitude, double longitude) async {
    ///TODO: upravit parametr language
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyC9kYBOoMRY7ttnOHwm4QiH-vNrNfLpWJs&language=cs";
    print("url:"+url);
    http.Response response = await http.get(url);
    String city = JSON.decode(response.body)['results'][0]['address_components'][3]['long_name'];
//    http.post(url).then((http.Response response) {
//      String city = JSON.decode(response.body)['results'][0]['address_components'][3]['long_name'];
//    });
    print("Response status: $city");
    return city;
  }

  @override
  Map<String, dynamic> toSafeMap() => null;
}
