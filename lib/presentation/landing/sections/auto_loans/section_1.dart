import 'package:flutter/material.dart';

// 🔵 Hero Banner
class AutoLoansHeroBanner extends StatelessWidget {
  const AutoLoansHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      height: isMobile ? 220 : 500,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/auto-loans-hero.webp"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 32),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          constraints: BoxConstraints(maxWidth: isMobile ? 340 : 650),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Drive your dream car with IGEG Auto Loans",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 18 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Low rates. Fast approval. Flexible terms for new and used vehicles.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 13 : 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: isMobile ? double.infinity : null,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/apply');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB31B1B),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 32,
                      vertical: isMobile ? 10 : 14,
                    ),
                  ),
                  child: const Text(
                    "Apply Now",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🧭 Quick Start CTA
class QuickStartCTA extends StatelessWidget {
  const QuickStartCTA({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isMobile ? 32 : 64,
      ),
      child: Column(
        children: [
          Text(
            "Get Started with a Personalized Quote",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "It takes just a few minutes. No commitment. No credit impact.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 13 : 15,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              SizedBox(
                width: isMobile ? double.infinity : 160,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/apply');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB31B1B),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("New Vehicle"),
                ),
              ),
              SizedBox(
                width: isMobile ? double.infinity : 160,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/apply');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB31B1B),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Used Vehicle"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 🚗 Auto Loan Promo Cards
class AutoLoanPromoCards extends StatelessWidget {
  const AutoLoanPromoCards({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final cards = [
      {
        "icon": "assets/icons/car-search.png",
        "title": "Find your car",
        "desc": "Access exclusive tools to shop for new or used vehicles.",
        "route": "/tools/car-search",
        "link": "Start shopping >",
      },
      {
        "icon": "assets/icons/rate-check.png",
        "title": "Check your rate",
        "desc":
            "Get a personalized auto loan rate with no impact to your credit.",
        "route": "/apply",
        "link": "Check rates >",
      },
      {
        "icon": "assets/icons/loan-calculator.png",
        "title": "Estimate your payment",
        "desc": "Use our calculator to plan your monthly budget.",
        "route": "/auto-loans/calculator",
        "link": "Estimate now >",
      },
      {
        "icon": "assets/icons/apply-now.png",
        "title": "Ready to apply?",
        "desc": "Submit your auto loan application and get pre-approved today.",
        "route": "/apply",
        "link": "Apply now >",
      },
    ];

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          Text(
            "Auto financing made easy",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: isMobile ? 12 : 20,
            runSpacing: isMobile ? 16 : 20,
            alignment: WrapAlignment.center,
            children: cards.map((card) {
              return Container(
                width: isMobile ? double.infinity : 260,
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset(
                      card["icon"]!,
                      height: isMobile ? 48 : 64,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      card["title"]!,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFB31B1B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      card["desc"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isMobile ? 12 : 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, card["route"]!);
                      },
                      child: Text(
                        card["link"]!,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB31B1B),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
