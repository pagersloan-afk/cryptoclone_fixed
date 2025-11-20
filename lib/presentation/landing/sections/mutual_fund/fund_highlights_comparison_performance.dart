import 'package:ecommerce_app/presentation/landing/screen/mutual_fund_application.dart';
import 'package:flutter/material.dart';

/// 🔹 Fund Highlights
class FundHighlightsSection extends StatelessWidget {
  const FundHighlightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 16 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Why Choose IGEG Mutual Funds?",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 20 : 24,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;
              return isNarrow
                  ? Column(
                      children: const [
                        _HighlightCard(
                          iconPath: "assets/icons/management.png",
                          title: "Professional Management",
                          description:
                              "Expert fund managers actively optimize your portfolio for performance and risk control.",
                        ),
                        SizedBox(height: 24),
                        _HighlightCard(
                          iconPath: "assets/icons/diversification.png",
                          title: "Diversified Portfolios",
                          description:
                              "Access a mix of bonds, equities, and fixed-income assets for balanced, long-term growth.",
                        ),
                        SizedBox(height: 24),
                        _HighlightCard(
                          iconPath: "assets/icons/flexibility.png",
                          title: "Flexible Access",
                          description:
                              "Choose fixed or flexible withdrawal options to match your financial goals.",
                        ),
                        SizedBox(height: 24),
                        _HighlightCard(
                          iconPath: "assets/icons/low-entry.png",
                          title: "Low Entry Barrier",
                          description:
                              "Start investing with as little as ₦500,000 and enjoy premium returns.",
                        ),
                      ],
                    )
                  : Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: const [
                        _HighlightCard(
                          iconPath: "assets/icons/management.png",
                          title: "Professional Management",
                          description:
                              "Expert fund managers actively optimize your portfolio for performance and risk control.",
                        ),
                        _HighlightCard(
                          iconPath: "assets/icons/diversification.png",
                          title: "Diversified Portfolios",
                          description:
                              "Access a mix of bonds, equities, and fixed-income assets for balanced, long-term growth.",
                        ),
                        _HighlightCard(
                          iconPath: "assets/icons/flexibility.png",
                          title: "Flexible Access",
                          description:
                              "Choose fixed or flexible withdrawal options to match your financial goals.",
                        ),
                        _HighlightCard(
                          iconPath: "assets/icons/low-entry.png",
                          title: "Low Entry Barrier",
                          description:
                              "Start investing with as little as ₦500,000 and enjoy premium returns.",
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;

  const _HighlightCard({
    required this.iconPath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return SizedBox(
      width: isMobile ? double.infinity : 280,
      child: Column(
        children: [
          Image.asset(iconPath, height: isMobile ? 48 : 64),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 16 : 18,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 13 : 14,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 🔹 Fund Comparison
class FundComparisonSection extends StatelessWidget {
  const FundComparisonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      key: const Key("funds"),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 16 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Compare Our Flagship Funds",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 20 : 24,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;
              return isNarrow
                  ? Column(
                      children: const [
                        _FundCard(
                          title: "IGEG-LOCK",
                          description:
                              "30% interest upfront on a 90–365 day fixed deposit.",
                          features: [
                            "Capital locked for term duration",
                            "Ideal for long-term savers",
                            "Guaranteed returns",
                          ],
                          ctaText: "Apply for IGEG-LOCK",
                          ctaLink: "/mutual-fund-application.html?fund=lock",
                        ),
                        SizedBox(height: 24),
                        _FundCard(
                          title: "IGEG-SAVE",
                          description:
                              "Up to 17% monthly with daily compounding and flexible withdrawals.",
                          features: [
                            "Withdraw anytime",
                            "Best for short-term goals",
                            "Daily earnings visibility",
                          ],
                          ctaText: "Apply for IGEG-SAVE",
                          ctaLink: "/mutual-fund-application.html?fund=save",
                        ),
                      ],
                    )
                  : Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: const [
                        _FundCard(
                          title: "IGEG-LOCK",
                          description:
                              "30% interest upfront on a 90–365 day fixed deposit.",
                          features: [
                            "Capital locked for term duration",
                            "Ideal for long-term savers",
                            "Guaranteed returns",
                          ],
                          ctaText: "Apply for IGEG-LOCK",
                          ctaLink: "/mutual-fund-application.html?fund=lock",
                        ),
                        _FundCard(
                          title: "IGEG-SAVE",
                          description:
                              "Up to 17% monthly with daily compounding and flexible withdrawals.",
                          features: [
                            "Withdraw anytime",
                            "Best for short-term goals",
                            "Daily earnings visibility",
                          ],
                          ctaText: "Apply for IGEG-SAVE",
                          ctaLink: "/mutual-fund-application.html?fund=save",
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }
}

class _FundCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> features;
  final String ctaText;
  final String ctaLink; // we’ll parse this to decide which fund to preselect

  const _FundCard({
    required this.title,
    required this.description,
    required this.features,
    required this.ctaText,
    required this.ctaLink,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: isMobile ? double.infinity : 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 18 : 20,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 13 : 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Features list
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features
                .map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            f,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: isMobile ? 13 : 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),

          // CTA Button
          ElevatedButton(
            onPressed: () {
              // ✅ Navigate to MutualFundForm with preselected fund
              String? preselectedFund;
              if (ctaLink.contains("lock")) {
                preselectedFund = "IGEG-LOCK";
              } else if (ctaLink.contains("save")) {
                preselectedFund = "IGEG-SAVE";
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      MutualFundForm(preselectedFund: preselectedFund),
                ),
              );
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
              ctaText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 📈 Performance Chart
class PerformanceSection extends StatelessWidget {
  const PerformanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 60,
        horizontal: isMobile ? 16 : 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Fund Performance Snapshot",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 20 : 24,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Chart image
          Image.asset(
            "assets/images/fund-performance-chart.png",
            height: isMobile ? 200 : 300,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),

          // Disclaimer text
          Text(
            "Historical returns are not guarantees of future performance. See full disclosures below.",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 12 : 14,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
