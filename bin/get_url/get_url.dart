import "package:http/http.dart" as http;
import "dart:async";

Future main() async{
  String url = "https://maps.googleapis.com/maps/api/geocode/json?address=jugoslavskychpartizanu15&key=AIzaSyC9kYBOoMRY7ttnOHwm4QiH-vNrNfLpWJs&language=cs";
//  String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=49.865099582644575,16.893539428710938&key=AIzaSyC9kYBOoMRY7ttnOHwm4QiH-vNrNfLpWJs&language=cs";
  http.Response response = await http.get(url);
//  String city = JSON.decode(response.body)['results'][0]['address_components'][3]['long_name'];
  print(response.body);

}

