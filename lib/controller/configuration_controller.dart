import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:liquid_replication/model/convert.dart';

class ConfigurationController extends GetxController {
  //identify theme
  var isLightTheme = false.obs;
  //setup all converts for tab bar
  var convertTabs = [
    ConvertTab(
        presenter: const Icon(Icons.star_rounded, size: 20),
        type: ConvertType.favorite),
    ConvertTab(presenter: const Text('USD'), type: ConvertType.usd),
  ];
  //coin api
  final String apiKey = 'bbccb6299ee86214c2416c78eb7d3c6c50717ca5'; //api key
  final String apiPath =
      'https://api.nomics.com/v1/currencies/ticker'; //path behind host
  //favorite coin list
  final favoriteCoinList = [
    'BTC',
    'ETH',
    'XRP',
  ];
  //coin list
  final coinList = [
    'BTC',
    'ETH',
    'XRP',
    'USDT',
    'ADA',
    'DOGE',
    'DOGE',
    'LTC',
    'XLM',
    'XLM',
    'EOS',
    'XMR',
    'XTZ',
    'ETC',
    'DAI',
    'ZEC',
    'BAT',
    'NANO',
    'LSK',
    'STEEM',
    'RDD',
    'NAV',
    'NMC',
    'PPC',
    'XPM'
  ];
}
