import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, double>> fetchLivePrices(List<String> coins) async {
  if (coins.isEmpty) return {}; // prevent empty API call

  final coinIds = {
    'BTC': 'bitcoin',
    'ETH': 'ethereum',
    'SOL': 'solana',
    // Add more mappings as needed
  };

  final ids = coins
      .map((c) => coinIds[c] ?? '')
      .where((id) => id.isNotEmpty)
      .join(',');

  if (ids.isEmpty) return {}; // extra safety

  final url = Uri.parse(
    'https://api.coingecko.com/api/v3/simple/price?ids=$ids&vs_currencies=usd',
  );

  final response = await http.get(url);
  final data = jsonDecode(response.body);

  final prices = <String, double>{};
  coinIds.forEach((symbol, id) {
    if (data[id] != null && data[id]['usd'] != null) {
      prices[symbol] = (data[id]['usd'] as num).toDouble();
    }
  });

  return prices;
}

double calculatePortfolioValue(
  Map<String, dynamic> holdings,
  Map<String, double> prices,
) {
  double total = 0;
  holdings.forEach((coin, amount) {
    final price = prices[coin] ?? 0;
    total += (amount as num) * price;
  });
  return total;
}
