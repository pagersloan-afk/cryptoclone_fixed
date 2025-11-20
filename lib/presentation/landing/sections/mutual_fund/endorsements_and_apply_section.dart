import 'package:ecommerce_app/presentation/landing/screen/mutual_fund_application.dart';
import 'package:flutter/material.dart';

/// 🏆 Trust Badges (Endorsements)
class EndorsementsSection extends StatelessWidget {
  const EndorsementsSection({super.key});

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 600;
          return isNarrow
              ? Column(
                  children: const [
                    _EndorsementSource(
                      title: "Nerdwallet",
                      items: [
                        "Best Robo-advisor, Portfolio Options, 2023",
                        "Best Robo-advisor, IRA, 2025",
                      ],
                    ),
                    SizedBox(height: 24),
                    _EndorsementSource(
                      title: "Bankrate",
                      items: [
                        "Best Cash Management Account, 2023–25",
                        "Best Investing App, 2025",
                      ],
                    ),
                  ],
                )
              : Wrap(
                  spacing: 40,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: const [
                    _EndorsementSource(
                      title: "Nerdwallet",
                      items: [
                        "Best Robo-advisor, Portfolio Options, 2023",
                        "Best Robo-advisor, IRA, 2025",
                      ],
                    ),
                    _EndorsementSource(
                      title: "Bankrate",
                      items: [
                        "Best Cash Management Account, 2023–25",
                        "Best Investing App, 2025",
                      ],
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class _EndorsementSource extends StatelessWidget {
  final String title;
  final List<String> items;

  const _EndorsementSource({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: isMobile ? double.infinity : 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 16 : 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      "• $item",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isMobile ? 13 : 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// 📝 Application CTA
class ApplySection extends StatelessWidget {
  const ApplySection({super.key});

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
      color: const Color(0xFFF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Ready to Invest?",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 20 : 24,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Take the first step toward financial freedom. Choose your fund and submit your application securely online.",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 14 : 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // ✅ Navigate to MutualFundForm
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const MutualFundForm()));
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
              "Start Application",
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
