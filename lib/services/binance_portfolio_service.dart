import 'dart:convert';
import 'package:http/http.dart' as http;

class BinancePortfolioService {
  /// Fetches current USDT prices for a list of coin symbols
  Future<Map<String, double>> fetchCurrentPrices(List<String> symbols) async {
    final Map<String, double> prices = {};
    final url = Uri.parse('https://api.binance.com/api/v3/ticker/price');
    print('🔍 Fetching prices from: $url');

    int retries = 0;
    while (retries < 3) {
      try {
        final response = await http
            .get(url)
            .timeout(const Duration(seconds: 10));
        print('📡 Status: ${response.statusCode}');
        if (response.statusCode == 429) {
          print('⚠️ Rate limited. Retrying...');
          await Future.delayed(const Duration(seconds: 2));
          retries++;
          continue;
        }

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          for (final symbol in symbols) {
            final pair = '${symbol.toUpperCase()}USDT';
            final match = data.firstWhere(
              (item) => item['symbol'] == pair,
              orElse: () => null,
            );
            prices[symbol] = match != null
                ? double.tryParse(match['price']) ?? 0.0
                : 0.0;
          }
          return prices;
        } else {
          print('❌ Failed to fetch prices: ${response.statusCode}');
          break;
        }
      } catch (e) {
        print('❌ Error fetching prices: $e');
        retries++;
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    // Fallback: return zeroed prices
    for (final symbol in symbols) {
      prices[symbol] = 0.0;
    }
    return prices;
  }

  /// Fetches 24h price change percentage for BTC/USDT as a market proxy
  Future<double?> fetch24hChange() async {
    final url = Uri.parse(
      'https://api.binance.com/api/v3/ticker/24hr?symbol=BTCUSDT',
    );
    print('🔍 Fetching 24h change from: $url');

    int retries = 0;
    while (retries < 3) {
      try {
        final response = await http
            .get(url)
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
          final data = json.decode(response.body);
          return double.tryParse(data['priceChangePercent'] ?? '0');
        } else {
          print('❌ Failed to fetch 24h change: ${response.statusCode}');
          break;
        }
      } catch (e) {
        print('❌ Error fetching 24h change: $e');
        retries++;
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return null;
  }

  /// Fetches coin logos from CoinGecko
  Future<Map<String, String>> fetchCoinLogos() async {
    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false',
    );
    print('🔍 Fetching coin logos from: $url');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      print('📡 Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return {
          for (var coin in data)
            coin['symbol'].toString().toUpperCase(): coin['image'] ?? '',
        };
      } else {
        throw Exception('Failed to fetch coin logos: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching coin logos: $e');
      return {};
    }
  }
}
