import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'bank_setup_status_screen.dart'; // ✅ Adjust path if needed

class BankSetupScreen extends StatefulWidget {
  final String userId;
  final String connectedStripeAccountId;

  const BankSetupScreen({
    required this.userId,
    required this.connectedStripeAccountId,
    super.key,
  });

  @override
  State<BankSetupScreen> createState() => _BankSetupScreenState();
}

class _BankSetupScreenState extends State<BankSetupScreen> {
  bool isSubmitting = false;

  Future<void> submitBankSetup() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/confirm-bank-setup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': widget.userId,
          'accountId': widget.connectedStripeAccountId,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BankSetupStatusScreen(userId: widget.userId),
          ),
        );
      } else {
        _showUpgradeDialog();
      }
    } catch (e) {
      _showUpgradeDialog();
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Bank Setup Error'),
        content: Text(
          'Please upgrade your account to connect your bank payout.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Link Bank Account')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ready to link your bank account and enable payouts?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSubmitting ? null : submitBankSetup,
              child: isSubmitting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Confirm Bank Setup'),
            ),
          ],
        ),
      ),
    );
  }
}
