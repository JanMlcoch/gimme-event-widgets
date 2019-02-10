library currency_provider;

import "../../model/library.dart";
import '../../../../server_libs/server/library.dart' as libs;
import 'package:akcnik/constants/constants.dart';
//import "../filter/library.dart";
import "dart:async";

void loadCurrencyProviderModule() {
  libs.route(CONTROLLER_GET_EXCHANGE_RATE, () => new CurrencyProviderRequestContext(), method: "POST");
}

class CurrencyProviderRequestContext extends libs.RequestContext {
  @override
  Future execute() {
    double responseIsh;
    if (data["request"] == GET_EXCHANGE_RATE) {
      responseIsh = CurrencyRater.getInstance().getExchangeRate(data["currencyFrom"], data["currencyTo"]);
    }
    envelope.withMap({"exchangeRateToEur": responseIsh});
    return null;
  }
}
