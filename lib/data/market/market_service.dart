import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketService {
  static const _url =
      'https://api.coingecko.com/api/v3/coins/markets'
      '?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false';

  /// Fetches top 10 coins with price, change %, and logo
  Future<List<Map<String, dynamic>>> getTopCoins() async {
    final uri = Uri.parse(_url);
    print('🔍 Fetching market data from: $uri');

    int retries = 0;
    while (retries < 3) {
      try {
        final response = await http
            .get(uri)
            .timeout(const Duration(seconds: 10));
        print('📡 Status: ${response.statusCode}');
        print('📦 Body: ${response.body}');

        if (response.statusCode == 429) {
          print('⚠️ Rate limited. Retrying...');
          await Future.delayed(const Duration(seconds: 2));
          retries++;
          continue;
        }

        if (response.statusCode == 200) {
          final List data = json.decode(response.body);
          return data
              .map(
                (coin) => {
                  'name': coin['name'] ?? '',
                  'symbol': coin['symbol']?.toUpperCase() ?? '',
                  'price': coin['current_price'] ?? 0.0,
                  'change': coin['price_change_percentage_24h'] ?? 0.0,
                  'image': coin['image'] ?? '',
                },
              )
              .toList();
        } else {
          throw Exception('Failed to load market data: ${response.statusCode}');
        }
      } catch (e) {
        print('❌ Error fetching market data: $e');
        retries++;
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    throw Exception('Market data fetch failed after 3 retries');
  }
}
