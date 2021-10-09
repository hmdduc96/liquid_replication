// ignore_for_file: non_constant_identifier_names

class CoinModel {
  CoinModel({
    required this.currency,
    required this.id,
    required this.price,
    required this.price_date,
    required this.circulating_supply,
    required this.max_supply,
    required this.name,
    required this.logo_url,
    required this.market_cap,
    required this.market_cap_dominance,
    required this.day1,
  });

  final String currency;
  final String id;
  final String price;
  final String price_date;
  final String circulating_supply;
  final String max_supply;
  final String name;
  final String logo_url;
  final String market_cap;
  final String market_cap_dominance;
  final Map<String, dynamic>? day1;

  factory CoinModel.fromMap(Map<String, dynamic> data) {
    final String currency = data['currency'];
    final String id = data['id'];
    final String price = data['price'];
    final String price_date = data['price_date'];
    final String circulating_supply = data['circulating_supply'];
    final String max_supply = data['max_supply'];
    final String name = data['name'];
    final String logo_url = data['logo_url'];
    final String market_cap = data['market_cap'];
    final String market_cap_dominance = data['market_cap_dominance'];
    final Map<String, dynamic>? day1 = data['1d'];

    return CoinModel(
        day1: day1,
        currency: currency,
        id: id,
        price: price,
        price_date: price_date,
        circulating_supply: circulating_supply,
        max_supply: max_supply,
        name: name,
        logo_url: logo_url,
        market_cap: market_cap,
        market_cap_dominance: market_cap_dominance);
  }

  Map<String, dynamic> toMap() {
    return {
      '1d': day1,
      'currency': currency,
      'id': id,
      'price': price,
      'price_date': price_date,
      'circulating_supply': circulating_supply,
      'max_supply': max_supply,
      'name': 'name',
      'logo_url': logo_url,
      'market_cap': market_cap,
      'market_cap_dominance': market_cap_dominance
    };
  }

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
        currency: json['currency'],
        id: json['id'],
        day1: json['1d'],
        price: json['price'],
        price_date: json['price_date'],
        circulating_supply: json['circulating_supply'],
        max_supply: json['max_supply'],
        name: json['name'],
        logo_url: json['logo_url'],
        market_cap: json['market_cap'],
        market_cap_dominance: json['market_cap_dominance']);
  }
}
