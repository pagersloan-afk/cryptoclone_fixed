import 'package:flutter/material.dart';

class MortgagePromoSection extends StatelessWidget {
  const MortgagePromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        color: const Color(0xFFF9F9F9), // ✅ light background
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 900;

            return isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _mortgageContent(context, isMobile),
                      const SizedBox(height: 24),
                      _mortgageImage(isMobile),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _mortgageContent(context, isMobile),
                      ),
                      const SizedBox(width: 40),
                      Expanded(flex: 1, child: _mortgageImage(isMobile)),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget _mortgageContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "A home of your own",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 20 : 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "With low down payment options on a fixed-rate mortgage",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isMobile ? 14 : 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home-loans');
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
      ],
    );
  }

  Widget _mortgageImage(bool isMobile) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/mortgage-banner.jpg",
        fit: BoxFit.cover,
        height: isMobile ? 200 : 300,
      ),
    );
  }
}

// 🟢 Mobile App Promo Section
class MobileAppPromoSection extends StatelessWidget {
  const MobileAppPromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        color: Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 900;

            return isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _mobileContent(context, isMobile),
                      const SizedBox(height: 24),
                      _mobileImage(isMobile),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _mobileContent(context, isMobile),
                      ),
                      const SizedBox(width: 40),
                      Expanded(flex: 1, child: _mobileImage(isMobile)),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget _mobileContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bank on the go",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 20 : 24,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Download our app to manage your accounts, track spending, and more.",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isMobile ? 14 : 16,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: () {
                // Use url_launcher for external APK link
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB31B1B),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 20,
                  vertical: isMobile ? 10 : 12,
                ),
              ),
              child: Text(
                "Download for Android",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: null, // disabled for now
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade400,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 20,
                  vertical: isMobile ? 10 : 12,
                ),
              ),
              child: Text(
                "Coming Soon on iOS",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 14 : 16,
                  color: const Color.fromARGB(255, 94, 91, 91),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _mobileImage(bool isMobile) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/igeg_app_ui2.png",
        fit: BoxFit.contain,
        height: isMobile ? 220 : 300,
      ),
    );
  }
}
