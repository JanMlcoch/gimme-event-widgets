part of akcnik.tests.models;

void costTests() {
  String testRates = """27.11.2015 #229
  země|měna|množství|kód|kurz
  Austrálie|dolar|1|AUD|18,393
  Brazílie|real|1|BRL|6,863
  Bulharsko|lev|1|BGN|13,817
  Čína|renminbi|1|CNY|3,994
  Dánsko|koruna|1|DKK|3,622
  EMU|euro|1|EUR|27,025
  Filipíny|peso|100|PHP|54,117
  Hongkong|dolar|1|HKD|3,295
  Chorvatsko|kuna|1|HRK|3,545
  Indie|rupie|100|INR|38,251
  Indonesie|rupie|1000|IDR|1,853
  Izrael|šekel|1|ILS|6,570
  Japonsko|jen|100|JPY|20,826
  Jihoafrická rep.|rand|1|ZAR|1,783
  Jižní Korea|won|100|KRW|2,212
  Kanada|dolar|1|CAD|19,137
  Maďarsko|forint|100|HUF|8,662
  Malajsie|ringgit|1|MYR|5,995
  Mexiko|peso|1|MXN|1,543
  MMF|SDR|1|XDR|35,081
  Norsko|koruna|1|NOK|2,941
  Nový Zéland|dolar|1|NZD|16,692
  Polsko|zlotý|1|PLN|6,336
  Rumunsko|nové leu|1|RON|6,078
  Rusko|rubl|10000000|RUB|38,603
  Singapur|dolar|1|SGD|18,100
  Švédsko|koruna|1|SEK|2,924
  Švýcarsko|frank|1|CHF|24,794
  Thajsko|baht|100|THB|71,161
  Turecko|lira|1|TRY|8,762
  USA|dolar|1|USD|25,540
  Velká Británie|libra|1|GBP|38,444""";
  // changed rate of Russia => hyperinflation
  model_lib.Cost cost;
  model_lib.Costs costs;
  model_lib.CurrencyRater rater = model_lib.CurrencyRater.getInstance();
  group("fromMap", () {
    test("without call", () {
      cost = new model_lib.Cost();
      expect(cost.price, 0.0);
      expect(cost.description, "");
    });
    test("full", () {
      cost = new model_lib.Cost();
      cost.fromMap(
          {"price": 25.0, "currency": "USD", "description": "common price", "flag": common_lib.CostFlags.HANDICAPPED});
      expect(cost.price, 25.0);
      expect(cost.currency, "USD");
      expect(cost.description, "common price");
      expect(cost.flag, common_lib.CostFlags.HANDICAPPED);
    });
    test("int price", () {
      cost = new model_lib.Cost()..fromMap({"price": 100});
      expect(cost.price, 100.0);
    });
  });
  group("CurrencyRater", () {
    group("methods", () {
      test("getInstance()", () {
        expect(rater, isNotNull);
        expect(rater.loaded, isTrue);
      });
      test("updateRates()", () {
        rater.updateRates(testRates);
        expect(rater.getRateToUnited("RUB"), 0.0000038603);
      });
      test("getRateToUnited()", () {
        expect(rater.getRateToUnited("CZK"), 1.0);
        expect(rater.getRateToUnited("EUR"), 27.025);
        expect(rater.getRateToUnited("USD"), 25.540);
      });
      test("getUnitedPrice()", () {
        expect(rater.getUnitedPrice(new model_lib.Cost.fromData(25.5, "CZK")), 25.5);
        expect(rater.getUnitedPrice(new model_lib.Cost.fromData(1, "EUR")), 27.025);
        expect(rater.getUnitedPrice(new model_lib.Cost.fromData(256, "USD")), 6538.24);
      });
      test("convertCurrency", () {
        expect(rater.convertCurrency(new model_lib.Cost.fromData(25.5, "CZK"), "USD"), 0.9984338292873923);
        expect(rater.convertCurrency(new model_lib.Cost.fromData(1, "EUR"), "RUB"), 7000751.236950495);
        expect(rater.convertCurrency(new model_lib.Cost.fromData(80, "GBP"), "NOK"), 1045.7395443726625);
      });
    });
  });
  group("Costs", () {
    group("fromList", () {
      test("without call", () {
        costs = new model_lib.Costs();
        expect(costs.list.length, 0);
      });
      test("one cost", () {
        costs.fromList([
          {"price": 25.0, "currency": "USD", "description": "common price", "flag": common_lib.CostFlags.HANDICAPPED}
        ]);
        expect(costs.list.length, 1);
        expect(costs.list.first is model_lib.Cost, isTrue);
        cost = costs.list.first;
        expect(cost.price, 25.0);
        expect(cost.currency, "USD");
        expect(cost.description, "common price");
        expect(cost.flag, common_lib.CostFlags.HANDICAPPED);
      });
      test("multiple cost", () {
        costs.fromList([
          {"price": 22.0, "currency": "USD", "description": "common price", "flag": common_lib.CostFlags.PRE_ORDER},
          {"price": 25.0, "currency": "USD", "description": "common price", "flag": common_lib.CostFlags.LIMITED_OFFER},
          {"price": 500, "currency": "CZK", "description": "common price", "flag": common_lib.CostFlags.HANDICAPPED},
          {"price": 20.0, "currency": "EUR", "description": "common price", "flag": common_lib.CostFlags.PRE_ORDER}
        ]);
        expect(costs.list.length, 4);
      });
      test("getRepresentaticePrice", () {
        expect(costs.getRepresentativePrice(), 540.5);
      });
    });
  });
}
