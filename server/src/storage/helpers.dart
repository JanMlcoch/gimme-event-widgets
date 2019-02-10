part of storage;

const int TOKEN_LENGTH = 40;
const String FACEBOOK_ID_KEY = "facebook_id";
const String GOOGLE_ID_KEY = "google_id";

String generateToken() {
  var rand = new math.Random();
  var codeUnits = new List.generate(TOKEN_LENGTH, (index) {
    int index = rand.nextInt(62);
    if (index < 10) return index + 48;
    if (index < 36) return index + 55;
    return index + 61;
  });
  return new String.fromCharCodes(codeUnits);
}
