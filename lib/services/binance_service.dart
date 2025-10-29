import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ecommerce_app/models/trade_data.dart';

/// Maps common coin names to Binance trading symbols
String getBinanceSymbol(String coin) {
  switch (coin.toLowerCase()) {
    case 'bitcoin':
      return 'BTCUSDT';
    case 'ethereum':
      return 'ETHUSDT';
    case 'binancecoin':
      return 'BNBUSDT';
    default:
      return 'BTCUSDT';
  }
}

class BinanceService {
  Future<List<TradeData>> fetchOHLCV(
    String coinName,
    String interval,
    int limit,
  ) async {
    final symbol = getBinanceSymbol(coinName);
    final url = Uri.parse(
      'https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval&limit=$limit',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> rawData = jsonDecode(response.body);
      return rawData.map((item) {
        return TradeData(
          DateTime.fromMillisecondsSinceEpoch(item[0]),
          double.parse(item[1]),
          double.parse(item[2]),
          double.parse(item[3]),
          double.parse(item[4]),
          double.parse(item[5]),
        );
      }).toList();
    } else {
      throw Exception('Failed to load OHLCV data from Binance');
    }
  }
}
