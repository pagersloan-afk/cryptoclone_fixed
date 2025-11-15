import 'package:flutter/material.dart';
import 'package:ecommerce_app/screen/ibm_kuberneteslink_screen.dart';
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
      backgroundColor: const Color(0xFF0D0E1C),
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 700;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 600 : double.infinity,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Manage your payout settings and bank account.',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.account_balance),
                      label: const Text('Link Bank Account'),
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
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.cloud),
                      label: const Text('Link IBM Kubernetes'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const IBMKubernetesLinkScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
