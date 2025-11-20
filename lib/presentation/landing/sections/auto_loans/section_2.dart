import 'package:flutter/material.dart';

// 🧠 Auto Loan Tools
class AutoLoanToolsSection extends StatelessWidget {
  const AutoLoanToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final tools = [
      {
        "img": "assets/images/tool-arv.webp",
        "title": "Loan Calculators",
        "route": "/auto-loans/calculator",
        "link": "Run the numbers >",
      },
      {
        "img": "assets/images/tool-budget.webp",
        "title": "Today’s Rates",
        "route": "/auto-loans/rates",
        "link": "Check current APRs >",
      },
      {
        "img": "assets/images/tool-compare.png",
        "title": "Learning Center",
        "route": "/auto-loans/learn",
        "link": "Explore articles >",
      },
    ];

    return Container(
      color: const Color(0xFFF2F2F2),
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        children: [
          Text(
            "Auto Loan Tools",
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
            children: tools.map((tool) {
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
                      tool["img"]!,
                      height: isMobile ? 70 : 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tool["title"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, tool["route"]!);
                      },
                      child: Text(
                        tool["link"]!,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 12 : 14,
                          color: const Color(0xFFB31B1B),
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

// ❓ Auto Loans FAQs
class AutoLoansFAQSection extends StatelessWidget {
  const AutoLoansFAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final faqs = [
      {
        "q": "What vehicles can I finance?",
        "a":
            "You can finance new and used cars, trucks, SUVs, and even refinance an existing auto loan.",
      },
      {
        "q": "What credit score is needed?",
        "a":
            "We offer flexible options for a wide range of credit profiles. Better scores may qualify for lower rates.",
      },
      {
        "q": "Can I apply with a co-borrower?",
        "a":
            "Yes. Applying with a co-borrower may improve your approval chances and help secure better loan terms.",
      },
      {
        "q": "How long does approval take?",
        "a":
            "Most applications are reviewed within minutes. In some cases, additional documentation may be required.",
      },
      {
        "q": "What loan terms are available?",
        "a":
            "Loan terms typically range from 36 to 72 months. Longer terms may reduce monthly payments but increase total interest.",
      },
      {
        "q": "Is there a prepayment penalty?",
        "a":
            "No. You can pay off your auto loan early without any penalties or fees.",
      },
      {
        "q": "Can I use the loan for a private seller?",
        "a":
            "Yes. We support purchases from dealerships and private sellers, subject to verification and title requirements.",
      },
    ];

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        children: [
          Text(
            "Auto Loans FAQs",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: isMobile ? 20 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ...faqs.map((faq) {
            return ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16),
              title: Text(
                faq["q"]!,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 14 : 16,
                  color: Colors.black,
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 12,
                    vertical: 8,
                  ),
                  child: Text(
                    faq["a"]!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: isMobile ? 12 : 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
