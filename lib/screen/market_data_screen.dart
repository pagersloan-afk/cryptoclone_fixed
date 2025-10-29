import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/fiat_market_tile.dart';

class MarketDataScreen extends StatelessWidget {
  final String marketData;
  const MarketDataScreen({super.key, required this.marketData});

  List<double> generateSparkline(double base) {
    return List.generate(7, (i) {
      final fluctuation = (i % 2 == 0 ? -1 : 1) * (i * 5);
      return base + fluctuation;
    });
  }

  @override
  Widget build(BuildContext context) {
    final parsed = json.decode(marketData);
    final caps = parsed['data']?['total_market_cap'] ?? {};

    final currencies = ['btc', 'eth', 'xrp', 'sol', 'bnb'];

    final data = currencies
        .where((key) => caps[key] != null)
        .map(
          (key) => {
            'pair': '${key.toUpperCase()} • USD',
            'volume':
                '${(caps[key]! / 1000000).toStringAsFixed(1)}M ${key.toUpperCase()}',
            'price': '\$${(caps[key]! / 1000000).toStringAsFixed(2)}',
            'change': key == 'xrp'
                ? 3.22
                : key == 'eth'
                ? -1.45
                : 0.00,
            'sparkline': generateSparkline(caps[key]! / 1000000),
          },
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('📈 Fiat Markets'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: data.isEmpty
          ? const Center(
              child: Text(
                'No market cap data available',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = data[index];
                return FiatMarketTile(
                  pair: item['pair'] as String,
                  volume: item['volume'] as String,
                  price: item['price'] as String,
                  change: item['change'] as double,
                  sparkline: (item['sparkline'] as List)
                      .map((e) => e as double)
                      .toList(),
                );
              },
            ),
    );
  }
}
