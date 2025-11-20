import 'package:ecommerce_app/presentation/landing/screen/mutual_fund_application.dart';
import 'package:flutter/material.dart';

class MutualFundsHeroBanner extends StatelessWidget {
  const MutualFundsHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 40 : 80,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/mutual-fund-hero.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            // Headline
            Text(
              "Grow Your Wealth with IGEG Mutual Funds",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 22 : 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
            ),
            const SizedBox(height: 16),

            // Subtext
            Text(
              "Smart, secure, and personalized investment options designed to help you reach your financial goals.",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 14 : 18,
                color: Colors.white70,
              ),
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
            ),
            const SizedBox(height: 24),

            // CTA Button
            Align(
              alignment: isMobile ? Alignment.center : Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MutualFundForm()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB31B1B), // brand red
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 24,
                    vertical: isMobile ? 10 : 12,
                  ),
                ),
                child: const Text("Explore Funds"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
