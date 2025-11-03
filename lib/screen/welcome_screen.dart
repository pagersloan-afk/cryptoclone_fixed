import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🔄 Animated Lottie background
          Container(
            width: double.infinity,
            height: 400,
            padding: const EdgeInsets.only(top: 20),
            alignment: Alignment.topCenter,
            child: Lottie.asset(
              'assets/animations/blockchain.json',
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
            ),
          ),

          // 🧠 Main content
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 48,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Ready to change the way you money?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildFeatureHighlights(),
                    const SizedBox(height: 32),
                    _buildCTAButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureHighlights() {
    return Column(
      children: [
        _featureCard('💸 Instant Transfers', 'Send money in seconds'),
        _featureCard('🔐 Secure Wallet', 'Your assets, encrypted and insured'),
        _featureCard(
          '📈 Smart Trading',
          'AI-powered insights for better decisions',
        ),
        _featureCard('🌍 Global Access', 'Trade and transact across borders'),
      ],
    );
  }

  Widget _featureCard(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCTAButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/signup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FFB0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Create Account',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, '/signin'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Sign in', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
