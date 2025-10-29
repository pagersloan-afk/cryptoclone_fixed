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
          // 🔄 Animated Lottie background inside adjustable container
          Container(
            width: double.infinity,
            height: 400, // Adjust height as needed
            padding: const EdgeInsets.only(top: 20),
            alignment: Alignment.topCenter,
            child: Lottie.asset(
              'assets/animations/blockchain.json', // Replace with your Lottie file
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
            ),
          ),

          // 🧠 Main content layered on top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureHighlights() {
    return SizedBox(
      height: 150,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _featureCard('💸 Instant Transfers', 'Send money in seconds'),
          _featureCard(
            '🔐 Secure Wallet',
            'Your assets, encrypted and insured',
          ),
          _featureCard(
            '📈 Smart Trading',
            'AI-powered insights for better decisions',
          ),
          _featureCard('🌍 Global Access', 'Trade and transact across borders'),
        ],
      ),
    );
  }

  Widget _featureCard(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
          ),
        ],
      ),
    );
  }

  Widget _buildCTAButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/signup'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00FFB0),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Create Account',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pushNamed(context, '/signin'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text('Sign in', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
