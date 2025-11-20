import 'package:flutter/material.dart';

// 🧠 Strategy & Insights
class StrategyInsightsSection extends StatelessWidget {
  const StrategyInsightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final insights = [
      {
        "img": "assets/images/bridge-report.jpg",
        "title": "Investment Strategy update",
        "desc":
            "Weekly market insights and possible impacts on investors from IGEG LLC Investment Institute.",
        "button": "Get the report",
      },
      {
        "img": "assets/images/year-end.jpg",
        "title": "5 money moves before year’s end",
        "desc":
            "The end of the year is nearly here. Consider these steps before December 31.",
        "button": "Get started now",
      },
      {
        "img": "assets/images/retirement.jpg",
        "title": "Retirement strategies",
        "desc":
            "Whether you're close to retirement or years away, we can help you build a retirement plan to help meet your goals.",
        "button": "Retirement center",
      },
    ];

    return Container(
      color: const Color(0xFFF4F4F4),
      padding: EdgeInsets.all(isMobile ? 16 : 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 1 : 3,
          crossAxisSpacing: isMobile ? 12 : 20,
          mainAxisSpacing: isMobile ? 16 : 20,
          childAspectRatio: isMobile ? 0.9 : 0.85,
        ),
        itemCount: insights.length,
        itemBuilder: (context, index) {
          final card = insights[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.asset(
                    card["img"]!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  card["title"]!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  card["desc"]!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isMobile ? 12 : 13,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00704A),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, isMobile ? 36 : 40),
                  ),
                  child: Text(
                    card["button"]!,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 🧭 Benefits & Resources
class BenefitsResourcesSection extends StatelessWidget {
  const BenefitsResourcesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final benefits = [
      {
        "img": "assets/images/scam-protection.jpg",
        "title": "Scams are on the rise. Protect yourself.",
        "desc":
            "Recognize the tell-tale signs of scams so you won’t be the next victim.",
        "button": "See what to look for",
      },
      {
        "img": "assets/images/digital-assets.jpg",
        "title": "Understanding digital assets",
        "desc":
            "IGEG LLC Investment Institute provides an overview of what digital assets are and their importance to the digital future.",
        "button": "Learn more",
      },
    ];

    return Container(
      color: const Color(0xFFF4FDF8),
      padding: EdgeInsets.all(isMobile ? 16 : 40),
      child: Column(
        children: benefits.map((benefit) {
          return Container(
            margin: EdgeInsets.only(bottom: isMobile ? 20 : 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(benefit["img"]!, fit: BoxFit.cover),
                const SizedBox(height: 12),
                Text(
                  benefit["title"]!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  benefit["desc"]!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isMobile ? 12 : 13,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00704A),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, isMobile ? 36 : 40),
                  ),
                  child: Text(
                    benefit["button"]!,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// 🔸 Commercial Contact CTA
class CommercialContactCTA extends StatelessWidget {
  const CommercialContactCTA({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(isMobile ? 16 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Reach out to get started",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Let’s connect. We’re focused on providing tailored products and services to meet the unique banking needs of commercial businesses with annual revenues ranging from \$25 million to \$2 billion.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 13 : 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: isMobile ? double.infinity : null,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/contact');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A1B9A),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 32,
                  vertical: isMobile ? 12 : 16,
                ),
              ),
              child: const Text(
                "Contact us",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
