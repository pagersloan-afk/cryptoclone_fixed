import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BankSetupStatusScreen extends StatefulWidget {
  final String userId;

  const BankSetupStatusScreen({required this.userId, super.key});

  @override
  State<BankSetupStatusScreen> createState() => _BankSetupStatusScreenState();
}

class _BankSetupStatusScreenState extends State<BankSetupStatusScreen> {
  bool dialogShown = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .snapshots()
        .listen((doc) {
          if (doc.exists && doc['bankSetupComplete'] == true && !dialogShown) {
            dialogShown = true;
            showBankSetupSuccessDialog();
          }
        });
  }

  void showBankSetupSuccessDialog() {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('✅ Bank Setup Complete'),
        content: Text(
          'Your payout account is verified and ready to receive funds.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Awesome'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bank Setup')),
      body: Center(child: Text('Waiting for bank setup confirmation...')),
    );
  }
}
