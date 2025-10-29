import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DepositSheet extends StatefulWidget {
  const DepositSheet({super.key});

  @override
  State<DepositSheet> createState() => _DepositSheetState();
}

class _DepositSheetState extends State<DepositSheet> {
  final TextEditingController _amountController = TextEditingController();
  final List<String> _networks = ['BTC', 'ETH', 'SOL', 'MATIC', 'USDT', 'XRP'];
  String _selectedNetwork = 'ETH';

  Map<String, String> walletAddresses = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWalletAddresses();
  }

  Future<void> _loadWalletAddresses() async {
    final doc = await FirebaseFirestore.instance
        .collection('SystemConfig')
        .doc('depositWallets')
        .get();

    setState(() {
      walletAddresses = Map<String, String>.from(doc.data() ?? {});
      isLoading = false;
    });
  }

  Future<void> _handleDeposit() async {
    final depositAmount = double.tryParse(_amountController.text) ?? 0.0;

    if (depositAmount < 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimum deposit is \$50 USD')),
      );
      return;
    }

    final wallet = walletAddresses[_selectedNetwork];
    if (wallet == null || wallet.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No wallet address configured for $_selectedNetwork'),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('deposits').add({
      'amount': depositAmount,
      'network': _selectedNetwork,
      'walletAddress': wallet,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance.collection('Transactions').add({
      'type': 'deposit',
      'label': 'Deposit via $_selectedNetwork',
      'date': DateTime.now().toString(),
      'amount': '+\$${depositAmount.toStringAsFixed(2)}',
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context, 'success');
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final walletAddress = walletAddresses[_selectedNetwork] ?? 'Unavailable';
    final isValid = walletAddress != 'Unavailable' && walletAddress.length > 10;

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
              'Deposit Funds',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Send crypto to the wallet address below.\nMinimum deposit is \$50 USD.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedNetwork,
              dropdownColor: const Color(0xFF1D1E33),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Select Network',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _networks.map((network) {
                return DropdownMenuItem(value: network, child: Text(network));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedNetwork = val);
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter deposit amount (USD)',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isValid ? walletAddress : 'No wallet address available',
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Colors.white),
                    onPressed: () {
                      if (isValid) {
                        Clipboard.setData(ClipboardData(text: walletAddress));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Wallet address copied'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (isValid)
              QrImageView(
                data: walletAddress,
                version: QrVersions.auto,
                size: 120,
                backgroundColor: Colors.white,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleDeposit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Confirm Deposit'),
            ),
          ],
        ),
      ),
    );
  }
}
