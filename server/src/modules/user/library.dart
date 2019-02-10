library userModule;

import '../../../../server_libs/server/library.dart' as libs;
import 'package:akcnik/envelope.dart';
import 'package:akcnik/constants/constants.dart';
import '../../model/library.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:validator/validator.dart' as validator;
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import '../../../../mailer/library.dart' as mailer;
import '../filter/entity/library.dart' as entity_filters;
import 'package:logging/logging.dart' as log;
import 'package:image/image.dart' as image_lib;
import 'dart:convert';

part "user_provider.dart";
part "login.dart";
part "create.dart";
part "edit.dart";
part 'connect.dart';

void loadUsersModule() {
  _bindUserLogin();
  _bindUserProvide();
  _bindCreateUser();
  _bindEditUser();
  _bindConnectUser();
}
