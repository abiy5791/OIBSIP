import 'package:currencyconverter/models/allcurrenciesmodel.dart';
import 'package:currencyconverter/utils/key.dart';
import '../models/ratesmodel.dart';
import 'package:http/http.dart' as http;

Future<Ratesmodel> fetchRates() async {
  const url = "https://openexchangerates.org/api/latest.json?app_id=" + key;
  var response = await http.get(Uri.parse(url));
  final result = ratesmodelFromJson(response.body);
  return result;
}

Future<Map> fetchCurrencies() async {
  const url = "https://openexchangerates.org/api/currencies.json?app_id=" + key;
  var response = await http.get(Uri.parse(url));
  final allcurrencies = currenciesFromJson(response.body);
  return allcurrencies;
}

String convertusd(Map exchangeRates, String usd, String currency) {
  String output =
      ((exchangeRates[currency] * double.parse(usd)).toStringAsFixed(2))
          .toString();
  return output;
}

String convertany(Map exchangeRates, String amount, String basecurrency,
    String finalcurrency) {
  String output = (double.parse(amount) /
          exchangeRates[basecurrency] *
          exchangeRates[finalcurrency])
      .toStringAsFixed(2)
      .toString();
  return output;
}
