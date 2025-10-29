import 'package:flutter/material.dart';
import 'package:ecommerce_app/services/coin_service.dart';
import 'package:ecommerce_app/presentation/prices/coin_detail_screen.dart';

class PricesScreen extends StatefulWidget {
  const PricesScreen({super.key});

  @override
  State<PricesScreen> createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  late Future<List<Map<String, dynamic>>> _coinList;

  @override
  void initState() {
    super.initState();
    _coinList = CoinService.fetchTopCoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E1C),
      appBar: AppBar(
        title: const Text('Prices'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _coinList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final coins = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: coins.length,
            itemBuilder: (_, index) {
              final coin = coins[index];
              final changeColor = coin['change'] != null && coin['change'] >= 0
                  ? Colors.green
                  : Colors.red;

              return GestureDetector(
                onTap: () {
                  final coinId = coin['id'];
                  if (coinId != null && coinId is String && coinId.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CoinDetailScreen(coinId: coinId),
                      ),
                    );
                  } else {
                    debugPrint('Invalid coin ID: $coinId');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to load coin details'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1E33),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      if (coin['logo'] != null)
                        Image.network(coin['logo'], width: 32, height: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${coin['symbol'] ?? ''} - ${coin['name'] ?? ''}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              coin['price'] != null
                                  ? '\$${coin['price'].toStringAsFixed(2)}'
                                  : 'Price unavailable',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        coin['change'] != null
                            ? '${coin['change'].toStringAsFixed(2)}%'
                            : '--',
                        style: TextStyle(color: changeColor),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
