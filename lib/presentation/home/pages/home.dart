import 'package:ecommerce_app/models/portfolio_item.dart';
import 'package:ecommerce_app/models/trade_data.dart';
import 'package:ecommerce_app/models/withdraw_modal.dart';
import 'package:ecommerce_app/presentation/home/widgets/limited_deposit_history_preview.dart';
import 'package:ecommerce_app/presentation/home/widgets/live_portfolio_card.dart';
import 'package:ecommerce_app/presentation/home/widgets/news_widget.dart';
import 'package:ecommerce_app/presentation/wallet/pages/unified_activity_screen.dart';
import 'package:ecommerce_app/screen/activity_screen.dart';
import 'package:ecommerce_app/screen/market_data_screen.dart';
import 'package:ecommerce_app/screen/portfolio_screen.dart';
import 'package:ecommerce_app/screen/prices_screen.dart';
import 'package:ecommerce_app/services/binance_portfolio_service.dart';
import 'package:ecommerce_app/services/binance_service.dart';
import 'package:ecommerce_app/widgets/activity_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_app/presentation/auth/pages/settings_modal.dart';
import 'package:ecommerce_app/presentation/auth/pages/signin.dart';
import 'package:ecommerce_app/presentation/auth/pages/trade_screen.dart';
import 'package:ecommerce_app/presentation/home/widgets/market_trends.dart';
import 'package:ecommerce_app/presentation/home/widgets/watchlist.dart';
import 'package:ecommerce_app/presentation/home/widgets/deposit_sheet.dart';
import 'package:ecommerce_app/presentation/home/widgets/send_sheet.dart';
import 'package:ecommerce_app/services/crypto_service.dart';
import 'package:ecommerce_app/core/configs/theme/app_colors.dart';
import 'package:ecommerce_app/presentation/home/widgets/candlestick_chart.dart';
import 'package:ecommerce_app/data/auth/repository/portfolio_repository.dart';

class HomePage extends StatefulWidget {
  final String? firstname;

  const HomePage({super.key, this.firstname});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PortfolioItem? selectedAsset;
  List<PortfolioItem> portfolioItems = [];
  bool isLoading = false;
  final BinanceService _chartService = BinanceService();
  final BinancePortfolioService _binance = BinancePortfolioService();
  final PortfolioRepository _repository = PortfolioRepository();

  List<TradeData> chartData = [];
  String selectedCoin = 'bitcoin';
  int selectedDays = 1;

  String _balance = '0.00';
  int _selectedIndex = 0;

  String getInterval(int days) {
    if (days == 1) return '1h';
    if (days == 7) return '4h';
    if (days == 30) return '1d';
    return '1d'; // fallback
  }

  DateTime? _lastMarketFetch;
  String? _marketData;
  List<TradeData> btcData = [];

  double _changePercent = 0.0;

  @override
  void initState() {
    super.initState();
    _loadPortfolioBalance();
    _loadChangePercent();
    _loadMarketData();
    _loadChartData();

    btcData = [
      TradeData(
        DateTime(2025, 10, 22, 10, 0),
        37000,
        37500,
        36800,
        37400,
        1200,
      ),
      TradeData(DateTime(2025, 10, 22, 11, 0), 37400, 37600, 37200, 37550, 980),
      TradeData(
        DateTime(2025, 10, 22, 12, 0),
        37550,
        37800,
        37400,
        37700,
        1500,
      ),
    ];
  }

  Future<void> _refreshData() async {
    setState(() => isLoading = true);
    await Future.wait([_loadPortfolioBalance(), _loadChangePercent()]);
    setState(() => isLoading = false);
  }

  Future<void> _loadPortfolioBalance() async {
    try {
      final items = await _loadPortfolio();
      final total = items.fold(0.0, (sum, item) => sum + item.value);

      if (!mounted) return; // ✅ Prevent crash
      setState(() {
        portfolioItems = items;
        _balance = total.toStringAsFixed(2);
        selectedAsset = items.isNotEmpty ? items.first : null;
      });
    } catch (e) {
      print('Error loading portfolio balance: $e');
      if (!mounted) return; // ✅ Prevent crash in catch block too
      setState(() {
        portfolioItems = [];
        _balance = '0.00';
        selectedAsset = null;
      });
    }
  }

  Future<void> _loadChangePercent() async {
    final change = await _binance.fetch24hChange();
    if (!mounted) return; // ✅ Prevent crash if widget is disposed
    setState(() {
      _changePercent = change ?? 0.0;
    });
  }

  Future<List<PortfolioItem>> _loadPortfolio() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    final holdings = await _repository.fetchUserHoldings(userId);
    final prices = await _binance.fetchCurrentPrices(
      holdings.map((h) => h.symbol).toList(),
    );

    final total = holdings.fold(0.0, (sum, h) {
      final price = prices[h.symbol] ?? 0.0;
      return sum + h.amount * price;
    });

