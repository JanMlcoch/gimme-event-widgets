part of akcnik.tests.filter;

void placeFilterTest() {
  RootFilter rootFilter;
  model_lib.ModelRoot model;
  EnvelopeHolder message;
  RootFilter nopeFilter = RootFilter.nope;
  test("Importing sample data", () {
    model = constructModel(placesJson: sample.placesJson, eventsJson: sample.eventsJson);
    storage_lib.loadMemoryStorage(model);
    expect(model.events.length, 120);
    expect(model.places.length, 98);
  });
  group("Place filters", () {
    group("creation", () {
      test("empty AndPlaceFilter", () {
        message = new EnvelopeHolder();
        rootFilter = new RootFilter.construct([], message);
        expect(rootFilter, isNot(nopeFilter));
        expect(message.empty, isTrue);
      });
      group("deep filter structure", () {
        test("valid", () {
          message = new EnvelopeHolder();
          rootFilter = new RootFilter.construct([
            {
              "name": "place_subname",
              "data": ["ahoj"]
            },
            {
              "name": "gps_window",
              "data": [15.0, 20.2, 50.4, 69.7]
            },
            {
              "name": "distance",
              "data": [23.2, 50.1, 25]
            }
          ],message);
          expect(rootFilter, isNot(nopeFilter));
          expect(message.empty, isTrue);
        });
      });
      group("composite filters", () {
        test("valid", () {
          message = new EnvelopeHolder();
          rootFilter = new RootFilter.construct([
            {
              "name": "gps_window",
              "data": [15.0, 20.2, 50.4, 69.7]
            },
          ], message);
          expect(rootFilter, isNotNull);
        });
        test("unknown filter name", () {
          message = new EnvelopeHolder();
          rootFilter = new RootFilter.construct([
            {
              "name": "price_xxx",
              "data": [100, 200]
            }
          ], message);
          expect(rootFilter, nopeFilter);
          expect(message.toMap(), failedEnvelope('unknown filter type: "price_xxx"',BAD_FILTER));
        });
      });
    });
    group("filtration", () {
      test("get Place list", () {
        List<model_lib.Place> places = model.places.list;
        expect(places.length, 98);
      });
      test("filter by subname", () {
        rootFilter = new RootFilter.construct([
          {
            "name": "place_subname",
            "data": ["hili"]
          }
        ],new EnvelopeHolder());
        model_lib.Places filtrate = rootFilter.filter(model.places);
        expect(filtrate.length, 3);
        filtrate.list.forEach((model_lib.Place place) {
          expect(place.name, contains("hili"));
        });
      });
      test("filter by gps", () {
        rootFilter = new RootFilter.construct([
          {
            "name": "gps_window",
            "data": [51.2, 49.0, 14.2, 17.0]
          }
        ],new EnvelopeHolder());
        model_lib.Places filtrate = rootFilter.filter(model.places);
        expect(filtrate.length, 69);
        filtrate.list.forEach((model_lib.Place place) {
          expect(place.latitude, inInclusiveRange(49.0, 51.2));
          expect(place.longitude, inInclusiveRange(14.2, 17.0));
        });
      });
    });
    group("filter request", () {
      shelf_route.Router router;
      shelf.Request request;
      PathProvider pp = new PathProvider();
      setUp(() {
        router = server_lib.loadRouter();
        server_lib.route(pp.path, () => new FilterPlacesRC(),
            method: "POST",
            template: {
              "?sortBy": "string",
              "?desc": "bool",
              "filters": [
                {"name": "string", "data": []}
              ]
            },
            allowAnonymous: true);
      });
      test("empty filter", () async {
        request = new shelf.Request("POST", pp.uri, body: JSON.encode({"filters": []}));
//        List response =
//            getListFromEnvelope(await getResponse(router.handler, request));
//        Map response = await getResponse(router.handler, request);
        Map response = getMapFromEnvelope(await getResponse(router.handler, request));
        expect(response, isMap);
        expect(response["places"].length, 98);
      });
      test("subname hili filter", () async {
        request = new shelf.Request("POST", pp.uri,
            body: JSON.encode({
              "filters": [
                {
                  "name": "place_subname",
                  "data": ["hili"]
                }
              ]
            }));
        Envelope response = await getResponse(router.handler, request);
        expect(getMapFromEnvelope(response)["places"].length, 3);
      });
    });
    group("filter + sorter", () {
      shelf_route.Router router;
      shelf.Request request;
      PathProvider pp = new PathProvider();
      setUp(() {
        router = server_lib.loadRouter();
        server_lib.route(pp.path, () => new FilterPlacesRC(),
            method: "POST",
            template: {
              "?sortBy": "string",
              "?desc": "bool",
              "filters": [
                {"name": "string", "data": []}
              ]
            },
            allowAnonymous: true);
      });
      test("sorted by price", () async {
        request = new shelf.Request("POST", pp.uri, body: JSON.encode({"sortBy": "price", "filters": []}));
        Envelope response = await getResponse(router.handler, request);
        expect((response.map["places"] as List<Map>).last["name"], "festival bohoslužeb");
      });
    }, skip: true);
  });
}
