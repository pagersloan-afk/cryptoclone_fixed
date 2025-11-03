import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/portfolio_item.dart';
import 'package:ecommerce_app/presentation/home/widgets/portfolio_card.dart';
import 'package:ecommerce_app/services/coin_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LivePortfolioCard extends StatefulWidget {
  final VoidCallback onDeposit;
  final VoidCallback onWithdraw;
  final void Function(PortfolioItem) onSend;

  const LivePortfolioCard({
    super.key,
    required this.onDeposit,
    required this.onWithdraw,
    required this.onSend,
  });

  @override
  State<LivePortfolioCard> createState() => _LivePortfolioCardState();
}

class _LivePortfolioCardState extends State<LivePortfolioCard> {
  late Stream<List<PortfolioItem>> _portfolioStream;
  double _changePercent = 0.0;
  bool _hasLoadedChange = false;

  @override
  void initState() {
    super.initState();
    _portfolioStream = _streamPortfolio();
  }

  Future<void> _loadChartData(String coinId) async {
    try {
      final data = await CoinService.fetchOHLCV(coinId, '24h', 100);
      if (data.isNotEmpty) {
        final open = data.first.open;
        final close = data.last.close;
        final change = open != 0 ? ((close - open) / open) * 100 : 0.0;

        if (!mounted) return;
        setState(() {
          _changePercent = change;
        });
      }
    } catch (e) {
      debugPrint('Chart load error: $e');
    }
  }

  Stream<List<PortfolioItem>> _streamPortfolio() async* {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    final coins = await CoinService.fetchTopCoins();
    final priceMap = {
      for (var coin in coins)
        coin['symbol'].toString().toUpperCase(): (coin['price'] ?? 0)
            .toDouble(),
    };
    final logoMap = {
      for (var coin in coins)
        coin['symbol'].toString().toUpperCase():
            coin['image'] ?? coin['logo'] ?? '',
    };

    yield* FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('holdings')
        .snapshots()
        .map((snapshot) {
          double totalValue = 0.0;
          final List<PortfolioItem> items = [];

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final symbol = (data['symbol'] ?? '').toString().toUpperCase();
            final amount = (data['amount'] ?? 0).toDouble();
            final price = priceMap[symbol] ?? 0.0;
            final value = amount * price;

            totalValue += value;

            items.add(
              PortfolioItem(
                name: symbol,
                symbol: symbol,
                amount: amount,
                value: value,
                percent: 0.0,
                logoUrl: logoMap[symbol] ?? '',
              ),
            );
          }

          return items.map((item) {
            final percent = totalValue > 0
                ? (item.value / totalValue) * 100
                : 0.0;
            return PortfolioItem(
              name: item.name,
              symbol: item.symbol,
              amount: item.amount,
              value: item.value,
              percent: percent,
              logoUrl: item.logoUrl,
            );
          }).toList()..sort((a, b) => b.value.compareTo(a.value));
        });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return StreamBuilder<List<PortfolioItem>>(
      stream: _portfolioStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return PortfolioCard(
            balance: '0.00 USD',
            changePercent: 0.0,
            onDeposit: widget.onDeposit,
            onWithdraw: widget.onWithdraw,
            onSend: (_) {},
            asset: PortfolioItem(
              name: 'Bitcoin',
              symbol: 'BTC',
              amount: 0.0,
              value: 0.0,
              percent: 0.0,
              logoUrl: 'https://cryptologos.cc/logos/bitcoin-btc-logo.png',
            ),
          );
        }

        final items = snapshot.data!;
        final totalValue = items.fold(0.0, (sum, i) => sum + i.value);
        final topAsset = items.first;

        // ✅ Dynamically load percent change for top asset
        if (!_hasLoadedChange) {
          _hasLoadedChange = true;
          _loadChartData(topAsset.name.toLowerCase()); // Use CoinGecko ID
        }

        return PortfolioCard(
          balance: '${formatter.format(totalValue)} USD',
          changePercent: _changePercent,
          onDeposit: widget.onDeposit,
          onWithdraw: widget.onWithdraw,
          onSend: widget.onSend,
          asset: topAsset,
        );
      },
    );
  }
}
