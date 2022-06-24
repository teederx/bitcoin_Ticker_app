import 'dart:io';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  //Store the values gotten from data into a map...
  Map<String, String> coinValues = {};

  bool isWaiting = false;
  void getData() async {
    isWaiting = true;
    try {
      //Get the crypto prices map from coin_data.dart and store in the map 'data'
      Map<String, String> data =
          await CoinData().getCoinData(currencyType: selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    //implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                selectedCurrency: selectedCurrency,
                coinType: 'BTC',
                value: isWaiting ? '?' : coinValues['BTC']!,
              ),
              CryptoCard(
                selectedCurrency: selectedCurrency,
                coinType: 'ETH',
                value: isWaiting ? '?' : coinValues['ETH']!,
              ),
              CryptoCard(
                selectedCurrency: selectedCurrency,
                coinType: 'LTC',
                value: isWaiting ? '?' : coinValues['LTC']!,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? getAndroidDropDown() : getIOSPicker(),
          ),
        ],
      ),
    );
  }

  DropdownButton<String> getAndroidDropDown() {
    //Create A List To Store The New Items
    List<DropdownMenuItem<String>> dropdowns = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdowns.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdowns,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getData();
        });
      },
    );
  }

  CupertinoPicker getIOSPicker() {
    List<Widget> itemize = [];
    for (String currency in currenciesList) {
      itemize.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: itemize,
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard(
      {Key? key,
      required this.selectedCurrency,
      required this.coinType,
      required this.value})
      : super(key: key);

  final String selectedCurrency;
  final String coinType;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coinType = $value $selectedCurrency ',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
