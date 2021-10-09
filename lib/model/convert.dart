import 'package:flutter/material.dart';
import 'package:liquid_replication/controller/configuration_controller.dart';

class ConvertTab {
  ConvertTab({required this.presenter, required this.type});

  final Widget presenter; //icon or text widget present on tab bar
  final ConvertType type; //type of tab
}

//define meaning of every tabs
enum ConvertType { search, favorite, usd, bitcon }

//create paramter for tab (list of coin)
Map<ConvertType, Map<String, dynamic>> tabQueryParameter(
        {required String apiKey,
        required ConfigurationController config,
        required String convert}) =>
    {
      ConvertType.favorite: {
        'key': apiKey,
        'interval': '1d,7d,30d',
        'convert': convert,
        'per-page': '10',
        'ids': config.favoriteCoinList.join(','),
        'filter': 'any'
      },
      ConvertType.usd: {
        'key': apiKey,
        'interval': '1d,7d,30d',
        'convert': 'USD',
        'per-page': '100',
        'ids': config.coinList.join(','),
        'filter': 'any'
      }
    };

//create paramter for single coin (from list of coin)
Map<String, dynamic> singleQueryParameter(
        {required String apiKey,
        required String coinID,
        required String convert}) =>
    {
      'key': apiKey,
      'interval': '1d,7d,30d',
      'convert': convert,
      'per-page': '10',
      'ids': coinID,
      'filter': 'any'
    };

//currency convert for every tab
Map<ConvertType, Map<String, dynamic>> tabConvertCurrency = {
  ConvertType.search: {'currency': 'USD', 'symbol': '\$'},
  ConvertType.favorite: {'currency': 'USD', 'symbol': '\$'},
  ConvertType.usd: {'currency': 'USD', 'symbol': '\$'},
  ConvertType.bitcon: {'currency': 'BTC', 'symbol': 'BTC'},
};
