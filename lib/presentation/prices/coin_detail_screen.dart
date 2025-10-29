import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecommerce_app/services/coin_service.dart';

class CoinDetailScreen extends StatefulWidget {
  final String coinId;
  const CoinDetailScreen({super.key, required this.coinId});

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  late Future<Map<String, dynamic>> _coinDetails;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadCoinDetails();
  }

  void _loadCoinDetails() {
    setState(() {
      _isError = false;
      _coinDetails = CoinService.fetchCoinDetails(widget.coinId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0E1C),
      appBar: AppBar(
        title: const Text('Coin Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _coinDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || _isError || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Failed to load coin details',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      _loadCoinDetails();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final coin = snapshot.data!;
          final changeColor = coin['change'] != null && coin['change'] >= 0
              ? Colors.green
              : Colors.red;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (coin['logo'] != null)
                Center(child: Image.network(coin['logo'], width: 64)),
              const SizedBox(height: 16),
              Text(
                '${coin['symbol'] ?? ''} - ${coin['name'] ?? ''}',
                style: const TextStyle(fontSize: 22, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                coin['price'] != null
                    ? '\$${coin['price'].toStringAsFixed(2)}'
                    : 'Price unavailable',
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              if (coin['change'] != null)
                Text(
                  '${coin['change'].toStringAsFixed(2)}%',
                  style: TextStyle(color: changeColor),
                ),
              const SizedBox(height: 16),
              if (coin['marketCap'] != null)
                Text(
                  'Market Cap: \$${coin['marketCap'].toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white),
                ),
              if (coin['volume'] != null)
                Text(
                  '24h Volume: \$${coin['volume'].toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white),
                ),
              if (coin['rank'] != null)
                Text(
                  'Rank: ${coin['rank']}',
                  style: const TextStyle(color: Colors.white),
                ),
              const SizedBox(height: 16),
              Text(
                'Description:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                coin['description']?.isNotEmpty == true
                    ? coin['description']
                    : 'No description available',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              if (coin['homepage'] != null &&
                  coin['homepage'].toString().isNotEmpty)
                Text(
                  'Website: ${coin['homepage']}',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
            ],
          );
        },
      ),
    );
  }
}
