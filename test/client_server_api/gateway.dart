part of akcnik.tests.client_server_api.common;

class Gateway {
  static Gateway _instance;
  String userToken;
  int port = 9999;
  String hostAddress = "http://localhost:";

  static Gateway get instance {
    if (_instance == null) {
      _instance = new Gateway();
    }
    return _instance;
  }

  Future<envelope_lib.Envelope> get(String url) async {
    return http.get(hostAddress + port.toString() + url, headers: createHeader()).then(handleResponse);
  }

  Future<envelope_lib.Envelope> post(String url, {Map<String, dynamic> data: const {}}) async {
    return http
        .post(hostAddress + port.toString() + url, headers: createHeader(), body: encodeJsonMap(data))
        .then(handleResponse);
  }

  envelope_lib.Envelope handleResponse(http.Response response) {
    envelope_lib.Envelope out;
    switch (response.statusCode) {
      case 401:
        out = new envelope_lib.Envelope.warning(envelope_lib.USER_NOT_LOGGED);
        logout();
        return out;
      case 200:
        try {
          out = new envelope_lib.Envelope.fromMap(decodeJsonMap(response.body));
        } catch (e) {
          throw response.body;
        }
        break;
      case 400:
        throw envelope_lib.DATA_IMPROPER_STRUCTURE;
      default:
        throw CONNECTION_ERROR;
    }
    if (response.statusCode == 400) throw out.category;
    userToken = response.headers["authorization"];
    if (userToken == "null") userToken = null;
    return out;
  }

  Map<String, String> createHeader() {
    if (userToken != null) return {"authorization": userToken};
    return {};
  }

  void logout() {
    userToken = null;
  }
}
