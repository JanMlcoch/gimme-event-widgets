part of akcnik.tests.filter;

void eventFilterTest() {
  RootFilter rootFilter;
  model_lib.ModelRoot model;
  EnvelopeHolder message;
  RootFilter nopeFilter = RootFilter.nope;
  test("Importing sample data", () {
    model = constructModel(placesJson: sample.placesJson, eventsJson: sample.eventsJson);
    storage_lib.loadMemoryStorage(model);
    expect(storage_lib.storage, isNotNull);
    expect(model.places.length, 98);
    expect(model.events.length, 120);
  });
  group("Event filters", () {
    group("creation", () {
      test("empty AndEventFilter", () {
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
              "name": "event_subname",
              "data": ["ahoj"]
            },
            {
              "name": "price_interval",
              "data": [100, 200, "EUR"]
            },
            {
              "name": "gps_window",
              "data": [15.0, 20.2, 50.4, 69.7]
            },
            {
              "name": "distance",
              "data": [23.2, 50.1, 25]
            }
          ], message);
          expect(rootFilter, isNot(nopeFilter));
          expect(message.empty, isTrue);
        });
        test("wrong price data type", () {
          message = new EnvelopeHolder();
          rootFilter = new RootFilter.construct([
            {
              "name": "event_subname",
              "data": ["ahoj"]
            },
            {
              "name": "price_interval",
              "data": ["cena", 200, "EUR"]
            },
            {
              "name": "gps_window",
              "data": [15.0, 20.2, 50.4, 69.7]
            },
            {
              "name": "distance",
              "data": [23.2, 50.1, 25]
            }
          ], message);
          expect(rootFilter, nopeFilter);
          expect(message.toMap(), failedEnvelope(
              "Filter price_interval have source data in incorrect format: 0-th item from [cena, 200, EUR] should be num",
              BAD_FILTER));
        });
        test("too short data length", () {
          message = new EnvelopeHolder();
          rootFilter = new RootFilter.construct([
            {
              "name": "event_subname",
              "data": ["ahoj"]
            },
            {
              "name": "price_interval",
              "data": [100, 200, "EUR"]
            },
            {
              "name": "gps_window",
              "data": [15.0, 20.2, 50.4, 69.7]
            },
            {
              "name": "distance",
              "data": [23.2, 50.1]
            }
          ], message);
          expect(rootFilter, nopeFilter);
          expect(message.toMap(), failedEnvelope(
              "Filter distance have source data in incorrect format: data array [23.2, 50.1] should contains 3 items",
              BAD_FILTER));
        });
      });
      group("composite filters", () {
        test("valid", () {
          message = new EnvelopeHolder();
          rootFilter = new RootFilter.construct([
            {
              "name": "price_interval",
              "data": [100, 200, "EUR"]
            },
            {
              "name": "gps_window",
              "data": [15.0, 20.2, 50.4, 69.7]
            },
          ], message);
          expect(rootFilter, isNot(nopeFilter));
        });
        test("missing name", () {
          message = new EnvelopeHolder();
          rootFilter = new RootFilter.construct([
            {
              "name": "price_interval",
              "data": [100, 200]
            },
            {
              "data": [15.0, 20.2, 50.4, 69.7]
            }
          ], message);
          expect(rootFilter, nopeFilter);
          expect(message.toMap(), failedEnvelope('{data: [15.0, 20.2, 50.4, 69.7]} should contains "name"',BAD_FILTER));
        });
        test("not map", () {
          message = new EnvelopeHolder();
          rootFilter = new RootFilter.construct([
            {
              "name": "price_interval",
              "data": [100, 200]
            },
            "filter",
          ], message);
          expect(rootFilter, nopeFilter);
          expect(message.toMap(), failedEnvelope('filter should be Map',BAD_FILTER));
        });
        test("data is not List", () {
          message = new EnvelopeHolder();
          rootFilter = new RootFilter.construct([
            {
              "name": "price_interval",
              "data": [100, 200]
            },
            {"name": "gps_window", "data": "data"}
          ], message);
          expect(rootFilter, nopeFilter);
          expect(message.toMap(), failedEnvelope('{name: gps_window, data: data}[data] should be List',BAD_FILTER));
        });
        test("unknown type", () {
          message = new EnvelopeHolder();
          rootFilter = new RootFilter.construct([
            {
              "name": "unknown_filter type",
              "data": [100, 200]
            }
          ], message);
          expect(rootFilter, nopeFilter);
          expect(message.toMap(), failedEnvelope('unknown filter type: "unknown_filter type"',BAD_FILTER));
        });
      });
    });
    group("filtration", () {
      test("get Event list", () {
        List<model_lib.Event> events = model.events.list;
        expect(events.length, 120);
      });
      test("empty AndEventFilter applied", () {
        rootFilter = new RootFilter.construct([],new EnvelopeHolder());
        expect(rootFilter
            .filter(model.events)
            .length, 120);
      });
      test("filter by subname", () {
        rootFilter = new RootFilter.construct([
          {
            "name": "event_subname",
            "data": ["festival"]
          }
        ],new EnvelopeHolder());
        model_lib.Events filtrate = rootFilter.filter(model.events);
        expect(filtrate.length, 10);
        filtrate.list.forEach((model_lib.Event event) {
          expect(event.name, contains("festival"));
        });
      });
      test("filter by price", () {
        rootFilter = new RootFilter.construct([
          {
            "name": "price_interval",
            "data": [200, 220, "CZK"]
          }
        ],new EnvelopeHolder());
        model_lib.Events filtrate = rootFilter.filter(model.events);
        expect(filtrate.length, 1);
        expect(filtrate.first.representativePrice, inInclusiveRange(200, 220));
      });
    });
    group("filter request", () {
      shelf_route.Router router;
      shelf.Request request;
      PathProvider pp = new PathProvider();
      setUp(() {
        router = server_lib.loadRouter();
        server_lib.route(pp.path, () => new FilterEventsRC(),
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
      test("missing filter parameter", () {
        request = new shelf.Request("POST", pp.uri, body: JSON.encode({"name": "nobody"}));
        expect(getResponseMap(router.handler, request),
            completion(failedEnvelope('Missing "filters" parameter of "rootData"', DATA_IMPROPER_STRUCTURE)));
      });
      test("empty filter", () async {
        request = new shelf.Request("POST", pp.uri, body: JSON.encode({"filters": []}));
        Envelope response = await getResponse(router.handler, request);
        expect(getMapFromEnvelope(response)["events"].length, 120);
      });
      test("subname festival filter", () async {
        request = new shelf.Request("POST", pp.uri,
            body: JSON.encode({
              "filters": [
                {
                  "name": "event_subname",
                  "data": ["festival"]
                }
              ]
            }));
        Map response = getMapFromEnvelope(await getResponse(router.handler, request));
        expect(response["events"], isList);
        expect(response["events"].length, 10);
      });
      test("subname festival+fantasy filter", () async {
        request = new shelf.Request("POST", pp.uri,
            body: JSON.encode({
              "filters": [
                {
                  "name": "event_subname",
                  "data": ["festival"]
                },
                {
                  "name": "event_subname",
                  "data": ["fantasy"]
                }
              ]
            }));
        Map response = getMapFromEnvelope(await getResponse(router.handler, request));
        expect(response["events"], isList);
        expect(response["events"].length, 1);
      });
    });
    group("filter + sorter", () {
      shelf_route.Router router;
      shelf.Request request;
      PathProvider pp = new PathProvider();
      setUp(() {
        router = server_lib.loadRouter();
        server_lib.route(pp.path, () => new FilterEventsRC(),
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
      test("unknown sortBy", () {
        request = new shelf.Request("POST", pp.uri, body: JSON.encode({"sortBy": "medvěd", "filters": []}));
        expect(getResponse(router.handler, request), completion(failedEnvelope('Wrong name of sorter')));
      });
      test("sorted by price", () async {
        request = new shelf.Request("POST", pp.uri, body: JSON.encode({"sortBy": "price", "filters": []}));
        Map response = getMapFromEnvelope(await getResponse(router.handler, request));
        expect(response["events"], isList);
        expect((response["events"] as List<Map>).last["name"], "festival bohoslužeb");
      });
      test("sorted by start date desc", () async {
        request =
            new shelf.Request("POST", pp.uri, body: JSON.encode({"desc": true, "sortBy": "startDate", "filters": []}));
        Map response = getMapFromEnvelope(await getResponse(router.handler, request));
        expect(response["events"], isList);
        expect((response["events"] as List<Map>).last["name"], "festival bohoslužeb");
      });
    }, skip: true);
  });
}
