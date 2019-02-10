library akcnik.tests.memory;

import '../../server/src/storage/library.dart' as storage;
import 'package:test/test.dart';

void main() {
  group("generateToken()", () {
    test("token is at least 40 letter long", () {
      expect(storage
          .generateToken()
          .length, storage.TOKEN_LENGTH);
      expect(storage.TOKEN_LENGTH >= 40, isTrue);
    });
    test("token contains only [0-9a-zA-Z] letters", () {
      RegExp regex = new RegExp(r'^[0-9a-zA-Z]*$');
      for (var i = 0; i < 300; i++) {
        String token = storage.generateToken();
        expect(regex.hasMatch(token), isTrue, reason: "$token contains other letters");
      }
    });
  });
}