import 'package:flutter/material.dart';
import 'package:ecommerce_app/data/market/market_service.dart';
import 'package:shimmer/shimmer.dart';

class MarketTrends extends StatelessWidget {
  const MarketTrends({super.key});

  Widget _marketShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 32, height: 32, color: Colors.black),
            const SizedBox(height: 8),
            Container(width: 40, height: 12, color: Colors.black),
            const SizedBox(height: 4),
            Container(width: 60, height: 12, color: Colors.black),
            const SizedBox(height: 4),
            Container(width: 40, height: 12, color: Colors.black),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📈 Market Movers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: MarketService().getTopCoins(),
            builder: (context, snapshot) {
              final isLoading =
                  snapshot.connectionState == ConnectionState.waiting;
              final hasError =
                  snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty;

              if (isLoading || hasError) {
                return SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (_, __) => _marketShimmerItem(),
                  ),
                );
              }

              final coins = snapshot.data!;
              return SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: coins.length,
                  itemBuilder: (context, index) {
                    final coin = coins[index];
                    final isUp = (coin['change'] ?? 0) >= 0;

                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(coin['image'], width: 32, height: 32),
                          const SizedBox(height: 8),
                          Text(
                            coin['symbol'].toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '\$${coin['price'].toString()}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            '${coin['change'].toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: isUp
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
