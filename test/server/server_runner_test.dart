library akcnik.tests.server_runner;

import 'package:test/test.dart';
import '../../server/main.dart' as runner;
import '../../server/src/model/library.dart' as model;
import '../../server/src/storage/library.dart' as storage;
import '../common.dart';

void main() {
  test("Run server with wrong database name", () async {
    expect(runner.main(["-d", "cosi_database_xyz"]), throwsFormatException);
  });
  test("Run server", () async {
    await runServer(12845);
    model.ModelRoot modelRoot = storage.storage.memory.model;
//    expect(modelRoot.events.length, isNonZero);
//    expect(modelRoot.places.length, isNonZero);
//    expect(modelRoot.users.length, isNonZero);
    expect(modelRoot.tags.length, isNonZero);
  });
}
