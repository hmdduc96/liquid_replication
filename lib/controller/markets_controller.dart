// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:liquid_replication/controller/configuration_controller.dart';
import 'package:liquid_replication/model/coin.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_replication/model/convert.dart';

class MarketsController {
  MarketsController({required this.apiKey});
  //get api key
  final String apiKey;
  //coin data
  var coinData = <CoinModel>[].obs;

  //MARK: Get All Coin Data
  Future<List<CoinModel>?> getListCoinData(
      {required ConvertType convertType,
      required ConfigurationController config,
      required bool isForSearching,
      required String? searchID}) async {
    Map<String, dynamic> queryParameters = {};
    if (isForSearching == true && searchID != null) {
      //create parameter here for Searching
      queryParameters = singleQueryParameter(
          apiKey: config.apiKey,
          coinID: searchID.toUpperCase(),
          convert: 'USD'); //map parameter for request
    } else {
      queryParameters = tabQueryParameter(
          //create parameter here for All Icons
          apiKey: config.apiKey,
          config: config,
          convert: 'USD')[convertType]!; //map parameter for request
    }
    //get request
    final response = await http.get(
        Uri.parse(config.apiPath).replace(queryParameters: queryParameters));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      if (response.body.isNotEmpty) {
        Iterable l = json.decode(response.body);
        List<CoinModel> coins =
            List<CoinModel>.from(l.map((model) => CoinModel.fromJson(model)));
        //update current coin value
        coinData.value = coins;
        return coins;
      } else {
        return [];
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  //MARK: Get Specific Coin Data - Use to refresh a coin that show on screen only
  Future<CoinModel?> getSingleCoinData(
      {required ConfigurationController config, required String coinID}) async {
    var queryParameters = singleQueryParameter(
        apiKey: config.apiKey,
        coinID: coinID,
        convert: 'USD'); //map parameter for request
    //get request
    final response = await http.get(
        Uri.parse(config.apiPath).replace(queryParameters: queryParameters));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable l = json.decode(response.body);
      List<CoinModel> coins =
          List<CoinModel>.from(l.map((model) => CoinModel.fromJson(model)));
      print(coins.first);
      return coins.first;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }
}
