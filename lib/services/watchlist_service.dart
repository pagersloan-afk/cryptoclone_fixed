import 'dart:convert';
import 'package:http/http.dart' as http;

class WatchlistService {
  Future<List<Map<String, dynamic>>> fetchWatchlistData() async {
    try {
      final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin,ethereum,solana,matic-network&order=market_cap_desc&per_page=4&page=1&sparkline=false',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((coin) {
          return {
            'name': coin['name'] ?? 'Unknown',
            'symbol': (coin['symbol'] ?? '').toString().toUpperCase(),
            'price': coin['current_price']?.toDouble() ?? 0.0,
            'change': coin['price_change_percentage_24h']?.toDouble() ?? 0.0,
            'image': coin['image'] ?? '',
          };
        }).toList();
      } else {
        print('Failed to load market data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching watchlist data: $e');
      return [];
    }
  }
}
