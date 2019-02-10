library storage.pgsql.query;

import 'sql_helpers.dart';
import '../constants/constants.dart';

part 'sql_twokey.dart';
part "sql_idkey.dart";
part 'sql_anykey.dart';
part 'sql_compiler.dart';
part "event_sql.dart";
part "place_in_event_sql.dart";
part "place_sql.dart";
part "user_sql.dart";
part 'organizer_sql.dart';
part 'custom_anykey_sql.dart';
part 'custom_sql.dart';

typedef String SpecialColumnCompiler();

