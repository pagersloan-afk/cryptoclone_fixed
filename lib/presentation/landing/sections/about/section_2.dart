import 'package:flutter/material.dart';

// 🔵 Additional Cards Section
class AdditionalCardsSection extends StatelessWidget {
  const AdditionalCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Wrap(
        spacing: isMobile ? 12 : 20,
        runSpacing: isMobile ? 16 : 20,
        alignment: WrapAlignment.center,
        children: [
          AdditionalCard(
            imagePath: "assets/icons/responsibility-icon.png",
            title: "Responsibility and Impact",
            description:
                "Focusing on making a positive impact by supporting a sustainable and inclusive future.",
            linkText: "Learn more >",
            linkRoute: "/about/responsibility",
          ),
          AdditionalCard(
            imagePath: "assets/icons/news-icon.png",
            title: "News Releases",
            description:
                "Keeping you informed with the latest updates from IGEG.",
            linkText: "Learn more >",
            linkRoute: "/about/news",
          ),
          AdditionalCard(
            imagePath: "assets/icons/stories-icon.png",
            title: "IGEG Stories",
            description:
                "Expert tips, real stories, and customer spotlights to empower communities and spark ideas.",
            linkText: "Get inspired >",
            linkRoute: "/about/stories",
          ),
        ],
      ),
    );
  }
}

// 🟣 Individual Card Widget
class AdditionalCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String linkText;
  final String linkRoute;

  const AdditionalCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.linkText,
    required this.linkRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: isMobile ? double.infinity : 300,
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
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
            imagePath,
            height: isMobile ? 48 : 64,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 14 : 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 12 : 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, linkRoute);
            },
            child: Text(
              linkText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: isMobile ? 12 : 14,
                color: const Color(0xFFC20000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🟠 History Section
class HistorySection extends StatelessWidget {
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "History in the Making",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 18 : 22,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "We’ve helped people go further with their money since our founding. With innovative solutions that evolve with the times, we continue to help our customers get ahead.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 13 : 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/about/history');
            },
            child: Text(
              "Explore our history",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: isMobile ? 12 : 14,
                color: const Color(0xFFC20000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ⚪ Footer
class PremiumFooter extends StatelessWidget {
  const PremiumFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final links = [
      {"label": "Privacy & Legal", "route": "/privacy"},
      {"label": "Do Not Sell or Share", "route": "/opt-out"},
      {"label": "Terms of Use", "route": "/terms"},
      {"label": "Report Fraud", "route": "/fraud"},
      {"label": "Sitemap", "route": "/sitemap"},
      {"label": "About IGEG", "route": "/about"},
      {"label": "Careers", "route": "/careers"},
      {"label": "Accessibility", "route": "/accessibility"},
    ];

    return Container(
      width: double.infinity,
      color: const Color(0xFF222222),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 20 : 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: isMobile ? 12 : 16,
            runSpacing: isMobile ? 8 : 12,
            alignment: WrapAlignment.center,
            children: links
                .map(
                  (link) => TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, link["route"]!);
                    },
                    child: Text(
                      link["label"]!,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isMobile ? 12 : 13,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Text(
            "© 2025 IGEG Vault. All rights reserved.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 11 : 12,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
