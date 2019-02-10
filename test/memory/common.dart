library akcnik.tests.memory.common;

import '../sample_data/library.dart' as sample;
import "../../server/src/model/library.dart" as model_lib;
import "../../server/src/storage/library.dart" as storage_lib;

void init() {
  model_lib.ModelRoot model = sample.constructModel();
  storage_lib.loadMemoryStorage(model);
}