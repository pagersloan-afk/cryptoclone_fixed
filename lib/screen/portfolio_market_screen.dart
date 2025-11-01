import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/portfolio_item.dart';
import 'package:ecommerce_app/services/coin_service.dart';
import 'package:ecommerce_app/presentation/prices/coin_detail_screen.dart';
import 'package:flutter/material.dart';

class PortfolioMarketScreen extends StatefulWidget {
  final String userId;
  const PortfolioMarketScreen({super.key, required this.userId});

  @override
  State<PortfolioMarketScreen> createState() => _PortfolioMarketScreenState();
}

class _PortfolioMarketScreenState extends State<PortfolioMarketScreen> {
  late Future<List<Map<String, dynamic>>> _coinListFuture;
  late Future<List<PortfolioItem>> _portfolioFuture;

  @override
  void initState() {
    super.initState();
    _coinListFuture = CoinService.fetchTopCoins();
    _portfolioFuture = _loadPortfolio();
  }

  Future<List<PortfolioItem>> _loadPortfolio() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .collection('holdings')
        .get();

    final coins = await CoinService.fetchTopCoins();
    final coinMap = {
      for (var coin in coins) coin['symbol'].toString().toUpperCase(): coin,
    };

    final List<Map<String, dynamic>> rawItems = [];
    double totalValue = 0.0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final symbol = data['symbol'].toString().toUpperCase();
      final amount = (data['amount'] ?? 0).toDouble();

      final coin = coinMap[symbol];
      if (coin == null || coin['price'] == null) continue;

      final price = coin['price'].toDouble();
      final value = amount * price;
      totalValue += value;

      rawItems.add({
        'name': coin['name'],
        'symbol': symbol,
        'amount': amount,
        'value': value,
        'logoUrl': coin['image'] ?? coin['logo'] ?? '',
      });
    }

    return rawItems.map((raw) {
      final percent = totalValue > 0 ? (raw['value'] / totalValue) * 100 : 0.0;
      return PortfolioItem(
        name: raw['name'],
        symbol: raw['symbol'],
        amount: raw['amount'],
        value: raw['value'],
        percent: percent,
        logoUrl: raw['logoUrl'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E1C),
      appBar: AppBar(
        title: const Text('Portfolio Market'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: Future.wait([_coinListFuture, _portfolioFuture]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final coins = snapshot.data![0] as List<Map<String, dynamic>>;
          final holdings = snapshot.data![1] as List<PortfolioItem>;
          final holdingMap = {
            for (var item in holdings) item.symbol.toUpperCase(): item,
          };

          final sortedCoins = [...coins];
          sortedCoins.sort((a, b) {
            final aHeld =
                holdingMap.containsKey(a['symbol'].toString().toUpperCase())
                ? 0
                : 1;
            final bHeld =
                holdingMap.containsKey(b['symbol'].toString().toUpperCase())
                ? 0
                : 1;
            return aHeld.compareTo(bHeld);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedCoins.length,
            itemBuilder: (_, index) {
              final coin = sortedCoins[index];
              final symbol = coin['symbol'].toString().toUpperCase();
              final holding = holdingMap[symbol];
              final hasHolding = holding != null;
              final logoUrl = coin['image'] ?? coin['logo'] ?? '';

              return InkWell(
                onTap: () {
                  final coinId = coin['id'];
                  if (coinId != null && coinId is String && coinId.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CoinDetailScreen(coinId: coinId),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1E33),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        logoUrl,
                        width: 32,
                        height: 32,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.error, size: 32),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$symbol — ${coin['name']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              coin['price'] != null
                                  ? '\$${coin['price'].toStringAsFixed(2)}'
                                  : 'Price unavailable',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            if (hasHolding)
                              Text(
                                '${holding.amount.toStringAsFixed(4)} $symbol ≈ \$${holding.value.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        coin['change'] != null
                            ? '${coin['change'].toStringAsFixed(2)}%'
                            : '--',
                        style: TextStyle(
                          color: coin['change'] != null && coin['change'] >= 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
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
