import 'package:flutter/material.dart';
import 'bank_setup_screen.dart'; // ✅ Adjust path if needed

class AccountScreen extends StatelessWidget {
  final String userId;
  final String stripeAccountId;

  const AccountScreen({
    required this.userId,
    required this.stripeAccountId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Manage your payout settings and bank account.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BankSetupScreen(
                      userId: userId,
                      connectedStripeAccountId: stripeAccountId,
                    ),
                  ),
                );
              },
              child: Text('Link Bank Account'),
            ),
          ],
        ),
      ),
    );
  }
}
