import 'package:ecommerce_app/core/configs/theme/app_colors.dart';
import 'package:ecommerce_app/models/portfolio_item.dart';
import 'package:ecommerce_app/presentation/home/widgets/deposit_sheet.dart';
import 'package:ecommerce_app/services/coin_service.dart';
import 'package:ecommerce_app/presentation/prices/coin_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  late Future<List<PortfolioItem>> _portfolioFuture;
  final NumberFormat currencyFormatter = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );
  final double _changePercent = 0.0;

  final Map<String, String> coinIds = {
    'BTC': 'bitcoin',
    'ETH': 'ethereum',
    'XRP': 'ripple',
    'ADA': 'cardano',
    'LINK': 'chainlink',
    'SOL': 'solana',
    'USDC': 'usd-coin',
    'STETH': 'staked-ether',
    'DOGE': 'dogecoin',
    'BNB': 'binancecoin',
    'DOT': 'polkadot',
    'MATIC': 'matic-network',
    'AVAX': 'avalanche-2',
    'TRX': 'tron',
    'SHIB': 'shiba-inu',
    'DAI': 'dai',
    'ATOM': 'cosmos',
    'UNI': 'uniswap',
    'LTC': 'litecoin',
    'XLM': 'stellar',
    'APT': 'aptos',
    'ARB': 'arbitrum',
    'OP': 'optimism',
    'NEAR': 'near',
    'INJ': 'injective',
    'PEPE': 'pepe',
    'TUSD': 'true-usd',
    'WBTC': 'wrapped-bitcoin',
    'SUI': 'sui',
    'RNDR': 'render-token',
    'IMX': 'immutable-x',
    'GRT': 'the-graph',
    'AAVE': 'aave',
    'SNX': 'synthetix-network-token',
    'CRV': 'curve-dao-token',
    '1INCH': '1inch',
    'BUSD': 'binance-usd',
    'FLR': 'flare',
    'LDO': 'lido-dao',
    'KAVA': 'kava',
    'RPL': 'rocket-pool',
    'BAL': 'balancer',
    'COMP': 'compound',
    'MKR': 'maker',
    'ENJ': 'enjincoin',
    'CHZ': 'chiliz',
    'SAND': 'the-sandbox',
    'AXS': 'axie-infinity',
    'GMT': 'stepn',
    'DYDX': 'dydx',
    'YFI': 'yearn-finance',
    'ZEC': 'zcash',
    'EOS': 'eos',
    'XMR': 'monero',
    'ZRX': '0x',
    'BAT': 'basic-attention-token',
    'SKL': 'skale',
    'ALGO': 'algorand',
    'NEXO': 'nexo',
    'CEL': 'celsius-network',
    'FTM': 'fantom',
    'GALA': 'gala',
    'MINA': 'mina-protocol',
    'RUNE': 'thorchain',
    'ANKR': 'ankr',
    'KSM': 'kusama',
    'QTUM': 'qtum',
    'OMG': 'omisego',
    'ICX': 'icon',
    'ONT': 'ontology',
    'ZEN': 'horizen',
    'SC': 'siacoin',
    'BTT': 'bittorrent',
    'WIN': 'wink',
  };

  @override
  void initState() {
    super.initState();
    _portfolioFuture = _loadPortfolio();
  }

  Future<List<PortfolioItem>> _loadPortfolio() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    final holdingsSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('holdings')
        .get();

    final coins = await CoinService.fetchTopCoins();

    final holdingsMap = {
      for (var doc in holdingsSnapshot.docs)
        doc['symbol'].toString().toUpperCase(): (doc['amount'] ?? 0).toDouble(),
    };

    double totalValue = 0.0;
    final List<PortfolioItem> items = [];

    for (var coin in coins) {
      final symbol = coin['symbol'].toString().toUpperCase();
      final name = coin['name'] ?? symbol;
      final logoUrl = coin['image'] ?? coin['logo'] ?? '';
      final price = (coin['price'] ?? 0).toDouble();
      final amount = holdingsMap[symbol] ?? 0.0;
      final value = amount * price;

      totalValue += value;

      items.add(
        PortfolioItem(
          name: name,
          symbol: symbol,
          amount: amount,
          value: value,
          percent: 0.0,
          logoUrl: logoUrl,
        ),
      );
    }

    final List<PortfolioItem> finalItems = items.map((item) {
      final percent = totalValue > 0 ? (item.value / totalValue) * 100 : 0.0;
      return PortfolioItem(
        name: item.name,
        symbol: item.symbol,
        amount: item.amount,
        value: item.value,
        percent: percent,
        logoUrl: item.logoUrl,
      );
    }).toList();

    finalItems.sort((a, b) => b.value.compareTo(a.value));
    return finalItems;
  }

  void _openDepositSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DepositSheet(),
    );
  }

  void _navigateToCoinDetail(String symbol) {
    final coinId = coinIds[symbol.toUpperCase()] ?? symbol.toLowerCase();
    HapticFeedback.selectionClick();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => CoinDetailScreen(coinId: coinId),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('💼 Portfolio'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_balance_wallet,
              color: AppColors.text,
            ),
            tooltip: 'Deposit',
            onPressed: _openDepositSheet,
          ),
        ],
      ),
      body: FutureBuilder<List<PortfolioItem>>(
        future: _portfolioFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          final totalValue = items.fold(0.0, (sum, i) => sum + i.value);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Portfolio Value',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  currencyFormatter.format(totalValue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_changePercent >= 0 ? '+' : ''}${_changePercent.toStringAsFixed(2)}% Past 24h',
                  style: TextStyle(
                    color: _changePercent >= 0
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available: ${currencyFormatter.format(totalValue)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'On Order: ${currencyFormatter.format(0.00)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return InkWell(
                        onTap: () => _navigateToCoinDetail(item.symbol),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              if (item.logoUrl.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Image.network(
                                    item.logoUrl,
                                    width: 32,
                                    height: 32,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.error, size: 32),
                                  ),
                                ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${item.percent.toStringAsFixed(2)}%',
                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${item.amount.toStringAsFixed(2)} ${item.symbol}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    currencyFormatter.format(item.value),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
