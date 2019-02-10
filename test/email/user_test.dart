import 'package:test/test.dart';
import '../../mailer/library.dart' as mailer;
import '../../mailer/private/library.dart' as mailer_private;
import 'dart:async';
import '../../server/src/model/library.dart';
import 'common.dart';
import '../sample_data/library.dart' as sample;
import 'package:akcnik/resources.dart';

void main() {
  ModelRoot model = sample.constructModel();
  User gratzky = model.users.getById(156);
  User eleanore = model.users.getById(158);
  StreamController<String> controller;
  setUp(() {
    controller = new StreamController<String>();
    mailer_private.Mailer.instance.testOut = controller;
  });
  group("czech", () {
    Lang lang = mailer.resources.getLangByShortcut("cs");
    setUp(() {
      gratzky.language = "cs";
      eleanore.language = "cs";
    });
    test("reset password", () async {
      Future<String> emailFuture = getEmail(controller);
      mailer.sendResetPasswordEmail(gratzky);
      String email = await emailFuture;
      expect(email, contains("${lang.mailer.server_site}/app/#reset_password?token=${gratzky.authenticationToken}"));
      expect(new RegExp(lang.mailer.server_site)
          .allMatches(email)
          .length, 4);
      expect(email, contains("Obnova hesla na portálu "));
      expect(email, contains("___ Obnova hesla ___"));
      expect(email, contains("<h1>Obnova hesla</h1>"));
    });
    test("confirm user", () async {
      Future<String> emailFuture = getEmail(controller);
      mailer.sendConfirmUserEmail(gratzky);
      String email = await emailFuture;
      expect(email, contains("${lang.mailer.server_site}/app/#confirm_user?token=${gratzky.authenticationToken}"));
      expect(new RegExp(lang.mailer.server_site)
          .allMatches(email)
          .length, 4);
      expect(email, contains("Potvrzení registrace na portálu "));
      expect(email, contains("___ Potvrzení registrace ___"));
      expect(email, contains("<h1>Potvrzení registrace</h1>"));
    });
  });
  group("english", () {
    Lang lang = mailer.resources.getLangByShortcut("en");
    setUp(() {
      gratzky.language = "en";
      eleanore.language = "en";
    });
    test("reset password", () async {
      Future<String> emailFuture = getEmail(controller);
      mailer.sendResetPasswordEmail(gratzky);
      String email = await emailFuture;
      expect(new RegExp(lang.mailer.server_site)
          .allMatches(email)
          .length, 4);
      expect(email, contains("${lang.mailer.server_site}/app/#reset_password?token=${gratzky.authenticationToken}"));
      expect(email, contains("Reset password on portal"));
      expect(email, contains("<h1>Reset password</h1>"));
      expect(email, contains("___ Reset password ___"));
    });
    test("confirm user", () async {
      Future<String> emailFuture = getEmail(controller);
      mailer.sendConfirmUserEmail(gratzky);
      String email = await emailFuture;
      expect(new RegExp(lang.mailer.server_site)
          .allMatches(email)
          .length, 4);
      expect(email, contains("${lang.mailer.server_site}/app/#confirm_user?token=${gratzky.authenticationToken}"));
      expect(email, contains("Email validation on portal"));
      expect(email, contains("<h1>Email validation</h1>"));
      expect(email, contains("___ Email validation ___"));
    });
  });
}
