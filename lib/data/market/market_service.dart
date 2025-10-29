import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketService {
  Future<List<Map<String, dynamic>>> getTopCoins() async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data
          .map(
            (coin) => {
              'name': coin['name'],
              'symbol': coin['symbol'],
              'price': coin['current_price'],
              'change': coin['price_change_percentage_24h'],
              'image': coin['image'],
            },
          )
          .toList();
    } else {
      throw Exception('Failed to load market data');
    }
  }
}
