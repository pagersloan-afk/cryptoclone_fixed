import 'package:flutter/material.dart';

class FinancialGuidanceSection extends StatelessWidget {
  const FinancialGuidanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 24 : 40,
        ),
        color: const Color(0xFFF9F9F9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Financial guidance and support",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 20 : 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            isMobile
                ? Column(
                    children: [
                      _guidanceCard(
                        context,
                        "assets/images/goal-setting.jpg",
                        "Your Money. Your Goals. Your Future.",
                        "Setting financial goals is a powerful first step you can take today.",
                        "Get started",
                        isMobile,
                      ),
                      const SizedBox(height: 20),
                      _guidanceCard(
                        context,
                        "assets/images/borrowing-options.jpg",
                        "Explore your borrowing options",
                        "Find solutions for you and your financial needs, before you borrow.",
                        "Financial support",
                        isMobile,
                      ),
                      const SizedBox(height: 20),
                      _guidanceCard(
                        context,
                        "assets/images/fraud-alert.jpg",
                        "Fraud & Scam Alert",
                        "The latest news and what to watch for\nHelp keep your money safe\nLearn how to spot the latest scams and help avoid them.",
                        "Learn about scams",
                        isMobile,
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _guidanceCard(
                          context,
                          "assets/images/goal-setting.jpg",
                          "Your Money. Your Goals. Your Future.",
                          "Setting financial goals is a powerful first step you can take today.",
                          "Get started",
                          isMobile,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _guidanceCard(
                          context,
                          "assets/images/borrowing-options.jpg",
                          "Explore your borrowing options",
                          "Find solutions for you and your financial needs, before you borrow.",
                          "Financial support",
                          isMobile,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _guidanceCard(
                          context,
                          "assets/images/fraud-alert.jpg",
                          "Fraud & Scam Alert",
                          "The latest news and what to watch for\nHelp keep your money safe\nLearn how to spot the latest scams and help avoid them.",
                          "Learn about scams",
                          isMobile,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _guidanceCard(
    BuildContext context,
    String image,
    String title,
    String description,
    String buttonText,
    bool isMobile,
  ) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(image, fit: BoxFit.cover, height: isMobile ? 120 : 160),
          const SizedBox(height: 12),
          Text(
            title,
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
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 12 : 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB31B1B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 8 : 10,
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 12 : 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🏛️ Community Engagement Section
class CommunitySection extends StatelessWidget {
  const CommunitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 24 : 40,
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Serving our customers and communities",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 20 : 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "It doesn't happen with one transaction, in one day on the job, or in one quarter. It's earned relationship by relationship.",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isMobile ? 14 : 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // Two columns
            isMobile
                ? Column(
                    children: [
                      _communityCard(
                        context,
                        "assets/images/who-we-are.jpg",
                        "Who we are",
                        "IGEG LLC helps strengthen communities through inclusion, economic empowerment and environmental sustainability.",
                        "About IGEG LLC",
                        isMobile,
                      ),
                      const SizedBox(height: 20),
                      _communityCard(
                        context,
                        "assets/images/why-committed.jpg",
                        "Why we’re committed to communities",
                        "We’re committed to helping communities succeed. We support communities where we live and work by volunteering and donating to causes that align with our values.",
                        "IGEG LLC Stories",
                        isMobile,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _communityCard(
                          context,
                          "assets/images/who-we-are.jpg",
                          "Who we are",
                          "IGEG LLC helps strengthen communities through inclusion, economic empowerment and environmental sustainability.",
                          "About IGEG LLC",
                          isMobile,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _communityCard(
                          context,
                          "assets/images/why-committed.jpg",
                          "Why we’re committed to communities",
                          "We’re committed to helping communities succeed. We support communities where we live and work by volunteering and donating to causes that align with our values.",
                          "IGEG LLC Stories",
                          isMobile,
                        ),
                      ),
                    ],
                  ),
            const SizedBox(height: 40),

            // Help icons
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "How can we help?",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 16 : 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: isMobile ? 20 : 40,
                    runSpacing: 20,
                    children: [
                      _helpItem(
                        context,
                        "assets/icons/icon-appointment.png",
                        "Make an appointment",
                        isMobile,
                      ),
                      _helpItem(
                        context,
                        "assets/icons/icon-location.png",
                        "Find a location",
                        isMobile,
                      ),
                      _helpItem(
                        context,
                        "assets/icons/icon-feedback.png",
                        "Give feedback",
                        isMobile,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _communityCard(
    BuildContext context,
    String image,
    String title,
    String description,
    String buttonText,
    bool isMobile,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(image, fit: BoxFit.cover, height: isMobile ? 120 : 160),
          const SizedBox(height: 12),
          Text(
            title,
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
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 12 : 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB31B1B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 8 : 10,
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 12 : 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _helpItem(
    BuildContext context,
    String iconPath,
    String label,
    bool isMobile,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(iconPath, height: isMobile ? 32 : 40, fit: BoxFit.contain),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: isMobile ? 12 : 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
