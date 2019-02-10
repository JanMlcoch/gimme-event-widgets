part of akcnik.tests.filter;

void accessFilterTest() {
  RootFilter rootFilter;
  model_lib.ModelRoot model;
  EnvelopeHolder message;
  model_lib.User ring;
  RootFilter nopeFilter = RootFilter.nope;
  test("Importing sample data", () {
    model = constructModel(placesJson: sample.placesJson, eventsJson: sample.eventsJson, usersJson: sample.usersJson);
    storage_lib.loadMemoryStorage(model);
    expect(storage_lib.storage, isNotNull);
    expect(model.places.length, 98);
    expect(model.events.length, 120);
    ring = model.users.getById(2);
  });
  group("Access filters", () {
    group("creation", () {
      setUp((){
        message = new EnvelopeHolder();
      });
      test("no permission with null level and null user", () {
        rootFilter = AccessProvider.createAccessFilter(null, null, null, "events", message: message);
        expect(rootFilter, isNot(nopeFilter));
        expect(message.empty, isTrue);
      });
      test("no permission with any level and null user", () {
        rootFilter = AccessProvider.createAccessFilter(null, "any", null, "events", message: message);
        expect(rootFilter, isNot(nopeFilter));
        expect(message.empty, isTrue);
      });
      test("no permission with null level", () {
        rootFilter = AccessProvider.createAccessFilter(null, null, ring, "events", message: message);
        expect(rootFilter, isNot(nopeFilter));
        expect(message.empty, isTrue);
      });
      test("no permission with any level", () {
        rootFilter = AccessProvider.createAccessFilter(null, "any", ring, "events", message: message);
        expect(rootFilter, isNot(nopeFilter));
        expect(message.empty, isTrue);
      });
      test("any permission with null level", () {
        rootFilter = AccessProvider.createAccessFilter("anyPermission", null, ring, "events", message: message);
        expect(rootFilter, nopeFilter);
        expect(message.envelope.message,startsWith('level=null for anyPermission from '));
      });
      test("any permission with any level", () {
        rootFilter = AccessProvider.createAccessFilter("anyPermission", "any", ring, "events", message: message);
        expect(rootFilter, isNot(nopeFilter));
        expect(message.empty, isTrue);
      });
      test("testPermission with any level", () {
        rootFilter = AccessProvider.createAccessFilter("testPermission", "any", ring, "events", message: message);
        expect(rootFilter, isNot(nopeFilter));
        expect(message.empty, isTrue);
      });
      test("testPermission with any level", () {
        rootFilter = AccessProvider.createAccessFilter("testPermission", "any", ring, "events", message: message);
        expect(rootFilter, isNot(nopeFilter));
        expect(message.empty, isTrue);
      });
    });

  });
}
