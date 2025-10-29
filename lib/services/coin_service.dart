import 'dart:convert';
import 'package:http/http.dart' as http;

class CoinService {
  /// Fetches top 50 coins with valid IDs for the Prices screen
  static Future<List<Map<String, dynamic>>> fetchTopCoins() async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      // ✅ Filter out coins with missing or invalid IDs
      final filtered = data.where((coin) {
        final id = coin['id'];
        return id != null && id is String && id.trim().isNotEmpty;
      });

      return filtered
          .map(
            (coin) => {
              'id': coin['id'],
              'name': coin['name'],
              'symbol': coin['symbol']?.toString().toUpperCase() ?? '',
              'price': coin['current_price'],
              'change': coin['price_change_percentage_24h'],
              'logo': coin['image'],
            },
          )
          .toList();
    } else {
      throw Exception('Failed to load coin data');
    }
  }

  /// Fetches full details for a specific coin by ID
  static Future<Map<String, dynamic>> fetchCoinDetails(String coinId) async {
    final url = Uri.parse('https://api.coingecko.com/api/v3/coins/$coinId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'name': data['name'],
        'symbol': data['symbol'].toUpperCase(),
        'logo': data['image']['large'],
        'description': data['description']['en'],
        'homepage': data['links']['homepage'][0],
        'price': data['market_data']['current_price']['usd'],
        'change': data['market_data']['price_change_percentage_24h'],
        'marketCap': data['market_data']['market_cap']['usd'],
        'volume': data['market_data']['total_volume']['usd'],
        'rank': data['market_cap_rank'],
      };
    } else {
      throw Exception('Failed to load coin details');
    }
  }
}
