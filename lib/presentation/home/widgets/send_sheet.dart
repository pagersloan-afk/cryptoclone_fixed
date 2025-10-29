import 'package:audioplayers/audioplayers.dart';
import 'package:ecommerce_app/models/portfolio_item.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SendSheet extends StatefulWidget {
  final PortfolioItem asset;
  final List<PortfolioItem> assets;
  final String userId;

  const SendSheet({
    required this.asset,
    required this.assets,
    required this.userId,
    super.key,
  });

  @override
  State<SendSheet> createState() => _SendSheetState();
}

class _SendSheetState extends State<SendSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();

  final List<String> supportedAssets = [
    'BTC',
    'ETH',
    'SOL',
    'MATIC',
    'USDT',
    'XRP',
    'USDC',
  ];
  late PortfolioItem selectedAsset;

  final String accountName = 'igegllc.com Account';
  final String assetLogoUrl =
      'https://assets.coingecko.com/coins/images/6319/small/USD_Coin_icon.png';

  double? availableBalance;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedAsset = widget.asset;
    isLoading = false; // ✅ Spinner fix
  }

  Future<void> _handleSend() async {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final recipient = _recipientController.text.trim();
    final String assetSymbol = selectedAsset.symbol.toLowerCase();
    final double availableUsd = selectedAsset.value;
    final double currentCoinAmount = selectedAsset.amount;

    if (amount <= 0 || recipient.isEmpty || amount > availableUsd) {
      HapticFeedback.mediumImpact();
      _showCenteredError('Enter a valid amount and recipient');
      return;
    }

    setState(() => isLoading = true);

    try {
      // ✅ Use value from selectedAsset instead of Firestore price
      final price = availableUsd / currentCoinAmount;
      final coinToDeduct = amount / price;

      if (coinToDeduct > currentCoinAmount) {
        HapticFeedback.mediumImpact();
        _showCenteredError(
          'Insufficient ${selectedAsset.symbol.toUpperCase()} balance',
        );
        setState(() => isLoading = false);
        return;
      }

      // ✅ Update Firestore holding
      final holdingRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('holdings')
          .doc(assetSymbol);

      await holdingRef.update({'amount': currentCoinAmount - coinToDeduct});

      // 🧾 Log transaction
      await FirebaseFirestore.instance.collection('transactions').add({
        'userId': widget.userId,
        'type': 'send',
        'amount': amount,
        'recipient': recipient,
        'symbol': assetSymbol,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance.collection('Transactions').add({
        'userId': widget.userId,
        'type': 'send',
        'label': 'Sent ${selectedAsset.symbol.toUpperCase()} to $recipient',
        'date': DateTime.now().toString(),
        'amount': '-\$${amount.toStringAsFixed(2)}',
        'symbol': assetSymbol,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _amountController.clear();
      _recipientController.clear();
      _showSuccessDialog(amount, recipient);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Transaction failed')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSuccessDialog(double amount, String recipient) async {
    HapticFeedback.mediumImpact();

    final player = AudioPlayer();
    await player.play(AssetSource('sounds/success.mp3'));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1D1E33),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/success.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Send Completed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You sent \$${amount.toStringAsFixed(2)} to $recipient',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext); // Close dialog
                    Navigator.pop(context); // Close sheet
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
      },
    );
  }

  void _showCenteredError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double coinAmount = selectedAsset.amount;
    final double usdValue = selectedAsset.value;
    final String symbol = selectedAsset.symbol.toUpperCase();

    final formattedCoin = NumberFormat("#,##0.0000").format(coinAmount);
    final formattedUsd = NumberFormat("#,##0.00").format(usdValue);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1D1E33),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Send Funds',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter recipient wallet address and amount to send.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // 🔽 Asset selection dropdown
            DropdownButton<PortfolioItem>(
              value: selectedAsset,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: const Color(0xFF1D1E33),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              onChanged: (PortfolioItem? newAsset) {
                if (newAsset != null) {
                  setState(() => selectedAsset = newAsset);
                }
              },
              items: widget.assets.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    '${item.symbol} — \$${item.value.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // ✅ Asset Display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(assetLogoUrl),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$accountName — $symbol',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Available: $formattedCoin $symbol ≈ USD \$${formattedUsd}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Recipient Field
            TextField(
              controller: _recipientController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Recipient wallet address',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white54,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ✅ Amount Field
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Amount (USD)',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Confirm Button
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _handleSend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Confirm Send'),
                  ),
          ],
        ),
      ),
    );
  }
}
