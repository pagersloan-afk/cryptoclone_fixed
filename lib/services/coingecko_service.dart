import 'dart:convert';
import 'package:ecommerce_app/models/trade_data.dart';
import 'package:http/http.dart' as http;

class CoinGeckoService {
  Future<List<TradeData>> fetchOHLC(String coinId, int days) async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/coins/$coinId/ohlc?vs_currency=usd&days=$days',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> rawData = jsonDecode(response.body);
      return rawData.map((item) {
        return TradeData(
          DateTime.fromMillisecondsSinceEpoch(item[0]),
          item[1].toDouble(),
          item[2].toDouble(),
          item[3].toDouble(),
          item[4].toDouble(),
          0.0,
        );
      }).toList();
    } else {
      throw Exception('Failed to load OHLC data');
    }
  }
}
