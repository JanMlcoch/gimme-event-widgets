part of model;
//todo: renew on every midnight and to last midnight on server restart

class CurrencyRater {
  static CurrencyRater _instance;
  static const String MAIN_CURRENCY = "CZK";
  Map<String, double> _rates;
  static String _ratesText = """27.11.2015 #229
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
  Rusko|rubl|100|RUB|38,603
  Singapur|dolar|1|SGD|18,100
  Švédsko|koruna|1|SEK|2,924
  Švýcarsko|frank|1|CHF|24,794
  Thajsko|baht|100|THB|71,161
  Turecko|lira|1|TRY|8,762
  USA|dolar|1|USD|25,540
  Velká Británie|libra|1|GBP|38,444""";

  static CurrencyRater getInstance() {
    if (_instance == null) {
      _instance = new CurrencyRater();
    }
    return _instance;
  }

  CurrencyRater() {
    updateRates();
  }
  bool get loaded => _rates.length > 5;
  double convertCurrency(Cost cost, String currencyTo) {
    if (cost.currency == currencyTo) return cost.price;
    double rate1 = _rates[cost.currency];
    double rate2 = _rates[currencyTo];
    if (rate1 == null || rate2 == null) return 0.0;
    return cost.price * rate1 / rate2;
  }

  double getExchangeRate(String currencyFrom, String currencyTo) {
    if (currencyFrom == currencyTo) return 1.0;
    double rate1 = _rates[currencyFrom];
    double rate2 = _rates[currencyTo];
    if (rate1 == null || rate2 == null) return 0.0;
    return rate1 / rate2;
  }

  double getUnitedPrice(Cost cost) {
    double rate1 = _rates[cost.currency];
    if (rate1 == null) return 0.0;
    return cost.price * rate1;
  }

  double getRateToUnited(String currency) {
    double rate1 = _rates[currency];
    if (rate1 == null) return 1.0;
    return rate1;
  }

  void updateRates([String ratesText]) {
    //to be overridden on both server and client separately
    if (ratesText == null) ratesText = _ratesText;
    _rates = _parseRates(ratesText);
  }

  ///refines incoming string from ČNB to map of rates to CZK
  static Map<String, double> _parseRates(String ratesTxt) {
    List<String> splittedRates = ratesTxt.split("""
  """);
    Map<String, double> rates = {};
    for (String split in splittedRates) {
      bool isInError = false;
      List<String> subsplits = split.split("|");
      if (subsplits.length != 5) {
        /*print(subsplits.join("|")+"wrong length");*/ continue;
      }
      subsplits[2] = subsplits[2].replaceAll(",", ".");
      subsplits[4] = subsplits[4].replaceAll(",", ".");
      if (subsplits[4].contains("kurz")) {
        continue;
      }
      double.parse(subsplits[4], (_) {
        print("4 not double");
        isInError = true;
      });
      double.parse(subsplits[2], (_) {
        print("2 nto double");
        //changed dor strict checker, this left deliberately original so we could discover future errors
        return int.parse(subsplits[2], onError: (_) {
          isInError = true;
          return 0;
        }).toDouble();
      });
      if (isInError) {
        continue;
      }
      rates[subsplits[3]] = (double.parse(subsplits[4]) / double.parse(subsplits[2]));
      rates["CZK"] = 1.0;
    }
    return rates;
  }
}
