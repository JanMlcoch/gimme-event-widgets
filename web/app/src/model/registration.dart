part of model;

class Registration {
  static const String OK = "ok";
  String name = "";
  String login = "";
  String surname = "";
  String email = "";
  String password1 = "";
  String password2 = "";
  List<Function> onStepChanged = [];
  int _step = 1;

  int get step => _step;

  void set step(int val) {
    _step = val;
    onStepChanged.forEach((Function f) => f());
  }

  Registration();

  void restart() {
    step = 1;
  }

  Future<envelope_lib.Envelope> createUser() async {
    ClientUser clientUser = model.user;
    clientUser
      ..firstName = name
      ..surname = surname
      ..email = email
      ..password = password1
      ..login = login;
    envelope_lib.Envelope envelope = await clientUser.create();
    return envelope;
  }
}
