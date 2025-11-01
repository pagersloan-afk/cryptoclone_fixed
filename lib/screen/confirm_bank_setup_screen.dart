import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConfirmBankSetupButton extends StatelessWidget {
  final String userId;
  final String accountId;

  const ConfirmBankSetupButton({
    super.key,
    required this.userId,
    required this.accountId,
  });

  Future<void> _confirmBankSetup(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/confirm-bank-setup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'accountId': accountId}),
      );

      if (response.statusCode == 200) {
        // ✅ Success — show confirmation
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Bank Linked'),
            content: Text('Your bank account has been successfully linked.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // 🔁 Server responded but failed
        _showUpgradeDialog(context);
      }
    } catch (e) {
      // 🔥 Network error (e.g. SocketException)
      _showUpgradeDialog(context);
    }
  }

  void _showUpgradeDialog(BuildContext context) {
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
    return ElevatedButton(
      onPressed: () => _confirmBankSetup(context),
      child: Text('Confirm Bank Setup'),
    );
  }
}
