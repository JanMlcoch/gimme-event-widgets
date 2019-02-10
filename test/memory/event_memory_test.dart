import 'package:test/test.dart';
import '../sample_data/library.dart' as sample;
import '../../server/src/model/library.dart';
import '../../server/src/storage/library.dart' as storage_lib;
import '../../server/src/modules/filter/common/library.dart' as filter_module;

void main() {
  ModelRoot model;
  storage_lib.Connection connection;
  setUp(() async {
    model = sample.constructModel();
    storage_lib.loadMemoryStorage(model);
    connection = await storage_lib.storage.getConnection(onlyMemory: true);
  });
  test("init", () {
    expect(storage_lib.storage.memory, isNotNull);
    expect(storage_lib.storage.memory.model.events.length, sample.eventsJson.length);
    expect(storage_lib.storage.memory.model.tags.length, sample.tagsJson.length);
  });
  group("load", () {
    List<String> columns = const ["id", "name", "from", "to", "tags"];
    Events events;
    test("load by passFilter", () async {
      events = await connection.events.load(filter_module.RootFilter.pass, columns);
      expect(events.length, sample.eventsJson.length);
      for (int i = 0; i < events.length; i++) {
        Event event = events.list[i];
        expect(event.id, sample.eventsJson[i]["id"]);
        expect(event.name, isNotNull);
        expect(event.name, sample.eventsJson[i]["name"]);
      }
    });
    test("load by nopeFilter", () async {
      events = await connection.events.load(filter_module.RootFilter.nope, columns);
      expect(events.length, 0);
    });
  });
  group("update", () {
    test("update name of first", () async {
      Event event = model.events.first;
      await connection.events.updateModel({"id": event.id, "name": "new Name"}, ["name"]);
      expect(event.name, "new Name");
    });
    test("update from of third", () async {
      int epoch = 256355458;
      Event event = model.events.list[2];
      await connection.events.updateModel({"id": event.id, "from": epoch}, ["from"]);
      expect(event.from.millisecondsSinceEpoch, epoch);
    });
    test("not update anything else", () async {
      Event event = model.events.list[2];
      Event backupEvent = new Event()
        ..fromMap(event.toFullMap());
      await connection.events.updateModel(model.events.list[1].toFullMap()
        ..["id"] = event.id, ["from"]);
      expect(event.from.millisecondsSinceEpoch, model.events.list[1].from.millisecondsSinceEpoch);
      expect(event.name, backupEvent.name);
      expect(event.to.millisecondsSinceEpoch, backupEvent.to.millisecondsSinceEpoch);
    });
  });
  group("save", () {
    test("save", () async {
      int lastLength = model.events.length;
      Map<String, dynamic> eventMap = {"name": "save test event", "from": 20000000, "to": 30000000, "mapPlace": 5};
      Event savedEvent = await connection.events.saveModel(eventMap);
      expect(model.events.length, lastLength + 1);
      expect(savedEvent.name, eventMap["name"]);
      expect(savedEvent.from.millisecondsSinceEpoch, eventMap["from"]);
      expect(savedEvent.to.millisecondsSinceEpoch, eventMap["to"]);
    });
    test("duplication", () async {
      Event oldEvent = model.events.list[1];
      Event savedEvent = await connection.events.saveModel(oldEvent.toFullMap());
      expect(oldEvent.id, isNot(savedEvent.id));
      expect(oldEvent.toFullMap(), savedEvent.toFullMap()
        ..["id"] = oldEvent.id);
    });
  });
}
