import 'package:test/test.dart';
import '../../server/src/model/library.dart';
import '../sample_data/library.dart' as sample;
import '../../mailer/library.dart' as mailer;
import '../../mailer/private/library.dart' as mailer_private;
import 'dart:async';
import 'common.dart';

void main() {
  ModelRoot model = sample.constructModel();
  User gratzky = model.users.getById(156);
  User eleanore = model.users.getById(158);
  StreamController<String> controller;
  Events pickedEvents;
  setUp(() {
    controller = new StreamController<String>();
    mailer_private.Mailer.instance.testOut = controller;
    pickedEvents = new Events()
      ..addAll(model.events.list.sublist(0, 10));
  });
  group("Czech", () {
    setUp(() {
      gratzky.language = "cs";
      eleanore.language = "cs";
    });
    test("male", () async {
      Future<String> emailFuture = getEmail(controller);
      mailer.sendRecommendedEventsEmail(gratzky, pickedEvents);
      String email = await emailFuture;
      expect(email, contains("<h1>Doporučené akce</h1>"));
      expect(email, contains("___ Doporučené akce ___"));
      for (Event event in pickedEvents.list) {
        expect(email, contains("<h3>${event.name}</h3>"));
        expect(email, contains("___ ${event.name} ___"));
      }
    });
  });
  group("English", () {
    setUp(() {
      gratzky.language = "en";
      eleanore.language = "en";
    });
    test("male", () async {
      Future<String> emailFuture = getEmail(controller);
      mailer.sendRecommendedEventsEmail(gratzky, pickedEvents);
      String email = await emailFuture;
      expect(email, contains("<h1>Recommended events</h1>"));
      expect(email, contains("___ Recommended events ___"));
      for (Event event in pickedEvents.list) {
        expect(email, contains("<h3>${event.name}</h3>"));
        expect(email, contains("___ ${event.name} ___"));
      }
    });
  });
//  group("Real send",(){
//    test("czech",()async{
//      gratzky.language = "cs";
//      gratzky.email="mlcoch.jan@gmail.com";
//      mailer_private.Mailer.instance.testOut=null;
//      expect(await mailer.sendRecommendedEventsEmail(gratzky, model.events),isTrue);
//    });
//    test("english",()async{
//      gratzky.language = "en";
//      gratzky.email="mlcoch.jan@gmail.com";
//      mailer_private.Mailer.instance.testOut=null;
//      expect(await mailer.sendRecommendedEventsEmail(gratzky, model.events),isTrue);
//    });
//  });
}