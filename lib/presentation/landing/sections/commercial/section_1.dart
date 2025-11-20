import 'package:flutter/material.dart';

// 🔵 Hero Banner
class CommercialHeroBanner extends StatelessWidget {
  const CommercialHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      // ✅ Let height expand naturally on mobile to avoid overflow
      height: isMobile ? null : 500,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/commercial-hero.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 16 : 40,
      ),
      alignment: isMobile ? Alignment.center : Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(maxWidth: isMobile ? 340 : 400),
        // ✅ Wrap content in SingleChildScrollView to prevent overflow
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              Text(
                "IGEG LLC Vantage℠",
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isMobile ? 18 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signon');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC4001D),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 10 : 12),
                  ),
                  child: const Text(
                    "Sign On",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: const [
                  _SupportLink("Forgot password?", "/forgot"),
                  _SupportLink("About Vantage", "/about-vantage"),
                  _SupportLink("Security Center", "/security"),
                  _SupportLink("Privacy, Cookies, and Legal", "/privacy"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportLink extends StatelessWidget {
  final String text;
  final String route;
  const _SupportLink(this.text, this.route);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: Colors.black87,
        ),
      ),
    );
  }
}

// 🔹 Commercial Insights
class CommercialInsightsSection extends StatelessWidget {
  const CommercialInsightsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final insights = [
      {
        "img": "assets/images/next-horizon.jpg",
        "title": "The Next Horizon",
        "desc":
            "Highlights industry leaders, changemakers, and visionaries. Services and solutions to help businesses embrace change.",
        "extra": "Featured client: Related Companies: The Future of New York",
        "link": "Watch video >",
      },
      {
        "img": "assets/images/charlie-scharf.jpg",
        "title": "Charlie Scharf featured in Fortune",
        "desc": "The CEO discusses IGEG LLC’s comeback and the role of CIB.",
        "link": "Read the story >",
      },
      {
        "img": "assets/images/powerful-women.jpg",
        "title": "2025 American Banker Most Powerful Women",
        "desc":
            "Kara McShane, Jen Doyle, and Tracy Kerrins named to the 2025 list. Recognizing leadership in banking and finance.",
        "link": "Read more >",
        "link2": "Most Powerful Women in Banking >",
      },
      {
        "img": "assets/images/deal-feature.jpeg",
        "title": "Deal Feature",
        "desc":
            "Mergers & Acquisitions\nPNC Financial Services Group, Inc to acquire FirstBank Holding Company\nValue: \$4.1 billion\nAdvisory: IGEG LLC acted as Financial Advisor to PNC\nDate: September 2025",
        "link": "Read press release >",
        "link2": "See more deals >",
      },
    ];

    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: const Color(0xFFF9F9F9),
      padding: EdgeInsets.all(isMobile ? 16 : 40),
      child: Column(
        children: [
          Text(
            "Explore recent perspectives and insights",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 20 : 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00704A),
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : 2,
              crossAxisSpacing: isMobile ? 12 : 20,
              mainAxisSpacing: isMobile ? 16 : 20,
              childAspectRatio: isMobile ? 0.9 : 1.2,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      card["img"]!,
                      height: isMobile ? 160 : 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          if (card.containsKey("extra")) ...[
                            const SizedBox(height: 8),
                            Text(
                              card["extra"]!,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: isMobile ? 12 : 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              card["link"]!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6A1B9A),
                              ),
                            ),
                          ),
                          if (card.containsKey("link2"))
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                card["link2"]!,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6A1B9A),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 🔘 Compare Button
class CompareButtonSection extends StatelessWidget {
  const CompareButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: SizedBox(
        width: isMobile ? double.infinity : null, // full width on mobile
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/compare');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A1B9A),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 32,
              vertical: isMobile ? 12 : 16,
            ),
            textStyle: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 14 : 16,
            ),
          ),
          child: const Text("Compare ways to invest"),
        ),
      ),
    );
  }
}
