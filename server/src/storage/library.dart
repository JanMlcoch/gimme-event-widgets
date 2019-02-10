library storage;

import "../model/library.dart";
import 'dart:math' as math;
import "../modules/filter/common/library.dart" as filter_module;
import "dart:async";
import "dart:convert";
import 'package:akcnik/envelope.dart';
import "package:postgresql/postgresql.dart" as pgsql;
import "memory/library.dart";
import 'pgsql/library.dart';
import 'tables/library.dart';
import 'package:logging/logging.dart' as log;

part "storage.dart";
part "connection.dart";
part 'helpers.dart';

DataStorage storage;

Future loadStorage({ModelRoot model, String pgsqlUri: "default"}) {
  storage = new DataStorage(model, pgsqlUri);
  return storage.init();
}

Future<DataStorage> loadDefaultStorage([String database = 'devel']) {
  ModelRoot model = new ModelRoot();
  storage = new DataStorage(model, database);
  return storage.init().then((DataStorage dataStorage) => storage.initMemoryFromDb());
}

Future loadMemoryStorage(ModelRoot model) {
  storage = new DataStorage(model, null);
  return storage.init();
}