    return holdings.map((h) {
      final price = prices[h.symbol] ?? 0.0;
      final value = h.amount * price;
      final percent = total > 0 ? (value / total) * 100 : 0.0;

      return PortfolioItem(
        name: h.symbol.toUpperCase(),
        symbol: h.symbol.toUpperCase(),
        amount: h.amount,
        value: value,
        percent: percent,
        logoUrl: '', // ✅ Add this line
      );
    }).toList();
  }

  Future<void> _loadMarketData() async {
    if (_lastMarketFetch != null &&
        DateTime.now().difference(_lastMarketFetch!) <
            const Duration(seconds: 10)) {
      return;
    }

    _lastMarketFetch = DateTime.now();

    try {
      final data = await CryptoService().fetchMarketData();
      setState(() {
        _marketData = data;
      });
    } catch (e) {
      print('Failed to load market data: $e');
    }
  }

  Future<void> _loadChartData() async {
    try {
      final interval = getInterval(selectedDays);
      final data = await _chartService.fetchOHLCV(selectedCoin, interval, 100);

      debugPrint('Fetched ${data.length} candles for $selectedCoin');

      if (data.isNotEmpty) {
        debugPrint(
          'First candle: open=${data.first.open}, close=${data.first.close}',
        );
        debugPrint(
          'Last candle: open=${data.last.open}, close=${data.last.close}',
        );

        final changePercent = await _chartService.fetchDynamicChange(
          selectedCoin,
        );
        debugPrint(
          'Dynamic 24h change for $selectedCoin: ${changePercent?.toStringAsFixed(2)}%',
        );

        if (!mounted) return;
        setState(() {
          chartData = data;
          _changePercent = changePercent ?? 0.0;
        });
      } else {
        debugPrint('No OHLCV data returned for $selectedCoin');
        if (!mounted) return;
        setState(() => chartData = []);
      }
    } catch (e) {
      debugPrint('Chart load error for $selectedCoin: $e');
      if (!mounted) return;
      setState(() => chartData = []);
    }
  }

  String formatBalance(dynamic rawBalance) {
    final cleaned = rawBalance.toString().replaceAll(',', '');
    final parsed = double.tryParse(cleaned) ?? 0.0;
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    ).format(parsed);
  }

  void _openWithdrawSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => WithdrawModal(
        balance: double.tryParse(_balance) ?? 0.0,
        onWithdrawConfirmed: (amount, bankDetails) {
          print(
            'Withdraw $amount to ${bankDetails['bankName']} - ${bankDetails['accountNumber']}',
          );
        },
      ),
    );
  }

  void _openDepositSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => const DepositSheet(),
    );

    if (result == 'success') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ActivityScreen()),
      );
    }
  }

  void _openSendSheet(PortfolioItem asset) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      }
      return;
    }

    final result = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => SendSheet(
        asset: selectedAsset!,
        assets: portfolioItems,
        userId: userId,
      ),
    );

    if (result == 'success' && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ActivityScreen()),
      );
    }
  }

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PortfolioScreen()),
      );
    } else if (index == 2 && userId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UnifiedActivityScreen(userId: userId),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TradeScreen()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PricesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dashboardBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.card,
              child: Icon(Icons.person, color: AppColors.text),
            ),
            const SizedBox(width: 12),
            Text(
              'Hi, ${widget.firstname ?? 'Guest'} 👋',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_balance_wallet,
              color: AppColors.text,
            ),
            tooltip: 'Deposit',
            onPressed: _openDepositSheet,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.text),
            onSelected: (value) async {
              if (value == 'settings') {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => SettingsModal(
                    name: widget.firstname ?? 'Guest',
                    email:
                        FirebaseAuth.instance.currentUser?.email ??
                        'user@example.com',
                    walletId: '0xABC123DEF456',
                    userStatus: 'Not verified',
                    appVersion: '1.0.0',
                  ),
                );
              } else if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SigninPage()),
                  (route) => false,
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'settings', child: Text('Account Settings')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  RepaintBoundary(
                    child: LivePortfolioCard(
                      onDeposit: _openDepositSheet,
                      onWithdraw: _openWithdrawSheet,
                      onSend: _openSendSheet,
                    ),
                  ),

                const SizedBox(height: 24),

                if (chartData.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '24h Change: ${_changePercent.toStringAsFixed(2)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                if (chartData.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'No chart data available',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  )
                else
                  RepaintBoundary(
                    child: CandlestickChart(
                      data: chartData,
                      asset: '${selectedCoin.toUpperCase()}/USDT',
                      selectedCoin: selectedCoin,
                      selectedDays: selectedDays,
                      onCoinChange: (coin) {
                        setState(() => selectedCoin = coin);
                        _loadChartData();
                      },
                      onDaysChange: (days) {
                        setState(() => selectedDays = days);
                        _loadChartData();
                      },
                    ),
                  ),

                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () {
                    if (_marketData != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MarketDataScreen(marketData: _marketData!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Market data not loaded yet'),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '📈 Market Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const RepaintBoundary(child: ActivityWidget()),
                const SizedBox(height: 24),
                const Text(
                  'Deposit Status',
                  style: TextStyle(color: Colors.white),
                ),
                const RepaintBoundary(child: LimitedDepositHistoryPreview()),
                const SizedBox(height: 24),
                const RepaintBoundary(child: MarketTrends()),
                const SizedBox(height: 24),
                const RepaintBoundary(child: Watchlist()),
                const SizedBox(height: 24),
                const RepaintBoundary(child: NewsWidget()),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF14194B), Color(0xFF010206)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(77), // 0.3 * 255 ≈ 77
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF00FFB0),
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Portfolio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz),
              label: 'Trade',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: 'Prices',
            ),
          ],
        ),
      ),
    );
  }
}
