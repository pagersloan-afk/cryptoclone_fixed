import 'package:flutter/material.dart';

class PromoSection extends StatelessWidget {
  const PromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxWidth: 1400,
        ), // ✅ same width as nav
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 24 : 40,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFF9F9F9), // ✅ light background band
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _promoText(context, isMobile),
                  const SizedBox(height: 24),
                  _promoImage(isMobile),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: _promoText(context, isMobile)),
                  const SizedBox(width: 40),
                  Expanded(flex: 1, child: _promoImage(isMobile)),
                ],
              ),
      ),
    );
  }

  Widget _promoText(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Money works better here.",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 20 : 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Earn 30% interest upfront on a 90–365 days fixed deposit.",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isMobile ? 13 : 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Earn up to 17% monthly with daily earnings and the ability to withdraw anytime.",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isMobile ? 13 : 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/mutual-funds');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB31B1B),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 24,
              vertical: isMobile ? 10 : 12,
            ),
          ),
          child: Text(
            "Get started",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 14 : 16,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 30),
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nerdwallet\nBest Robo-advisor, Portfolio Options, 2023\nBest Robo-advisor, IRA, 2025",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Bankrate\nBest Cash Management Account, 2023–25\nBest Investing App, 2025",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Nerdwallet\nBest Robo-advisor, Portfolio Options, 2023\nBest Robo-advisor, IRA, 2025",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      "Bankrate\nBest Cash Management Account, 2023–25\nBest Investing App, 2025",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _promoImage(bool isMobile) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/financial-app-promo.webp",
        fit: BoxFit.contain,
        height: isMobile ? 240 : 400,
      ),
    );
  }
}
