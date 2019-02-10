library server.mailer.private;

import "dart:async";
import "package:mailer/mailer.dart" as mailer;
import "../../server/src/modules/resources/resources.dart";
import '../../server/src/model/library.dart';
import 'package:akcnik/resources.dart';
import "package:mustache_no_mirror/mustache.dart" as mustache;

part 'mailer.dart';

part 'plain_converter.dart';

Future<bool> sendEmail(User user, Map<String, dynamic> data, Map<String, String> partials) {
  mailer.Envelope email = Mailer.instance._constructEmail(user, data, partials);
  return Mailer.instance._sendEnvelope(email);
}
