import 'dart:convert' show base64, jsonDecode, utf8;
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
//Get your API key from 'https://www.coinapi.io/pricing?apikey'
const apikey = 'YOUR-API-KEY-HERE';
const coinApiURL = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future getCoinData({required String currencyType}) async {
    //Create a map to hold the crypto list and their rates...
    // create a for loop to loop through the crypto list...
    //Save the result in the map...
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String url = '$coinApiURL/$crypto/$currencyType?apikey=$apikey';
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var decodeData = jsonDecode(response.body);
        double rate = decodeData['rate'];
        // Save result in map..
        cryptoPrices[crypto] = rate.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'problem with get request';
      }
    }
    return cryptoPrices;
  }
}
