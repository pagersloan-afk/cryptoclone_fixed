import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class TradeScreen extends StatefulWidget {
  const TradeScreen({super.key});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'BTC';
  String _toCurrency = 'ETH';
  double _rate = 0.0;
  bool _loading = false;
  DateTime? _lastUpdated;

  final Map<String, String> coinIds = {
    'BTC': 'bitcoin',
    'ETH': 'ethereum',
    'SOL': 'solana',
    'MATIC': 'polygon',
    'USDT': 'tether',
  };

  final List<String> _currencies = ['BTC', 'ETH', 'SOL', 'MATIC', 'USDT'];

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
    _fetchRate();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _fetchRate() async {
    setState(() => _loading = true);

    final fromId = coinIds[_fromCurrency]!;
    final toId = coinIds[_toCurrency]!;

    final url = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=$fromId,$toId&vs_currencies=usd',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final fromUsd = data[fromId]?['usd'];
      final toUsd = data[toId]?['usd'];

      if (fromUsd != null && toUsd != null && fromUsd > 0) {
        final newRate = toUsd / fromUsd;
        setState(() {
          _rate = newRate;
          _lastUpdated = DateTime.now();
          _loading = false;
        });

        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('cached_rates')
              .doc('$_fromCurrency-$_toCurrency')
              .set({
                'rate': newRate,
                'timestamp': FieldValue.serverTimestamp(),
              });
        }
        return;
      }
    }

    setState(() {
      _rate = 0.0;
      _loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to fetch exchange rate')),
    );
  }

  void _showSuccessAnimation() async {
    HapticFeedback.mediumImpact(); // ✅ Haptic feedback

    final player = AudioPlayer();
    await player.play(AssetSource('sounds/success.mp3')); // ✅ Play sound

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/success.json',
              repeat: false,
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 12),
            const Text(
              'Send completed successfully!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Send confirmed'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmation() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final received = amount * _rate;
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1E33),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm Exchange',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              'Exchange $amount $_fromCurrency for ${received.toStringAsFixed(4)} $_toCurrency?',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await saveExchange(
                      userId: userId,
                      from: _fromCurrency,
                      to: _toCurrency,
                      amount: amount,
                      received: received,
                      rate: _rate,
                    );
                    _showSuccessAnimation();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exchange completed')),
                    );
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final usdValue = amount * _rate;
    final formattedUsd = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    ).format(usdValue);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0E1C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Trade'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCurrencyCard('From', _fromCurrency, (String? val) {
                if (val != null) {
                  setState(() => _fromCurrency = val);
                  _fetchRate();
                }
              }),
              const SizedBox(height: 12),
              _buildCurrencyCard('To', _toCurrency, (String? val) {
                if (val != null) {
                  setState(() => _toCurrency = val);
                  _fetchRate();
                }
              }),
              const SizedBox(height: 20),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_loading)
                Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[500]!,
                  child: Container(height: 20, width: 200, color: Colors.white),
                )
              else ...[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Text(
                    '1 $_fromCurrency ≈ ${_rate.toStringAsFixed(4)} $_toCurrency',
                    key: ValueKey(_rate),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 8),
                if (_amountController.text.isNotEmpty && _rate > 0)
                  Text(
                    '≈ $formattedUsd USD',
                    style: const TextStyle(color: Colors.white54),
                  ),
                if (_lastUpdated != null)
                  Text(
                    'Last updated: ${DateFormat.yMd().add_jm().format(_lastUpdated!)}',
                    style: const TextStyle(color: Colors.white38),
                  ),
              ],
              const SizedBox(height: 40), // ✅ Replaces Spacer
              Center(
                child: ElevatedButton(
                  onPressed: _showConfirmation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Exchange'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyCard(
    String label,
    String selected,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          DropdownButton<String>(
            value: selected,
            dropdownColor: const Color(0xFF1D1E33),
            style: const TextStyle(color: Colors.white),
            underline: const SizedBox(),
            iconEnabledColor: Colors.white,
            items: _currencies.map((currency) {
              return DropdownMenuItem(
                value: currency,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/${currency.toLowerCase()}.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(currency, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Future<void> saveExchange({
    required String userId,
    required String from,
    required String to,
    required double amount,
    required double received,
    required double rate,
  }) async {
    await FirebaseFirestore.instance.collection('exchange_history').add({
      'userId': userId,
      'from': from,
      'to': to,
      'amount': amount,
      'received': received,
      'rate': rate,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
