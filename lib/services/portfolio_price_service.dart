import 'dart:convert';
import 'package:http/http.dart' as http;

Future<double?> fetchLivePrice(String symbol) async {
  final coingeckoMap = {
    'btc': 'bitcoin',
    'eth': 'ethereum',
    'bnb': 'binancecoin',
    'usdt': 'tether',
    'doge': 'dogecoin',
    'ada': 'cardano',
    'avax': 'avalanche-2',
    'axs': 'axie-infinity',
    'bch': 'bitcoin-cash',
    'usdc': 'usd-coin',
    'dot': 'polkadot',
    'etc': 'ethereum-classic',
    'ltc': 'litecoin',
    'shib': 'shiba-inu',
    'sol': 'solana',
    'trx': 'tron',
    'uni': 'uniswap',
    'xlm': 'stellar',
    'xrp': 'ripple',
    'xtz': 'tezos',
    'link': 'chainlink',
    'kai': 'kardiachain',
    'five': 'five',
    'a': 'aave',
    'pol': 'polkastarter',
  };

  final apiSymbol = coingeckoMap[symbol.toLowerCase()];
  if (apiSymbol == null) return null;

  final url = Uri.parse(
    'https://api.coingecko.com/api/v3/simple/price?ids=$apiSymbol&vs_currencies=usd',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return (data[apiSymbol]?['usd'] ?? 0.0).toDouble();
  } else {
    return null;
  }
}
