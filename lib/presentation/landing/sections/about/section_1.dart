import 'package:flutter/material.dart';

// ⚫ Hero Marquee
class HeroMarqueeSection extends StatelessWidget {
  const HeroMarqueeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      height: isMobile ? 220 : 400,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/about-hero-lg.jpg", fit: BoxFit.cover),
          Align(
            alignment: isMobile ? Alignment.bottomCenter : Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.all(isMobile ? 12 : 16),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 8 : 12,
              ),
              decoration: BoxDecoration(
                color: isMobile
                    ? Colors.transparent
                    : Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Putting people and communities first",
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 15 : 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🟣 Three-Card Section
class ThreeCardSection extends StatelessWidget {
  const ThreeCardSection({super.key});

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
          InfoCard(
            imagePath: "assets/icons/card-investor-relations.png",
            title: "Investor Relations",
            description:
                "Providing investors with information about our financial performance.",
            linkText: "Learn more",
            linkRoute: "/about/investor-relations",
          ),
          InfoCard(
            imagePath: "assets/icons/card-leadership.png",
            title: "Leadership and Governance",
            description:
                "Earning trust by doing the right thing for our customers, communities, and employees.",
            linkText: "Learn more",
            linkRoute: "/about/governance",
          ),
          InfoCard(
            imagePath: "assets/icons/card-accessibility.png",
            title: "Inclusion and Accessibility",
            description:
                "Championing inclusion and accessibility in every aspect of our business.",
            linkText: "Learn more",
            linkRoute: "/about/accessibility",
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String linkText;
  final String linkRoute;

  const InfoCard({
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
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, linkRoute);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC20000),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 8 : 10,
              ),
            ),
            child: Text(
              linkText,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🟡 Career Promo
class CareerPromoSection extends StatelessWidget {
  const CareerPromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: const Color(0xFFF0F0F0),
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: isMobile
          ? Column(
              children: [
                Image.asset(
                  "assets/icons/career-promo.png",
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                _promoContent(context, isMobile),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Image.asset(
                    "assets/icons/career-promo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(flex: 1, child: _promoContent(context, isMobile)),
              ],
            ),
    );
  }

  Widget _promoContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          "Imagine a rewarding career with great work-life balance",
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 18 : 22,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Wherever you may be on your journey, discover your sweet spot at IGEG.",
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isMobile ? 13 : 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/about/careers');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC20000),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 24,
              vertical: isMobile ? 10 : 12,
            ),
          ),
          child: const Text(
            "Join us",
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
