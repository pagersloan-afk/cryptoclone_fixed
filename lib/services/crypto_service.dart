import 'dart:convert';
import 'package:http/http.dart' as http;

class CryptoService {
  Future<double?> fetch24hChange() async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd&include_24hr_change=true',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['bitcoin']['usd_24h_change']?.toDouble();
    }
    return null;
  }

  Future<String?> fetchMarketData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/global',
        ), // Example endpoint
      );

      if (response.statusCode == 200) {
        return response.body; // You can parse this later
      } else {
        print('Market data error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception fetching market data: $e');
      return null;
    }
  }
}
