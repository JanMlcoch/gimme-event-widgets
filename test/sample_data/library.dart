library akcnik.tests.sample;

import "../../server/src/model/library.dart" as model_lib;
import "../../lib/common/flags/library.dart" as flag_lib;
import "package:dbcrypt/dbcrypt.dart";
import '../common.dart' as common;

part 'tags.dart';

part 'users.dart';

part 'events.dart';

part 'places.dart';

const int CORE = 5;
const int CONCRETE = 4;
const int COMPOSITE = 3;
const int COMMON = 2;
const int COMPARABLE = 1;

DBCrypt dbCrypt = new DBCrypt();

model_lib.ModelRoot constructModel() => common.constructModel(
    usersJson: usersJson,
    eventsJson: eventsJson,
    placesJson: placesJson,
    organizersJson: organizersJson,
    tagsJson: tagsJson);


List<Map> organizersJson = [
  {"id": 1, "name": "Thilisar o.s.",},
  {"id": 2, "name": "Stíny Temné pověsti",},
  {"id": 3, "name": "Vanir o.s.",},
  {"id": 4, "name": "Zábřežská kulturní, s.r.o.",}
];
