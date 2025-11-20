import 'package:flutter/material.dart';

class ProductSection extends StatelessWidget {
  const ProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 24 : 40,
        ),
        color: const Color(0xFFF9F9F9), // ✅ light background band
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Explore Our Products",
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 20 : 24,
              ),
            ),
            const SizedBox(height: 24),

            // 🟠 Product Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isMobile ? 1 : 2, // ✅ stack on mobile
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 4 : 3, // ✅ taller on mobile
              children: const [
                ProductCard(
                  icon: Icons.account_balance,
                  title: "Checking & Savings",
                  description: "Manage your money with ease.",
                ),
                ProductCard(
                  icon: Icons.credit_card,
                  title: "Credit Cards",
                  description: "Find the card that fits your lifestyle.",
                ),
                ProductCard(
                  icon: Icons.home,
                  title: "Loans & Mortgages",
                  description: "Finance your home or vehicle.",
                ),
                ProductCard(
                  icon: Icons.trending_up,
                  title: "Investing & Retirement",
                  description: "Plan for your future with confidence.",
                ),
              ],
            ),
            const SizedBox(height: 40),

            // 🧮 Financial Product Highlights
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 600;
                return isNarrow
                    ? Column(
                        children: const [
                          HighlightCard(
                            iconPath: "assets/icons/icon-house.png",
                            title: "Find mortgage happiness",
                            description: "With a down payment as low as 3%",
                            linkText: "Learn more >",
                          ),
                          SizedBox(height: 20),
                          HighlightCard(
                            iconPath: "assets/icons/icon-document.png",
                            title: "Unlock convenient checking",
                            description:
                                "Discover the benefits of our checking accounts and choose the right one for you",
                            linkText: "Get started >",
                          ),
                          SizedBox(height: 20),
                          HighlightCard(
                            iconPath: "assets/icons/icon-creditcard.png",
                            title: "Find a credit card",
                            description:
                                "Low intro rate, cash back, rewards and more",
                            linkText: "Learn more >",
                          ),
                          SizedBox(height: 20),
                          HighlightCard(
                            iconPath: "assets/icons/icon-percent.png",
                            title: "Interest rates today",
                            description: "",
                            linkText: "Check rates >",
                          ),
                        ],
                      )
                    : Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: const [
                          HighlightCard(
                            iconPath: "assets/icons/icon-house.png",
                            title: "Find mortgage happiness",
                            description: "With a down payment as low as 3%",
                            linkText: "Learn more >",
                          ),
                          HighlightCard(
                            iconPath: "assets/icons/icon-document.png",
                            title: "Unlock convenient checking",
                            description:
                                "Discover the benefits of our checking accounts and choose the right one for you",
                            linkText: "Get started >",
                          ),
                          HighlightCard(
                            iconPath: "assets/icons/icon-creditcard.png",
                            title: "Find a credit card",
                            description:
                                "Low intro rate, cash back, rewards and more",
                            linkText: "Learn more >",
                          ),
                          HighlightCard(
                            iconPath: "assets/icons/icon-percent.png",
                            title: "Interest rates today",
                            description: "",
                            linkText: "Check rates >",
                          ),
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 🟠 Product Card
class ProductCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const ProductCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: isMobile ? 28 : 32, color: const Color(0xFFB31B1B)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.black54,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🧮 Highlight Card
class HighlightCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;
  final String linkText;

  const HighlightCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.linkText,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: isMobile ? double.infinity : 300,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(iconPath, height: 40, fit: BoxFit.contain),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 14 : 16,
            ),
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.black54,
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ],
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            child: Text(
              linkText,
              style: TextStyle(
                fontFamily: 'Inter',
                color: const Color(0xFFB31B1B),
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
